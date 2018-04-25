//
//  HomeScreenViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenViewController.h"
#import "GlobalVariables.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"
#import "ConversationsDatabase.h"
#import "NotificationsDatabase.h"
#import "AboutMeViewController.h"
#import "ContactMeViewController.h"
#import "HousesResourcesViewController.h"
#import "EventsAndNewsViewController.h"
#import "ReferralsViewController.h"
#import "AboutThisAppViewController.h"
#import "NotificationsViewController.h"
#import "MyNotificationsViewController.h"
#import "MessagerViewController.h"
#import "HttpPost.h"

//UIView *contactMePopup;
//UIView *chooseEmailOrTextPopup;
//UIView *firstListingsPopup;
//UIView *secondListingsPopup;
//UIView *thirdListingsPopup;
UIView *chooseTypeOfNotificationsPopup;
//UIView *registrationPopup;
//UIView *helpPopup;
//UIScrollView *hamburgerMenu;
//UIView *shadeView;
//NSArray *segmentedControlArray1;
//NSArray *segmentedControlArray2;

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    float buttonWidth = 1.0;
    int buttonVMargin = 0;
    UIScrollView *scrollView  = [[UIScrollViewHack alloc] init];
    scrollView.bounces = NO;
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:contentView];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"realtor_bg.png"]];
    [headerImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:headerImage];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeWidth multiplier:(headerImage.image.size.height / headerImage.image.size.width) constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    /*UITextView *address = [[UITextView alloc] init];
    address.text = @"Office Location: 401 N Great Neck Rd.\nSuite 126, Virginia Beach, VA 23453\nMLS ID# 55626";
    address.editable = NO;
    address.scrollEnabled = NO;
    [address setTextAlignment:NSTextAlignmentCenter];
    address.textColor = [UIColor whiteColor];
    address.backgroundColor = [UIColor clearColor];
    [address setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:address];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:.7 constant:0]];
    [address sizeToFit];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];*/
    
    UIImageView *address = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realtor_address.png"]];
    [address setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:address];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:.65 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:address attribute:NSLayoutAttributeWidth multiplier:(address.image.size.height / address.image.size.width) constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeBottom multiplier:1 constant:9]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeLeft multiplier:1 constant:0.05*self.view.frame.size.width]];
    
    UIImageView *groupImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group.png"]];
    [groupImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:groupImage];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:address attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:groupImage attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:groupImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:.3 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:groupImage attribute:NSLayoutAttributeWidth multiplier:(groupImage.image.size.height / groupImage.image.size.width) constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:address attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:address attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
     
    UIButton *aboutMeButton = [UIButton new];
    [aboutMeButton setBackgroundImage:[UIImage imageNamed:@"about_me_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:aboutMeButton selfView:self.view contentView:contentView beneath:address position:2 width:buttonWidth margin:buttonVMargin];
    [aboutMeButton addTarget:self action:@selector(openAboutMeViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *contactMeButton = [[UIButton alloc] init];
    [contactMeButton setBackgroundImage:[UIImage imageNamed:@"contact_us_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:contactMeButton selfView:self.view contentView:contentView beneath:aboutMeButton position:2 width:buttonWidth margin:buttonVMargin];
    [contactMeButton addTarget:self action:@selector(openContactMeViewController) forControlEvents:UIControlEventTouchUpInside];
     
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_refer_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:shareButton selfView:self.view contentView:contentView beneath:contactMeButton position:2 width:buttonWidth margin:buttonVMargin];
    [shareButton addTarget:self action:@selector(startSharing) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *housesResourcesButton = [UIButton new];
    [housesResourcesButton setBackgroundImage:[UIImage imageNamed:@"houses_resources_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:housesResourcesButton selfView:self.view contentView:contentView beneath:shareButton position:2 width:buttonWidth margin:buttonVMargin];
    [housesResourcesButton addTarget:self action:@selector(openHousesResourcesViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *referralsButton = [[UIButton alloc] init];
    [referralsButton setBackgroundImage:[UIImage imageNamed:@"referrals_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:referralsButton selfView:self.view contentView:contentView beneath: housesResourcesButton position:2 width:buttonWidth margin:buttonVMargin];
    [referralsButton addTarget:self action:@selector(openReferralsViewController) forControlEvents:UIControlEventTouchUpInside];
     
    UIButton *openNotificationsButton = [[UIButton alloc] init];
    [openNotificationsButton setBackgroundImage:[UIImage imageNamed:@"open_notifications_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:openNotificationsButton selfView:self.view contentView:contentView beneath:referralsButton position:2 width:buttonWidth margin:buttonVMargin];
    [openNotificationsButton addTarget:self action:@selector(openChooseTypeOfNotificationsPopup) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *aboutThisAppButton = [[UIButton alloc] init];
    [aboutThisAppButton setBackgroundImage:[UIImage imageNamed:@"about_this_app_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:aboutThisAppButton selfView:self.view contentView:contentView beneath:openNotificationsButton position:3 width:buttonWidth margin:buttonVMargin];
    [aboutThisAppButton addTarget:self action:@selector(openAboutThisAppViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)scrollView headerImage:(UIView *)headerImage];
}
- (void)openAboutMeViewController{
    [self.navigationController pushViewController:[AboutMeViewController new] animated:YES];
}
- (void)openContactMeViewController{
    [self.navigationController pushViewController:[ContactMeViewController new] animated:YES];
}
-(void)openHousesResourcesViewController{
    [self.navigationController pushViewController:[HousesResourcesViewController new] animated:YES];
}
-(void)startSharing{
    [super startSharing];
}
- (void)openReferralsViewController{
    [self.navigationController pushViewController:[ReferralsViewController new] animated:YES];
}
- (void)openAboutThisAppViewController{
    [self.navigationController pushViewController:[AboutThisAppViewController new] animated:YES];
}

-(void)openChooseTypeOfNotificationsPopup{
    float width = 0.9;
    int fontSize = 24;
    int buttonVMargin = 8;
    int buttonHMargin = 12;

    chooseTypeOfNotificationsPopup = [UIView new];
    chooseTypeOfNotificationsPopup.frame = self.view.frame;
    chooseTypeOfNotificationsPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:chooseTypeOfNotificationsPopup];

    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
    [viewHolder setUserInteractionEnabled:YES];
    [viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chooseTypeOfNotificationsPopup addSubview:viewHolder];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];

    UIButton *button1 = [UIButton new];
    [MyUtilities addPopupButton:button1 title:@"General notifications" viewHolder:viewHolder beneath:viewHolder position:1 width:width*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button1 addTarget:self action:@selector(generalNotificationsChosen) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button2 = [UIButton new];
    [MyUtilities addPopupButton:button2 title:@"My notifications" viewHolder:viewHolder beneath:button1 position:2 width:width*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button2 addTarget:self action:@selector(personalizedNotificationsChosen) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button = [UIButton new];
    [MyUtilities underlineTextInButton:button title:@"close" fontSize:20];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;

    UILabel *label = [[UILabel alloc] init];
    label.text = @"close";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
    size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));

    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

    [viewHolder addSubview:button];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    [button addTarget:self action:@selector(closeChooseTypeOfNotificationsPopup) forControlEvents:UIControlEventTouchUpInside];

    [chooseTypeOfNotificationsPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:chooseTypeOfNotificationsPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [chooseTypeOfNotificationsPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:chooseTypeOfNotificationsPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)closeChooseTypeOfNotificationsPopup{
    [chooseTypeOfNotificationsPopup removeFromSuperview];
}
-(void)generalNotificationsChosen{
    [self closeChooseTypeOfNotificationsPopup];
    [self.navigationController pushViewController:[NotificationsViewController new] animated:YES];
}
-(void)personalizedNotificationsChosen{
    [self closeChooseTypeOfNotificationsPopup];
    [self.navigationController pushViewController:[MyNotificationsViewController new] animated:YES];
}



- (void)chooseTypeOfNotifications{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil
                                                                           message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *chooseGeneralNotifications = [UIAlertAction actionWithTitle:@"Open general notifications"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                  {
                                      [self.navigationController pushViewController:[NotificationsViewController new] animated:YES];
                                  }];
    UIAlertAction *choosePersonalizedNotifications = [UIAlertAction actionWithTitle:@"Open personalized notifications"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self.navigationController pushViewController:[MyNotificationsViewController new] animated:YES];
                                 }];
    [alertController addAction:chooseGeneralNotifications];
    [alertController addAction:choosePersonalizedNotifications];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
