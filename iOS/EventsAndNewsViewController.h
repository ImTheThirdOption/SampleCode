//
//  EventsAndNewsViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"

@interface EventsAndNewsViewController : BaseViewController
- (void)addButton: (UIButton *)button title: (NSString *)title contentView: (UIView *)contentView beneath: (id)above position: (int)position width: (float)width margin: (int)margin;

@end
