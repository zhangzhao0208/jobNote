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

@property (nonatomic, weak) UIView *scannerLine;
@property (nonatomic, weak) UIImageView *scannerView;
@property(nonatomic,strong)UIImageView*carmeImageView;
@property(nonatomic,strong)UIView*backView;
@end
