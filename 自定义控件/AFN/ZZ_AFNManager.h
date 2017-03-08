//
//  ZZ_AFNManager.h
//  TaxAssistant
//
//  Created by suorui on 16/12/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^CompletionBlock)(NSDictionary*,NSError*) ;
@interface ZZ_AFNManager : NSObject

+(void)postWithUrl:(NSString*)URL andParameter:(NSDictionary*)Parameter withCompletionBlock:(CompletionBlock)completion;
+(void)getWithUrl:(NSString*)URL andParameter:(NSDictionary*)Parameter withCompletionBlock:(CompletionBlock)completion;
@end
