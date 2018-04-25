//
//  HttpPost.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HttpPost : NSObject
+(void)post:(NSString *)url data:(NSString *)data broadcastReceiver:(NSString *)broadcastReceiver extraData:(NSString *)extraData;
@end
