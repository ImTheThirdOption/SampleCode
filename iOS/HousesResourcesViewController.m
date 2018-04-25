//
//  HousesResourcesViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "HousesResourcesViewController.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

@interface HousesResourcesViewController ()

@end

@implementation HousesResourcesViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"houses_resources_bg.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:backgroundView];
    
    float buttonWidth = 0.9;
    int buttonVMargin = 0;
    int margin = 8;
    UIScrollView *scrollView  = [[UIScrollViewHack alloc] init];
    scrollView.bounces = NO;
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
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
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    
    UIImageView *header1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"houses_resources_header.png"]];
    [MyUtilities addImageView:header1 selfView:self.view contentView:contentView beneath:contentView position:1 width:buttonWidth margin:16.7];
    
    UIButtonWithString *icon1 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/idx/#refineSearch"];
    [icon1 setBackgroundImage:[UIImage imageNamed:@"search_listings_icon.png"] forState:UIControlStateNormal];
    [icon1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:icon1];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:header1 attribute:NSLayoutAttributeBottom multiplier:1 constant:55]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:icon1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.102*self.view.frame.size.width]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeHeight multiplier:(icon1.currentBackgroundImage.size.width / icon1.currentBackgroundImage.size.height) constant:0]];
    [icon1 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *icon2 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/idx/register.html"];
    [icon2 setBackgroundImage:[UIImage imageNamed:@"register_icon.png"] forState:UIControlStateNormal];
    [icon2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:icon2];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.102*self.view.frame.size.width]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:icon2 attribute:NSLayoutAttributeHeight multiplier:(icon2.currentBackgroundImage.size.width / icon2.currentBackgroundImage.size.height) constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [icon2 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *icon3 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/idx/login.html"];
    [icon3 setBackgroundImage:[UIImage imageNamed:@"login_icon.png"] forState:UIControlStateNormal];
    [icon3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:icon3];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:icon2 attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.066*self.view.frame.size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:icon3 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-0.102*self.view.frame.size.width]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:icon3 attribute:NSLayoutAttributeHeight multiplier:(icon3.currentBackgroundImage.size.width / icon3.currentBackgroundImage.size.height) constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [icon3 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *icon4 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/idx/dashboard.html"];
    [icon4 setBackgroundImage:[UIImage imageNamed:@"dashboard_icon.png"] forState:UIControlStateNormal];
    [icon4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:icon4];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:icon4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.232 constant:0]];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:icon1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:icon4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:icon4 attribute:NSLayoutAttributeHeight multiplier:(icon4.currentBackgroundImage.size.width / icon4.currentBackgroundImage.size.height) constant:0]];
    [icon4 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *header2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resources_header.png"]];
    [MyUtilities addImageView:header2 selfView:self.view contentView:contentView beneath:icon4 position:2 width:0.592 margin:55];
    
    UIButtonWithString *button1 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/buying.php"];
    [button1 setBackgroundImage:[UIImage imageNamed:@"home_buyers_guide_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:button1 selfView:self.view contentView:contentView beneath:header2 position:2 width:buttonWidth margin:9.3];
    [button1 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *button2 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/selling.php"];
    [button2 setBackgroundImage:[UIImage imageNamed:@"home_sellers_guide_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:button2 selfView:self.view contentView:contentView beneath:button1 position:2 width:buttonWidth margin:9.3];
    [button2 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *copyright = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copyright_beige_dark_text.png"]];
    [MyUtilities addImageView:copyright selfView:self.view contentView:contentView beneath:button2 position:3 width:0.744 margin:16.7];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)scrollView headerImage:(UIView *)scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
