//
//  ScanViewController.m
//  ScanClass
//
//  Created by suorui on 16/8/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ScanViewController.h"
#import "ParserManager.h"
#import "PayResultViewController.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
#define khb_SCANNERWIDTH_RATE 520/750
//扫描框中心Y的偏移量
#define khb_SCANNERCENTER_OFFSET HEIGHT*50/667
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SweepPay.Bundle"]
#define ZZImageNamed(imageName)  ([UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",BUNDLE_PATH,imageName]])
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZBarReaderDelegate,NSXMLParserDelegate>
{
    UIImageView *scannerView;
    NSURLSessionDataTask *urlSessionDataTask;
    BOOL closeRequest;
    int requestCount;

    
}
@property(nonatomic,strong)NSMutableDictionary*saxDic;
@property(nonatomic ,strong)NSMutableString*valueString;
@property(nonatomic ,strong)NSString*autoCode;
@end

@implementation ScanViewController


- (instancetype)initWithPayment:(NSArray*)payment{
    self = [super init];
    if (self) {
       
        _payment = payment;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    

    requestCount=0;
}
- (void)viewWillDisappear:(BOOL)animated{
    [urlSessionDataTask cancel];
    closeRequest=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.hidden=YES;
    self.view.backgroundColor =[UIColor whiteColor];
    [self instanceDevice];
}
- (void)instanceDevice{
    
    //获取摄像设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:[devices firstObject] error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //获取扫描范围并设置
    double scannerViewWidth = WIDTH * khb_SCANNERWIDTH_RATE;
    double scannerViewHeight = scannerViewWidth;
    double scannerViewX = (WIDTH - scannerViewWidth)/2;
    double scannerViewY = (HEIGHT- 64 - scannerViewWidth)/2 - khb_SCANNERCENTER_OFFSET;
    output.rectOfInterest = CGRectMake(scannerViewY/HEIGHT,   scannerViewX/WIDTH,scannerViewHeight/HEIGHT,scannerViewWidth/WIDTH);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prelayer = layer;
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    [self setOverlayPickerView];
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    //开始捕获
    [self.session startRunning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void  *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

#pragma mark 扫一扫界面布局
- (void)setOverlayPickerView {
    
    
    UIButton*backButton = [UIButton buttonWithType:UIButtonTypeCustom];

      [backButton setBackgroundImage:ZZImageNamed(@"pay_fh") forState:UIControlStateNormal];
//    backButton.backgroundColor = [UIColor redColor];
    backButton.frame = CGRectMake(20, 30, 30, 30);
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    //
    scannerView = [[UIImageView alloc] init];
    [self.view addSubview:scannerView];
    self.scanView = scannerView;
    scannerView.image = ZZImageNamed(@"pay_sm");
    scannerView.contentMode = UIViewContentModeScaleAspectFit;
    scannerView.center = self.view.center;
    scannerView.bounds = CGRectMake(0, 0, WIDTH * khb_SCANNERWIDTH_RATE, WIDTH * khb_SCANNERWIDTH_RATE);
    
    scannerView.backgroundColor = [UIColor clearColor];
    
    //左侧遮盖层
    UIImageView *leftView = [[UIImageView alloc] init];
    [self.view addSubview:leftView];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
     leftView.frame = CGRectMake(0, 0, (WIDTH- scannerView.frame.size.width)/2.0f, self.view.frame.size.height);

    
    //右侧遮盖层
    UIImageView *rightView = [[UIImageView alloc] init];
    [self.view addSubview:rightView];
    rightView.alpha = 0.5;
     rightView.frame = CGRectMake(scannerView.frame.size.width+(WIDTH- scannerView.frame.size.width)/2.0f, 0, (WIDTH- scannerView.frame.size.width)/2.0f, self.view.frame.size.height);
    rightView.backgroundColor = [UIColor blackColor];

    //顶部遮盖层
    UIImageView* upView = [[UIImageView alloc] init];
    [self.view addSubview:upView];
    upView.alpha = 0.5;
     upView.frame = CGRectMake((WIDTH- scannerView.frame.size.width)/2.0f, 0, scannerView.frame.size.width, (HEIGHT-scannerView.frame.size.height)/2.0f);
    upView.backgroundColor = [UIColor blackColor];
    
    //底部遮盖层
    UIImageView * downView = [[UIImageView alloc] init];
    [self.view addSubview:downView];
    downView.alpha = 0.5;
     downView.frame = CGRectMake((WIDTH- scannerView.frame.size.width)/2.0f, ((HEIGHT-scannerView.frame.size.height)/2.0f)+scannerView.frame.size.height, scannerView.frame.size.width, (HEIGHT-scannerView.frame.size.height)/2.0f);
    downView.backgroundColor = [UIColor blackColor];

    
    //扫描线
    UIImageView *scannerLine = [[UIImageView alloc] init];
    [self.view addSubview:scannerLine];
    self.scannerLine = scannerLine;
    scannerLine.image = ZZImageNamed(@"pay_smzf");

//        scannerLine.contentMo de = UIViewContentModeScaleAspectFill;
//    scannerLine.backgroundColor = [UIColor whiteColor];
    scannerLine.frame = CGRectMake((WIDTH- scannerView.frame.size.width)/2.0f, downView.frame.size.height, scannerView.frame.size.width, 1);

    
    //label
    UILabel *msgLabel = [[UILabel alloc] init];
    [self.view addSubview:msgLabel];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:15];
    msgLabel.text = [self payType:_payTypeStr];
     msgLabel.frame = CGRectMake(0, upView.frame.size.height+scannerView.frame.size.height+10, WIDTH, 30);

    
    
    
}
#pragma mark 扫描结果处理
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
//    NSLog(@"===%@",metadataObjects);
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self.session stopRunning];
            result = metadataObj.stringValue;
            [self doSomeThing:result];
        } else {
//            NSLog(@"不是二维码");
        }
        
    }
}

