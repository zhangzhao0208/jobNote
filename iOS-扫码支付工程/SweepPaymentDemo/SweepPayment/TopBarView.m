//
//  TopBarView.m
//  SweepPayment
//
//  Created by suorui on 17/3/16.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "TopBarView.h"
#define W_PI [UIScreen mainScreen].bounds.size.width/750
#define H_PI [UIScreen mainScreen].bounds.size.height/1334
#define ZZFONT(ZZfont) ([UIFont systemFontOfSize:self.frame.size.width==320? ZZfont-2:ZZfont])
#define BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SweepPay.Bundle"]
#define ZZImageNamed(imageName)  ([UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",BUNDLE_PATH,imageName]])
@implementation TopBarView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
       
        [self createTopBarView];
    }
    
    return self;
    
}
-(void)setBackImageStr:(NSString *)backImageStr{
     _backImageView.image = ZZImageNamed(backImageStr);
     [self addSubview:_backImageView];
}
- (void)setLeftStr:(NSString *)leftStr{
    _leftLabel.text = leftStr;
    _leftLabel.font = ZZFONT(16);
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    _leftLabel.textColor =[UIColor whiteColor];
    _leftLabel.backgroundColor = self.backgroundColor;
    [self addSubview:_leftLabel];
    
}
- (void)setCenterStr:(NSString *)centerStr{
    _centerLabel.text = centerStr;
    _centerLabel.font = ZZFONT(18);
    _centerLabel.textAlignment = NSTextAlignmentCenter;
    _centerLabel.backgroundColor = self.backgroundColor;
   
    [self addSubview:_centerLabel];
}
- (void)setBottomStr:(NSString *)bottomStr{
    _bottomLabel.text = bottomStr;
    _bottomLabel.font = ZZFONT(16);
    [self addSubview:_bottomLabel];
}
- (void)setRightStr:(NSString *)rightStr{
    
    
    [_rightButton ZZbuttonTitle:rightStr ZZcolor:[UIColor whiteColor]];
    _rightButton.backgroundColor = [UIColor colorWithRed:18.0f/255.0 green:120.0f/255.0 blue:245.0f/255.0 alpha:1.0];
    _rightButton.ZZfont =16;
    
    _rightButton.corner=5;
    [_rightButton addTarget];
    [self addSubview:_rightButton];
}

- (void)setOpenRightButton:(BOOL)openRightButton{
    
//    if (openRightButton) {
//        [self addSubview:_rightButton];
//        [_rightButton addTarget];
//        _rightButton.ZZBlock();
//
//    }
}
- (void)setOpenBackButton:(BOOL)openBackButton{
    
    if (openBackButton) {
        [self addSubview:_backButton];
        [_backButton addTarget];
        
    }
}

-(void)createTopBarView{
    
    self.backgroundColor = [UIColor colorWithRed:41.0f/255.0 green:48.0f/255.0 blue:53.0f/255.0 alpha:1.0];
   
    _backImageView = [[UIImageView alloc]init];
    _backImageView.frame = CGRectMake(10,(44-57*H_PI)/2.0f, 38*W_PI, 57*H_PI);
   
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.frame = CGRectMake(10+_backImageView.frame.size.width+5,(44-48*H_PI)/2.0f, 100*W_PI, 48*H_PI) ;
    
    _centerLabel = [[UILabel alloc]init];
    _centerLabel.textColor =[UIColor whiteColor];
    _centerLabel.frame = CGRectMake((self.frame.size.width-200*W_PI)/2.0f, (44-48*H_PI)/2.0f, 200*W_PI, 48*H_PI);
  
//    _bottomLabel = [[UILabel alloc]init];
//    _bottomLabel.center = self.center;
//    _bottomLabel.frame = CGRectMake(_centerLabel.frame.origin.x, _centerLabel.frame.size.height, 120*W_PI, 12*H_PI);
   
    _rightButton =[[ZZButton alloc]init];
    _rightButton.ZZframe = CGRectMake(self.frame.size.width-120*W_PI,5, 100*W_PI, self.frame.size.height-2*5);
    
    _backButton =[[ZZButton alloc]init];
    _backButton.ZZframe = CGRectMake(0,0,_backImageView.frame.size.width+_backImageView.frame.origin.x+10,44);
    _backButton.backgroundColor = [UIColor clearColor];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
