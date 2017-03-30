//
//  PaymentWaysView.h
//  SweepPayment
//
//  Created by suorui on 17/3/17.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZLabel.h"
#import "ZZButton.h"
@interface PaymentWaysView : UIView
@property(nonatomic,strong)UIImageView*paymentImageView;
@property(nonatomic,strong)ZZButton*tapButton;
@property(nonatomic,strong)ZZLabel*paymentLabel;
@property(nonatomic,copy)NSString*imageName;
@property(nonatomic,copy)NSString*titleName;
@property(nonatomic,strong)UIColor*titleColor;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title;
@end
