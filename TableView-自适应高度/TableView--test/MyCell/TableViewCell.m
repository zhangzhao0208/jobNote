//
//  TableViewCell.m
//  TableView--test
//
//  Created by kaizuomac2 on 16/8/3.
//  Copyright © 2016年 kaizuo. All rights reserved.
//

#import "TableViewCell.h"
#import "Masonry.h"
#import "Header.h"

@interface TableViewCell()

{
    NSString *imgStr;
}

@end

@implementation TableViewCell


-(void)setMyModel:(MyModel *)myModel{

    headImg.image = [UIImage imageNamed:myModel.headImg];
    username.text = myModel.name;
    contentText.text = myModel.trends;
    contentText.numberOfLines = 0;
//    [self imageViewWithImg:myModel.contentImgs];
    imgStr = myModel.contentImgs;
}

-(void)imageViewWithImg:(NSString*)imgName{
    
    NSArray *imgs = [imgName componentsSeparatedByString:@","];
    for (NSInteger i=0;i<imgs.count;i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSpace+imgWidth)*(i%3),(kSpace+imgWidth)*(i/3), imgWidth, imgWidth)];
        imageView.image = [UIImage imageNamed:imgs[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [newImage addSubview:imageView];
    }
}

-(void)tapAction:(UITapGestureRecognizer*)tap{
    
    NSArray *imgs = [imgStr componentsSeparatedByString:@","];
    [self.myDelegate checkImage:imgs[tap.view.tag]];
}

- (IBAction)comment:(id)sender {
    
    NSLog(@"评论----%ld",self.tag);
}

- (IBAction)praise:(id)sender {
    
    NSLog(@"点赞----%ld",self.tag);
}

@end
