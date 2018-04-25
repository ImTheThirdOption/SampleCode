//
//  AboutThisAppViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "AboutThisAppViewController.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

static UIView *developerInformationPopup;

@interface AboutThisAppViewController ()

@end

@implementation AboutThisAppViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    float buttonWidth = 0.9;
    int buttonVMargin = 15;
    int buttonHMargin = 12;
    int fontSize = 18;
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
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"open_door_logo.jpg"]];
    [headerImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:headerImage];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeWidth multiplier:(headerImage.image.size.height / headerImage.image.size.width) constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    UIButton *textButton1 = [UIButton new];
    [textButton1 setTitle:@"Open Door Multimedia Design, LLC provides personalized mobile apps for business professionals. Contact us for more information." forState:UIControlStateNormal];
    [textButton1 setTitleColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:91.0/255.0 alpha:1] forState:UIControlStateNormal];
    [textButton1.titleLabel setTextAlignment:NSTextAlignmentCenter];
    textButton1.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [textButton1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    textButton1.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Open Door Multimedia Design, LLC provides personalized mobile apps for business professionals. Contact us for more information.";
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(buttonWidth*self.view.frame.size.width, 10000)];
    size = CGSizeMake(buttonWidth*self.view.frame.size.width, MAX(size.height, 30));
    
    [textButton1 addConstraint:[NSLayoutConstraint constraintWithItem:textButton1.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:textButton1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [contentView addSubview:textButton1];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerImage attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:buttonWidth constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:textButton1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    
    [textButton1.titleLabel sizeToFit];
    
    UIButton *textButton2 = [UIButton new];
    [MyUtilities addButtonAsClickableTextWithPicture:textButton2 title:@"Developer information" imageview:nil selfView:self.view contentView:contentView beneath:textButton1 position:2 width:buttonWidth*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [textButton2 addTarget:self action:@selector(showDeveloperInformation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton3 = [[UIButtonWithString alloc] initWithStringTag:@"https://facebook.com/opendoormediadesign"];
    UIImageView *facebookImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fb_icon.png"]];
    [MyUtilities addButtonAsClickableTextWithPicture:textButton3 title:@"Follow us on facebook" imageview:facebookImage selfView:self.view contentView:contentView beneath:textButton2 position:2 width:buttonWidth*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [textButton3 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton4 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.opendoormediadesign.com"];
    [MyUtilities addButtonAsClickableTextWithPicture:textButton4 title:@"Visit our website" imageview:nil selfView:self.view contentView:contentView beneath:textButton3 position:2 width:buttonWidth*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [textButton4 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton5 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.opendoormediadesign.com/legal-information/#legalInfo"];
    [MyUtilities addButtonAsClickableTextWithPicture:textButton5 title:@"Legal information" imageview:nil selfView:self.view contentView:contentView beneath:textButton4 position:2 width:buttonWidth*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [textButton5 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton6 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.opendoormediadesign.com/legal-information/#TermsOfUse"];
    [MyUtilities addButtonAsClickableTextWithPicture:textButton6 title:@"Terms of use" imageview:nil selfView:self.view contentView:contentView beneath:textButton5 position:2 width:buttonWidth*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [textButton6 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *textButton7 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.opendoormediadesign.com/legal-information/#PrivacyPolicy"];
    [MyUtilities addButtonAsClickableTextWithPicture:textButton7 title:@"Privacy policy" imageview:nil selfView:self.view contentView:contentView beneath:textButton6 position:2 width:buttonWidth*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [textButton7 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *copyrightText = [UITextView new];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:11]
                                                                     forKey:NSFontAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"© Copyright 2017, Open Door Multimedia Design, LLC.\nAll rights reserved." attributes:attributesDictionary];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:1]
                             range:(NSRange){0,[attributedString length]}];
    
    //copyrightText.text = @"© Copyright 2017, Open Door Multimedia Design, LLC.\nAll rights reserved.";
    //copyrightText.font = [UIFont systemFontOfSize:11];
    copyrightText.attributedText = attributedString;
    copyrightText.editable = NO;
    copyrightText.scrollEnabled = NO;
    [copyrightText setTextAlignment:NSTextAlignmentCenter];
    copyrightText.textColor = [UIColor blackColor];
    copyrightText.backgroundColor = [UIColor clearColor];
    [copyrightText setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:copyrightText];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:copyrightText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textButton7 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:copyrightText attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [copyrightText sizeToFit];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:copyrightText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)scrollView headerImage:(UIView *)scrollView];
}

- (void)showDeveloperInformation{
    float width = 0.9;
    
    developerInformationPopup = [UIView new];
    developerInformationPopup.frame = self.view.frame;
    developerInformationPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:developerInformationPopup];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
    [viewHolder setUserInteractionEnabled:YES];
    [viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [developerInformationPopup addSubview:viewHolder];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    
    UITextView *textView = [UITextView new];
    textView.text = @"This App was Developed By Simon P. Matthews and SIAB.";
    textView.font = [UIFont systemFontOfSize:24];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    [textView setTextAlignment:NSTextAlignmentLeft];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor clearColor];
    
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewHolder addSubview:textView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [textView sizeToFit];
    
    UIButton *button = [UIButton new];
    [MyUtilities underlineTextInButton:button title:@"close" fontSize:20];
    //[button setTitle:@"close" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //button.titleLabel.font = [UIFont systemFontOfSize:20];
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
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [button addTarget:self action:@selector(closeDeveloperInformation) forControlEvents:UIControlEventTouchUpInside];
    
    [developerInformationPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:developerInformationPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [developerInformationPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:developerInformationPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)closeDeveloperInformation{
    [developerInformationPopup removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
