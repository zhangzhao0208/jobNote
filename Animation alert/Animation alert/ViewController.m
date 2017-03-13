//
//  ViewController.m
//  Animation alert
//
//  Created by suorui on 16/10/25.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"
#import "HRCoverView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blueColor];
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    button.backgroundColor =[UIColor redColor];
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor =[UIColor blueColor].CGColor;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)clickButton
{
    HRCoverView *cover = [[HRCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    [self.view addSubview:cover];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
