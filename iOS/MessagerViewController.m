//
//  MessagerViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "AppDelegate.h"
#import "MessagerViewController.h"
#import "UIButtonWithString.h"
#import "ConversationsDatabase.h"
#import "GlobalVariables.h"
#import "BottomNavigationBar.h"
#import "MyUtilities.h"
#import "ConversationViewController.h"

UIView *selectRecipientPopup;

@interface MessagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MessagerViewController


-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notifications_bg_red.png"]];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notifications_bg_red.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:backgroundView];
    
    float buttonWidth = 0.9;
    int buttonVMargin = 9;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-3.0*self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    _tableView.tag = 1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.alwaysBounceVertical = NO;
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.75;
    [_tableView addGestureRecognizer:longPressRecognizer];
    
    ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
    _dataArray = [db loadLastMessages];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 120.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
    /*UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-2.0*self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     tableView.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
     tableView.alwaysBounceVertical = NO;*/
    
    UIView *conversationOptionsBox = [UIView new];
    //conversationOptionsBox.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notifications_bg_red.png"]];
    [conversationOptionsBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:conversationOptionsBox];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:conversationOptionsBox attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:conversationOptionsBox attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:conversationOptionsBox attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:conversationOptionsBox attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.navigationController.navigationBar.frame.size.height]];
     
    UIView *zerothPlaceHolderView = [[UIView alloc]init];
    [zerothPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [conversationOptionsBox addSubview:zerothPlaceHolderView];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:zerothPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];

    UIButton *messageImage = [[UIButton alloc] init];
    [messageImage setBackgroundImage:[UIImage imageNamed:@"instantmessengerWhite.png"] forState:UIControlStateNormal];
    [messageImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [conversationOptionsBox addSubview:messageImage];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:messageImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [messageImage addTarget:self action:@selector(startNewConversation) forControlEvents:UIControlEventTouchUpInside];

    UIView *firstPlaceHolderView = [[UIView alloc]init];
    [firstPlaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [conversationOptionsBox addSubview:firstPlaceHolderView];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:messageImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:zerothPlaceHolderView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [conversationOptionsBox addConstraint:[NSLayoutConstraint constraintWithItem:firstPlaceHolderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:conversationOptionsBox attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)nil headerImage:(UIView *)self.view];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1){
        return _dataArray.count;
    }
    else {
        return _firstNames.count;
    }
}
#define SECONDPERSONNAME_TAG 1

#define LASTMESSAGE_TAG 2

