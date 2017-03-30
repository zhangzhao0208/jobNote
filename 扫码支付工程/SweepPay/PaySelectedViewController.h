//
//  PaySelectedViewController.h
//  SweepPayment
//
//  Created by suorui on 17/3/16.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySelectedViewController : UIViewController

@property(nonatomic,copy)NSString*goodsNumber;//商户号
@property(nonatomic,copy)NSString*orderNumber;//订单号
@property(nonatomic,copy)NSString*payPrice;//金额(整数，单位为分)
@property(nonatomic,copy)NSString*userCode;//收费人工号
@property(nonatomic,copy)NSString*payKey;//加密key
@property(nonatomic,copy)NSString*goodsName;//商品名称

@end
