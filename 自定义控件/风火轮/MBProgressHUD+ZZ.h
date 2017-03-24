//
//  MBProgressHUD+ZZ.h
//  SweepPayment
//
//  Created by suorui on 17/3/21.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZZ)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
+ (void)showAlert:(NSString *)text view:(UIView *)view afterDelay:(int)time;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;

@end
