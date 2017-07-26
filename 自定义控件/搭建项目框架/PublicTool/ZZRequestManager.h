//
//  ZZRequestManager.h
//  Class
//
//  Created by Helen on 2017/7/24.
//  Copyright © 2017年 Helen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^RequestSuccess)(NSDictionary*,NSString*,NSString*,NSError*) ;
@interface ZZRequestManager : NSObject


+(void)RequesstLoginWithAccount:(NSString*)account password:(NSString*)passwod success:(RequestSuccess)successBlock;





#pragma mark post请求
+ (void)POST:(NSString *)netType paramDic:(NSDictionary *)param success:(RequestSuccess)successBlock ;
@end
