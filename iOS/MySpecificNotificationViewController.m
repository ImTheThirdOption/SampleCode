//
//  MySpecificNotificationViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "MySpecificNotificationViewController.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "NotificationsDatabase.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

@implementation MySpecificNotificationViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notifications_bg_beige.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:backgroundView];
    
    UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UIScrollView *scrollView  = [[UIScrollViewHack alloc] init];
    scrollView.bounces = NO;
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    
    _contentView = [[UIView alloc] init];
    [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:_contentView];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    _header1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_notifications_header.png"]];
    [MyUtilities addImageView:_header1 selfView:self.view contentView:_contentView beneath:_contentView position:1 width:0.6 margin:16.7];
    
    
    //UIImageView *notificationImage = [UIImageView new];
    //UITextView *notificationText = [UITextView new];
    
    NotificationsDatabase *db = [NotificationsDatabase getSharedInstance];
    NSArray *dataArray = [db loadNotification: _notificationNumber];
    
    NSURL *url = [NSURL URLWithString:[[dataArray objectAtIndex:0] objectAtIndex:2]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    _hMargin = 15;
    _vMargin = 8;
    _hTextPadding = 5;
    _vTextPadding = 15;
    
    [self addMyNotificationImage:data];
    
    _imageForText = [UIImageView new];
    _notificationText = [UITextView new];
    //UITextView *notificationText = [[UITextView alloc] init];
    //notificationText.text = [[[NSAttributedString alloc] initWithData:[[[jsonDataArray objectAtIndex:0] objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding) } documentAttributes:nil error:nil] string];
    [MyUtilities addSpecificNotificationBox: _notificationText title: [[dataArray objectAtIndex:0] objectAtIndex:4] selfView: self.view contentView: (UIView *)_contentView beneath:_notificationImage on:_imageForText vMargin:_vMargin hMargin:_hMargin vTextPadding:_vTextPadding hTextPadding:_hTextPadding];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_notificationText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-_vMargin]];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)scrollView headerImage:(UIView *)scrollView];
}

- (id) initWithNumber: (NSString *)notificationNumber {
    
    self = [super init];
    if( !self ) return nil;
    
    _notificationNumber = [notificationNumber copy];
    
    return self;
}
-(void) addMyNotificationImage: (NSData *)data{
    _notificationImage = [UIImageView new];
    //UIImageView *_notificationImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
    [_notificationImage setImage:[UIImage imageWithData:data]];
    [_notificationImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_notificationImage];
    //[contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_notificationImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:_hMargin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_notificationImage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_hMargin]];
    if (_notificationImage.image.size.width!=0){
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_notificationImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_notificationImage attribute:NSLayoutAttributeWidth multiplier:(_notificationImage.image.size.height / _notificationImage.image.size.width) constant:0]];
    }
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_notificationImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_header1 attribute:NSLayoutAttributeBottom multiplier:1 constant:_hMargin]];

}
-(void)swipeLeft {
    [self swipeInDirection:@"left"];
}
-(void)swipeRight {
    [self swipeInDirection:@"right"];
}

- (void)swipeInDirection: (NSString *)direction{
    NotificationsDatabase *db = [NotificationsDatabase getSharedInstance];
    NSArray *dataArray = [db loadNotificationFling: direction number:_notificationNumber];
    
    if (dataArray.count!=0){
        _notificationNumber = [[dataArray objectAtIndex:0] objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[[dataArray objectAtIndex:0] objectAtIndex:2]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [_notificationImage removeFromSuperview];
        [self addMyNotificationImage:data];
        //[_notificationImage  setImage:[UIImage imageWithData:data]];
        [_imageForText removeFromSuperview];
        [MyUtilities addSpecificNotificationBox: _notificationText title: [[dataArray objectAtIndex:0] objectAtIndex:4] selfView: self.view contentView: (UIView *)_contentView beneath:_notificationImage on:_imageForText vMargin:_vMargin hMargin:_hMargin vTextPadding:_vTextPadding hTextPadding:_hTextPadding];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_notificationText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-_vMargin]];
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
