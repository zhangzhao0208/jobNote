//
//  NSString+Add.h
//  HengShiXinYong
//
//  Created by 霍驹 on 16/7/1.
//  Copyright © 2016年 霍驹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Add)
+(NSString*)isEmpty:(NSString*)str;
-(CGFloat)getHeighWithFontSize:(CGFloat)fontSize andConstrainedWidth:(CGFloat)width;
-(CGFloat)getWidethWithFontSize:(CGFloat)fontSize andConstrainedHeight:(CGFloat)Height;
+ (NSString *)filePathAtDocumentsWithFileName:(NSString *)fileName;
//+(CGFloat)judgeLength:(NSString*)str1 and:(NSString*)str2;
+(CGFloat)judgeLength:(NSString*)str1 and:(NSString*)str2 and:(CGFloat)width andfontSize:(CGFloat)size;
-(CGRect)getNsstringSize:(NSString*)string withWidth:(float)width;
-(BOOL)validateMobile;//电话号码验证
+(BOOL) validatePassword:(NSString *)passWord;//密码验证
+ (BOOL) validateEmail:(NSString *)email;//邮箱验证
+ (int)stringConvertToInt:(NSString*)strtemp;
+ (BOOL)dutyChecked:(NSString *)duty;
+(BOOL)isHaveLogin;
+(NSString *)JsonModel:(NSDictionary *)dictModel;
+(NSString*)getResponseObjectMes:(NSString*)mes;
+(BOOL)isHaveData:(NSString*)str;
+(NSString*)removeSpace:(NSString*)st;
+ (BOOL)isPureInt:(NSString*)string;
+(NSString*)getUserNum;
+(NSString*)getUserName;
+(NSString*)getUserID;
-(NSString*)UTF8;
+ (BOOL)CheckIsIdentityCard:(NSString *)identityCard;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (BOOL)validateNumber:(NSString*)number;//只输入数字
@end
