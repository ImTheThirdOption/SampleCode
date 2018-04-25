//
//  UIButtonWithDataForRegistrationPopup.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonWithDataForRegistrationPopup : UIButton
@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UITextField *textField3;
@property (strong, nonatomic) UITextField *textField4;
@property (strong, nonatomic) UITextField *textField5;
@property (strong, nonatomic) UISegmentedControl *segmentedControl1;
@property (strong, nonatomic) UISegmentedControl *segmentedControl2;
-(void)addData:(UITextField *)textField1 :(UITextField *)textField2 :(UITextField *)textField3 :(UITextField *)textField4 :(UITextField *)textField5 :(UISegmentedControl *)segmentedControl1 :(UISegmentedControl *)segmentedControl2;
@end
