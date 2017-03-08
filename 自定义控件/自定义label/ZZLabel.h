//
//  ZZLabel.h
//  Health
//
//  Created by suorui on 17/2/23.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLabel : UILabel


//位置
@property(nonatomic,assign)CGRect ZZframe;
//背景颜色
@property(nonatomic,strong)UIColor* ZZbgColor;
//字体
@property(nonatomic,strong)NSString* ZZtitle;
//字体大小
@property(nonatomic,assign)CGFloat ZZfont;
//边框线
@property(nonatomic,strong)UIColor* ZZlineColor;

//切圆角
@property(nonatomic,assign)CGFloat corner;

+ (instancetype)manager;
//label文字、颜色、字体大小
- (void)ZZlabelTitle:(NSString*)ZZtitle ZZcolor:(UIColor*)ZZcolor ZZfont:(CGFloat)ZZfont;

@end
