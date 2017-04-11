//
//  PaymentWaysView.m
//  SweepPayment
//
//  Created by suorui on 17/3/17.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "PaymentWaysView.h"
#define W_PI [UIScreen mainScreen].bounds.size.width/750
#define H_PI [UIScreen mainScreen].bounds.size.height/1334
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SweepPay.Bundle"]
#define ZZImageNamed(imageName)  ([UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",BUNDLE_PATH,imageName]])
@implementation PaymentWaysView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title{
    
    self =[super initWithFrame:frame];
    if (self) {
        
        self.imageName = imageName;
        self.titleName = title;
        [self createPaymentWaysView];
       
    }
    return self;
    
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    [_paymentLabel ZZlabelTitle:_titleName ZZcolor:titleColor ZZfont:16];
    if ([_titleName isEqualToString:@"支付成功"]||[_titleName isEqualToString:@"支付失败"]) {
        _paymentImageView.frame = CGRectMake(20*W_PI,(self.frame.size.height-65*H_PI)/2.0f, 65*W_PI, 65*H_PI);
    }
}

- (void)createPaymentWaysView{
    
    self.backgroundColor = RGB(246, 246, 246);
    self.layer.borderColor = RGB(198, 198, 198).CGColor;
    self.layer.borderWidth = 1;
    _paymentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*W_PI,(self.frame.size.height-52*H_PI)/2.0f, 68*W_PI, 52*H_PI)];
    _paymentImageView.image =ZZImageNamed(_imageName);
    _paymentImageView.backgroundColor =[UIColor redColor];

    [self addSubview:_paymentImageView];
    
    _paymentLabel = [[ZZLabel alloc]init];
    _paymentLabel.frame = CGRectMake(_paymentImageView.frame.size.width+_paymentImageView.frame.origin.x+5, 0, 200*W_PI, self.frame.size.height);
    _paymentImageView.backgroundColor = RGB(246, 246, 246);
    [self addSubview:_paymentLabel];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