#define LABEL_TAG 3

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag==1){
        static NSString *cellIdentifier = @"myIdentifier";
        UITextView *secondPersonName;
        UITextView *lastMessage;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        int hMargin = 9;
        int vMargin = 2;
        if (nil==cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
            cell.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:184.0/255.0 blue:168.0/255.0 alpha:1];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
            
            secondPersonName = [UITextView new];
            secondPersonName.tag = SECONDPERSONNAME_TAG;
            secondPersonName.editable = NO;
            secondPersonName.scrollEnabled = NO;
            secondPersonName.userInteractionEnabled = NO;
            secondPersonName.font = [UIFont systemFontOfSize:16];
            secondPersonName.textColor = [UIColor colorWithRed:137.0/255.0 green:133.0/255.0 blue:132.0/255.0 alpha:1];
            [secondPersonName setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView addSubview:secondPersonName];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
            //[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
            
            lastMessage = [UITextView new];
            lastMessage.tag = LASTMESSAGE_TAG;
            lastMessage.editable = NO;
            lastMessage.scrollEnabled = NO;
            lastMessage.userInteractionEnabled = NO;
            lastMessage.font = [UIFont systemFontOfSize:12];
            lastMessage.textColor = [UIColor colorWithRed:137.0/255.0 green:133.0/255.0 blue:132.0/255.0 alpha:1];
            [lastMessage setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView addSubview:lastMessage];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:secondPersonName attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastMessage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastMessage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
            //[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastMessage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastMessage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
            
            [MyUtilities addShadow:cell];
        }
        else {
            secondPersonName = (UITextView *)[cell.contentView viewWithTag:SECONDPERSONNAME_TAG];
            lastMessage = (UITextView *)[cell.contentView viewWithTag:LASTMESSAGE_TAG];
        }
        secondPersonName.text = [NSString stringWithFormat:@"%@ %@", [[_dataArray objectAtIndex:indexPath.row] objectAtIndex:0], [[_dataArray objectAtIndex:indexPath.row] objectAtIndex:1]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondPersonName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:[MyUtilities calculateHeightFor:secondPersonName.text and:cell.contentView.frame.size.width-2.0*hMargin with:16]+vMargin]];
        lastMessage.text = [[_dataArray objectAtIndex:indexPath.row] objectAtIndex:2];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastMessage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:[MyUtilities calculateHeightFor:lastMessage.text and:cell.contentView.frame.size.width-2.0*hMargin with:14]+5.0*vMargin]];
    }
    else {
        static NSString *cellIdentifier2 = @"myIdentifier2";
        UILabel *label;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (nil==cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            cell.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
            
            int hMargin = 9;
            int vMargin = 2;
            label = [UILabel new];
            label.tag = LABEL_TAG;
            [label setTranslatesAutoresizingMaskIntoConstraints:NO];
            label.font = [UIFont systemFontOfSize:13.0];
            [cell.contentView addSubview:label];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:-2.0*hMargin]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
            
            [MyUtilities addShadow:cell];
        }
        else {
            label = (UILabel *)[cell.contentView viewWithTag:LABEL_TAG];
        }
        label.text = [NSString stringWithFormat:@"%@ %@",[_firstNames objectAtIndex:indexPath.row], [_lastNames objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1){
        [AppDelegate setCurrentToName:[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:0] newCurrentToLastName:[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:1]];
        [AppDelegate checkOnlineStatus];
        [self.navigationController pushViewController:[[ConversationViewController alloc] initWithToFirstName: [[_dataArray objectAtIndex:indexPath.row] objectAtIndex:0] toLastName: [[_dataArray objectAtIndex:indexPath.row] objectAtIndex:1]] animated:YES];
    }
    else {
        _chosenFirstName = [_firstNames objectAtIndex:indexPath.row];
        _chosenLastName = [_lastNames objectAtIndex:indexPath.row];
    }
}
-(void)startNewConversation{
    if ([AppDelegate firstName]==nil || [AppDelegate lastName]==nil){
        [self tryToRegister];
    }
    else {
        GlobalVariables *globals = [GlobalVariables sharedInstance];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"get-contacts.php"]]];
        NSString *post = globals.phpKey;
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        urlRequest.HTTPMethod = @"POST";
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        urlRequest.HTTPBody = postData;
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(data)  {
                NSArray *jsonDataArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]];
                if ([jsonDataArray count]>0){
                    _firstNames = [NSMutableArray arrayWithObjects:[[jsonDataArray objectAtIndex:0] objectForKey:@"first_name"], nil];
                    _lastNames = [NSMutableArray arrayWithObjects:[[jsonDataArray objectAtIndex:0] objectForKey:@"last_name"], nil];
                    for (int i=1; i<[jsonDataArray count]; i++){
                        [_firstNames addObject:[[jsonDataArray objectAtIndex:i] objectForKey:@"first_name"]];
                        [_lastNames addObject:[[jsonDataArray objectAtIndex:i] objectForKey:@"last_name"]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSelectRecipientPopup];
                });
            }
        }];
        
        [dataTask resume];
    }
}
- (void)showSelectRecipientPopup{
    float width = 0.9;
    int fontSize = 24;
    int buttonVMargin = 8;
    int buttonHMargin = 12;
    
    selectRecipientPopup = [UIView new];
    selectRecipientPopup.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    //selectRecipientPopup.frame = self.view.frame;
    selectRecipientPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:selectRecipientPopup];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
    viewHolder.frame = CGRectMake((0.5-width/2.0)*selectRecipientPopup.frame.size.width, (0.5-width/2.0)*selectRecipientPopup.frame.size.height, width*selectRecipientPopup.frame.size.width, width*selectRecipientPopup.frame.size.height);
    [viewHolder setUserInteractionEnabled:YES];
    //[viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [selectRecipientPopup addSubview:viewHolder];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(buttonHMargin, buttonVMargin, viewHolder.frame.size.width-2.0*buttonHMargin, viewHolder.frame.size.height-3.0*buttonVMargin-30) style:UITableViewStylePlain];
    tableView.tag = 2;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.alwaysBounceVertical = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [viewHolder addSubview:tableView];
    //[viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTop multiplier:1 constant:buttonVMargin]];
    
    
    UIButton *button = [UIButton new];
    [MyUtilities underlineTextInButton:button title:@"OK" fontSize:20];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"OK";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
    size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:button];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    [button addTarget:self action:@selector(openChosenConversation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [UIButton new];
    [MyUtilities underlineTextInButton:cancelButton title:@"CANCEL" fontSize:20];
    [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    cancelButton.titleLabel.numberOfLines = 0;
    
    label.text = @"CANCEL";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
    size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
    
    [cancelButton addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:cancelButton];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [cancelButton addTarget:self action:@selector(closeSelectRecipientPopup) forControlEvents:UIControlEventTouchUpInside];
    
    //[selectRecipientPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:selectRecipientPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //[selectRecipientPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:selectRecipientPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)closeSelectRecipientPopup{
    [selectRecipientPopup removeFromSuperview];
}
-(void)openChosenConversation{
    [self closeSelectRecipientPopup];
    if (_chosenFirstName != nil){
        [AppDelegate setCurrentToName:_chosenFirstName newCurrentToLastName:_chosenLastName];
        [AppDelegate checkOnlineStatus];
        [self.navigationController pushViewController:[[ConversationViewController alloc] initWithToFirstName:_chosenFirstName toLastName:_chosenLastName] animated:YES];
    }
}
-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:touchPoint];
        if (indexPath != nil) {
            UIAlertController *alertController=[UIAlertController
                                                alertControllerWithTitle:nil
                                                message:nil
                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *deleteConversation = [UIAlertAction actionWithTitle:@"Delete conversation" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           ConversationsDatabase *db = [ConversationsDatabase getSharedInstance];
                                                           [db deleteConversation:[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:0] lastName:[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:1]];
                                                           _dataArray = [db loadLastMessages];
                                                           [_tableView reloadData];
                                                       }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //[alertController dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alertController addAction:deleteConversation];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
