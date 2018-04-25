//
//  ConversationViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "ConversationViewController.h"
#import "AppDelegate.h"
#import "ConversationsDatabase.h"
#import "GlobalVariables.h"
#import "MyUtilities.h"
#import "HttpPost.h"
#import "BottomNavigationBar.h"

@interface ConversationViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ConversationViewController

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
    
    _viewHolderForKeyboard = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
    [self.view addSubview: _viewHolderForKeyboard];
    
    UIButton *secondPersonName = [UIButton new];
    [secondPersonName setTitle:[NSString stringWithFormat:@"%@ %@", _toFirstName, _toLastName] forState:UIControlStateNormal];
    [secondPersonName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [secondPersonName.titleLabel setTextAlignment:NSTextAlignmentLeft];
    secondPersonName.titleLabel.font = [UIFont systemFontOfSize:24];
    secondPersonName.titleLabel.numberOfLines = 0;
    
    secondPersonName.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:116.0/255.0 blue:66.0/255.0 alpha:1];
    CGRect rect = [secondPersonName.titleLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]} context:nil];
    [secondPersonName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_viewHolderForKeyboard addSubview:secondPersonName];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.height)]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ceil(rect.size.height), self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-3.0*self.navigationController.navigationBar.frame.size.height-rect.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alwaysBounceVertical = NO;
    [_viewHolderForKeyboard addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 120.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
    _dataArray = [db loadArrayHistory:[NSString stringWithFormat:@"%@%@", _toFirstName, _toLastName]];
    
    UIView *textFieldHolder = [UIView new];
    [textFieldHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_viewHolderForKeyboard addSubview:textFieldHolder];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:textFieldHolder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.navigationController.navigationBar.frame.size.height]];
    
    UIButton *textFieldButton = [UIButton new];
    [textFieldButton setBackgroundImage:[UIImage imageNamed:@"ic_send_white_48dp.png"] forState:UIControlStateNormal];
    [textFieldButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textFieldHolder addSubview:textFieldButton];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    //[textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:MIN(self.navigationController.navigationBar.frame.size.height,45)]];
    
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:textFieldButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:MIN(self.navigationController.navigationBar.frame.size.height,45)]];
    
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
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [textFieldHolder addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:-MIN(self.navigationController.navigationBar.frame.size.height,45)]];
    
    _textField.delegate = self;
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    
    [bottomNavigationBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    bottomNavigationBar.backgroundColor = globals.bottomNavigationBarColor;
    [_viewHolderForKeyboard addSubview:bottomNavigationBar];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textFieldHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.navigationController.navigationBar.frame.size.height]];
    //[_viewHolderForKeyboard addConstraint:[NSLayoutConstraint constraintWithItem:bottomNavigationBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_viewHolderForKeyboard attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [BottomNavigationBar createBottomNavigationBar:bottomNavigationBar];
    [self scrollToBottom];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
#define BUBBLEIMAGE_TAG 1

#define BUBBLETEXT_TAG 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [[_dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    int sendOrReceive = [[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
    static NSString *cellIdentifier;
    if (0==sendOrReceive){
        cellIdentifier = @"outgoingIdentifier";
    }
    else {
        cellIdentifier = @"incomingIdentifier";
    }
    UIImageView *imageView;
    UILabel *label;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIEdgeInsets edgeInsets;
    int hMargin = 9;
    int vMargin = 2;
    if (nil==cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
        
        imageView = [UIImageView new];
        imageView.tag = BUBBLEIMAGE_TAG;
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:imageView];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
        if (0==sendOrReceive){
            edgeInsets = UIEdgeInsetsMake(12, 14, 12, 18);
            imageView.image = [[UIImage imageNamed:@"outgoing_bubble.png"] resizableImageWithCapInsets:edgeInsets];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
        }
        else {
            edgeInsets = UIEdgeInsetsMake(12, 18, 12, 14);
            imageView.image = [[UIImage imageNamed:@"incoming_bubble.png"] resizableImageWithCapInsets:edgeInsets];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
        }
        
        label = [UILabel new];
        label.tag = BUBBLETEXT_TAG;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [imageView addSubview:label];
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInsets.top]];
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:-edgeInsets.bottom]];
        
    }
    else {
        imageView = (UIImageView *)[cell.contentView viewWithTag:BUBBLEIMAGE_TAG];
        label = (UILabel *)[cell.contentView viewWithTag:BUBBLETEXT_TAG];
        if (0==sendOrReceive){
            edgeInsets = UIEdgeInsetsMake(12, 14, 12, 18);
        }
        else {
            edgeInsets = UIEdgeInsetsMake(12, 18, 12, 14);
        }
        NSArray *constraints = [cell.contentView constraints];
        NSLayoutConstraint *constraint;
        int j = 0;
        for(int i=0; i<[constraints count]; i++){
            constraint = constraints[i];
            if ([constraint.identifier isEqualToString:@"widthConstraint"]){
                [cell.contentView removeConstraint:constraint];
                j = j+1;
                if (2==j){
                    break;
                }
            }
            if ([constraint.identifier isEqualToString:@"heightConstraint"]){
                [cell.contentView removeConstraint:constraint];
                j = j+1;
                if (2==j){
                    break;
                }
            }
        }
    }
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width-edgeInsets.left-edgeInsets.right-2.0*hMargin, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.width)+edgeInsets.left+edgeInsets.right];
    constraint1.identifier = @"widthConstraint";
    [cell.contentView addConstraint:constraint1];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ceil(rect.size.height)+edgeInsets.top+edgeInsets.bottom];
    constraint2.identifier = @"heightConstraint";
    [cell.contentView addConstraint:constraint2];
    
    label.text = message;
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeLeading multiplier:1 constant:edgeInsets.left]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-edgeInsets.right]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

-(id)initWithToFirstName: (NSString *)firstName toLastName: (NSString *)lastName{
    self = [super init];
    if( !self ) return nil;
    
    _toFirstName = [firstName copy];
    _toLastName = [lastName copy];
    
    return self;
}

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
                    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Your message was not properly sent." message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
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
    ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
    _dataArray = [db loadArrayHistory:[NSString stringWithFormat:@"%@%@", _toFirstName, _toLastName]];
    [_tableView reloadData];
    [self scrollToBottom];
}
- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-3.0*self.navigationController.navigationBar.frame.size.height-_tableView.frame.origin.y-keyboardSize.height);
    _viewHolderForKeyboard.frame = CGRectMake(_viewHolderForKeyboard.frame.origin.x, _viewHolderForKeyboard.frame.origin.y, _viewHolderForKeyboard.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-keyboardSize.height);
    [UIView commitAnimations];
    //_tableView.contentOffset = CGPointMake(0,_tableView.contentOffset.y+keyboardSize.height);
    [self scrollToBottom];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-3.0*self.navigationController.navigationBar.frame.size.height-_tableView.frame.origin.y);
    _viewHolderForKeyboard.frame = CGRectMake(_viewHolderForKeyboard.frame.origin.x, _viewHolderForKeyboard.frame.origin.y, _viewHolderForKeyboard.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);
    [UIView commitAnimations];
    //_tableView.contentOffset = CGPointMake(0,_tableView.contentOffset.y-keyboardSize.height);
    [self scrollToBottom];
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
        if ([_dataArray count]>0){
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_dataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //[_tableView scrollRectToVisible:CGRectMake(_tableView.contentSize.width - 1,_tableView.contentSize.height - 1, 1, 1) animated:YES];
        }
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
