//
//  StarView.m
//  星级评论
//
//  Created by 1 on 17/2/20.
//  Copyright © 2017年 com.wh1.guozhentang. All rights reserved.
//

#import "StarView.h"

@implementation StarView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor clearColor];
        [self setNeedsDisplay];
    }

    return self;

}
-(void)setTouchX:(CGFloat)touchX
{
    _touchX=touchX;
    [self setNeedsDisplay];


}
-(void)drawRect:(CGRect)rect
{
    //星星的宽度
     _width = (self.bounds.size.width - 5 * 4) / 5;
    UIImage *image = [UIImage imageNamed:@"evaStar副本.png"];
    for (int i = 0; i < 5; i ++) {
        CGRect rect = CGRectMake(i * (_width + 5), 0, _width, _width);
        [image drawInRect:rect];
    }
    [[UIColor lightGrayColor] setFill];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    

    CGRect newRect = CGRectMake(0, 0, self.touchX, rect.size.height);
    [[UIColor redColor] set];
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);


}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)
event {
    
    CGPoint touchPoint = [touch locationInView:self];
    
    self.touchX =touchPoint.x;
    NSLog(@"+++%f",touchPoint.x);
    [self setNeedsDisplay];
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    self.touchX = touchPoint.x;
    [self setNeedsDisplay];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
