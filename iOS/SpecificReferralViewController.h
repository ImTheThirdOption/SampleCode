//
//  SpecificReferralViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"

@interface SpecificReferralViewController : BaseViewController
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *referralNumber;
@property (strong, nonatomic) UIImageView *referralImage;
@property (weak, nonatomic) UITextView *referralText;
@property (strong, nonatomic) UIImageView *imageForText;
@property (strong, nonatomic) UIView *referralOptionsBar;
@property (strong, nonatomic) UIImageView *copyright;
@property (strong, nonatomic) UIImageView *header1;
@property (nonatomic) int hMargin;
@property (nonatomic )int vMargin;
@property (nonatomic) int hTextPadding;
@property (nonatomic )int vTextPadding;


-(id)initWithNumber:(NSString *)referralNumber;

@end
