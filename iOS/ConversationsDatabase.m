//
//  ConversationsDatabase.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "ConversationsDatabase.h"
static ConversationsDatabase *instance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *query = nil;

@implementation ConversationsDatabase

+(ConversationsDatabase *)getSharedInstance{
    if (!instance) {
        instance = [[super alloc] init];
        [instance createDatabase];
    }
    return instance;
}

-(BOOL)createDatabase{
    NSString *docsDirectory;
    NSArray *directoryPaths;
    directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDirectory = directoryPaths[0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDirectory stringByAppendingPathComponent: @"conversations.db"]];
    BOOL isSuccessful = YES;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath: databasePath ] == NO)
    {
        const char *databasepath = [databasePath UTF8String];
        if (sqlite3_open(databasepath, &database) == SQLITE_OK)
        {
            char *errMessage;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS last_messages (_id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, message TEXT)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMessage)!=SQLITE_OK){
                isSuccessful = NO;
                NSLog(@"aaaFailed to create last_messages table");
            }
            sqlite3_close(database);
            NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyDictionary"] mutableCopy];
            if (myDictionary==nil){
                myDictionary = [NSMutableDictionary new];
            }
            myDictionary[@"conversationsDatabaseVersion"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"MyDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return  isSuccessful;
        }
        else {
            isSuccessful = NO;
            NSLog(@"aaaFailed to open/create conversations database");
        }
    }
    else if ([filemanager fileExistsAtPath: databasePath ] == YES){
        NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyDictionary"] mutableCopy];
        if (myDictionary==nil){
            myDictionary = [NSMutableDictionary new];
        }
        NSString *currentVersion = [myDictionary objectForKey:@"conversationsDatabaseVersion"];
        // modify database if current version of database is different than current version of app
        myDictionary[@"conversationsDatabaseVersion"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"MyDictionary"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    return isSuccessful;
}
-(void) addMessage:(NSString *)firstName lastName: (NSString *)lastName message: (NSString *)message sendOrReceive: (int) sendOrReceive{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *fullTableName = [[@"conversationswith" stringByAppendingString:firstName.lowercaseString] stringByAppendingString:lastName.lowercaseString];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT 1 FROM last_messages WHERE first_name LIKE \"%@\" AND last_name LIKE \"%@\"", firstName, lastName];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_ROW){
                querySQL = [NSString stringWithFormat:@"DELETE FROM last_messages WHERE (first_name LIKE \"%@\" AND last_name LIKE \"%@\")", firstName, lastName];    
            }
            else {
                querySQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (_id INTEGER PRIMARY KEY, message TEXT, send_or_receive INTEGER)", fullTableName];
            }
            sqlite3_reset(query);
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
                if (sqlite3_step(query) == SQLITE_DONE){
                    sqlite3_reset(query);
                    querySQL = [NSString stringWithFormat:@"INSERT INTO \"%@\" (message, send_or_receive) VALUES (\"%@\",  \"%d\")", fullTableName, message, sendOrReceive];
                    query_stmt = [querySQL UTF8String];
                    if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
                        if (sqlite3_step(query) == SQLITE_DONE){
                        }
                    }
                    sqlite3_reset(query);
                    querySQL = [NSString stringWithFormat:@"INSERT INTO last_messages (first_name, last_name, message) VALUES(\"%@\", \"%@\",  \"%@\")", firstName, lastName, message];
                    query_stmt = [querySQL UTF8String];
                    if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
                        if (sqlite3_step(query) == SQLITE_DONE){
                        }
                    }
                }
            }
        }
    }
}
-(sqlite3_stmt *) loadHistory: (NSString *)tableName{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *fullTableName = [@"conversationswith" stringByAppendingString:tableName.lowercaseString] ;
        NSString *querySQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (_id INTEGER PRIMARY KEY, message TEXT, send_or_receive INTEGER)", fullTableName];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_DONE){
                sqlite3_reset(query);
                querySQL = [NSString stringWithFormat:@"SELECT message, send_or_receive FROM \"%@\"", fullTableName];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
                    return query;
                }
            }
        }
    }
    return nil;
}
-(NSArray *) loadArrayHistory: (NSString *)tableName{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *fullTableName = [@"conversationswith" stringByAppendingString:tableName.lowercaseString] ;
        NSString *querySQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (_id INTEGER PRIMARY KEY, message TEXT, send_or_receive INTEGER)", fullTableName];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_DONE){
                sqlite3_reset(query);
                querySQL = [NSString stringWithFormat:@"SELECT message, send_or_receive FROM \"%@\"", fullTableName];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
                    while (sqlite3_step(query) == SQLITE_ROW) {
                        char *messageChars = (char *) sqlite3_column_text(query, 0);
                        int sendOrReceive = (int) sqlite3_column_int(query, 1);
                        NSString *message = [[NSString alloc] initWithUTF8String:messageChars];
                        NSArray *subArray = [[NSArray alloc] initWithObjects:message, [NSNumber numberWithInteger:sendOrReceive], nil];
                        [array addObject:subArray];
                    }
                    sqlite3_finalize(query);
                }
            }
        }
    }
    return array;
}
-(NSArray *) loadLastMessages{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = @"SELECT * FROM last_messages ORDER BY _id DESC";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            while (sqlite3_step(query) == SQLITE_ROW) {
                char *firstNameChars = (char *) sqlite3_column_text(query, 1);
                char *lastNameChars = (char *) sqlite3_column_text(query, 2);
                char *messageChars = (char *) sqlite3_column_text(query, 3);
                NSString *firstName = [[NSString alloc] initWithUTF8String:firstNameChars];
                NSString *lastName = [[NSString alloc] initWithUTF8String:lastNameChars];
                NSString *message = [[NSString alloc] initWithUTF8String:messageChars];
                NSArray *subArray = [[NSArray alloc] initWithObjects:firstName, lastName, message, nil];
                [array addObject:subArray];
            }
            sqlite3_finalize(query);
        }
    }
    return array;
}
-(void) deleteConversation: (NSString *)firstName lastName: (NSString *)lastName{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM last_messages WHERE (first_name LIKE \"%@\" AND last_name LIKE \"%@\")",firstName, lastName];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query)==SQLITE_DONE){
            }
        }
        sqlite3_reset(query);
        NSString *fullTableName = [[@"conversationswith" stringByAppendingString:firstName.lowercaseString] stringByAppendingString:lastName.lowercaseString];
        querySQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS \"%@\"",fullTableName];
        query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query)==SQLITE_DONE){  
            }
        }
        sqlite3_finalize(query);
        sqlite3_close(database);
    }
}
@end
