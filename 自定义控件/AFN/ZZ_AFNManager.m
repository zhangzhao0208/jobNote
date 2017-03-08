//
//  ZZ_AFNManager.m
//  TaxAssistant
//
//  Created by suorui on 16/12/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ZZ_AFNManager.h"

@implementation ZZ_AFNManager
+(void)postWithUrl:(NSString*)URL andParameter:(NSDictionary*)Parameter withCompletionBlock:(CompletionBlock)completion
{
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    [manager POST:URL parameters:Parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         NSLog(@"responseObject------%@",responseObject);
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
         completion(nil,error);
         NSLog(@"error------%@",error);
        }
        
    }];

    
}
+(void)getWithUrl:(NSString*)URL andParameter:(NSDictionary*)Parameter withCompletionBlock:(CompletionBlock)completion
{
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    [manager GET:URL parameters:Parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            completion(nil,error);
            NSLog(@"error------%@",error);
        }

    }];

}

@end
