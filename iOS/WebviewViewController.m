//
//  WebviewViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "WebviewViewController.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

@implementation WebviewViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    _webview = [WKWebView new];
    _webview.allowsBackForwardNavigationGestures = YES;
    [_webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_webview];
    [MyUtilities addConstraint:self.view view:_webview topView:self.view topMultiplier:1 topConstant:0 centerXView:self.view centerXMultiplier:1 centerXConstant:0 widthView:self.view widthMultiplier:1 widthConstant:0];
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)_webview headerImage:(UIView *)self.view];
    
    NSURL *nsurl=[NSURL URLWithString:_url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webview loadRequest:nsrequest];
    
}
- (id) initWithString: (NSString *)url {
    self = [super init];
    if( !self ) return nil;
    
    _url = [url copy];
    
    return self;
}
@end
