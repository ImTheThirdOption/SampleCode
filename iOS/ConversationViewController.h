//
//  ConversationViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"
#import <sqlite3.h>

@interface ConversationViewController : BaseViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSString *toFirstName;
@property (strong, nonatomic) NSString *toLastName;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *viewHolderForKeyboard;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

-(id)initWithToFirstName: (NSString *)firstName toLastName: (NSString *)lastName;
-(void)addNewMessage:(NSString *)message sendOrReceive:(int)sendOrReceive;
-(void)scrollToBottom;

@end