#pragma mark 扫描结果数据处理
- (void)doSomeThing:(NSString *)str{
   
   
    _autoCode=str;
   
    
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:scannerView animated:YES];
    
    hud.bezelView.color = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor ;
    hud.removeFromSuperViewOnHide = YES;
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.label.text = @"加载中";
    hud.label.textColor = [UIColor whiteColor];
    [self postRequestPayment];
    
//    
   
    
}
#pragma mark 发送请求 刷卡支付
- (void)postRequestPayment{
   
    if (closeRequest==YES) {
        
//         [MBProgressHUD hideHUDForView:scannerView animated:YES];
        return;
    }
    
   
    //获取已有完整路径
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ServerAddress" ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    //读取手动创建的plist文件的属性的值。
    NSString *urlStr =   [usersDic valueForKey:@"ScanPayurl"];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 创建请求对象
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式，默认为 GET 请求
    urlRequest.HTTPMethod = @"POST";
    NSString*MACStr = [NSString stringWithFormat:@"MERCHANTID=%@&OUT_TRADE_NO=%@&TOTAL_FEE=%@&AUTH_CODE=%@&KEY=%@",_goodsNumber,_orderNumber,_payPrice,_autoCode,_payKey];
    
    NSString*xmlStr = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?><ROOT><MERCHANTID>%@</MERCHANTID><OUT_TRADE_NO>%@</OUT_TRADE_NO><TOTAL_FEE>%@</TOTAL_FEE><AUTH_CODE>%@</AUTH_CODE><PAY_TYPE>%@</PAY_TYPE><GOODSNAME>%@</GOODSNAME><MAC>%@</MAC></ROOT>",_goodsNumber,_orderNumber,_payPrice,_autoCode,_payTypeStr,_goodsName,[self MD5:MACStr]];
    //     设置请求体(请求参数)
    NSString*body = [NSString stringWithFormat:@"requerstxml=%@",xmlStr];
    urlRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
  

    // 创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    // 发送请求
    urlSessionDataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       
        NSString*s = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"***%@",s);
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:scannerView animated:YES];
                [self alertMessage:@"请求超时，请检查网络"];
            });
            return ;
        }
        ParserManager*parser = [[ParserManager alloc]initData:data];
        if (parser.parserError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:scannerView animated:YES];
                    [self alertMessage:@"解析数据错误！"];
                
            });
            return ;
        }
    if([@"3"isEqualToString:parser.saxDic[@"RESULTCODE"]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            requestCount++;
            if (requestCount==21) {
                return ;
            }
             [self postRequestPayment];
            
        });

      
        
    }else if ([@"4"isEqualToString:parser.saxDic[@"RESULTCODE"]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:scannerView animated:YES];
            [self alertMessage:parser.saxDic[@"RESULTMSG"]];
        });

    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:scannerView animated:YES];
        });
        PayResultViewController*payResultViewController= [[PayResultViewController alloc]init];
        NSString*resultCode = [@"1" isEqualToString:parser.saxDic[@"RESULTCODE"]]?@"支付成功":@"支付失败";
        payResultViewController.goodsName =_goodsName;
        payResultViewController.orderNumber = _orderNumber;
        payResultViewController.payTime =parser.saxDic[@"FINISHNAME"];
        payResultViewController.payTypeStr = _payTypeStr;
        payResultViewController.payResultState =resultCode;

        payResultViewController.payPrice = _payPrice;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.session stopRunning];
            [self.prelayer removeFromSuperlayer];
            [self.navigationController pushViewController:payResultViewController animated:YES];
        });
        
 
    }
        
    }];
    
    
    // 执行任务
    [urlSessionDataTask resume];
    

}
- (NSString*)payType:(NSString*)payCode{
    
    if ([payCode isEqualToString:@"1"]) {
        return @"您使用的是微信扫一扫";
    }else if ([payCode isEqualToString:@"2"]){
        return @"您使用的是支付宝扫一扫";
    }else{
        return @"您使用的是翼支付扫一扫";
    }
}

