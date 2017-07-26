//
//  ZZTableView.m
//  Class
//
//  Created by Helen on 2017/7/24.
//  Copyright © 2017年 Helen. All rights reserved.
//

#import "ZZTableView.h"
#import "MJRefresh.h"
// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"
@implementation ZZTableView



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor =[UIColor whiteColor];
        
        
    }
    
    return self;
}

//下拉刷新
- (void)setIsDownRefresh:(BOOL)isDownRefresh{
    
    _isDownRefresh = isDownRefresh;
    if (_isDownRefresh) {
        
        MJRefreshNormalHeader*header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            
            self.downPullRefresh();
            
        }];
        //        header.lastUpdatedTimeLabel.hidden=YES;
        //        header.stateLabel.hidden=YES;//隐藏时间和状态
        self.mj_header = header;
    }else{
        self.mj_header = nil;

    }
}

//上啦加载
- (void)setIsUpRefresh:(BOOL)isUpRefresh{
    
    
    _isUpRefresh=isUpRefresh;
    if (_isUpRefresh) {
        MJRefreshAutoNormalFooter*foor = [MJRefreshAutoNormalFooter footerWithRefreshingBlock: ^{
            
            self.upPullRefresh();
            
        }];
        foor.automaticallyRefresh=NO;
        self.mj_footer = foor;
    }else{
        self.mj_footer = nil;
    }
}

- (void)setOpenPictureAnimation:(BOOL)openPictureAnimation{
    _openPictureAnimation= openPictureAnimation;
    if (_openPictureAnimation) {
        
        MJChiBaoZiHeader*header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//        header.lastUpdatedTimeLabel.hidden=YES;
//        header.stateLabel.hidden=YES;//隐藏时间和状态
        self.mj_header=header;
    }else{
        self.mj_header=nil;
    }
    
}
- (void)loadNewData{
    
     self.downPullRefresh();
}
//打开刷新功能
- (void)setOpenRefresh:(BOOL)openRefresh{
    
    _openRefresh=openRefresh;
    if (_openRefresh) {
        self.isDownRefresh=YES;
        self.isUpRefresh=YES;
    }
    
}

//结束刷新
-(void)setIsEndRefresh:(BOOL)isEndRefresh{
   
    _isEndRefresh = isEndRefresh;
    if (_isEndRefresh) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    }
  
    
  

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
