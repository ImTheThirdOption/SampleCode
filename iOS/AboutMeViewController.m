//
//  AboutMeViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "AboutMeViewController.h"
//#import "GlobalVariables.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_me_bg.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:backgroundView];
    
    
    float buttonWidth = 0.9;
    int buttonVMargin = 15;
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
    
    UIImageView *aboutMeHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_me_header.png"]];
    [MyUtilities addImageView:aboutMeHeader selfView:self.view contentView:contentView beneath:contentView position:1 width:1 margin:0];
    
    UIImageView *realtorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realtor_image.png"]];
    [MyUtilities addImageView:realtorImage selfView:self.view contentView:contentView beneath:aboutMeHeader position:2 width:buttonWidth margin:0];
    
    UIButtonWithString *houseAndHomeButton = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/idx/"];
    [houseAndHomeButton setBackgroundImage:[UIImage imageNamed:@"house_and_home_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:houseAndHomeButton selfView:self.view contentView:contentView beneath:realtorImage position:2 width:buttonWidth margin:buttonVMargin];
    [houseAndHomeButton addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *facebookButton = [[UIButtonWithString alloc] initWithStringTag:@"https://www.facebook.com/houseandhome757/"];
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:facebookButton selfView:self.view contentView:contentView beneath:houseAndHomeButton position:2 width:buttonWidth margin:buttonVMargin];
    [facebookButton addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *biographiesButton = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/about.php"];
    [biographiesButton setBackgroundImage:[UIImage imageNamed:@"biographies_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:biographiesButton selfView:self.view contentView:contentView beneath:facebookButton position:2 width:buttonWidth margin:buttonVMargin];
    [biographiesButton addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *testimonialsButton = [[UIButtonWithString alloc] initWithStringTag:@"http://www.besttimetogogreen.com/client-testimonials.php"];
    [testimonialsButton setBackgroundImage:[UIImage imageNamed:@"testimonials_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:testimonialsButton selfView:self.view contentView:contentView beneath:biographiesButton position:2 width:buttonWidth margin:buttonVMargin];
    [testimonialsButton addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *affiliateOrganizationsHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"affiliate_organizations_header.png"]];
    [MyUtilities addImageView:affiliateOrganizationsHeader selfView:self.view contentView:contentView beneath:testimonialsButton position:2 width:0.6 margin:buttonVMargin];
    
    UIButtonWithString *coachingButton = [[UIButtonWithString alloc] initWithStringTag:@"https://www.facebook.com/DunamisCoaching/"];
    [coachingButton setBackgroundImage:[UIImage imageNamed:@"coaching_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:coachingButton selfView:self.view contentView:contentView beneath:affiliateOrganizationsHeader position:2 width:buttonWidth margin:buttonVMargin];
    [coachingButton addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *rusticTartButton = [[UIButtonWithString alloc] initWithStringTag:@"https://www.facebook.com/TheRusticTart/"];
    [rusticTartButton setBackgroundImage:[UIImage imageNamed:@"rustic_tart_button.png"] forState:UIControlStateNormal];
    [MyUtilities addButton:rusticTartButton selfView:self.view contentView:contentView beneath:coachingButton position:2 width:buttonWidth margin:buttonVMargin];
    [rusticTartButton addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *copyright = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copyright_red.png"]];
    [MyUtilities addImageView:copyright selfView:self.view contentView:contentView beneath:rusticTartButton position:3 width:0.58 margin:16.7];
    
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
