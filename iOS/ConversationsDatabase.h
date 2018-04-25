//
//  ConversationsDatabase.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ConversationsDatabase : NSObject
{
    NSString *databasePath;
}

+(ConversationsDatabase *)getSharedInstance;
-(BOOL)createDatabase;
-(void) addMessage:(NSString *)firstName lastName: (NSString *)lastName message: (NSString *)message sendOrReceive: (int) sendOrReceive;
-(sqlite3_stmt *) loadHistory: (NSString *)tableName;
-(NSArray *) loadArrayHistory: (NSString *)tableName;
-(NSArray *) loadLastMessages;
-(void) deleteConversation: (NSString *)firstName lastName: (NSString *)lastName;

@end
