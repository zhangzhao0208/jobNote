//
//  cusViewController.m
//  keybord
//
//  Created by suorui on 16/8/24.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "cusViewController.h"
#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>
@interface cusViewController ()<UITextFieldDelegate>

@end

@implementation cusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 375, 667-64)];
    scroll.contentSize = CGSizeMake(375, 667*1.3);
    [self.view addSubview:scroll];
    scroll.backgroundColor =[UIColor blueColor];
    // [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside =YES;
    
    [IQKeyboardManager sharedManager].toolbarManageBehaviour =IQAutoToolbarByTag;
    IQKeyboardReturnKeyHandler *retuenKeyHandler = [[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    retuenKeyHandler.lastTextFieldReturnKeyType =UIReturnKeyDone;
    
    for (int a=0; a<15; a++) {
        
        
        UITextField *text =[UITextField new];
        text.frame = CGRectMake(20, (40+10)*a+10, 200, 40);
        text.delegate=self;
        text.tag = a+10;
        text .returnKeyType= UIReturnKeyNext;
        text.backgroundColor =[UIColor redColor];
        [scroll addSubview:text];
        
    }

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
