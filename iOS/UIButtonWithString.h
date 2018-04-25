//
//  UIButtonWithString.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonWithString : UIButton
@property (strong, nonatomic) NSString *stringTag;
-(id)initWithStringTag:(NSString *)stringTag;
@end
