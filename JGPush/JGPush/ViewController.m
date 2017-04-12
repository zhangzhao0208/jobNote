//
//  ViewController.m
//  JGPush
//
//  Created by suorui on 17/3/29.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import "ViewController.h"
#import "JPUSHService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSLog(@"当前系统版本号-->%@", systemVersion);
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:nil alias:@"200" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"++++%@",iAlias);
            
        }];

    });
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 100, 100, 40);
    button.backgroundColor =[UIColor redColor];
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor =[UIColor blueColor].CGColor;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self locationNote];
    });
    
}
- (void)clickButton{
//    [JPUSHService setTags:nil alias:@"200" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//        NSLog(@"++++%@",iAlias);
//        
//    }];
    //获取自定义消息
//     NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter postNotificationName:kJPFNetworkDidReceiveMessageNotification object:nil userInfo:@{@"content":@"大家号",@"extras":@{},@"customizeField1":@"ggg"}];
//    
    //本地通知
    [self locationNote];
}
//本地通知
- (void)locationNote{
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    // 2.2.设置通知的内容
    localNote.alertBody = @"在干吗?";
    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
    localNote.alertAction = @"解锁";
    // 2.4.决定alertAction是否生效
    localNote.hasAction = NO;
    // 2.5.设置点击通知的启动图片
    localNote.alertLaunchImage = @"123Abc";
    // 2.6.设置alertTitle
    localNote.alertTitle = @"你有一条新通知";
    // 2.7.设置有通知时的音效
    localNote.soundName = @"buyao.wav";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 999;
    
    // 2.9.设置额外信息
    localNote.userInfo = @{@"type" : @1};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
