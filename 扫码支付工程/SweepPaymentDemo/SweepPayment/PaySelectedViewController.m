//
//  PaySelectedViewController.m
//  SweepPayment
//
//  Created by suorui on 17/3/16.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "PaySelectedViewController.h"
#import "ScanViewController.h"
#import "TopBarView.h"
#import "PaymentWaysView.h"
#import "ParserManager.h"
#import "ReceivablesWaysView.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "PayResultViewController.h"

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
#define W_PI [UIScreen mainScreen].bounds.size.width/750
#define H_PI [UIScreen mainScreen].bounds.size.height/1334
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SweepPay.Bundle"]
#define ZZImageNamed(imageName)  ([UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",BUNDLE_PATH,imageName]])

@interface PaySelectedViewController ()<NSXMLParserDelegate>
{
    PaymentWaysView*paymentView;
    UIView*scanCodeView;
    ZZButton*lastButton;
    BOOL stateBarWhite;
     BOOL navgatinBar;
    NSString*payTypeStr;
    NSURLSessionDataTask *sessionDataTask;
    int requestCount;
}
@property(nonatomic,strong)UIImageView*codeImageView;
@property(nonatomic,copy)NSDictionary*orderInfoDic;
@property(nonatomic,assign)ReceivablesWaysView*receivablesWaysView;
@property(nonatomic,assign)BOOL closeTime;
@end
@implementation PaySelectedViewController

