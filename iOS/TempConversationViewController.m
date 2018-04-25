//
//  TempConversationViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "TempConversationViewController.h"
#import "AppDelegate.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "ConversationsDatabase.h"
#import "GlobalVariables.h"
#import "MyUtilities.h"
#import "HttpPost.h"
#import "BottomNavigationBar.h"

@interface TempConversationViewController ()

@end

@implementation TempConversationViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) viewDidLoad{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //_viewHolderForKeyboard = [UIView new];
    _viewHolderForKeyboard = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
    //[_viewHolderForKeyboard setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview: _viewHolderForKeyboard];
    /*[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewHolderForKeyboard attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];*/
    
    UIButton *secondPersonName = [UIButton new];
    [secondPersonName setTitle:[NSString stringWithFormat:@"%@ %@", _toFirstName, _toLastName] forState:UIControlStateNormal];
    [secondPersonName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [secondPersonName.titleLabel setTextAlignment:NSTextAlignmentLeft];
    secondPersonName.titleLabel.font = [UIFont systemFontOfSize:24];
    secondPersonName.titleLabel.numberOfLines = 0;
    
    secondPersonName.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:116.0/255.0 blue:66.0/255.0 alpha:1];
    CGRect rect = [secondPersonName.titleLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]} context:nil];
    //[secondPersonName setBackgroundImage:nil forState:UIControlStateNormal];
    [secondPersonName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_viewHolderForKeyboard addSubview:secondPersonName];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.height)]];
    
    float buttonWidth = 0.9;
    int buttonVMargin = 9;
    _scrollView  = [[UIScrollViewHack alloc] init];
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_viewHolderForKeyboard addSubview:_scrollView];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:secondPersonName attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    //[_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    _contentView = [[UIView alloc] init];
    [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_scrollView addSubview:_contentView];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:button];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:0]];
    _constraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [_contentView addConstraint:_constraint];
    _bottomView = button;
    
    ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
    sqlite3_stmt *query = [db loadHistory:[NSString stringWithFormat:@"%@%@", _toFirstName, _toLastName]];
    
    while (sqlite3_step(query) == SQLITE_ROW) {
        char *messageChars = (char *) sqlite3_column_text(query, 0);
        int sendOrReceive = (int) sqlite3_column_int(query, 1);
        NSString *message = [[NSString alloc] initWithUTF8String:messageChars];
        [self addNewMessage:message sendOrReceive:sendOrReceive];
    }
    sqlite3_finalize(query);
    
    UIView *textFieldHolder = [UIView new];
    [textFieldHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_viewHolderForKeyboard addSubview:textFieldHolder];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    UIButton *textFieldButton = [UIButton new];
    //textFieldButton.backgroundColor = [UIColor clearColor];
    //UIEdgeInsets insets = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0);
    [textFieldButton setBackgroundImage:[UIImage imageNamed:@"ic_send_white_48dp.png"] forState:UIControlStateNormal];
    [textFieldButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textFieldHolder addSubview:textFieldButton];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:45]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:45]];
    [textFieldButton addTarget:self action:@selector(composeMessageEnterPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [UITextField new];
    _textField.layer.cornerRadius = 4.0;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderColor = [[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] CGColor];
    _textField.layer.borderWidth = 0.0;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type to compose message" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    _textField.textColor = [UIColor whiteColor];
    _textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textFieldHolder addSubview:_textField];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:-45]];
    _textField.delegate = self;
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:_viewHolderForKeyboard navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)textFieldHolder headerImage:(UIView *)_scrollView];
    
    
}

-(id)initWithToFirstName: (NSString *)firstName toLastName: (NSString *)lastName{
    self = [super init];
    if( !self ) return nil;
    
    _toFirstName = [firstName copy];
    _toLastName = [lastName copy];
    
    return self;
}

- (void)setupAppointment{}

-(void)composeMessageEnterPressed{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"send-message.php"]]];
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[AppDelegate firstName], @"fromFirstName", [AppDelegate lastName], @"fromLastName", _textField.text, @"message", nil];
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@"instantMessage", @"type", message, @"message", nil];
    NSError *error;
    NSString *post = [NSString stringWithFormat:@"toFirstName=%@&toLastName=%@&message_payload=%@%@",_toFirstName,_toLastName, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding],globals.phpKey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = postData;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data)  {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[[jsonDictionary objectForKey:@"success"] stringValue] isEqualToString:@"1"]){
                    ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
                    [db addMessage:_toFirstName lastName:_toLastName message:_textField.text sendOrReceive:0];
                    [self addNewMessage:_textField.text sendOrReceive:0];
                    _textField.text=@"";
                }
                else {
                    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:[@"abc" stringByAppendingString:[jsonDictionary description]] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        //[alertController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            });
        }
    }];
    
    [dataTask resume];
}
- (void)addNewMessage:(NSString *)message sendOrReceive:(int)sendOrReceive{
    UIEdgeInsets edgeInsets;
    int hMargin = 9;
    int vMargin = 2;
    
    UIImageView *imageView = [UIImageView new];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:imageView];
    if (0==sendOrReceive){
        edgeInsets = UIEdgeInsetsMake(12, 14, 12, 18);
        imageView.image = [[UIImage imageNamed:@"outgoing_bubble.png"] resizableImageWithCapInsets:edgeInsets];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
    }
    else {
        edgeInsets = UIEdgeInsetsMake(12, 18, 12, 14);
        imageView.image = [[UIImage imageNamed:@"incoming_bubble.png"] resizableImageWithCapInsets:edgeInsets];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
    }
    //CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-edgeInsets.left-edgeInsets.right-2.0*hMargin, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width-edgeInsets.left-edgeInsets.right-2.0*hMargin, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    //CGSize size = [label sizeThatFits:CGSizeMake(self.view.frame.size.width-2.0*hMargin, 10000)];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.width)+edgeInsets.left+edgeInsets.right]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.height)+edgeInsets.top+edgeInsets.bottom]];
    
    UILabel *label = [UILabel new];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView addSubview:label];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInsets.top]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:-edgeInsets.bottom]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeLeading multiplier:1 constant:edgeInsets.left]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-edgeInsets.right]];
    
    [_contentView removeConstraint:_constraint];
    _constraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin];
    [_contentView addConstraint:_constraint];
    _bottomView = imageView;
    [_textField resignFirstResponder];
    [self scrollToBottom];
}
- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    _viewHolderForKeyboard.frame = CGRectMake(_viewHolderForKeyboard.frame.origin.x, _viewHolderForKeyboard.frame.origin.y, _viewHolderForKeyboard.frame.size.width, _viewHolderForKeyboard.frame.size.height-keyboardSize.height);
    [UIView commitAnimations];
    _scrollView.contentOffset = CGPointMake(0,_scrollView.contentOffset.y+keyboardSize.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    NSDictionary* dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    _viewHolderForKeyboard.frame = CGRectMake(_viewHolderForKeyboard.frame.origin.x, _viewHolderForKeyboard.frame.origin.y, _viewHolderForKeyboard.frame.size.width, _viewHolderForKeyboard.frame.size.height+keyboardSize.height);
    [UIView commitAnimations];
    _scrollView.contentOffset = CGPointMake(0,_scrollView.contentOffset.y-keyboardSize.height);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)scrollToBottom{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [_scrollView scrollRectToVisible:CGRectMake(_scrollView.contentSize.width - 1,_scrollView.contentSize.height - 1, 1, 1) animated:YES];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
