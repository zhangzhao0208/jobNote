//
//  ReceivablesWaysView.h
//  SweepPayment
//
//  Created by suorui on 17/3/20.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZLabel.h"
#import "ZZButton.h"
@interface ReceivablesWaysView : UIView

@property(nonatomic,strong)UIView*backgroudView;
@property(nonatomic,strong)UIView*receivablesWaysView;
@property(nonatomic,strong)ZZLabel*titleLabel;
@property(nonatomic,strong)UIButton*lastButton;
@property(nonatomic,strong)ZZLabel*lastLabel;
@property(nonatomic,copy)NSArray*receivablesWaysArray;
@property(nonatomic,copy)NSString*payTypeStr;
@property(nonatomic,copy)void(^scanBlock)(NSString*);
@end
