//
//  UIScrollViewHack.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "UIScrollViewHack.h"

@implementation UIScrollViewHack

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
@end
