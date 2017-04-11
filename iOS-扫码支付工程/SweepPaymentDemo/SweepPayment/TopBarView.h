//
//  TopBarView.h
//  SweepPayment
//
//  Created by suorui on 17/3/16.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZButton.h"
@interface TopBarView : UIView


@property(nonatomic,strong)UILabel*leftLabel;
@property(nonatomic,strong)UIImageView*backImageView;
@property(nonatomic,strong)ZZButton*backButton;
@property(nonatomic,strong)ZZButton*rightButton;
@property(nonatomic,strong)UILabel*centerLabel;
@property(nonatomic,strong)UILabel*bottomLabel;
@property(nonatomic,copy)NSString*leftStr;
@property(nonatomic,copy)NSString*rightStr;
@property(nonatomic,copy)NSString*backImageStr;
@property(nonatomic,copy)NSString*centerStr;
@property(nonatomic,copy)NSString*bottomStr;
@property(nonatomic,assign)BOOL openRightButton;
@property(nonatomic,assign)BOOL openBackButton;

- (instancetype)initWithFrame:(CGRect)frame;
@end
