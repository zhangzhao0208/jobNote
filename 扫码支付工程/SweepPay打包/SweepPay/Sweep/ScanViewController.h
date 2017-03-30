//
//  ScanViewController.h
//  ScanClass
//
//  Created by suorui on 16/8/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController : UIViewController
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *prelayer;
@property(nonatomic,copy)NSArray*payment;
@property (nonatomic, weak) UIView *scannerLine;
@property (nonatomic, weak) UIImageView *scanView;
@property(nonatomic,strong)UIImageView*carmeImageView;
@property(nonatomic,copy)NSString*dutyCompanyStr;

@property(nonatomic,copy)NSString*goodsName;//商品名称
@property(nonatomic,copy)NSString*goodsNumber;//商户号
@property(nonatomic,copy)NSString*orderNumber;//订单号
@property(nonatomic,copy)NSString*payTime;//交易时间
@property(nonatomic,copy)NSString*payTypeStr;//支付类型
@property(nonatomic,copy)NSString*payResultState;//支付结果状态
@property(nonatomic,copy)NSString*payPrice;//支付价格
@property(nonatomic,copy)NSString*payKey;//加密key

@property(nonatomic,strong)UIView*backView;
@end
