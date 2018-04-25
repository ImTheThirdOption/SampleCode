//
//  WebviewViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BaseViewController.h"

@interface WebviewViewController : BaseViewController
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) WKWebView *webview;

-(id)initWithString:(NSString *)url;

@end
