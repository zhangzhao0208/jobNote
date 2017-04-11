//
//  ReceivablesWaysView.m
//  SweepPayment
//
//  Created by suorui on 17/3/20.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "ReceivablesWaysView.h"
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define W_PI [UIScreen mainScreen].bounds.size.width/750
#define H_PI [UIScreen mainScreen].bounds.size.height/1334
#define BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SweepPay.Bundle"]
#define ZZImageNamed(imageName)  ([UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",BUNDLE_PATH,imageName]])
@implementation ReceivablesWaysView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    if (self) {
        [self createReceivablesWaysView];
    }
    
    return self;
}

- (void)createReceivablesWaysView{
    
    _backgroudView = [[UIView alloc]initWithFrame:self.bounds];
    _backgroudView.backgroundColor = [UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:0.5];
    [self addSubview:_backgroudView];
    
    _receivablesWaysView =[[UIView alloc]init];
    _receivablesWaysView.center = CGPointMake(self.center.x, self.center.y-200*H_PI);
    _receivablesWaysView.bounds = CGRectMake(0, 0, self.frame.size.width-80, 360.0f*H_PI);
    _receivablesWaysView.backgroundColor =[UIColor whiteColor];
    _receivablesWaysView.layer.cornerRadius=5;
    _receivablesWaysView.clipsToBounds=YES;
    [self addSubview:_receivablesWaysView];
    
    self.titleLabel.frame = CGRectMake(0, 0, _receivablesWaysView.frame.size.width, 64*H_PI);
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [_receivablesWaysView addSubview:self.titleLabel];
    float labelHeight =(_receivablesWaysView.frame.size.height-_titleLabel.frame.size.height*2)/3;
    
    _receivablesWaysArray = @[@"支付宝",@"微信支付",@"翼支付"];
    for (int i=0; i<3; i++) {
 
        ZZLabel*label =[[ZZLabel alloc]init];
        label.frame = CGRectMake(20*W_PI+68*W_PI+10, self.titleLabel.frame.size.height+labelHeight*i,180*W_PI, labelHeight);
//        label.backgroundColor = [UIColor redColor];
        label.tag = 300+i;
        [label ZZlabelTitle:_receivablesWaysArray[i] ZZcolor:RGB(48, 48, 48) ZZfont:15];
        [_receivablesWaysView addSubview:label];
        UIButton*button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i+200;
        [button addTarget:self action:@selector(clickReceivablesWaysButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20*W_PI+10, self.titleLabel.frame.size.height+labelHeight*i+(labelHeight-40*H_PI)/2,50*W_PI, 40*H_PI);
        [button setBackgroundImage:ZZImageNamed(@"pay_select_no") forState:UIControlStateNormal];
        [button setBackgroundImage:ZZImageNamed(@"pay_select") forState:UIControlStateSelected];
        [_receivablesWaysView addSubview:button];
        
        UIButton*clearButton =[UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.tag=i+100;
        [clearButton addTarget:self action:@selector(clickReceivablesWaysButton:) forControlEvents:UIControlEventTouchUpInside];
        clearButton.frame = CGRectMake(0, self.titleLabel.frame.size.height+labelHeight*i,_receivablesWaysView.frame.size.width , labelHeight);
         [_receivablesWaysView addSubview:clearButton];
        
        UIView*lineView =[[UIView alloc]initWithFrame:CGRectMake(20*W_PI, self.titleLabel.frame.size.height+labelHeight*(i+1)-1,_receivablesWaysView.frame.size.width-40*W_PI,1)];
        lineView.backgroundColor = RGB(225, 225, 225);
        if (i!=2) {
            [_receivablesWaysView addSubview:lineView];
        }
        
        if (i==0) {
            button.selected=YES;
             [label ZZlabelTitle:_receivablesWaysArray[i] ZZcolor:RGB(9, 144,63) ZZfont:15];
            _lastButton=button;
            _lastLabel=label;
            _payTypeStr=_receivablesWaysArray[i];
        }
    }
    //动画弹出
    [self receivablesWaysViewShowAnimation];
    
}

- (void)clickReceivablesWaysButton:(UIButton*)sender{
    _lastButton.selected=NO;
    _lastLabel.textColor =RGB(48, 48, 48);
    UIButton*button = [self viewWithTag:sender.tag+100];
    button.selected=YES;
    _payTypeStr=_receivablesWaysArray[sender.tag-100];
  
    self.scanBlock([self returnPayType:_payTypeStr]);
    ZZLabel*label = [self viewWithTag:sender.tag+200];
    label.textColor = RGB(9, 144,63);
    _lastButton=button;
    _lastLabel=label;
}

- (NSString*)returnPayType:(NSString*)str{
    
    if ([str isEqualToString:@"微信支付"]) {
        return @"1";
    }else if ([str isEqualToString:@"支付宝"]){
        return @"2";
    }else{
        return @"3";
    }
}

- (void)receivablesWaysViewShowAnimation{
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_receivablesWaysView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_receivablesWaysView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_receivablesWaysView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_receivablesWaysView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
    

}
- (ZZLabel*)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[ZZLabel alloc]init];
        [_titleLabel ZZlabelTitle:@"选择用户支付方式" ZZcolor:RGB(161,161,161) ZZfont:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
