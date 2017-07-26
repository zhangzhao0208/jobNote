//
//  ZZTableView.h
//  Class
//
//  Created by Helen on 2017/7/24.
//  Copyright © 2017年 Helen. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 导入三个文件夹 */
@interface ZZTableView : UITableView
@property (nonatomic,copy) void (^downPullRefresh)();
@property (nonatomic,copy) void (^upPullRefresh)();
// 是否刷新完毕
@property (nonatomic,assign) BOOL isEndRefresh;
@property(nonatomic,assign)BOOL isUpRefresh;//是否上啦加载
@property(nonatomic,assign)BOOL isDownRefresh;//是否下啦刷新
@property(nonatomic,assign)BOOL openRefresh;//打开刷新
@property(nonatomic,assign)BOOL openPictureAnimation;//动画刷新..必须添加图片,否则崩溃.MJChiBaoZiHeader.h类里修改图片.
// 首次进入页面时的加载图
//-(void)loadingImgView;
@end
