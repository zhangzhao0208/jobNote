//
//  ZZButton.h
//  AFUrl
//
//  Created by suorui on 16/12/26.
//  Copyright © 2016年 suorui. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@interface ZZButton : UIButton

//位置
@property(nonatomic,assign)CGRect ZZframe;
//背景颜色
@property(nonatomic,strong)UIColor* ZZbgColor;
//字体
@property(nonatomic,strong)NSString* ZZtitle;
//字体大小
@property(nonatomic,assign)CGFloat ZZfont;
//字体颜色
@property(nonatomic,strong)UIColor* ZZtitleColor;
//边框线
@property(nonatomic,strong)UIColor* ZZlineColor;
//图片
@property(nonatomic,copy)NSString *ZZimage;
//切圆角
@property(nonatomic,assign)CGFloat corner;
//倒计时背景颜色
@property(nonatomic,strong)UIColor* ZZcountBgColor;
//倒计时字体颜色

//点击按钮
@property(nonatomic,copy)void (^ZZBlock)();
+ (instancetype)manager;
//按钮文字和颜色
- (void)ZZbuttonTitle:(NSString*)ZZtitle ZZcolor:(UIColor*)ZZcolor;
//按钮点击事件
- (void)addTarget;
- (void)openCountDownBg:(UIColor*)bgCorlor titleColor:(UIColor*)titleColor;
@end
