//
//  PayResultViewController.h
//  SweepPayment
//
//  Created by suorui on 17/3/20.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayResultViewController : UIViewController
@property(nonatomic,strong)NSMutableArray*sacnResultArray;
@property(nonatomic,copy)NSString*goodsName;
@property(nonatomic,copy)NSString*orderNumber;
@property(nonatomic,copy)NSString*payTime;
@property(nonatomic,copy)NSString*payTypeStr;
@property(nonatomic,copy)NSString*payResultState;
@property(nonatomic,copy)NSString*payPrice;

@end
