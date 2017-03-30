//
//  ViewController.m
//  SweepPayment
//
//  Created by suorui on 17/3/7.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "ViewController.h"
#import "ZZButton.h"
#import "PaySelectedViewController.h"
#import "ResultViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:self];
    UIWindow*window = [[[UIApplication sharedApplication]delegate]window];
    window.rootViewController = nav;
    ZZButton*button = [[ZZButton alloc] init];
    [button ZZbuttonTitle:@"支付宝" ZZcolor:[UIColor redColor]];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button addTarget];
    [button setZZlineColor:[UIColor blueColor]];
    button.ZZBlock = ^{
//     payMethod   1--支付宝 2--微信  3--翼支付
//       订单号 -金额-授权码-类型
        int x = arc4random() % 10000+10000;
        int y = arc4random() % 10000000+10000000;
        dispatch_async(dispatch_get_main_queue(), ^{
            PaySelectedViewController*paySeletedViewController= [[PaySelectedViewController alloc]init];
            
            paySeletedViewController.goodsNumber = [NSString stringWithFormat:@"%@",@"10008"];
            paySeletedViewController.orderNumber = [NSString stringWithFormat:@"%d",y];
            paySeletedViewController.payPrice = @"1";
            paySeletedViewController.userCode = @"16884";
            paySeletedViewController.payKey = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iR0JLIiBzdGFuZGFsb25lPS";
            paySeletedViewController.goodsName = @"商品名称";
           
         
            [self.navigationController pushViewController:paySeletedViewController animated:YES];
        });
             
           };
    [self.view addSubview:button];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"payResult" object:nil];
    
}
- (void)payResult:(NSNotification*)objc{

    NSLog(@"++++-回调结果");
     ResultViewController*result = [[ResultViewController alloc]init];
    [self.navigationController pushViewController:result animated:YES];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
