//
//  BottomNavigationBar.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomNavigationBar : NSObject 
+ (void)addBottomNavigationBar: (UIView *)bottomNavigationBar to:(UIView *)selfView navigationBarHeight: (float)barHeight scrollView: (UIView *)scrollView headerImage: (UIView *)headerImage;
+ (void)createBottomNavigationBar: (UIView *)bottomNavigationBar;
+ (void)addReferralOptionsBar: (UIView *)referralOptionsBar selfView:(UIView *)selfView beneath:(id)above contentView:(UIView *)contentView barHeight:(float)barHeight emailAddress:(NSString *)emailAddress phoneNumber:(NSString *)phoneNumber website:(NSString *)website margin:(int)buttonVMargin;
+ (void)openNonWebURL:(id)sender;
+ (void)goHome:(id)sender;
+ (void)goBack:(id)sender;
@end
