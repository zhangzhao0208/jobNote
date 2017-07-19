//
//  ZYCustomTabBar.h
//  ZYTabBarController
//
//  Created by admin on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCustomTabBar : UITabBarController

/**
 *  初始化
 *
 *  @param controllerArray 加载的控制器数组
 *  @param titleArray      tabbar上的标题数组
 *  @param imageArray      tabbar上的正常图片数组
 *  @param selImageArray   tababr上的选中的图片数组
 *  @param height          tabbar的高度(默认49，小于49 也是默认)
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithControllerArray:(NSArray *)controllerArray titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray selImageArray:(NSArray *)selImageArray height:(CGFloat)height;


/*
 影藏此自定义TabBar 调用系统方法
 VC.hidesBottomBarWhenPushed = YES;
 */

/**
 *  设置tababr显示指定控制器
 *
 *  @param index 位置
 */
-(void)showControllerIndex:(NSInteger)index;



/**
 *  数字角标
 *
 *  @param bage  显示的角标数目
 *  @param index 显示的位置
 */
-(void)showBadgeMark:(NSInteger)bage index:(NSInteger)index;


/**
 *  小红点
 *
 *  @param index 显示的位置下标
 */
-(void)showPointMarkIndex:(NSInteger)index;

/**
 *  隐藏指定位置的角标
 *
 *  @param index 隐藏的位置
 */

-(void)hideMarkIndex:(NSInteger)index;

@end
