//
//  HttpPost.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "HttpPost.h"
#import "GlobalVariables.h"

@implementation HttpPost{
    
}

+(void)post:(NSString *)url data:(NSString *)data broadcastReceiver:(NSString *)broadcastReceiver extraData:(NSString *)extraData{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSData *postData = [[data stringByAppendingString:globals.phpKey] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = postData;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *result, NSURLResponse *response, NSError *error) {
        if(result)  {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![broadcastReceiver isEqualToString:@""]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:broadcastReceiver object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding], @"result", extraData, @"extra_data", nil]];
                }
            });
        }
        
    }];
    
    
    [dataTask resume];
}

@end
