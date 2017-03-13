//
//  CustomWebViewController.m
//  ScanClass
//
//  Created by suorui on 16/8/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "CustomWebViewController.h"

@interface CustomWebViewController ()

@end

@implementation CustomWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSLog(@"===%@",_url);
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:webview];
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