- (void)alertMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.session stopRunning];
            [self.prelayer removeFromSuperlayer];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}
- (void)addAnimation {
    //    UIView *line = [self.view viewWithTag:self.line_tag];
    //    line.hidden = NO;
    self.scannerLine.hidden = NO;
    CABasicAnimation *animation = [ScanViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:@(WIDTH * khb_SCANNERWIDTH_RATE - 5) rep:OPEN_MAX];
    //    [line.layer addAnimation:animation forKey:@"LineAnimation"];
    [self.scannerLine.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep {
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
//    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}
/**
 *  去除扫码动画
 */
- (void)removeAnimation {
    //    UIView *line = [self.view viewWithTag:self.line_tag];
    //    [line.layer removeAnimationForKey:@"LineAnimation"];
    //    line.hidden = YES;
    [self.scannerLine.layer removeAnimationForKey:@"LineAnimation"];
    self.scannerLine.hidden = YES;
}
/**
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview {
    [self.session stopRunning];
    [self.prelayer removeFromSuperlayer];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 返回按钮事件
-(void)clickBackButton
{
    [self.session stopRunning];
    [self.prelayer removeFromSuperlayer];
    [self.navigationController popViewControllerAnimated:YES];
  
}
- (NSString *)MD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
    
}

//- (void)pushToPayResultViewController{
//    [self selfRemoveFromSuperview];
//    
//    PayResultViewController*payResultViewController= [[PayResultViewController alloc]init];
//    
//
////    NSString*resultCode = [@"1" isEqualToString:self.saxDic[@"RESULTCODE"]]?@"支付成功":@"支付失败";
//    payResultViewController.goodsName =_goodsName;
//    payResultViewController.orderNumber = _orderNumber;
//    //    payResultViewController.payTime =self.saxDic[@"FINISHNAME"];
//    payResultViewController.payTime =@"2017-02-14";
//    payResultViewController.payTypeStr = _payTypeStr;
//    //    payResultViewController.payResultState =resultCode;
//    payResultViewController.payResultState =@"支付成功";
//    payResultViewController.payPrice = _payPrice;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:payResultViewController animated:YES];
//    });
//    //状态码  -1 异常 0失败1 成功 2请求片段非法
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
