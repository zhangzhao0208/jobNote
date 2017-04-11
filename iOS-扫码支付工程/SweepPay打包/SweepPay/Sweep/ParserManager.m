//
//  ParserManager.m
//  SweepPayment
//
//  Created by suorui on 17/3/17.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "ParserManager.h"
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

@implementation ParserManager

- (instancetype)initData:(NSData*)data{
    
    self =[super init];
    if (self) {
        
        NSXMLParser *saxParser = [[NSXMLParser alloc] initWithData:data];
        //指定代理
        saxParser.delegate = self;
        [saxParser parse];

        
    }
    return self;
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    self.saxArray = [NSMutableArray array];
}
//开始解析某个节点
//elementName:标签名称
//namespaceURI:命名空间指向的链接
//qName:命名空间的名称
//attributeDict:节点的所有属性
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString* )qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSLog(@"开始解析%@节点",elementName);
    //当开始解析student标签的时候,就应该初始化字典,因为一个字典就对应的是一个学生的信息
    if ([elementName isEqualToString:@"RESULTCODE"]) {
        self.saxDic = [NSMutableDictionary dictionary];
    }
}
//获取节点之间的值
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"取值--------%@",string);
    if (self.valueString) {//说明有值
        [self.valueString appendString:string];
    } else {
        self.valueString = [NSMutableString stringWithString:string];
    }
}
//某个节点结束取值


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString* )namespaceURI qualifiedName:(NSString* )qName {
    if ([elementName isEqualToString:@"RESULTCODE"]) {//说明name节点已经取值结束
        [self.saxDic setObject:self.valueString forKey:elementName];
    }
    if ([elementName isEqualToString:@"RESULTMSG"]) {
        [self.saxDic setObject:self.valueString forKey:elementName];
    }
    if ([elementName isEqualToString:@"OUT_TRADE_NO"]) {
        if (!kStringIsEmpty(self.valueString)) {
            [self.saxDic setObject:self.valueString forKey:elementName];
        }
    }
    if ([elementName isEqualToString:@"FINISHNAME"]) {
        if (!kStringIsEmpty(self.valueString)) {
            [self.saxDic setObject:self.valueString forKey:elementName];
        }
    }
    if ([elementName isEqualToString:@"GOODSNAME"]) {
        if (!kStringIsEmpty(self.valueString)) {
            [self.saxDic setObject:self.valueString forKey:elementName];
        }
    }
   
    if ([elementName isEqualToString:@"WXPAY"]) {
        if (!kStringIsEmpty(self.valueString)) {
            [self.saxDic setObject:self.valueString forKey:elementName];
        }
       
    }
    if ([elementName isEqualToString:@"ZFBPAY"]) {
        if (!kStringIsEmpty(self.valueString)) {
            [self.saxDic setObject:self.valueString forKey:elementName];
        }
    }
    if ([elementName isEqualToString:@"YZFPAY"]) {
        if (!kStringIsEmpty(self.valueString)) {
            [self.saxDic setObject:self.valueString forKey:elementName];
        }
    }
   
    
    self.valueString = nil;//置空
    NSLog(@"结束%@节点的解析",elementName);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    //可以使用解析完成的数据
    NSLog(@"%@",self.saxDic);
    NSLog(@"整个解析结束");
//    self.completion(self.saxDic,parseError);
    //状态码  -1 异常 0失败1 成功 2请求片段非法
    
    
}

//解析出错

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"解析出现错误-------%@",parseError.description);
    self.parserError=parseError;
}


@end
