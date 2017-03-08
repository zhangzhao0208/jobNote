//
//  ViewController.m
//  星级评论
//
//  Created by 1 on 17/2/20.
//  Copyright © 2017年 com.wh1.guozhentang. All rights reserved.
//

#import "ViewController.h"
#import "StarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    StarView *star=[[StarView alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    star.touchX=0;
       [self.view addSubview:star];
//     [NSTimer scheduledTimerWithTimeInterval:.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//      star.touchX++;
//        if (star.touchX==100)
//        {
//            [timer invalidate];
//        }
//    }];


    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
