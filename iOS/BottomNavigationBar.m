//
//  BottomNavigationBar.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "GlobalVariables.h"
#import "BottomNavigationBar.h"
#import "UIButtonWithString.h"
#import "HomeScreenViewController.h"
#import "MyUtilities.h"
#import "WebviewViewController.h"
#import "MessagerViewController.h"

static UIView *chooseRealtorForPhoneCallPopup;

@implementation BottomNavigationBar{
    
}

+ (void)addBottomNavigationBar: (UIView *)bottomNavigationBar to: (UIView *)selfView navigationBarHeight: (float)barHeight scrollView: (UIView *)scrollView headerImage: (UIView *)headerImage{
    [bottomNavigationBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    bottomNavigationBar.backgroundColor = globals.bottomNavigationBarColor;
    [selfView addSubview:bottomNavigationBar];
    if (scrollView){
        [selfView addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:barHeight]];
    //self.navigationController.navigationBar.frame.size.height
    [BottomNavigationBar createBottomNavigationBar:bottomNavigationBar];
    
    
}
+(void)createBottomNavigationBar:(UIView *)bottomNavigationBar{
    UIView *zerothPlaceHolderView = [[UIView alloc]init];
    [zerothPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:zerothPlaceHolderView];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    UIButton *messageImage = [[UIButton alloc] init];
    [messageImage setBackgroundImage:[UIImage imageNamed:@"instantmessengerWhite.png"] forState:UIControlStateNormal];
    [messageImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:messageImage];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [messageImage addTarget:self action:@selector(startMessager:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *firstPlaceHolderView = [[UIView alloc]init];
    [firstPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:firstPlaceHolderView];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButton *callImage = [UIButton new];
    [callImage setBackgroundImage:[UIImage imageNamed:@"phone_symbol.png"] forState:UIControlStateNormal];
    [callImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:callImage];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:callImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:callImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:callImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:firstPlaceHolderView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:callImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [callImage addTarget:self action:@selector(openChooseRealtorForPhoneCallPopup) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *secondPlaceHolderView = [[UIView alloc]init];
    [secondPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:secondPlaceHolderView];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:callImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButton *homeImage = [[UIButton alloc] init];
    [homeImage setBackgroundImage:[UIImage imageNamed:@"home_White.png"] forState:UIControlStateNormal];
    [homeImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:homeImage];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:homeImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:homeImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:homeImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:secondPlaceHolderView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:homeImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [homeImage addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *thirdPlaceHolderView = [[UIView alloc]init];
    [thirdPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:thirdPlaceHolderView];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:homeImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButton *backImage = [[UIButton alloc] init];
    [backImage setBackgroundImage:[UIImage imageNamed:@"arrow_white.png"] forState:UIControlStateNormal];
    [backImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:backImage];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:backImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:backImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:backImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:thirdPlaceHolderView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:backImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [backImage addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *fourthPlaceHolderView = [[UIView alloc]init];
    [fourthPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomNavigationBar addSubview:fourthPlaceHolderView];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:backImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bottomNavigationBar attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [bottomNavigationBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}
+ (void)addReferralOptionsBar:(UIView *)referralOptionsBar selfView:(UIView *)selfView beneath:(id)above contentView:(UIView *)contentView barHeight:(float)barHeight emailAddress:(NSString *)emailAddress phoneNumber:(NSString *)phoneNumber website:(NSString *)website margin:(int)buttonVMargin{
    [referralOptionsBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    //referralOptionsBar.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
    [contentView addSubview:referralOptionsBar];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    
    //[selfView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:barHeight]];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralOptionsBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    //self.navigationController.navigationBar.frame.size.height
    
    UIView *zerothPlaceHolderView = [[UIView alloc]init];
    [zerothPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:zerothPlaceHolderView];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    UIButtonWithString *firstImage;
    if ([emailAddress isEqualToString:@""]){
        firstImage = [[UIButtonWithString alloc] initWithStringTag:@"No email address on file"];
    }
    else {
        GlobalVariables *globals = [GlobalVariables sharedInstance];
        firstImage = [[UIButtonWithString alloc] initWithStringTag:[NSString stringWithFormat:@"mailto:%@%@%@",emailAddress, @"?subject=Request%20For%20Contact&body=Hi,%20My%20name%20is%20(Enter%20Your%20Name).%20I%20would%20Like%20For%20you%20To%20Contact%20Me.%20Thank%20you%0A%0A%0A", globals.emailFooter]];
    }
    
    [firstImage setBackgroundImage:[UIImage imageNamed:@"referral_email_icon.png"] forState:UIControlStateNormal];
    [firstImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:firstImage];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstImage attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    if ([emailAddress isEqualToString:@""]){
        [firstImage addTarget:self action:@selector(noData:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [firstImage addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *firstPlaceHolderView = [[UIView alloc]init];
    [firstPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:firstPlaceHolderView];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:firstImage attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButtonWithString *secondImage = [[UIButtonWithString alloc] initWithStringTag:@""];
    [secondImage setBackgroundImage:[UIImage imageNamed:@"referral_share_icon.png"] forState:UIControlStateNormal];
    [secondImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:secondImage];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:firstPlaceHolderView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstImage attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIView *secondPlaceHolderView = [[UIView alloc]init];
    [secondPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:secondPlaceHolderView];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:secondImage attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:secondPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButtonWithString *thirdImage;
    if ([phoneNumber isEqualToString:@""]){
        thirdImage = [[UIButtonWithString alloc] initWithStringTag:@"No phone number on file"];
    }
    else {
        thirdImage = [[UIButtonWithString alloc] initWithStringTag:[@"tel://" stringByAppendingString:phoneNumber]];
    }
    [thirdImage setBackgroundImage:[UIImage imageNamed:@"referral_call_icon.png"] forState:UIControlStateNormal];
    [thirdImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:thirdImage];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:secondPlaceHolderView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:thirdImage attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    if ([phoneNumber isEqualToString:@""]){
        [thirdImage addTarget:self action:@selector(noData:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [thirdImage addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *thirdPlaceHolderView = [[UIView alloc]init];
    [thirdPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:thirdPlaceHolderView];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:thirdImage attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:thirdPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButtonWithString *fourthImage;
    if ([website isEqualToString:@""]){
        fourthImage = [[UIButtonWithString alloc] initWithStringTag:@"No website on file"];
    }
    else {
        fourthImage = [[UIButtonWithString alloc] initWithStringTag:website];
    }
    [fourthImage setBackgroundImage:[UIImage imageNamed:@"referral_website_icon.png"] forState:UIControlStateNormal];
    [fourthImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:fourthImage];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:thirdPlaceHolderView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:firstImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:fourthImage attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    if ([website isEqualToString:@""]){
        [fourthImage addTarget:self action:@selector(noData:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [fourthImage addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *fourthPlaceHolderView = [[UIView alloc]init];
    [fourthPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [referralOptionsBar addSubview:fourthPlaceHolderView];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:fourthImage attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:referralOptionsBar attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [referralOptionsBar addConstraint:[NSLayoutConstraint constraintWithItem:fourthPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}
+(void)noData:(id)sender{
    [AppDelegate makeToast:[(UIButtonWithString *)sender stringTag]];
}
+ (void)openURLWithString:(NSString *)url{
    [MyUtilities openURLWithString:url];
}

+ (void)openURL:(id)sender{
    NSString *url = [(UIButtonWithString *)sender stringTag];
    [self openURLWithString:url];
}
+ (void)openNonWebURLWithString:(NSString *)url{
    [MyUtilities openNonWebURLWithString:url];
}

+ (void)openNonWebURL:(id)sender{
    NSString *url = [(UIButtonWithString *)sender stringTag];
    [self openNonWebURLWithString:url];
}
+ (void)openChooseRealtorForPhoneCallPopup{
    float width = 0.9;
    int fontSize = 24;
    int buttonVMargin = 8;
    int buttonHMargin = 12;
    
    UIViewController *selfController = [((UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController]).viewControllers lastObject];
    
    float yOrigin = 0;
    if (UIRectEdgeNone != selfController.edgesForExtendedLayout){
        yOrigin = selfController.navigationController.navigationBar.frame.origin.y+selfController.navigationController.navigationBar.frame.size.height;
    }
    
    UIView *selfView = selfController.view;
    
    chooseRealtorForPhoneCallPopup = [UIView new];
    chooseRealtorForPhoneCallPopup.frame = CGRectMake(0, yOrigin, selfView.frame.size.width, selfView.frame.size.height-yOrigin);
    chooseRealtorForPhoneCallPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [selfView addSubview:chooseRealtorForPhoneCallPopup];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
    [viewHolder setUserInteractionEnabled:YES];
    [viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chooseRealtorForPhoneCallPopup addSubview:viewHolder];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    
    UIButton *button1 = [UIButton new];
    [MyUtilities addPopupButton:button1 title:[@"Call " stringByAppendingString:globals.firstRealtorName] viewHolder:viewHolder beneath:viewHolder position:1 width:width*selfView.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button1 addTarget:self action:@selector(closeChooseRealtorForPhoneCallPopup) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(callFirstRealtor) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton new];
    [MyUtilities addPopupButton:button2 title:[@"Call " stringByAppendingString:globals.secondRealtorName] viewHolder:viewHolder beneath:button1 position:2 width:width*selfView.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button2 addTarget:self action:@selector(closeChooseRealtorForPhoneCallPopup) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(callSecondRealtor) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton new];
    [MyUtilities underlineTextInButton:button title:@"close" fontSize:20];
    //[button setTitle:@"close" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"close";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*selfView.frame.size.width/3.0, 10000)];
    size = CGSizeMake(width*selfView.frame.size.width/3.0, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:button];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    [button addTarget:self action:@selector(closeChooseRealtorForPhoneCallPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseRealtorForPhoneCallPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:chooseRealtorForPhoneCallPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [chooseRealtorForPhoneCallPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:chooseRealtorForPhoneCallPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

+ (void)closeChooseRealtorForPhoneCallPopup{
    [chooseRealtorForPhoneCallPopup removeFromSuperview];
}
+(void)callFirstRealtor{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [MyUtilities openNonWebURLWithString:[@"tel://" stringByAppendingString:globals.firstRealtorPhoneNumber]];
}
+(void)callSecondRealtor{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [MyUtilities openNonWebURLWithString:[@"tel://" stringByAppendingString:globals.secondRealtorPhoneNumber]];
}
+ (void)goHome:(id)sender{
    if (![[((UINavigationController *)[[(UIView *)sender window] rootViewController]).viewControllers lastObject] isMemberOfClass: [HomeScreenViewController class]]){
        [(UINavigationController *)[[(UIView *)sender window] rootViewController] pushViewController:[HomeScreenViewController new] animated:YES];
        //[(UINavigationController *)[[(UIView *)sender window] rootViewController] popToRootViewControllerAnimated:YES];
    }
}

+ (void)goBack:(id)sender{
    UIViewController *viewController = [((UINavigationController *)[[(UIView *)sender window] rootViewController]).viewControllers lastObject];
    if ([viewController isMemberOfClass: [WebviewViewController class]] && [[(WebviewViewController *)viewController webview] canGoBack]){
        [[(WebviewViewController *)viewController webview] goBack];
    }
    else {
        [(UINavigationController *)[[(UIView *)sender window] rootViewController] popViewControllerAnimated:YES];
    }
}

+ (void)startMessager:(id)sender{
    if ([AppDelegate firstName]==nil || [AppDelegate lastName]==nil){
        [(BaseViewController *)[((UINavigationController *)[[(UIView *)sender window] rootViewController]).viewControllers lastObject] tryToRegister];
    }
    else if (![[((UINavigationController *)[[(UIView *)sender window] rootViewController]).viewControllers lastObject] isMemberOfClass: [MessagerViewController class]]){
        [(UINavigationController *)[[(UIView *)sender window] rootViewController] pushViewController:[MessagerViewController new] animated:YES];
    }
}
@end
