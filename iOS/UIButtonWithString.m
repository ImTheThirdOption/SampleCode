//
//  UIButtonWithString.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//
//#import <Foundation/Foundation.h>
#import "UIButtonWithString.h"

@implementation UIButtonWithString

-(id)initWithStringTag:(NSString *)stringTag{
    self = [super init];
    if (self){
        _stringTag = [stringTag copy];
    }
    return self;
}

@end