- (void)dealloc{
   
}
- (void)viewWillAppear:(BOOL)animated{
    
    if (self.navigationController.navigationBar.hidden!=YES) {
        navgatinBar=YES;
        self.navigationController.navigationBar.hidden=YES;
    }
    if (self.navigationController.navigationBar.barStyle != UIBarStyleBlack) {
        
        stateBarWhite=YES;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    _closeTime=NO;
    requestCount=0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (!_closeTime) {
            

            [self postRequestCheckResult];
        }
  
    });

    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    if (stateBarWhite==YES) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    if (navgatinBar==YES) {
        self.navigationController.navigationBar.hidden=NO;
    }

    _closeTime=YES;
    [sessionDataTask cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(243, 243, 243);
    [self createTopBArView];
    [self createPaymentWaysView];
    [self createScanCodeView];
    [self postRequest];

   
    
   
}
#pragma mark 导航条
- (void)createTopBArView{
    TopBarView*topView = [[TopBarView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    topView.leftStr = @"收付款";
    topView.backImageStr = @"pay__fh";
    topView.openBackButton = YES;
    topView.backButton.ZZBlock= ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    };
    [self.view addSubview:topView];
    
    UIView*backGroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    backGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backGroundView];

}
- (void)createPaymentWaysView{
    
    paymentView = [[PaymentWaysView alloc]initWithFrame:CGRectMake(0, 64,  self.view.frame.size.width, 100*H_PI) imageName:@"pay_sj" title:@"向商家付款"];
    paymentView.titleColor = RGB(75, 166, 111);
    [self.view addSubview:paymentView];
    
    PaymentWaysView*payeeView = [[PaymentWaysView alloc]initWithFrame:CGRectMake(0, 64+paymentView.frame.size.height+560.0f*H_PI,  self.view.frame.size.width, 100*H_PI) imageName:@"pay_user" title:@"向用户收款"];
    payeeView.titleColor = RGB(248, 100, 66);
    [self.view addSubview:payeeView];
    UITapGestureRecognizer*payeeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPayee)];
    [payeeView addGestureRecognizer:payeeTap];

    
}
#pragma mark 创建二维码
- (void)createScanCodeView{
    scanCodeView =[[UIView alloc]initWithFrame:CGRectMake(0, 64+paymentView.frame.size.height, paymentView.frame.size.width, 520.0f*H_PI)];
    scanCodeView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:scanCodeView];
    
    NSArray*payTypeArray = @[@"支付宝",@"微信支付",@"翼支付"];
    float buttonWidth =180*W_PI;
    float rowSpace = (self.view.frame.size.width-buttonWidth*3)/4.0f;
    for (int i=0; i<payTypeArray.count; i++) {
        
        ZZButton*button = [[ZZButton alloc]init];
        [button ZZbuttonTitle:payTypeArray[i] ZZcolor:[UIColor blackColor]];
        button.ZZfont =14;
        button.ZZframe = CGRectMake(rowSpace+(rowSpace+buttonWidth)*i, 30*H_PI, buttonWidth, 50*H_PI);
        button.tag = i+100;

        [scanCodeView addSubview:button];
        [button setImage:ZZImageNamed(@"pay_select_no") forState:UIControlStateNormal];
         [button setImage:ZZImageNamed(@"pay_select") forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40*H_PI);
        if (i==0) {
            
            button.selected =YES;
            lastButton=button;
            payTypeStr=@"支付宝";
        }
        if (i!=1) {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -40*H_PI, 0, 0);
        }
        
        [button addTarget:self action:@selector(clickSeletedTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((scanCodeView.frame.size.width-320*W_PI)/2, 120*H_PI, 320*W_PI, 320*W_PI)];
//    _codeImageView.image = ZZImageNamed(@"pay_sbzf");
    [scanCodeView addSubview:_codeImageView];
    
}
#pragma mark 发送请求，扫码支付，获取二维码图片地址
- (void)postRequest{
     
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ServerAddress" ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    //读取手动创建的plist文件的属性的值。
    NSString *urlStr =   [usersDic valueForKey:@"Paymethodurl"];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 创建请求对象
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式，默认为 GET 请求
    urlRequest.HTTPMethod = @"POST";
    NSString*MD5Str =[NSString stringWithFormat:@"MERCHANTID=%@&OUT_TRADE_NO=%@&TOTAL_FEE=%@&USERCODE=%@&KEY=%@",_goodsNumber,_orderNumber,_payPrice,_userCode,_payKey];
    NSString*xmlStr = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?><ROOT><MERCHANTID>%@</MERCHANTID><OUT_TRADE_NO>%@</OUT_TRADE_NO><TOTAL_FEE>%@</TOTAL_FEE><GOODSNAME>%@</GOODSNAME><USERCODE>%@</USERCODE><MAC>%@</MAC></ROOT>",_goodsNumber,_orderNumber,_payPrice,_goodsName,_userCode,[self MD5:MD5Str] ];
    
    //     设置请求体(请求参数)
    NSString*body = [NSString stringWithFormat:@"requerstxml=%@",xmlStr];
    
    urlRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    // 创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    // 发送请求
    NSURLSessionDataTask *urlSessionDataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString*s = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"++++-+-+-%@",s);
        if (error) {
            UIImage*image = [self imageWithPayType:@"ZFBPAY"];
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeImageView.image = image;
            });


            
            return ;
     }

        ParserManager*parser = [[ParserManager alloc]initData:data];
        if (parser.parserError) {
           
            return ;
        }
        if ([parser.saxDic[@"RESULTCODE"] intValue]==0) {
            self.orderInfoDic = parser.saxDic;
            UIImage*image = [self imageWithPayType:@"ZFBPAY"];
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeImageView.image = image;
            });
        }else if ([parser.saxDic[@"RESULTCODE"] intValue]==1){
            [self alertMessage:parser.saxDic[@"RESULTMSG"]];
        }else if ([parser.saxDic[@"RESULTCODE"] intValue]==3){
              [self alertMessage:parser.saxDic[@"RESULTMSG"]];
            
        }else if ([parser.saxDic[@"RESULTCODE"] intValue]==4){
              [self alertMessage:parser.saxDic[@"RESULTMSG"]];
            
        }else if ([parser.saxDic[@"RESULTCODE"] intValue]==5){
           [self alertMessage:parser.saxDic[@"RESULTMSG"]];
            

        }else if ([parser.saxDic[@"RESULTCODE"] intValue]==6){
            [self alertMessage:parser.saxDic[@"RESULTMSG"]];
           
        }
   
    }];
     
    // 执行任务
    [urlSessionDataTask resume];
}

