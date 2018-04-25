//
//  AppDelegate.m
//  iRealtor
//
//  Created by user121303 on 8/22/16.
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "HomeScreenViewController.h"
#import "HttpPost.h"
#import "ConversationViewController.h"
#import "ConversationsDatabase.h"
#import "NotificationsDatabase.h"
#import "NotificationsViewController.h"
#import "MyNotificationsViewController.h"

static NSString *firstName;
static NSString *lastName;
static NSString *currentToFirstName = @"";
static NSString *currentToLastName = @"";
static bool isMessagerOpen = NO;
static bool isConversationOpen = NO;
static bool isWaiting = NO;

@interface AppDelegate ()

@end

@import UIKit;
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif
@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif
// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    // Override point for customization after application launch.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[HomeScreenViewController new]];
    self.window.rootViewController = navigationController;
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:176.0/255.0 green:150.0/255.0 blue:118.0/255.0 alpha:1]];
    [self.window makeKeyAndVisible];

    NSDictionary * pushNotificationUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [self openThroughNotification:pushNotificationUserInfo];
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    //UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    //UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    //[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
        #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].remoteMessageDelegate = self;
        #endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    // [END register_for_notifications]

    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];

    NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"registeredname"] mutableCopy];
    if (myDictionary==nil){
        myDictionary = [NSMutableDictionary new];
    }
    firstName = myDictionary[@"firstName"];
    lastName = myDictionary[@"lastName"];
    NSString *myVersion = myDictionary[@"version"];
    if (![myVersion isEqualToString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]){
        if (!([[FIRInstanceID instanceID] token] == nil || firstName == nil || lastName == nil)){
            [AppDelegate reRegister:@"" :@"" :@"no"];
        }
        myDictionary[@"version"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"registeredname"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triedToRegisterReceiver:) name:@"triedtoregister" object:nil];
    
    /*UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];*/
    return YES;
}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    [self firebaseTokenReceiver];
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
}
// [END refresh_token]
-(void)firebaseTokenReceiver{
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/alliosdevices"];
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/alldevices"];
    if (firstName==nil || lastName==nil){
        //[AppDelegate tryToRegister];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenWithNoName" object:nil userInfo:nil];
    }
    else {
        [AppDelegate reRegister:@"" :@"" :@"no"];
    }
}

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:@"da", @"fromFirstName", @"pad", @"fromLastName", [@"didFailtoregister: " stringByAppendingString:[error description]], @"message", nil];
    NSDictionary *payload1 = [NSDictionary dictionaryWithObjectsAndKeys:@"instantMessage", @"type", message, @"message", nil];
    NSError *error1;
    NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", @"Technical", @"Support", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload1 options:NSJSONWritingPrettyPrinted error:&error1] encoding:NSUTF8StringEncoding]];
    [HttpPost post:@"http://www.server.opendoormediadesign.com/php_scripts/main_template/send-message.php" data:data broadcastReceiver:@"" extraData:@""];
    
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:@"da", @"fromFirstName", @"pad", @"fromLastName", @"didRegisterForRemoteNotifications ", @"message", nil];
    NSDictionary *payload1 = [NSDictionary dictionaryWithObjectsAndKeys:@"instantMessage", @"type", message, @"message", nil];
    NSError *error;
    NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", @"Technical", @"Support", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload1 options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
    [HttpPost post:@"http://www.server.opendoormediadesign.com/php_scripts/main_template/send-message.php" data:data broadcastReceiver:@"" extraData:@""];
    
    // With swizzling disabled you must set the APNs token here.
    //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
}
/*- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    //const void *devTokenBytes = [devToken bytes];
    [self tokenReceiver:devToken];
}
- (void)tokenReceiver:(NSData *)newToken{
    token = [self hexToString:newToken];
    NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"registeredname"] mutableCopy];
    if (myDictionary==nil){
        myDictionary = [NSMutableDictionary new];
    }
    myDictionary[@"token"] = token;
    [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"registeredname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (firstName==nil || lastName==nil){
        //[AppDelegate tryToRegister];
    }
    else {
        [AppDelegate reRegister:@"" :@"" :@"no"];
    }
}
- (NSString *) hexToString: (NSData *)hex{
    NSUInteger bytesCount = hex.length;
    if (bytesCount) {
        const char *hexChars = "0123456789ABCDEF";
        const unsigned char *dataBuffer = hex.bytes;
        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
        char *s = chars;
        for (unsigned i = 0; i < bytesCount; ++i) {
            *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
            *s++ = hexChars[(*dataBuffer & 0x0F)];
            dataBuffer++;
        }
        *s = '\0';
        NSString *hexString = [NSString stringWithUTF8String:chars];
        free(chars);
        return hexString;
    }
    return @"";
}*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
    }];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:@"da", @"fromFirstName", @"pad", @"fromLastName", @"didReceiveRemoteNotification ", @"message", nil];
     NSDictionary *payload1 = [NSDictionary dictionaryWithObjectsAndKeys:@"instantMessage", @"type", message, @"message", nil];
     NSError *error;
     NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", @"Technical", @"Support", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload1 options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
     GlobalVariables *globals = [GlobalVariables sharedInstance];
     [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"send-message.php"] data:data broadcastReceiver:@"" extraData:@""];
    if ([firstName isEqualToString:@"da"]){
    UIAlertController *alertController=[UIAlertController
                                        alertControllerWithTitle:[@"didReceiveRemoteNotification: " stringByAppendingString:[userInfo description]]
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                               }];
    [alertController addAction:ok];
    [(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
    NSDictionary *payload=userInfo[@"payload"];
    if(application.applicationState == UIApplicationStateInactive) {
        // app was inactive
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        // app was in the background
        
    } else {
        // app is active
        
    }
    if(payload){
        if ([[payload objectForKey:@"type"] isEqualToString:@"instantMessage"]){
            NSDictionary *jObject = [payload objectForKey:@"message"];
            NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
            NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
            NSString *message = [jObject objectForKey:@"message"];
            ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
            [db addMessage:fromFirstName lastName:fromLastName message:message sendOrReceive:1];
            
            UIViewController *viewController = [((UINavigationController *)[[(UIView *)self window] rootViewController]).viewControllers lastObject];
            if ([viewController isMemberOfClass: [ConversationViewController class]] && [currentToFirstName.lowercaseString isEqualToString:fromFirstName.lowercaseString] && [currentToLastName.lowercaseString isEqualToString:fromLastName.lowercaseString]){
                [(ConversationViewController *)viewController addNewMessage:message sendOrReceive:1];
            }
            else {
                /*UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.alertTitle = [NSString stringWithFormat:@"Message from %@ %@", fromFirstName, fromLastName];
                localNotification.alertBody = message;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                //localNotification.alertLaunchImage = @"AppIcon.png";
                //localNotification.userInfo =
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];*/
            }
        }
        else if ([[payload objectForKey:@"type"] isEqualToString:@"systemMessage"]){
            NSDictionary *jObject = [payload objectForKey:@"message"];
            NSString *type = [jObject objectForKey:@"type"];
            if ([type isEqualToString:@"ping"]){
                NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
                NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
                NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:firstName, @"fromFirstName", lastName, @"fromLastName", @"pong", @"type", nil];
                NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@"systemMessage", @"type", message, @"message", nil];
                NSError *error;
                NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", fromFirstName, fromLastName, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
                GlobalVariables *globals = [GlobalVariables sharedInstance];
                [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"send-message.php"] data:data broadcastReceiver:@"" extraData:@""];
            }
            else if([type isEqualToString:@"pong"]){
                NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
                NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
                [self pongReceiver:fromFirstName fromLastName:fromLastName];
            }
            
        }
        else if ([[payload objectForKey:@"type"] isEqualToString:@"tailoredNotification"]){
            NSArray *jArray = [payload objectForKey:@"message"];
            NSDictionary *jObject = [jArray objectAtIndex:0];
            NSString *type = [jObject objectForKey:@"type"];
            NSString *first = [jObject objectForKey:@"first"];
            NSString *second = [jObject objectForKey:@"second"];
            NSString *third = [jObject objectForKey:@"third"];
            NotificationsDatabase *db = [NotificationsDatabase getSharedInstance];
            int notificationNumber = [db addNotificationOf:type first:first second:second third:third];
        }
    }
    completionHandler(UIBackgroundFetchResultNoData);
}
// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    //NSDictionary *userInfo = notification.request.content.userInfo;
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {

    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self openThroughNotification:userInfo];
    completionHandler();
}
#endif
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSDictionary *payload=remoteMessage.appData;
    /*NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:firstName, @"fromFirstName", lastName, @"fromLastName", [@"applicationReceivedRemoteMessage payload description: " stringByAppendingString:[payload description]], @"message", nil];
    NSDictionary *payload1 = [NSDictionary dictionaryWithObjectsAndKeys:@"instantMessage", @"type", message, @"message", nil];
    NSError *error;
    NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", @"Technical", @"Support", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload1 options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"send-message.php"] data:data broadcastReceiver:@"" extraData:@""];*/
    
    if(payload){
        if([payload objectForKey:@"notification"]!=nil){
            return;
        }
        if ([[payload objectForKey:@"type"] isEqualToString:@"instantMessage"]){
            NSError *error;
            NSData *data = [[payload objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jObject = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:&error];
            NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
            NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
            NSString *message = [jObject objectForKey:@"message"];
            ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
            [db addMessage:fromFirstName lastName:fromLastName message:message sendOrReceive:1];
            
            UIViewController *viewController = [((UINavigationController *)[[(UIView *)self window] rootViewController]).viewControllers lastObject];
            if ([viewController isMemberOfClass: [ConversationViewController class]] && [currentToFirstName.lowercaseString isEqualToString:fromFirstName.lowercaseString] && [currentToLastName.lowercaseString isEqualToString:fromLastName.lowercaseString]){
                [(ConversationViewController *)viewController addNewMessage:message sendOrReceive:1];
            }
        }
        else if ([[payload objectForKey:@"type"] isEqualToString:@"systemMessage"]){
            NSError *error;
            NSData *data = [[payload objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            NSString *type = [jObject objectForKey:@"type"];
            if ([type isEqualToString:@"ping"]){
                NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
                NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
                NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:firstName, @"fromFirstName", lastName, @"fromLastName", @"pong", @"type", nil];
                NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@"systemMessage", @"type", message, @"message", nil];
                NSError *error;
                NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", fromFirstName, fromLastName, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
                GlobalVariables *globals = [GlobalVariables sharedInstance];
                [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"send-message.php"] data:data broadcastReceiver:@"" extraData:@""];
            }
            else if([type isEqualToString:@"pong"]){
                NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
                NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
                [self pongReceiver:fromFirstName fromLastName:fromLastName];
            }
        }
        else if ([[payload objectForKey:@"type"] isEqualToString:@"tailoredNotification"]){
            NSError *error;
            NSData *data = [[payload objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *jArray = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            NSDictionary *jObject = [jArray objectAtIndex:0];
            NSString *type = [jObject objectForKey:@"type"];
            NSString *first = [jObject objectForKey:@"first"];
            NSString *second = [jObject objectForKey:@"second"];
            NSString *third = [jObject objectForKey:@"third"];
            NotificationsDatabase *db = [NotificationsDatabase getSharedInstance];
            int notificationNumber = [db addNotificationOf:type first:first second:second third:third];
        }
    }
}
#endif
// [END ios_10_data_message_handling]
-(void)openThroughNotification:(NSDictionary *)userInfo{
    if(userInfo){
        if ([[userInfo objectForKey:@"type"] isEqualToString:@"instantMessage"]){
            NSError *error;
            NSData *data = [[userInfo objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            NSString *fromFirstName = [jObject objectForKey:@"fromFirstName"];
            NSString *fromLastName = [jObject objectForKey:@"fromLastName"];
            
            currentToFirstName = fromFirstName;
            currentToLastName = fromLastName;
            [AppDelegate checkOnlineStatus];
            [(UINavigationController *)self.window.rootViewController pushViewController:[[ConversationViewController alloc] initWithToFirstName:fromFirstName toLastName:fromLastName] animated:YES];
        }
        else if ([[userInfo objectForKey:@"type"] isEqualToString:@"generalNotification"]){
            [(UINavigationController *)self.window.rootViewController pushViewController:[MyNotificationsViewController new] animated:YES];
        }
        else if ([[userInfo objectForKey:@"type"] isEqualToString:@"tailoredNotification"]){
            NSError *error;
            NSData *data = [[userInfo objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *jArray = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
            NSDictionary *jObject = [jArray objectAtIndex:0];
            NSString *type = [jObject objectForKey:@"type"];
            NSString *first = [jObject objectForKey:@"first"];
            NSString *second = [jObject objectForKey:@"second"];
            NSString *third = [jObject objectForKey:@"third"];
            //NotificationsDatabase *db = [NotificationsDatabase getSharedInstance];
            //int notificationNumber = [db addNotificationOf:type first:first second:second third:third];
            [(UINavigationController *)self.window.rootViewController pushViewController:[MyNotificationsViewController new] animated:YES];
        }
    }
}
/*-(void)triedToRegisterReceiver:(NSNotification *)notification {
    NSString *result = [[notification userInfo] objectForKey:@"result"];
    if ([result isEqualToString:@"taken"]){
        NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"registeredname"] mutableCopy];
        if (myDictionary==nil){
            myDictionary = [NSMutableDictionary new];
        }
        myDictionary[@"firstName"] = nil;
        myDictionary[@"lastName"] = nil;
        firstName = nil;
        lastName = nil;
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"registeredname"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:@"That name is not available. Please choose another."
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [AppDelegate tryToRegister];
                                                   }];
        [alertController addAction:ok];
        [(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];

    }
}*/

/*+(void)onNameChosen:(NSString *)newFirstName lastName:(NSString *)newLastName{
    if ([newFirstName isEqualToString:@""] || [newLastName isEqualToString:@""]){
        [AppDelegate tryToRegister];
    }
    else {
        firstName = newFirstName;
        lastName = newLastName;
        NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"registeredname"] mutableCopy];
        if (myDictionary==nil){
            myDictionary = [NSMutableDictionary new];
        }
        NSString *oldFirstName = myDictionary[@"firstName"];
        NSString *oldLastName = myDictionary[@"lastName"];
        myDictionary[@"firstName"] = firstName;
        myDictionary[@"lastName"] = lastName;
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"registeredname"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self reRegister:oldFirstName :oldLastName :@"yes"];
    }
}*/
+(void)reRegister:(NSString *)oldFirstName :(NSString *)oldLastName :(NSString *)newName{
    NSString *data = [NSString stringWithFormat:@"first_name=%@&last_name=%@&token=%@&system=ios&version=%@&old_first_name=%@&old_last_name=%@&new_name=%@",firstName, lastName, [[FIRInstanceID instanceID] token], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"], oldFirstName, oldLastName, newName];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    //[HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"register-contact.php"] data:data broadcastReceiver:@"triedtoregister" extraData:@""];
    [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"register-contact.php"] data:data broadcastReceiver:@"" extraData:@""];
    
    
}
/*+(void)tryToRegister{
    UIAlertController *alertController=[UIAlertController
                                        alertControllerWithTitle:@"Please register (optional)"
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [AppDelegate onNameChosen:alertController.textFields[0].text lastName:alertController.textFields[1].text];
                                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //[alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alertController addAction:cancel];
    [alertController addAction:ok];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        textField.textColor = [UIColor blackColor];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        textField.textColor = [UIColor blackColor];
    }];
    [(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}*/


-(void)pongReceiver:(NSString *)fromFirstName fromLastName:(NSString *)fromLastName{
    if (isWaiting && [currentToFirstName.lowercaseString isEqualToString:fromFirstName.lowercaseString] && [currentToLastName.lowercaseString isEqualToString:fromLastName.lowercaseString]){
        isWaiting = NO;
    }
    else {
        [AppDelegate makeToast:[NSString stringWithFormat:@"%@ %@ is now online.", fromFirstName, fromLastName]];
    }
}
+(void)setCurrentToName:(NSString *)newCurrentToFirstName newCurrentToLastName:(NSString *)newCurrentToLastName{
    currentToFirstName = newCurrentToFirstName;
    currentToLastName = newCurrentToLastName;
}
+(void)checkOnlineStatus{
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:firstName, @"fromFirstName", lastName, @"fromLastName", @"ping", @"type", nil];
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@"systemMessage", @"type", message, @"message", nil];
    NSError *error;
    NSString *data = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@", currentToFirstName, currentToLastName, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"send-message.php"] data:data broadcastReceiver:@"" extraData:@""];
    
    isWaiting = YES;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5.0*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        if (isWaiting){
            [AppDelegate makeToast:[NSString stringWithFormat:@"%@ %@ is not currently online", currentToFirstName, currentToLastName]];
            isWaiting = NO;
        }
    });
}
+(void)makeToast:(NSString *)toast{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel *toastView = [[UILabel alloc] init];
        toastView.text = toast;
        toastView.font = [UIFont systemFontOfSize:16];
        toastView.textColor = [UIColor whiteColor];
        toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        toastView.numberOfLines = 0;
        toastView.textAlignment = NSTextAlignmentCenter;
        CGRect rect = [toast boundingRectWithSize:CGSizeMake(keyWindow.frame.size.width-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
        toastView.frame = CGRectMake(0.0, 0.0, ceil(rect.size.width)+20, ceil(rect.size.height)+20);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 3.0f delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations: ^{ toastView.alpha = 0.0; } completion: ^(BOOL finished) {
                                        [toastView removeFromSuperview];
                                    }];
    }];
}
+(NSString *)firstName {
    return firstName;
}
+(NSString *)lastName {
    return lastName;
}
+(NSString *)token{
    return [[FIRInstanceID instanceID] token];
}
+(void)firstName:(NSString *)newFirstName{
    firstName = newFirstName;
}
+(void)lastName:(NSString *)newLastName{
    lastName = newLastName;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// [START disconnect_from_fcm]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.window endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}
// [END disconnect_from_fcm]

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

// [START connect_on_active]
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connectToFcm];
}
// [END connect_on_active]
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
