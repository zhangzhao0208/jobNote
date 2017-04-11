//
//  ParserManager.h
//  SweepPayment
//
//  Created by suorui on 17/3/17.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserManager : NSObject<NSXMLParserDelegate>
@property(nonatomic,strong)NSMutableArray*saxArray;
@property(nonatomic,strong)NSMutableDictionary*saxDic;
@property(nonatomic,strong)NSMutableString*valueString;
@property(nonatomic,strong)NSError*parserError;
- (instancetype)initData:(NSData*)data;

@end
