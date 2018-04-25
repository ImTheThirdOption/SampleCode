//
//  MyUtilities.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUtilities : NSObject
+(void)addShadow:(UIView *)view;
+(void)addShadow:(UIView *)view fromPath:(UIBezierPath *)shadowPath;
+(void)addShadowViewBelow:(UIView *)view;
+(void)addShadowViewAbove:(UIView *)view;
+(void)addButton:(UIButton *)button selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin;
+(void)addImageView:(UIImageView *)imageView selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin;
+(void)addImageView:(UIImageView *)imageView withInsets:(UIEdgeInsets)edgeInsets andText:(NSString *)text fontSize:(int)fontSize selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin;
+(void)addButton:(UIButton *)button title:(NSString *)title selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width margin:(float)margin;
+(void)addButtonAsClickableTextWithPicture:(UIButton *)button title:(NSString *)title imageview:(UIImageView *)imageview selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above position:(int)position width:(float)width vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize;
+(void)addPopupButton:(UIButton *)button title:(NSString *)title viewHolder:(UIView *)viewHolder beneath:(id)above position:(int)position width:(float)width vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize;
+(void)addPopupButtonWithPicture:(UIButton *)button title:(NSString *)title imageview:(UIImageView *)imageview viewHolder:(UIView *)viewHolder beneath:(id)above position:(int)position width:(float)width vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize;
+(void)addTextField:(UITextField *)textfield :(NSString *)hint :(UIView *)viewHolder :(id)above :(int)position vMargin:(float)vMargin hMargin:(float)hMargin fontSize:(int)fontSize;
+(void)addCellButton:(UIButton *)preview contentView:(UIView *)contentView vMargin:(float)vMargin hMargin:(float)hMargin;
+(void)addSpecificNotificationBox:(UITextView *)textView title:(NSString *)title selfView:(UIView *)selfView contentView:(UIView *)contentView beneath:(id)above on:(UIImageView *)imageView vMargin:(float)vMargin hMargin:(float)hMargin vTextPadding:(float)vTextPadding hTextPadding:(float)hTextPadding;
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topView:(UIView *)topView topMultiplier:(float)topMultiplier topConstant:(float)topConstant heightView:(UIView *)heightView heightMultiplier:(float)heightMultiplier heightConstant:(float)heightConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant;
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topToBottomView:(UIView *)topToBottomView topToBottomMultiplier:(float)topToBottomMultiplier topToBottomConstant:(float)topToBottomConstant heightView:(UIView *)heightView heightMultiplier:(float)heightMultiplier heightConstant:(float)heightConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant;
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topView:(UIView *)topView topMultiplier:(float)topMultiplier topConstant:(float)topConstant bottomView:(UIView *)bottomView bottomMultiplier:(float)bottomMultiplier bottomConstant:(float)bottomConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant trailingView:(UIView *)trailingView trailingMultiplier:(float)trailingMultiplier trailingConstant:(float)trailingConstant;
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topView:(UIView *)topView topMultiplier:(float)topMultiplier topConstant:(float)topConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant;
+(void)addConstraint:(UIView *)viewHolder view:(UIView *)view topToBottomView:(UIView *)topToBottomView topToBottomMultiplier:(float)topToBottomMultiplier topToBottomConstant:(float)topToBottomConstant centerXView:(UIView *)centerXView centerXMultiplier:(float)centerXMultiplier centerXConstant:(float)centerXConstant widthView:(UIView *)widthView widthMultiplier:(float)widthMultiplier widthConstant:(float)widthConstant;
+(float)calculateHeightFor:(NSString *)title and:(float)width with:(int)fontSize;
+(void)openURLWithString:(NSString *)url;
+(void)openNonWebURLWithString:(NSString *)url;
+(void)underlineTextInButton:(UIButton *)button title:(NSString *)title fontSize:(int)fontSize;
@end
