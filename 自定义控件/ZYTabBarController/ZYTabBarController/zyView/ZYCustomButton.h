//
//  ZYCustomButton.h
//  ZYTabBarController
//
//  Created by admin on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

//image ratio
#define TabBarButtonImageRatio 0.3

@interface ZYCustomButton : UIButton

@property(nonatomic, strong)UITabBarItem * tabBarItem;

@property(nonatomic, assign)BOOL hidden;

-(void)hideTitle:(BOOL)states;

@end
