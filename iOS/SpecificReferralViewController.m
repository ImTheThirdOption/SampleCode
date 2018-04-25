//
//  SpecificReferralViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "SpecificReferralViewController.h"
#import "GlobalVariables.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

@implementation SpecificReferralViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 }

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"specific_referral_bg.png"]];
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
    //[scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"get-specific-referral.php"]]];
    NSString *post = [NSString stringWithFormat:@"referralNumber=%@%@",_referralNumber,globals.phpKey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = postData;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data)  {
            NSArray *jsonDataArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSURL *url = [NSURL URLWithString:[[jsonDataArray objectAtIndex:0] objectForKey:@"first"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                _hMargin = 15;
                _vMargin = 15;
                _hTextPadding = 5;
                _vTextPadding = 15;
                
                _header1 = [UIImageView new];
                UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                _header1.image = [[UIImage imageNamed:@"specific_referral_header_9patch.png"] resizableImageWithCapInsets:edgeInsets];
                [MyUtilities addImageView:_header1 withInsets:edgeInsets andText:[[jsonDataArray objectAtIndex:0] objectForKey:@"second"] fontSize:16 selfView:self.view contentView:_contentView beneath:_contentView position:1 width:0.9 margin:16.7];
                
                [self addMyReferralImage:data];
                
                _imageForText = [UIImageView new];
                _referralText = [UITextView new];
                [MyUtilities addSpecificNotificationBox: _referralText title: [[jsonDataArray objectAtIndex:0] objectForKey:@"fourth"] selfView: self.view contentView: (UIView *)_contentView beneath:_referralImage on:_imageForText vMargin:_vMargin hMargin:_hMargin vTextPadding:_vTextPadding hTextPadding:_hTextPadding];
                
                _referralOptionsBar = [UIView new];
                
                [BottomNavigationBar addReferralOptionsBar:_referralOptionsBar selfView:self.view beneath:_referralText contentView:(UIView *)_contentView barHeight:self.navigationController.navigationBar.frame.size.height emailAddress:[[jsonDataArray objectAtIndex:0] objectForKey:@"fifth"] phoneNumber:[[jsonDataArray objectAtIndex:0] objectForKey:@"sixth"] website:[[jsonDataArray objectAtIndex:0] objectForKey:@"seventh"] margin:_vMargin];
                
                _copyright = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copyright_beige_white.png"]];
                [MyUtilities addImageView:_copyright selfView:self.view contentView:_contentView beneath:_referralOptionsBar position:3 width:0.664 margin:_vMargin];
                
                UIView *bottomNavigationBar = [[UIView alloc] init];
                [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)scrollView headerImage:(UIView *)scrollView];
            });
        }
        
    }];
    
    [dataTask resume];
}

- (id) initWithNumber: (NSString *)referralNumber {
    self = [super init];
    if( !self ) return nil;
    
    _referralNumber = [referralNumber copy];
    
    return self;
}
-(void) addMyReferralImage:(NSData *)data{
    _referralImage = [UIImageView new];
    [_referralImage setImage:[UIImage imageWithData:data]];
    [_referralImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_referralImage];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_referralImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:_hMargin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_referralImage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-_hMargin]];
    if (_referralImage.image.size.width!=0){
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_referralImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_referralImage attribute:NSLayoutAttributeWidth multiplier:(_referralImage.image.size.height / _referralImage.image.size.width) constant:0]];
    }
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_referralImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_header1 attribute:NSLayoutAttributeBottom multiplier:1 constant:_hMargin]];
    
}
-(void)swipeLeft {
    [self swipeInDirection:@"left"];
}
-(void)swipeRight {
    [self swipeInDirection:@"right"];
}

- (void)swipeInDirection: (NSString *)direction{
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"get-referral-fling.php"]]];
    NSString *post = [NSString stringWithFormat:@"referralNumber=%@&direction=%@%@",_referralNumber, direction,globals.phpKey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = postData;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data)  {
            NSArray *jsonDataArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (jsonDataArray.count!=0){
                    _referralNumber = [[jsonDataArray objectAtIndex:0] objectForKey:@"referralNumber"];
                    NSURL *url = [NSURL URLWithString:[[jsonDataArray objectAtIndex:0] objectForKey:@"first"]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    
                    [_header1 removeFromSuperview];
                    _header1 = [UIImageView new];
                    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                    _header1.image = [[UIImage imageNamed:@"specific_referral_header_9patch.png"] resizableImageWithCapInsets:edgeInsets];
                    [MyUtilities addImageView:_header1 withInsets:edgeInsets andText:[[jsonDataArray objectAtIndex:0] objectForKey:@"second"] fontSize:16 selfView:self.view contentView:_contentView beneath:_contentView position:1 width:0.9 margin:16.7];
                    
                    [_referralImage removeFromSuperview];
                    [self addMyReferralImage:data];
                    [_imageForText removeFromSuperview];
                    [MyUtilities addSpecificNotificationBox: _referralText title: [[jsonDataArray objectAtIndex:0] objectForKey:@"fourth"] selfView: self.view contentView: (UIView *)_contentView beneath:_referralImage on:_imageForText vMargin:_vMargin hMargin:_hMargin vTextPadding:_vTextPadding hTextPadding:_hTextPadding];
                    
                    [_referralOptionsBar removeFromSuperview];
                    [BottomNavigationBar addReferralOptionsBar:_referralOptionsBar selfView:self.view beneath:_referralText contentView:(UIView *)_contentView barHeight:self.navigationController.navigationBar.frame.size.height emailAddress:[[jsonDataArray objectAtIndex:0] objectForKey:@"fifth"] phoneNumber:[[jsonDataArray objectAtIndex:0] objectForKey:@"sixth"] website:[[jsonDataArray objectAtIndex:0] objectForKey:@"seventh"] margin:_vMargin];
                    
                    [_copyright removeFromSuperview];
                    [MyUtilities addImageView:_copyright selfView:self.view contentView:_contentView beneath:_referralOptionsBar position:3 width:0.664 margin:_vMargin];
                }
            });
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */
@end
