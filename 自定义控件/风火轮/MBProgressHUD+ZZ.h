//
//  MBProgressHUD+ZZ.h
//  SweepPayment
//
//  Created by suorui on 17/3/21.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZZ)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;//加载提示带图片
+ (void)showAlert:(NSString *)text view:(UIView *)view afterDelay:(int)time;//提示语-自动关闭-时间可调
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;//风火轮 手动关闭
+ (void)hideHUDForView:(UIView *)view;//关闭风火轮
+ (void)showMessageDetaly:(NSString*)message;//提示语-自动关闭
@end
