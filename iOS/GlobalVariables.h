//
//  GlobalVariables.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalVariables : NSObject

@property(strong, nonatomic) NSString *navigationBarTitle;
@property(strong, nonatomic) NSString *openDoorRealtorWebsite;
@property(strong, nonatomic) NSString *serverAddress;
@property(strong, nonatomic) NSString *phpKey;
@property(strong, nonatomic) NSString *emailFooter;
@property(strong, nonatomic) NSString *firstRealtorName;
@property(strong, nonatomic) NSString *secondRealtorName;
@property(strong, nonatomic) NSString *firstRealtorPhoneNumber;
@property(strong, nonatomic) NSString *secondRealtorPhoneNumber;
@property(strong, nonatomic) NSString *firstRealtorEmailAddress;
@property(strong, nonatomic) NSString *secondRealtorEmailAddress;

@property(strong, nonatomic) UIColor *bottomNavigationBarColor;

+ (GlobalVariables *)sharedInstance;

@end
