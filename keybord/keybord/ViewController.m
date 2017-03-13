//
//  ViewController.m
//  keybord
//
//  Created by suorui on 16/8/24.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"

#import "cusViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController*nav =[[UINavigationController alloc]initWithRootViewController:self];
    UIWindow*window =[[UIApplication sharedApplication].delegate window];
    window.rootViewController = nav;
    
    UIButton*button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor redColor];
    button.frame =CGRectMake(100, 100, 200, 60);
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
       
}

-(void)click
{
    cusViewController *c =[cusViewController new];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
