//
//  ZZButton.m
//  AFUrl
//
//  Created by suorui on 16/12/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ZZButton.h"

@implementation ZZButton

- (instancetype)init{
    
    self = [super init];
    if (self) {
       self= [ZZButton buttonWithType:UIButtonTypeCustom];
    }
    
    return self;
}

- (void)setZZframe:(CGRect)ZZframe{
    self.frame = ZZframe;
}

- (void)setZZbgColor:(UIColor*)ZZbgColor{
     _ZZbgColor = ZZbgColor;
    self.backgroundColor =ZZbgColor;
}
- (void)setZZlineColor:(UIColor *)ZZlineColor{
    self.layer.borderWidth = 1;
    self.layer.borderColor =ZZlineColor.CGColor;
    
}
- (void)ZZbuttonTitle:(NSString*)ZZtitle ZZcolor:(UIColor*)ZZcolor{
    [self setTitle:ZZtitle forState:UIControlStateNormal];
    [self setTitleColor:ZZcolor forState:UIControlStateNormal];
    _ZZtitle = ZZtitle;
    _ZZtitleColor = ZZcolor;
}
- (void)setZZfont:(CGFloat)ZZfont{
    
    ZZfont = [UIScreen mainScreen].bounds.size.width==320? ZZfont-2:ZZfont;
    
    self.titleLabel.font = [UIFont systemFontOfSize:ZZfont];
    
}

- (void)setZZimage:(NSString *)ZZimage{
    [self setBackgroundImage:[UIImage imageNamed:ZZimage] forState:UIControlStateNormal];
}
- (void)addTarget{
    [self addTarget:self action:@selector(clickZZButton) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setCorner:(CGFloat)corner{
     self.clipsToBounds=YES;
    self.layer.cornerRadius=corner;
}

- (void)clickZZButton{
    
    self.ZZBlock();
}
- (void)openCountDownBg:(UIColor*)bgCorlor  titleColor:(UIColor*)titleColor{
    
    __block int timeout=4; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:_ZZtitle forState:UIControlStateNormal];
                self.backgroundColor =_ZZbgColor ;
                
                [self setTitleColor:_ZZtitleColor forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                self.backgroundColor =bgCorlor;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self setTitle:[NSString stringWithFormat:@"%@s后重试",strTime] forState:UIControlStateNormal];
                [self setTitleColor:titleColor forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
