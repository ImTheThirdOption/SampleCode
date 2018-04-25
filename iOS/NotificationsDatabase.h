//
//  NotificationsDatabase.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NotificationsDatabase : NSObject
{
    NSString *databasePath;
}

+(NotificationsDatabase *)getSharedInstance;
-(BOOL)createDatabase;
-(int) addNotificationOf:(NSString *)type first: (NSString *)first second: (NSString *)second third: (NSString *)third;
-(NSArray *) loadNotifications;
-(NSArray *) loadNotification: (NSString *)notificationNumber;
-(NSArray *) loadNotificationFling: (NSString *)direction number: (NSString *)notificationNumber;
-(void) deleteNotification: (NSString *)id;
-(void) deleteAllNotifications;
-(NSArray *) findByRegisterNumber:(NSString *)registerNumber;

@end
