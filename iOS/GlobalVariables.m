//
//  GlobalVariables.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables : NSObject

+ (GlobalVariables *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVariables *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVariables alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _navigationBarTitle = @"House and Home 757";
        _openDoorRealtorWebsite = @"http://www.opendoormediadesign.com/house-and-home-757-mobile-app-download";
        _serverAddress = @"http://www.server.opendoormediadesign.com/php_scripts/house_and_home_757/";
        _phpKey = @"&phpKey=uCzvkblogM0vrDHiN39XfIGepTcwwWVkhWncHRoepFGCiyJRk4Wk1GOC5Ne2y1DtCxRezyifQLGOzDJlVvBAvCLBLld3ZY65FPRysZpY25fDaJ9VeHOaVOfJXGpUOt8wbPbgftzB5JXonB1wgWrdvO8P7j0dI2CWX493FPF1mNeA8ntW4FZfjJ9I7QWSdU8np0CrJw03";
        _emailFooter = @"(Message%20Sent%20From%20House%20and%20Home%20757%20Mobile%20App)";
        _firstRealtorName = @"Kim";
        _secondRealtorName = @"Deane";
        _firstRealtorPhoneNumber = @"17572778280";
        _secondRealtorPhoneNumber = @"17577855075";
        _firstRealtorEmailAddress = @"kim@realestategrp.com";
        _secondRealtorEmailAddress = @"deane@realestategrp.com";
        
        _bottomNavigationBarColor = [UIColor colorWithRed:176.0/255.0 green:150.0/255.0 blue:118.0/255.0 alpha:1];
    }
    return self;
}
@end
