//
//  MBProgressHUD+ZZ.m
//  SweepPayment
//
//  Created by suorui on 17/3/21.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "MBProgressHUD+ZZ.h"
#import "MBProgressHUD.h"
@implementation MBProgressHUD (ZZ)

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    
    // 设置图片
    hud.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",icon]]]; ;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 2秒之后再消失
//    [hud hideAnimated:YES afterDelay:2];
}


/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //背景框颜色
    hud.bezelView.color = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    //菊花颜色
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.label.text = message;
    //固定色
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor ;
    hud.label.textColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
//    hud.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    return hud;
}

+ (void)showAlert:(NSString *)text view:(UIView *)view afterDelay:(int)time{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //背景框颜色
    hud.bezelView.color = [UIColor blackColor];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.label.textColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:time];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}@end
