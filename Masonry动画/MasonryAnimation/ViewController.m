//
//  ViewController.m
//  MasonryAnimation
//
//  Created by suorui on 16/9/6.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"
#import"Masonry.h"
@interface ViewController ()


{
    UIView *view;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    view =[UIView new];
    view.backgroundColor =[UIColor redColor];
    [self.view addSubview:view ];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.offset(100);
        make.width.offset(100);
        make.height.offset (60);
    }];
    
    UIButton*stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:stopButton];
    stopButton.backgroundColor =[UIColor redColor];
    [stopButton setTitle:@"停止" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopButton.layer.borderColor =[UIColor blueColor].CGColor;
    stopButton.layer.borderWidth = 1;
    [stopButton addTarget:self action:@selector(clickstopButton) forControlEvents:UIControlEventTouchUpInside];
    stopButton.frame = CGRectMake(200, 200, 60, 60);
    
    
}

-(void)clickstopButton
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:1 animations:^{
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.and.left.offset(100);
//            make.width.offset(100);
            make.height.offset (200);
        }];

         [self.view  layoutIfNeeded];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
