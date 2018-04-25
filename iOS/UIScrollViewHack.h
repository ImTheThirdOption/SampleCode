//
//  UIScrollViewHack.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollViewHack : UIScrollView
- (BOOL)touchesShouldCancelInContentView:(UIView *)view;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end
