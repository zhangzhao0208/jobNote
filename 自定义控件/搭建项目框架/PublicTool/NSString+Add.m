//
//  NSString+Add.m
//  HengShiXinYong
//
//  Created by 霍驹 on 16/7/1.
//  Copyright © 2016年 霍驹. All rights reserved.
//

#import "NSString+Add.h"
#import "PersonalInformationModel.h"

@implementation NSString (Add)
//utf8编码
-(NSString*)UTF8
{
   return  [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+(NSString*)isEmpty:(NSString*)str
{
    if (str==nil||[str isEqualToString:@""]||[str isEqualToString:@"(null)"]||[str isEqualToString:@"null"]||[str isEqualToString:@"<null>"]) {
        return @"";
    }
    else{
        return str;
    }
}
//获得字体高度
-(CGFloat)getHeighWithFontSize:(CGFloat)fontSize andConstrainedWidth:(CGFloat)width
{
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return (int)(rect.size.height+1);
}
-(CGFloat)getWidethWithFontSize:(CGFloat)fontSize andConstrainedHeight:(CGFloat)Height
{
    CGRect rect=[self boundingRectWithSize:CGSizeMake(MAXFLOAT, Height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return (int)(rect.size.width+1);
}
//Documents路径
+ (NSString *)filePathAtDocumentsWithFileName:(NSString *)fileName{
    
    NSString *fileStr = [NSString stringWithFormat:@"Documents/%@",fileName];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:fileStr];
    return filePath;
}

+(CGFloat)judgeLength:(NSString*)str1 and:(NSString*)str2 and:(CGFloat)width andfontSize:(CGFloat)size
{
    CGFloat length;
    if ([str1 getHeighWithFontSize:size andConstrainedWidth:width] >[str2 getHeighWithFontSize:size andConstrainedWidth:width]) {
        length=[str1 getHeighWithFontSize:size andConstrainedWidth:width];
    }else
    {
        length=[str2 getHeighWithFontSize:size andConstrainedWidth:width];
    }
    int lenght1=(int)(length+1);
    return lenght1;
}
-(CGRect)getNsstringSize:(NSString*)string withWidth:(float)width
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|
                 NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    
    return rect;
    
}
//判断手机号
-(BOOL)validateMobile{
    NSString *MOBILE = @"^1[34578]\\d{9}$";
    
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    
    if ([regexTestMobile evaluateWithObject:self]) {return YES;}else {return NO;}
}
//验证密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
    
}
//验证邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}
//验证税号
+ (BOOL)dutyChecked:(NSString *)duty
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";

    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:duty];
    
}
//限制长度
+ (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1);
}
//身份证验证
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}
//判断是否登录
+(BOOL)isHaveLogin
{
   NSUserDefaults*userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"personalInformationModel"]==nil ) {
        return NO;
    }
    else{
    
        return YES;
    }
 
}
//判断是否是数字
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+(NSString *)JsonModel:(NSDictionary *)dictModel
{
    if ([NSJSONSerialization isValidJSONObject:dictModel])
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictModel options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}
+(NSString*)getResponseObjectMes:(NSString*)mes
{
    NSArray*arr=[mes componentsSeparatedByString:@"\""];
    NSString*str=[arr objectAtIndex:arr.count-2];
    return str;
}
+(BOOL)isHaveData:(NSString*)str
{
    NSArray*arr=[str componentsSeparatedByString:@"/"];
    NSString*str1=[arr objectAtIndex:0];
    if ([str1 isEqualToString:@"0"]) {
        return NO;
    }
    else
    {
        return YES;
    }
}
+(NSString*)removeSpace:(NSString*)st
{
    NSArray*arr=[st componentsSeparatedByString:@" "];
    if (arr.count==0) {
        return @"";
    }else
    {
    return arr[0];
    }
    
}
@end
