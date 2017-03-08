//
//  ZZLabel.m
//  Health
//
//  Created by suorui on 17/2/23.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "ZZLabel.h"

static ZZLabel * label =nil;
@implementation ZZLabel

+ (instancetype)manager{
    
    label = [[ZZLabel alloc]init];
    
    return label;
}
- (void)setZZframe:(CGRect)ZZframe{
    label.frame = ZZframe;
}
- (void)setZZbgColor:(UIColor*)ZZbgColor{
   
    label.backgroundColor =ZZbgColor;
}
- (void)setZZlineColor:(UIColor *)ZZlineColor{
    label.layer.borderWidth = 1;
    label.layer.borderColor =ZZlineColor.CGColor;
}
- (void)setZZtitle:(NSString *)ZZtitle{
     label.text = ZZtitle;
}
- (void)setZZfont:(CGFloat)ZZfont{
    ZZfont = [UIScreen mainScreen].bounds.size.width==320? ZZfont-2:ZZfont;
    label.font =[UIFont systemFontOfSize:ZZfont];
}

- (void)setCorner:(CGFloat)corner{
    label.clipsToBounds=YES;
    label.layer.cornerRadius = corner;
}
- (void)ZZlabelTitle:(NSString*)ZZtitle ZZcolor:(UIColor*)ZZcolor ZZfont:(CGFloat)ZZfont{
    label.text = ZZtitle;
    label.textColor = ZZcolor;
    ZZfont = [UIScreen mainScreen].bounds.size.width==320? ZZfont-2:ZZfont;
    label.font =[UIFont systemFontOfSize:ZZfont];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
