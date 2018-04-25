//
//  ContactMeViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "ContactMeViewController.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"
#import "GlobalVariables.h"

@interface ContactMeViewController ()

@end

@implementation ContactMeViewController

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
    
    UIImageView *header1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_me_header.png"]];
    [MyUtilities addImageView:header1 selfView:self.view contentView:contentView beneath:contentView position:1 width:buttonWidth margin:16.7];
    
    UIImageView *realtor1View = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_me_blue_bg.png"]];
    [realtor1View setUserInteractionEnabled:YES];
    [realtor1View setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:realtor1View];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:realtor1View attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:realtor1View attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:realtor1View attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:header1 attribute:NSLayoutAttributeBottom multiplier:1 constant:margin]];
    
    UIImageView *realtor1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realtor_1_image.png"]];
    [realtor1Image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor1View addSubview:realtor1Image];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Image attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Image attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeLeading multiplier:1 constant:margin]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor1Image attribute:NSLayoutAttributeHeight multiplier:(realtor1Image.image.size.width / realtor1Image.image.size.height) constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1]];
    
    
    UIImageView *realtor1Name = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realtor_1_name.png"]];
    [realtor1Name setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor1View addSubview:realtor1Name];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Name attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor1Image attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Name attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:realtor1Image attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor1Image attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor1Name attribute:NSLayoutAttributeHeight multiplier:(realtor1Name.image.size.width / realtor1Name.image.size.height) constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:realtor1Name attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    UIButtonWithString *callButton1 = [[UIButtonWithString alloc] initWithStringTag:[@"tel://" stringByAppendingString:globals.firstRealtorPhoneNumber]];
    [callButton1 setBackgroundImage:[UIImage imageNamed:@"call_icon.png"] forState:UIControlStateNormal];
    [callButton1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor1View addSubview:callButton1];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:callButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:callButton1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeTrailing multiplier:1 constant:-margin]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:callButton1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeHeight multiplier:(callButton1.currentBackgroundImage.size.width / callButton1.currentBackgroundImage.size.height) constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:callButton1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:realtor1Image attribute:NSLayoutAttributeTrailing multiplier:1 constant:margin]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:callButton1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1]];
    [callButton1 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *emailButton1 = [[UIButtonWithString alloc] initWithStringTag:[@"mailto:" stringByAppendingString:globals.firstRealtorEmailAddress]];
    [emailButton1 setBackgroundImage:[UIImage imageNamed:@"email_icon.png"] forState:UIControlStateNormal];
    [emailButton1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor1View addSubview: emailButton1];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [emailButton1 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton1 = [[UIButtonWithString alloc] initWithStringTag:[@"sms:+"stringByAppendingString:globals.firstRealtorPhoneNumber]];
    [textButton1 setBackgroundImage:[UIImage imageNamed:@"text_icon.png"] forState:UIControlStateNormal];
    [textButton1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor1View addSubview: textButton1];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:emailButton1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:callButton1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [realtor1View addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    [textButton1 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *realtor2View = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_me_blue_bg.png"]];
    [realtor2View setUserInteractionEnabled:YES];
    [realtor2View setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:realtor2View];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:realtor2View attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:realtor2View attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:realtor2View attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor1View attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    
    UIImageView *realtor2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realtor_2_image.png"]];
    [realtor2Image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor2View addSubview:realtor2Image];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Image attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor2View attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Image attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:realtor2View attribute:NSLayoutAttributeLeading multiplier:1 constant:margin]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor2Image attribute:NSLayoutAttributeHeight multiplier:(realtor2Image.image.size.width / realtor2Image.image.size.height) constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1]];
    
    
    UIImageView *realtor2Name = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realtor_2_name.png"]];
    [realtor2Name setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor2View addSubview:realtor2Name];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Name attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor2Image attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Name attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:realtor2Image attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor2Image attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:realtor2Name attribute:NSLayoutAttributeHeight multiplier:(realtor2Name.image.size.width / realtor2Name.image.size.height) constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:realtor2Name attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:realtor2View attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    UIButtonWithString *callButton2 = [[UIButtonWithString alloc] initWithStringTag:[@"tel://" stringByAppendingString:globals.secondRealtorPhoneNumber]];
    [callButton2 setBackgroundImage:[UIImage imageNamed:@"call_icon.png"] forState:UIControlStateNormal];
    [callButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor2View addSubview:callButton2];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:callButton2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:realtor2View attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:callButton2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:realtor2View attribute:NSLayoutAttributeTrailing multiplier:1 constant:-margin]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:callButton2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeHeight multiplier:(callButton2.currentBackgroundImage.size.width / callButton2.currentBackgroundImage.size.height) constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:callButton2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:realtor2Image attribute:NSLayoutAttributeTrailing multiplier:1 constant:margin]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:callButton2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1]];
    [callButton2 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *emailButton2 = [[UIButtonWithString alloc] initWithStringTag:[@"mailto:" stringByAppendingString:globals.secondRealtorEmailAddress]];
    [emailButton2 setBackgroundImage:[UIImage imageNamed:@"email_icon.png"] forState:UIControlStateNormal];
    [emailButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor2View addSubview: emailButton2];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:emailButton2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [emailButton2 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton2 = [[UIButtonWithString alloc] initWithStringTag:[@"sms:+"stringByAppendingString:globals.secondRealtorPhoneNumber]];
    [textButton2 setBackgroundImage:[UIImage imageNamed:@"text_icon.png"] forState:UIControlStateNormal];
    [textButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [realtor2View addSubview: textButton2];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:textButton2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:emailButton2 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:textButton2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:textButton2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:textButton2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:callButton2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [realtor2View addConstraint:[NSLayoutConstraint constraintWithItem:textButton2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:realtor2View attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    [textButton2 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:realtor2View attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    
    UIImageView *copyright = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copyright_beige.png"]];
    [MyUtilities addImageView:copyright selfView:self.view contentView:contentView beneath:realtor2View position:3 width:0.664 margin:16.7];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)scrollView headerImage:(UIView *)scrollView];
}
- (void)openNonWebURLWithString:(NSString *)url{
    [MyUtilities openNonWebURLWithString:url];
}

- (void)openNonWebURL:(id)sender{
    NSString *url = [(UIButtonWithString *)sender stringTag];
    [self openNonWebURLWithString:url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
