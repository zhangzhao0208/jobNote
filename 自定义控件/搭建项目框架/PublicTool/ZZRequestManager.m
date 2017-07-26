//
//  ZZRequestManager.m
//  Class
//
//  Created by Helen on 2017/7/24.
//  Copyright © 2017年 Helen. All rights reserved.
//

#import "ZZRequestManager.h"

#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? @"空" : str )
@implementation ZZRequestManager

+(void)RequesstLoginWithAccount:(NSString*)account password:(NSString*)passwod success:(RequestSuccess)successBlock{
    
    account= kStringIsEmpty(account);
    passwod= kStringIsEmpty(passwod);
    NSDictionary*dic =@{
                        @"account":account,
                        @"password":passwod
                        };
    [self POST:@"" paramDic:dic success:^(NSDictionary *resultDic, NSString *msg, NSString *errcode, NSError *error) {
        
        successBlock(resultDic,msg,errcode,error);
        
    }];
    
}
//post 请求
+ (void)POST:(NSString *)netType paramDic:(NSDictionary *)param success:(RequestSuccess)successBlock{
    
    AFHTTPSessionManager*manager =[AFHTTPSessionManager manager];
    NSString *url = [@"http://139.224.105.87/bailu/index.php/Mobile/" stringByAppendingString:@"User/login"];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript", nil];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = (NSDictionary *)responseObject;
        NSString *errcode = responseData[@"errcode"];
        NSString *msg = responseData[@"msg"];
        successBlock(responseData,msg,errcode,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            successBlock(nil,nil,nil,error);
        }
    }];
}

//get请求
+ (void)GET:(NSString *)netType paramDic:(NSDictionary *)param success:(RequestSuccess)successBlock{
    
    AFHTTPSessionManager*manager =[AFHTTPSessionManager manager];
    NSString *url = [@"http://139.224.105.87/bailu/index.php/Mobile/" stringByAppendingString:@"User/login"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript", nil];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = (NSDictionary *)responseObject;
        NSString *errcode = responseData[@"errcode"];
        NSString *msg = responseData[@"msg"];
        successBlock(responseData,msg,errcode,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            successBlock(nil,nil,nil,error);
        }

    }];
}

@end
