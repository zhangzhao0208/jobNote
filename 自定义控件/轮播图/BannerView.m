//
//  PictureRotate.m
//  PictureRotate
//
//  Created by lm on 2017/5/13.
//  Copyright © 2017年 CocaCola. All rights reserved.
//

#import "BannerView.h"

@interface BannerView () < UIScrollViewDelegate >

@property (nonatomic, strong) UIScrollView *scrollView;
// 当前页数
@property (nonatomic, assign) NSInteger currentPage;

// 左中右三个视图
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;// 定时器

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)setupUI {

    
   
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    scrollView.contentSize = CGSizeMake(viewW * 3, 200);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.frame = CGRectMake(viewW * 0, 0, viewW, viewH);
    [scrollView addSubview:leftImageView];
    _leftImageView = leftImageView;
    
    UIImageView *middleImageView = [[UIImageView alloc] init];
    middleImageView.frame = CGRectMake(viewW * 1, 0, viewW, viewH);
    [scrollView addSubview:middleImageView];
    _middleImageView = middleImageView;
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.frame = CGRectMake(viewW * 2, 0, viewW, viewH);
    [scrollView addSubview:rightImageView];
    _rightImageView = rightImageView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, viewH - 20, viewW, 20)];
    pageControl.numberOfPages = _images.count;
    pageControl.currentPage = _currentPage;
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    // 默认显示中间的视图
    _scrollView.contentOffset = CGPointMake(viewW, 0);
    _scrollView.delegate = self;
    
    _currentPage = 0;// 默认是第一张图片
    
    _leftImageView.image = [UIImage imageNamed:_images[_images.count - 1]];
    _middleImageView.image = [UIImage imageNamed:_images[_currentPage]];
    _rightImageView.image = [UIImage imageNamed:_images[_currentPage + 1]];
    
     NSLog(@"---%@",self.subviews);
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 拖拽的时候需要暂停定时器，以免在拖拽过程中出现轮转
    [self resumeTimer];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating:%f",scrollView.contentOffset.x);
    CGPoint contentOffset = scrollView.contentOffset;
    [self changeCurrent:contentOffset];
    // 减速结束的时候开启定时器
    [self addTimerLoop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    NSLog(@"scrollViewDidEndDragging:%f",scrollView.contentOffset.x);
    CGPoint contentOffset = scrollView.contentOffset;
//    NSLog(@"%f", contentOffset.x);
    [self changeCurrent:contentOffset];
    
    // 结束拖拽的时候开启定时器
    [self addTimerLoop];
}

#pragma maark 视图切换
- (void)changeCurrent:(CGPoint)contentOffset {
    
    CGFloat viewW = self.frame.size.width;
    // 停止拖拽的时候还原ScrollView的偏移量
    _scrollView.contentOffset = CGPointMake(viewW, 0);

    // 当拖拽的位置大于视图一半的时候，应该切换图片，否则还是保留原来的图片
    if (contentOffset.x > viewW + viewW / 2) { // 向 <-- 拖拽视图超过一半
        _currentPage++;
        // 如果是最后的图片，让其成为第一个
        if (_currentPage >= _images.count) {
            _currentPage = 0;
        }
        NSLog(@"切换下一张:%ld", _currentPage);
    } else if (contentOffset.x < viewW / 2) {// 向 --> 拖拽视图超过一半
        _currentPage--;
        // 如果是开始的图片，让其成为最后一个
        if (_currentPage < 0) {
            _currentPage = _images.count - 1;
        }
        NSLog(@"切换上一张:%ld", _currentPage);
    } else {
        NSLog(@"不变:%ld", _currentPage);
    }
    [self showImageView:_currentPage];
}

#pragma mark 添加定时器
- (void)addTimerLoop {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changeContentOffset) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark 暂停定时器
- (void)resumeTimer {
    
    // 释放定时器
    [_timer invalidate];
    _timer = nil;
    
}

#pragma mark 私有方法
- (void)changeContentOffset {
    
    _currentPage++;
    // 如果是最后的图片，让其成为第一个
    if (_currentPage >= _images.count) {
        _currentPage = 0;
    }
    [self showImageView:_currentPage];
}

- (void)showImageView:(NSInteger)currentPage {

    NSInteger down = currentPage + 1;
    NSInteger up = currentPage - 1;
    // 如果是最后的图片，让其成为第一个
    if (down >= _images.count) {
        down = 0;
    }
    // 如果是开始的图片，让其成为最后一个
    if (up < 0) {
        up = _images.count - 1;
    }
    _leftImageView.image = [UIImage imageNamed:_images[up]];
    _middleImageView.image = [UIImage imageNamed:_images[currentPage]];
    _rightImageView.image = [UIImage imageNamed:_images[down]];
    
    _pageControl.currentPage = currentPage;
}

#pragma mark setter
- (void)setImages:(NSArray *)images {
    
    _images = images;
    if (_images.count==0) {
        _images = @[@"003.jpg",@"004.jpg",@"005.jpg"];
    }
    [self setupUI];
    
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {

    _timeInterval = timeInterval;
    [self addTimerLoop];
}
@end
