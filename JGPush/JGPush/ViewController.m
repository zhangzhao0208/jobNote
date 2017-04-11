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

    
}
- (void)clickButton{
//    [JPUSHService setTags:nil alias:@"200" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//        NSLog(@"++++%@",iAlias);
//        
//    }];
     NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:kJPFNetworkDidReceiveMessageNotification object:nil userInfo:@{@"content":@"大家号",@"extras":@{},@"customizeField1":@"ggg"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
