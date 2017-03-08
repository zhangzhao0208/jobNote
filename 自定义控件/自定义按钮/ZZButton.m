//
//  ZZButton.m
//  AFUrl
//
//  Created by suorui on 16/12/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ZZButton.h"

static ZZButton*manager=nil;
@implementation ZZButton

+ (instancetype)manager{
    manager= [ZZButton buttonWithType:UIButtonTypeCustom];
    return manager;
}

- (void)setZZframe:(CGRect)ZZframe{
    manager.frame = ZZframe;
}

- (void)setZZbgColor:(UIColor*)ZZbgColor{
     _ZZbgColor = ZZbgColor;
    manager.backgroundColor =ZZbgColor;
}
- (void)setZZlineColor:(UIColor *)ZZlineColor{
    manager.layer.borderWidth = 1;
    manager.layer.borderColor =ZZlineColor.CGColor;
    
}
- (void)ZZbuttonTitle:(NSString*)ZZtitle ZZcolor:(UIColor*)ZZcolor{
    [manager setTitle:ZZtitle forState:UIControlStateNormal];
    [manager setTitleColor:ZZcolor forState:UIControlStateNormal];
    _ZZtitle = ZZtitle;
    _ZZtitleColor = ZZcolor;
}
- (void)setZZfont:(CGFloat)ZZfont{
    
    ZZfont = [UIScreen mainScreen].bounds.size.width==320? ZZfont-2:ZZfont;
    NSLog(@"+++%f",ZZfont);
    manager.titleLabel.font = [UIFont systemFontOfSize:ZZfont];
    
}

- (void)setZZimage:(NSString *)ZZimage{
    [manager setBackgroundImage:[UIImage imageNamed:ZZimage] forState:UIControlStateNormal];
}
- (void)addTarget{
    [manager addTarget:self action:@selector(clickZZButton) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setCorner:(CGFloat)corner{
     manager.clipsToBounds=YES;
    manager.layer.cornerRadius=corner;
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
                [manager setTitle:_ZZtitle forState:UIControlStateNormal];
                manager.backgroundColor =_ZZbgColor ;
                
                [manager setTitleColor:_ZZtitleColor forState:UIControlStateNormal];
                manager.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                manager.backgroundColor =bgCorlor;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [manager setTitle:[NSString stringWithFormat:@"%@s后重试",strTime] forState:UIControlStateNormal];
                [manager setTitleColor:titleColor forState:UIControlStateNormal];
                [UIView commitAnimations];
                manager.userInteractionEnabled = NO;
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
