//
//  UIButtonWithDataForRegistrationPopup.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIButtonWithDataForRegistrationPopup.h"

@implementation UIButtonWithDataForRegistrationPopup{
    UITextField *_textField1;
    UITextField *_textField2;
    UITextField *_textField3;
    UITextField *_textField4;
    UITextField *_textField5;
    UISegmentedControl *_segmentedControl1;
    UISegmentedControl *_segmentedControl2;
}
-(void)addData:(UITextField *)textField1 :(UITextField *)textField2 :(UITextField *)textField3 :(UITextField *)textField4 :(UITextField *)textField5 :(UISegmentedControl *)segmentedControl1 :(UISegmentedControl *)segmentedControl2{
    _textField1 = textField1;
    _textField2 = textField2;
    _textField3 = textField3;
    _textField4 = textField4;
    _textField5 = textField5;
    _segmentedControl1 = segmentedControl1;
    _segmentedControl2 = segmentedControl2;
}
@end

