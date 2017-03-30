//
//  PayResultViewController.m
//  SweepPayment
//
//  Created by suorui on 17/3/20.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "PayResultViewController.h"
#import "TopBarView.h"
#import "PaymentWaysView.h"
#import "ParserManager.h"
#import "MBProgressHUD.h"

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
@interface PayResultViewController ()<NSXMLParserDelegate>
{
    BOOL stateBarWhite;
    BOOL navgatinBar;
}
@property(nonatomic,strong)NSMutableDictionary*saxDic;
@property(nonatomic ,strong)NSMutableString*valueString;
@property(nonatomic ,strong)ZZLabel*titleLabel;
@property(nonatomic ,strong)UIView*orderInfoView;
@end

@implementation PayResultViewController
- (void)viewWillAppear:(BOOL)animated{
    
    if (self.navigationController.navigationBar.hidden!=YES) {
        navgatinBar=YES;
        self.navigationController.navigationBar.hidden=YES;
    }
    if (self.navigationController.navigationBar.barStyle != UIBarStyleBlack) {
        
        stateBarWhite=YES;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    if (navgatinBar==YES) {
        self.navigationController.navigationBar.hidden=NO;
    }
    if (stateBarWhite==YES) {
        self.navigationController.navigationBar.hidden=NO;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.hidden=YES;
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTopBarView];
    [self createPaymentStateView];
//    [self postRequestPayment:_sacnResultArray];
    [self createPayResultInfoView];
    
    
}
#pragma mark 导航条
- (void)createTopBarView{
    TopBarView*topView = [[TopBarView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    topView.centerStr = @"交易详情";
    topView.rightStr = @"完成";
   
    topView.rightButton.ZZBlock= ^{
        dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"payResult" object:nil];
        });
        
    };
    [self.view addSubview:topView];
    
    UIView*backGroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    backGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backGroundView];
    
}
- (void)createPaymentStateView{
    
   NSString*iamgeNameStr = [_payResultState isEqualToString:@"支付成功"]?@"pay_cgzf":@"pay_sbzf";
    
        PaymentWaysView*paymentView = [[PaymentWaysView alloc]initWithFrame:CGRectMake(0, 64,  self.view.frame.size.width, 100*H_PI) imageName:iamgeNameStr title:_payResultState];
        paymentView.titleColor = RGB(75, 166, 111);
        [self.view addSubview:paymentView];
}

#pragma mark 订单信息展示界面
- (void)createPayResultInfoView{
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.orderInfoView];
    NSArray*array =@[@"商       品",@"交易单号",@"交易时间",@"银行类型",@"当前状态"];
     NSLog(@"+++%@+++%@++%@++%@+%@",_goodsName,_orderNumber,_payTime,_payResultState,_payTypeStr);
    NSArray*rightArray = @[_goodsName,_orderNumber,_payTime,[_payTypeStr length]>1?_payTypeStr:[self payType:_payTypeStr],_payResultState];
   
    float infoHeight = 400*H_PI;
    for (int i=0; i<5; i++) {
        
        ZZLabel*leftLabel = [[ZZLabel alloc]init];
        leftLabel.frame = CGRectMake(10, 10+(infoHeight-20)/5*i, 200*W_PI, (infoHeight-20)/5);
        leftLabel.textAlignment = NSTextAlignmentLeft;
        [leftLabel ZZlabelTitle:array[i] ZZcolor:RGB(169, 169, 169) ZZfont:15];
        [self.orderInfoView addSubview:leftLabel];
        ZZLabel*rightLabel = [[ZZLabel alloc]init];
        rightLabel.frame = CGRectMake(10+leftLabel.frame.size.width, 10+(infoHeight-20)/5*i, self.view.frame.size.width-leftLabel.frame.size.width-20, (infoHeight-20)/5);
        rightLabel.textAlignment = NSTextAlignmentRight;
        [rightLabel ZZlabelTitle:rightArray[i] ZZcolor:RGB(52, 52, 52) ZZfont:15];
        [self.orderInfoView addSubview:rightLabel];

    }
    
    UIView*lineView =[[UIView alloc]initWithFrame:CGRectMake(0, infoHeight, self.view.frame.size.width, 1)];
    lineView.backgroundColor = RGB(236, 235, 236);
    [_orderInfoView addSubview:lineView];
    ZZLabel*priceLabel =[[ZZLabel alloc]init];
    priceLabel.frame = CGRectMake(0, infoHeight, self.view.frame.size.width-10, 600*H_PI-infoHeight);
    
    float price = [_payPrice floatValue]/100.0f;
    NSString*priceStr = [NSString stringWithFormat:@"￥%.2f",price];
    [priceLabel ZZlabelTitle:priceStr ZZcolor:RGB(17, 17, 17) ZZfont:40];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [_orderInfoView addSubview:priceLabel];
    
    UIView*bottomView =[[UIView alloc]init];
    bottomView.frame = CGRectMake(0,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+self.orderInfoView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-(self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+self.orderInfoView.frame.size.height));
    bottomView.backgroundColor = RGB(221, 219, 217);
    [self.view addSubview:bottomView];
    
}
- (NSString*)payType:(NSString*)payCode{
    
    if ([payCode isEqualToString:@"1"]) {
        return @"微信支付";
    }else if ([payCode isEqualToString:@"2"]){
        return @"支付宝";
    }else{
        return @"翼支付";
    }
}

#pragma mark 订单信息背景view
- (UIView*)orderInfoView{
    if (!_orderInfoView) {
        _orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, self.view.frame.size.width, 600*H_PI)];
        _orderInfoView.backgroundColor =[UIColor whiteColor];
        _orderInfoView.layer.borderWidth = 1;
        _orderInfoView.layer.borderColor = RGB(236, 235, 236).CGColor;
    }
    return _orderInfoView;
}
- (ZZLabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[ZZLabel alloc]init];
        [_titleLabel ZZlabelTitle:@"中国电信甘肃分公司" ZZcolor:RGB(46,46,46) ZZfont:20];
        _titleLabel.frame = CGRectMake(0, 64+100*H_PI, self.view.frame.size.width, 140*H_PI);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
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
