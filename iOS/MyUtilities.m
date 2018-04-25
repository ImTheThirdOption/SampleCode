//
//  MyUtilities.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//
#import "MyUtilities.h"
#import "WebviewViewController.h"

@implementation MyUtilities{
    
}

+(void)addShadow:(UIView *)view{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    //UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 500, 10) cornerRadius:5.0];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    view.layer.shadowOpacity = 0.7f;
    //view.layer.shadowPath = shadowPath.CGPath;
}

+(void)addShadow:(UIView *)view fromPath:(UIBezierPath *)shadowPath{
    //UIBezierPath *shadowPath2 = [UIBezierPath bezierPathWithRect:view.bounds];
    //UIBezierPath *shadowPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 500, 10) cornerRadius:5.0];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowRadius = 1.0;
    //view.layer.shadowPath = shadowPath.CGPath;
}
+(void)addShadowViewBelow:(UIView *)view{
    UIView *shadowView = [UIView new];
    shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[view superview] addSubview:shadowView];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
}

+(void)addShadowViewAbove:(UIView *)view{
    UIView *shadowView = [UIView new];
    shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[view superview] addSubview:shadowView];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [[view superview] addConstraint:[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
}
+ (void)addButton:(UIButton *)button selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin{
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:button];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    if (1==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
        
    }
    else{
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:margin]];
        
    }
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:(button.currentBackgroundImage.size.width / button.currentBackgroundImage.size.height) constant:0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    if (3==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    }
}
+ (void)addImageView:(UIImageView *)view selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:view];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    if (1==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
        
    }
    else{
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:margin]];
        
    }
    if (view.image.size.height!=0){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:(view.image.size.width / view.image.size.height) constant:0]];
    }
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    if (3==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    }
}
+(void)addImageView:(UIImageView *)imageView withInsets:(UIEdgeInsets)edgeInsets andText:(NSString *)text fontSize:(int)fontSize selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin{
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:imageView];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    if (1==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
        
    }
    else{
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:margin]];
        
    }
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    if (3==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    }

    
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-edgeInsets.left-edgeInsets.right-2.0*hMargin, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width*selfView.frame.size.width-edgeInsets.left-edgeInsets.right, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    //CGSize size = [label sizeThatFits:CGSizeMake(self.view.frame.size.width-2.0*hMargin, 10000)];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.height)+edgeInsets.top+edgeInsets.bottom]];
    
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView addSubview:label];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInsets.top]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:-edgeInsets.bottom]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeLeading multiplier:1 constant:edgeInsets.left]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-edgeInsets.right]];
}
+ (void)addButton:(UIButton *)button title:(NSString *)title selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*selfView.frame.size.width, 10000)];
    
    //CGSize size = CGSizeMake(width*selfView.frame.size.width, 10);
    size = CGSizeMake(width*selfView.frame.size.width, MAX(size.height, 30));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    //[[UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1] setFill];
    //UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0.5, size.width-1.0, size.height-1.0) cornerRadius:5.0];
    [[UIColor blackColor] setStroke];
    path.lineWidth = 2.0;
    [path stroke];
    [[UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1] setFill];
    [path fill];
    
    [button setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = button.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5.0].CGPath;
    button.layer.mask = maskLayer;
    
    /*CGRect shadowFrame;
     shadowFrame.size.width = 200.f;
     shadowFrame.size.height = 200.f;
     shadowFrame.origin.x = 0.f;
     shadowFrame.origin.y = 0.f;*/
    UIView *shadow = [[UIView alloc] init];
    [shadow setTranslatesAutoresizingMaskIntoConstraints:NO];
    shadow.tag = 1;
    //shadow.userInteractionEnabled = YES;
    shadow.layer.shadowColor = [UIColor blackColor].CGColor;
    shadow.layer.shadowOffset = CGSizeMake(-5.0, 5.0);
    shadow.layer.shadowRadius = 5.0;
    shadow.layer.masksToBounds = NO;
    shadow.clipsToBounds = NO;
    shadow.layer.shadowOpacity = 0.7;
    
    [shadow addSubview:button];
    [contentView addSubview:shadow];
    //[button.superview insertSubview:shadow belowSubview:button];
    //[shadow addSubview:button];
    //shadow.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:155.0/255.0 alpha:1];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    [button sizeToFit];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    if (1==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:shadow attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
        
    }
    else{
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:shadow attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:margin]];
        
    }
    [shadow addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    //[shadow addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:shadow attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [shadow addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //[shadow addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    //[shadow addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:shadow attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    
    //[button.superview insertSubview:shadow belowSubview:button];
    //[shadow addSubview:button];
    //shadow.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:155.0/255.0 alpha:1];
    
    //[selfView addConstraint:[NSLayoutConstraint constraintWithItem:shadow attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:shadow attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    if (3==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:shadow attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    }
    
    
    
    /*UIView *view2 = [[UIView alloc] init];
     
     view2.layer.cornerRadius = 5.0;
     view2.layer.shadowColor = [[UIColor blackColor] CGColor];
     view2.layer.shadowOpacity = 1.0;
     view2.layer.shadowRadius = 10.0;
     view2.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
     [button.superview insertSubview:view2 belowSubview:button];
     [view2 addSubview:button];*/
     //[MyUtilities addShadow:button fromPath:path];
}
+ (void)addButtonAsClickableTextWithPicture:(UIButton *)button title:(NSString *)title imageview:(UIImageView *)imageview selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize{
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:91.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width-3*hMargin-30, 10000)];
    size = CGSizeMake(width-3*hMargin-30, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [contentView addSubview:button];
    if (1==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
        
    }
    else{
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];
        
    }
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeLeading multiplier:1 constant:2*hMargin+30]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    
    [button.titleLabel sizeToFit];
    if (3==position){
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
    }
    if(imageview!=nil){
        [imageview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView addSubview:imageview];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
        [selfView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
        [selfView addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin+30]];
    }
}
+ (void)addPopupButton:(UIButton *)button title:(NSString *)title viewHolder:(UIView *)viewHolder beneath:(id)above position:(int)position width:(float)width vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width-2*hMargin, 10000)];
    size = CGSizeMake(width-2*hMargin, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:button];
    if (1==position){
        [self addConstraint:viewHolder view:button topView:viewHolder topMultiplier:1 topConstant:vMargin heightView:nil heightMultiplier:0 heightConstant:size.height centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*hMargin];
        /*[viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];*/
    }
    else{
        [self addConstraint:viewHolder view:button topToBottomView:above topToBottomMultiplier:1 topToBottomConstant:vMargin heightView:nil heightMultiplier:0 heightConstant:size.height centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*hMargin];
        /*[viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];*/
    }
    /*[viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*hMargin]];
     [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
     [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];*/
    if (3==position){
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
    }
}
+ (void)addPopupButtonWithPicture:(UIButton *)button title:(NSString *)title imageview:(UIImageView *)imageview viewHolder:(UIView *)viewHolder beneath:(id)above position:(int)position width:(float)width vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width-3*hMargin-30, 10000)];
    size = CGSizeMake(width-3*hMargin-30, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:button];
    if (1==position){
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
    }
    else{
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];
    }
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:2*hMargin+30]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    if (3==position){
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
    }
    if(imageview!=nil){
        [imageview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [viewHolder addSubview:imageview];
        
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin+30]];
    }
}
+ (void)addTextField:(UITextField *)textfield :(NSString *)hint :(UIView *)viewHolder :(id)above :(int)position vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize{
    textfield.layer.cornerRadius = 4.0;
    textfield.layer.masksToBounds = YES;
    textfield.layer.borderColor = [[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] CGColor];
    textfield.layer.borderWidth = 1.0;
    textfield.font = [UIFont systemFontOfSize:fontSize];
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hint attributes:@{ NSForegroundColorAttributeName :[UIColor blackColor] }];
    [textfield setTranslatesAutoresizingMaskIntoConstraints:NO];
    textfield.textColor = [UIColor blackColor];
    
    [viewHolder addSubview:textfield];
    if (1==position){
        [self addConstraint:viewHolder view:textfield topView:viewHolder topMultiplier:1 topConstant:vMargin centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*hMargin];
    }
    else{
        [self addConstraint:viewHolder view:textfield topToBottomView:above topToBottomMultiplier:1 topToBottomConstant:vMargin centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*hMargin];
    }
    if (3==position){
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:textfield attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
    }
}
+ (void)addCellButton:(UIButton *)preview contentView:(UIView *)contentView vMargin:(float)vMargin hMargin:(float)hMargin{
    /*[button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*selfView.frame.size.width, 10000)];*/
    
    CGSize size = CGSizeMake(250, 50);
    //size = CGSizeMake(width*selfView.frame.size.width, MAX(size.height, 30));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [[UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5.0];
    [[UIColor blackColor] setStroke];
    path.lineWidth = 2.0;
    //[path stroke];
    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] setFill];
    [path fill];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [preview setBackgroundImage:image forState:UIControlStateNormal];
    //UIGraphicsEndImageContext();
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = preview.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5.0].CGPath;
    //preview.layer.mask = maskLayer;
    
    [contentView addSubview:preview];
    [self addConstraint:contentView view:preview topView:contentView topMultiplier:1 topConstant:vMargin bottomView:contentView bottomMultiplier:1 bottomConstant:-vMargin widthView:contentView widthMultiplier:.67 widthConstant:-2.0*hMargin trailingView:contentView trailingMultiplier:1 trailingConstant:-hMargin];
    /*[contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:.67 constant:0]];
     [contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
     [contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
     [contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];*/

    //[MyUtilities addShadow:button fromPath:path];
}

