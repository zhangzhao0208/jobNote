//
//  ViewController.m
//  lunbo
//
//  Created by LvPoul on 16/1/20.
//  Copyright © 2016年 LvPoul. All rights reserved.
//

#import "ViewController.h"

#define screenWidth  self.view.bounds.size.width

@interface ViewController ()

@property(nonatomic,strong)UIView *changeview;
@property(nonatomic,strong)NSTimer *changeTimer;
@property(nonatomic,assign)NSInteger  index;
//@property(nonatomic,strong)UILabel *firstLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changeview = [[UIView alloc]initWithFrame:CGRectMake(0, 200, screenWidth, 44)];
    self.changeview.clipsToBounds = YES;
    [self.changeview setBackgroundColor:[UIColor grayColor]];
    
    self.index = 1;
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth,44)];
    [firstLabel setText:@"this is first label"];
    firstLabel.tag = self.index;
    [self.changeview addSubview:firstLabel];
    self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(repeadFuntion) userInfo:self repeats:YES];
    
    [self.view addSubview:self.changeview];
}
-(void)repeadFuntion{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, screenWidth, 44)];
    if (self.index == 1) {
        label.text = @"this is second label";
        label.tag = 2;
    }else{
        label.text = @"this is first label";
        label.tag = 1;
    }
    [self.changeview addSubview:label];
    
    UILabel *labelOnChangeView = [self.changeview viewWithTag:self.index];
    
    [UIView animateWithDuration:1 animations:^{
        labelOnChangeView.frame = CGRectMake(0, -44, screenWidth, 44);
        label.frame = CGRectMake(0, 0, screenWidth, 44);
    } completion:^(BOOL finished){
         [labelOnChangeView removeFromSuperview];
    }];
    if (self.index == 1) {
        self.index = 2;
    }else{
        self.index = 1;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
