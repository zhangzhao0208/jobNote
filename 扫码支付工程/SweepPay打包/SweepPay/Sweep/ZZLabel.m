//
//  ZZLabel.m
//  Health
//
//  Created by suorui on 17/2/23.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "ZZLabel.h"


@implementation ZZLabel

- (void)setZZframe:(CGRect)ZZframe{
    self.frame = ZZframe;
}
- (void)setZZbgColor:(UIColor*)ZZbgColor{
   
    self.backgroundColor =ZZbgColor;
}
- (void)setZZlineColor:(UIColor *)ZZlineColor{
    self.layer.borderWidth = 1;
    self.layer.borderColor =ZZlineColor.CGColor;
}
- (void)setZZtitle:(NSString *)ZZtitle{
     self.text = ZZtitle;
}
- (void)setZZfont:(CGFloat)ZZfont{
    ZZfont = [UIScreen mainScreen].bounds.size.width==320? ZZfont-2:ZZfont;
    self.font =[UIFont systemFontOfSize:ZZfont];
}

- (void)setCorner:(CGFloat)corner{
    self.clipsToBounds=YES;
    self.layer.cornerRadius = corner;
}
- (void)ZZlabelTitle:(NSString*)ZZtitle ZZcolor:(UIColor*)ZZcolor ZZfont:(CGFloat)ZZfont{
    self.text = ZZtitle;
    self.textColor = ZZcolor;
    ZZfont = [UIScreen mainScreen].bounds.size.width==320? ZZfont-2:ZZfont;
    self.font =[UIFont systemFontOfSize:ZZfont];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
