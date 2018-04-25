//
//  AppDelegate.h
//  iRealtor
//
//  Created by user121303 on 8/22/16.
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(void)setCurrentToName:(NSString *)newCurrentToFirstName newCurrentToLastName:(NSString *)newCurrentToLastName;
+(void)checkOnlineStatus;
+(void)makeToast:(NSString *)toast;
+(NSString *)firstName;
+(NSString *)lastName;
+(NSString *)token;
+(void)firstName:(NSString *)newFirstName;
+(void)lastName:(NSString *)newLastName;
@end