+ (void)addSpecificNotificationBox:(UITextView *)textView title:(NSString *)title selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above on:(UIImageView *)imageView vMargin:(float)vMargin hMargin:(float)hMargin vTextPadding:(float)vTextPadding hTextPadding:(float)hTextPadding{

    /*NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.firstLineHeadIndent = 4.0f;
    style.headIndent = 4.0f;
    style.tailIndent = -5.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:title attributes:@{ NSParagraphStyleAttributeName :style}];*/
    
    /*[button setAttributedTitle:attrText forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor colorWithRed:137.0/255.0 green:133.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    button.titleLabel.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.numberOfLines = 0;*/
    textView.text = title;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor colorWithRed:137.0/255.0 green:133.0/255.0 blue:132.0/255.0 alpha:1];
    textView.backgroundColor = [UIColor clearColor];
     
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(selfView.frame.size.width-2.0*hMargin, 10000)];
    
    size = CGSizeMake(selfView.frame.size.width-2.0*hMargin, MAX(size.height+2.0*vTextPadding, 30));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [[UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5.0];
    [[UIColor blackColor] setStroke];
    path.lineWidth = 2.0;
    //[path stroke];
    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] setFill];
    [path fill];
    
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [imageView setImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    
    /*[button setBackgroundImage:image forState:UIControlStateNormal];
    //UIGraphicsEndImageContext();
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = button.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5.0].CGPath;
    //button.layer.mask = maskLayer;*/
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:imageView];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
    [imageView sizeToFit];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:above attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];
    
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView addSubview:textView];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
    
    
    //[MyUtilities addShadow:button fromPath:path];
}
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topView:(UIView *)topView topMultiplier:(float)topMultiplier topConstant:(float)topConstant heightView:(UIView *)heightView heightMultiplier:(float)heightMultiplier heightConstant:(float)heightConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant{
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:topMultiplier constant:topConstant]];
    if (nil==heightView){
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:heightConstant]];
    }
    else {
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:heightView attribute:NSLayoutAttributeHeight multiplier:heightMultiplier constant:heightConstant]];
    }
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerXView attribute:NSLayoutAttributeCenterX multiplier:centerXMultiplier constant:centerXConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:widthView attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:widthConstant]];
}
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topToBottomView:(UIView *)topToBottomView topToBottomMultiplier:(float)topToBottomMultiplier topToBottomConstant:(float)topToBottomConstant heightView:(UIView *)heightView heightMultiplier:(float)heightMultiplier heightConstant:(float)heightConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant{
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topToBottomView attribute:NSLayoutAttributeBottom multiplier:topToBottomMultiplier constant:topToBottomConstant]];
    if (nil==heightView){
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:heightConstant]];
    }
    else {
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:heightView attribute:NSLayoutAttributeHeight multiplier:heightMultiplier constant:heightConstant]];
    }
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerXView attribute:NSLayoutAttributeCenterX multiplier:centerXMultiplier constant:centerXConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:widthView attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:widthConstant]];
}
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topView:(UIView *)topView topMultiplier:(float)topMultiplier topConstant:(float)topConstant bottomView:(UIView *)bottomView bottomMultiplier:(float)bottomMultiplier bottomConstant:(float)bottomConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant trailingView:(UIView *)trailingView trailingMultiplier:(float)trailingMultiplier trailingConstant:(float)trailingConstant{
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:topMultiplier constant:topConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:bottomMultiplier constant:bottomConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:widthView attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:widthConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:trailingView attribute:NSLayoutAttributeTrailing multiplier:trailingMultiplier constant:trailingConstant]];
}
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topView:(UIView *)topView topMultiplier:(float)topMultiplier topConstant:(float)topConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant{
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:topMultiplier constant:topConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerXView attribute:NSLayoutAttributeCenterX multiplier:centerXMultiplier constant:centerXConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:widthView attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:widthConstant]];
    [view sizeToFit];
}
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topToBottomView:(UIView *)topToBottomView topToBottomMultiplier:(float)topToBottomMultiplier topToBottomConstant:(float)topToBottomConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant{
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topToBottomView attribute:NSLayoutAttributeBottom multiplier:topToBottomMultiplier constant:topToBottomConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerXView attribute:NSLayoutAttributeCenterX multiplier:centerXMultiplier constant:centerXConstant]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:widthView attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:widthConstant]];
    [view sizeToFit];
}
+(float)calculateHeightFor:(NSString *)title and:(float)width with:(int)fontSize{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width, 10000)];
    size = CGSizeMake(width, MAX(size.height, 30));
    return size.height;
}
+(void)openURLWithString:(NSString *)url{
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:[[WebviewViewController alloc] initWithString:url] animated:YES];
}
+(void)openNonWebURLWithString:(NSString *)url{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
+(void)underlineTextInButton:(UIButton *)button title:(NSString *)title fontSize:(int)fontSize{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize]
                                                                     forKey:NSFontAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:attributesDictionary];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:1]
                             range:(NSRange){0,[attributedString length]}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] range:NSMakeRange(0, attributedString.length)];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
}
@end