#pragma mark  查询订单结果
- (void)postRequestCheckResult{
  
    if (_closeTime==YES) {
        return;
    }
    //获取已有完整路径
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ServerAddress" ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    //读取手动创建的plist文件的属性的值。
    NSString *urlStr =   [usersDic valueForKey:@"OrderCheckurl"];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 创建请求对象
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式，默认为 GET 请求
    urlRequest.HTTPMethod = @"POST";
     NSString*MD5Str =[NSString stringWithFormat:@"MERCHANTID=%@&OUT_TRADE_NO=%@&KEY=%@",_goodsNumber,_orderNumber,_payKey];
    
    NSString*xmlStr = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?><ROOT><MERCHANTID>%@</MERCHANTID><OUT_TRADE_NO>%@</OUT_TRADE_NO><MAC>%@</MAC></ROOT>",_goodsNumber,_orderNumber,[self MD5:MD5Str]];
    //     设置请求体(请求参数)
    NSString*body = [NSString stringWithFormat:@"requerstxml=%@",xmlStr];
    urlRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    // 创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    // 发送请求
   sessionDataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"***%@",error);
        if (error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                requestCount++;
                if (requestCount==21) {
                    return ;
                }
                [self postRequestCheckResult];

            });
            
            return ;
        }
        
        ParserManager*parser = [[ParserManager alloc]initData:data];
          NSLog(@"+++++**--%@",parser.saxDic);
        if ([parser.saxDic[@"RESULTCODE"] intValue]==1||[parser.saxDic[@"RESULTCODE"] intValue]==2||[parser.saxDic[@"RESULTCODE"] intValue]==-1) {
            NSLog(@"+++++**--%@",parser.saxDic);
            PayResultViewController*payResultViewController= [[PayResultViewController alloc]init];

            NSString*resultCode = [@"1" isEqualToString:parser.saxDic[@"RESULTCODE"]]?@"支付成功":@"支付失败";
            payResultViewController.goodsName =_goodsName;
            payResultViewController.orderNumber = _orderNumber;
            payResultViewController.payTime =parser.saxDic[@"FINISHNAME"];
            payResultViewController.payTypeStr = payTypeStr;
            payResultViewController.payResultState =resultCode;
            payResultViewController.payPrice = _payPrice;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:payResultViewController animated:YES];
            });

        }else{
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                requestCount++;
                if (requestCount==21) {
                    return ;
                }
                [self postRequestCheckResult];
                
            });        }

        
    }];
    
    
    // 执行任务
    [sessionDataTask resume];
}

#pragma mark 向用户收款
- (void)tapPayee{

    
    [self.view addSubview:self.receivablesWaysView];
    UITapGestureRecognizer*receivablesWaysTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapReceivablesWaysView)];
    [self.receivablesWaysView addGestureRecognizer:receivablesWaysTap];
    __weak PaySelectedViewController*weakSelf = self;
   
    self.receivablesWaysView.scanBlock=^(NSString*payType){
        [weakSelf.receivablesWaysView removeFromSuperview];
        weakSelf.receivablesWaysView=nil;

        ScanViewController*scan = [[ScanViewController alloc]init];
        scan.goodsName =weakSelf.goodsName;
        scan.orderNumber =weakSelf.orderNumber;
        scan.payTypeStr =payType ;
        scan.payPrice =weakSelf.payPrice;
        scan.goodsNumber =weakSelf.goodsNumber;
        scan.payKey =weakSelf.payKey;
      
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:scan animated:YES];
            });
        
    };
    
}
- (void)tapReceivablesWaysView{
    
    [self.receivablesWaysView removeFromSuperview];
    self.receivablesWaysView=nil;
}
#pragma mark 选择支付类型的二维码
- (void)clickSeletedTypeButton:(ZZButton*)sender{
    
    lastButton.selected=NO;
    sender.selected=YES;
    lastButton=sender;
    switch (sender.tag) {
        case 100:
        {
            UIImage*image = [self imageWithPayType:@"ZFBPAY"];
               _codeImageView.image = image;
    
            payTypeStr = @"支付宝";
        }
            break;
            
        case 101:
        {
            UIImage*image = [self imageWithPayType:@"WXPAY"];
            _codeImageView.image = image;
            payTypeStr = @"微信支付";
        }
            break;
        case 102:
        {
            UIImage*image = [self imageWithPayType:@"YZFPAY"];
            _codeImageView.image = image;
            payTypeStr = @"翼支付";
        }
            break;
        default:
            break;
    }
    
    
}
- (UIImage*)imageWithPayType:(NSString*)type{
    
    UIImage *image=nil;
    NSLog(@"+++++++%@",self.orderInfoDic[type]);
    if (!self.orderInfoDic[type]||[self.orderInfoDic[type] isEqualToString:@"null"]) {
        image = ZZImageNamed(@"pay_jzsb1");
    }else{
        NSURL*url = [NSURL URLWithString:self.orderInfoDic[type]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //image与data的相互转换
      image = [UIImage imageWithData:data];
    }
    
    return image;
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

#pragma mark 提示框
- (void)alertMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
      
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self presentViewController:alert animated:YES completion:nil];
    });
    
    

}
- (ReceivablesWaysView*)receivablesWaysView{
    
    if (!_receivablesWaysView) {
        _receivablesWaysView = [[ReceivablesWaysView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _receivablesWaysView;
}
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
