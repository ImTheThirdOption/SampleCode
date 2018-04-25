//
//  SpecificNotificationViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"

@interface SpecificNotificationViewController : BaseViewController
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *notificationNumber;
@property (strong, nonatomic) UIImageView *notificationImage;
@property (weak, nonatomic) UITextView *notificationText;
@property (strong, nonatomic) UIImageView *imageForText;
@property (strong, nonatomic) UIImageView *header1;
@property (nonatomic) int hMargin;
@property (nonatomic )int vMargin;
@property (nonatomic) int hTextPadding;
@property (nonatomic )int vTextPadding;


-(id)initWithNumber:(NSString *)notificationNumber;

@end
