//
//  ZYCustomButton.m
//  ZYTabBarController
//
//  Created by admin on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ZYCustomButton.h"

@implementation ZYCustomButton

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        //只需要设置一次的放置在这里
        self.imageView.contentMode = UIViewContentModeBottom;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [self setTitleColor:[UIColor colorWithRed:255/255.0  green:143/255.0 blue:23/255.0  alpha:1.0] forState:UIControlStateSelected];
        
        [self setTitleColor:[UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:1.0] forState:UIControlStateNormal];
    }

    return self;
}

/**
 *  重写该方法可以去除长按按钮时出现的高亮效果
 */
-(void)setHighlighted:(BOOL)highlighted{

}

/**
 *此处可以调节自定义按钮imageview的位置和大小
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect{

    CGFloat imageW = contentRect.size.width * 0.5;
    CGFloat imageH = contentRect.size.height * 0.5;
    return CGRectMake(15, 5, imageW, imageH);
    
}

/**
 *  此处可以调节自定义按title的位置和大小
 */
-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    CGFloat titleY = contentRect.size.height * TabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height;
    return  CGRectMake(0, titleY+2, titleW, titleH);
    
}

-(void)setTabBarItem:(UITabBarItem *)tabBarItem{

    _tabBarItem = tabBarItem;
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    
}

/**
 *  此处进行中间按钮的位置和大小调节
 */
-(void)layoutSubviews{

    [super layoutSubviews];
    
    if (_hidden == YES) {
        
        self.imageView.frame = CGRectMake(5, -3, 55, 55);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }else{
    
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
}

- (void)hideTitle:(BOOL)states{

    if (states == YES) {
        
        self.titleLabel.hidden = YES;
        _hidden = YES;
        [self layoutSubviews];
        
    }else{
    
        self.titleLabel.hidden = NO;
        _hidden = NO;
        [self layoutSubviews];
        
    }
}

@end
