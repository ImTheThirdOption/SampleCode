//
//  TempConversationViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"
#import <sqlite3.h>
#import "UIScrollViewHack.h"

@interface TempConversationViewController : BaseViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSString *toFirstName;
@property (strong, nonatomic) NSString *toLastName;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSLayoutConstraint *constraint;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *viewHolderForKeyboard;
@property (strong, nonatomic) UIScrollViewHack *scrollView;

-(id)initWithToFirstName: (NSString *)firstName toLastName: (NSString *)lastName;
-(void)addNewMessage:(NSString *)message sendOrReceive:(int)sendOrReceive;
-(void)scrollToBottom;

@end
