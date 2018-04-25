//
//  NotificationsDatabase.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "NotificationsDatabase.h"
static NotificationsDatabase *instance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *query = nil;

@implementation NotificationsDatabase

+(NotificationsDatabase *)getSharedInstance{
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
                    [docsDirectory stringByAppendingPathComponent: @"notifications.db"]];
    BOOL isSuccessful = YES;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath: databasePath ] == NO)
    {
        const char *databasepath = [databasePath UTF8String];
        if (sqlite3_open(databasepath, &database) == SQLITE_OK)
        {
            char *errMessage;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS notifications (_id INTEGER PRIMARY KEY, type TEXT, first TEXT, second TEXT, third TEXT)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMessage)!=SQLITE_OK){
                isSuccessful = NO;
                NSLog(@"aaaFailed to create notifications table");
                NSLog(@"%s", errMessage);
            }
            sqlite3_close(database);
            NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyDictionary"] mutableCopy];
            if (myDictionary==nil){
                myDictionary = [NSMutableDictionary new];
            }
            myDictionary[@"notificationsDatabaseVersion"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"MyDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return  isSuccessful;
        }
        else {
            isSuccessful = NO;
            NSLog(@"aaaFailed to open/create notifications database");
        }
    }
    else if ([filemanager fileExistsAtPath: databasePath ] == YES){
        NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyDictionary"] mutableCopy];
        if (myDictionary==nil){
            myDictionary = [NSMutableDictionary new];
        }
        NSString *currentVersion = [myDictionary objectForKey:@"notificationsDatabaseVersion"];
        // modify database if current version of database is different than current version of app
        myDictionary[@"notificationsDatabaseVersion"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"MyDictionary"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    return isSuccessful;
}

- (int) addNotificationOf: (NSString *)type first: (NSString *)first second:(NSString *)second third:(NSString *)third{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO notifications (`type`, `first`, `second`, `third`) values (\"%@\",\"%@\", \"%@\", \"%@\")",type, first, second, third];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_DONE){
                sqlite3_reset(query);
                return (int)sqlite3_last_insert_rowid(database);
            }
            else {
                sqlite3_reset(query);
            }
        }
    }
    return -1;
}

-(NSArray *) loadNotifications{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = @"SELECT * FROM notifications ORDER BY _id DESC";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            while (sqlite3_step(query) == SQLITE_ROW) {
                int idInt = sqlite3_column_int(query, 0);
                char *typeChars = (char *) sqlite3_column_text(query, 1);
                char *firstChars = (char *) sqlite3_column_text(query, 2);
                char *secondChars = (char *) sqlite3_column_text(query, 3);
                char *thirdChars = (char *) sqlite3_column_text(query, 4);
                NSNumber *idNumber = [NSNumber numberWithInteger:idInt];
                NSString *type = [[NSString alloc] initWithUTF8String:typeChars];
                NSString *first = [[NSString alloc] initWithUTF8String:firstChars];
                NSString *second = [[NSString alloc] initWithUTF8String:secondChars];
                NSString *third = [[NSString alloc] initWithUTF8String:thirdChars];
                NSArray *subArray = [[NSArray alloc] initWithObjects:idNumber, type, first, second, third, nil];
                [array addObject:subArray];
            }
            sqlite3_finalize(query);
        }
    }
    return array;
}

-(NSArray *) loadNotification: (NSString *)notificationNumber{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM notifications WHERE _id=\"%@\"",notificationNumber];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_ROW) {
                int idInt = sqlite3_column_int(query, 0);
                char *typeChars = (char *) sqlite3_column_text(query, 1);
                char *firstChars = (char *) sqlite3_column_text(query, 2);
                char *secondChars = (char *) sqlite3_column_text(query, 3);
                char *thirdChars = (char *) sqlite3_column_text(query, 4);
                NSNumber *idNumber = [NSNumber numberWithInteger:idInt];
                NSString *type = [[NSString alloc] initWithUTF8String:typeChars];
                NSString *first = [[NSString alloc] initWithUTF8String:firstChars];
                NSString *second = [[NSString alloc] initWithUTF8String:secondChars];
                NSString *third = [[NSString alloc] initWithUTF8String:thirdChars];
                NSArray *subArray = [[NSArray alloc] initWithObjects:idNumber, type, first, second, third, nil];
                [array addObject:subArray];
            }
            sqlite3_finalize(query);
        }
    }
    return array;
}
-(NSArray *) loadNotificationFling: (NSString *)direction number: (NSString *)notificationNumber{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL;
        if ([direction isEqualToString:@"left"]){
            querySQL = [NSString stringWithFormat:@"SELECT * FROM notifications WHERE _id<\"%@\" ORDER BY _id DESC LIMIT 1", notificationNumber];
            
        }
        else if ([direction isEqualToString:@"right"]){
            querySQL = [NSString stringWithFormat:@"SELECT * FROM notifications WHERE _id>\"%@\" ORDER BY _id ASC LIMIT 1", notificationNumber];
            
        }
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_ROW) {
                int idInt = sqlite3_column_int(query, 0);
                char *typeChars = (char *) sqlite3_column_text(query, 1);
                char *firstChars = (char *) sqlite3_column_text(query, 2);
                char *secondChars = (char *) sqlite3_column_text(query, 3);
                char *thirdChars = (char *) sqlite3_column_text(query, 4);
                NSNumber *idNumber = [NSNumber numberWithInteger:idInt];
                NSString *type = [[NSString alloc] initWithUTF8String:typeChars];
                NSString *first = [[NSString alloc] initWithUTF8String:firstChars];
                NSString *second = [[NSString alloc] initWithUTF8String:secondChars];
                NSString *third = [[NSString alloc] initWithUTF8String:thirdChars];
                NSArray *subArray = [[NSArray alloc] initWithObjects:idNumber, type, first, second, third, nil];
                [array addObject:subArray];
            }
            sqlite3_finalize(query);
        }
    }
    return array;
}
-(void) deleteNotification: (NSString *)id{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM notifications WHERE (_id=\"%@\")",id];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query)==SQLITE_DONE){
                
            }
        }
        sqlite3_finalize(query);
        sqlite3_close(database);
    }
}
-(void) deleteAllNotifications{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = @"DELETE FROM notifications";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query)==SQLITE_DONE){
                
            }
        }
        sqlite3_finalize(query);
        sqlite3_close(database);
    }
}
- (NSArray*) findByRegisterNumber:(NSString*)registerNumber{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &query, NULL) == SQLITE_OK){
            if (sqlite3_step(query) == SQLITE_ROW){
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(query, 2)];
                [resultArray addObject:year];
                sqlite3_reset(query);
                return resultArray;
            }
            else{
                sqlite3_reset(query);
                NSLog(@"Not found");
                return nil;
            }
        }
    }
    return nil;
}
@end
