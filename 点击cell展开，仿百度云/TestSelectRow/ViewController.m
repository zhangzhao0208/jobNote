//
//  ViewController.m
//  TestSelectRow
//
//  Created by Raykle on 12-9-20.
//  Copyright (c) 2012年 Ray. All rights reserved.


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectIndex = nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中之后的cell的高度
    if (indexPath.row == self.selectIndex.row && self.selectIndex != nil){
        return 120;
    }
    else
        return 55;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断cell是否处于选中状态，并且用不同的identifier标记重用;
    //选中的cell改变高度，同时在cell的下方添加背景图片和需要的button;
    if (indexPath.row == self.selectIndex.row &&self.selectIndex!= nil){    //选中状态
        static NSString *identifier_ = @"cell_";
        UITableViewCell *cell_ = [tableView dequeueReusableCellWithIdentifier:identifier_];
        if (cell_ == nil){
            cell_ = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
            label.tag = 10;
            [cell_.contentView addSubview:label];
            [label release];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, 320, 70)];
            image.image = [UIImage imageNamed:@"arrawBg.png"];
            [cell_.contentView addSubview:image];
            [image release];
            
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn1.frame = CGRectMake(20, 75, 80, 30);
            [btn1 setTitle:@"leftBtn" forState:UIControlStateNormal];
            btn1.tag = 11;
            [btn1 addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell_.contentView addSubview:btn1];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn2.frame = CGRectMake(120, 75, 80, 30);
            [btn2 setTitle:@"rightBtn" forState:UIControlStateNormal];
            btn2.tag = 12;
            [btn2 addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell_.contentView addSubview:btn2];
            
            UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn3.frame = CGRectMake(220, 75, 80, 30);
            [btn3 setTitle:@"Cancle" forState:UIControlStateNormal];
            btn3.tag = 13;
            [btn3 addTarget:self action:@selector(cancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell_.contentView addSubview:btn3];
        }
        cell_.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *label = (UILabel*)[cell_.contentView viewWithTag:10];
        label.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
        return cell_;
    }
    else{   //非选中状态
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
            label.tag = 10;
            [cell.contentView addSubview:label];
            [label release];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:10];
        label.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!self.selectIndex){     
        self.selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else{
        BOOL selectTheSameRow = indexPath.row == self.selectIndex.row? YES:NO;
        
        //两次点击不同的cell
        if (!selectTheSameRow){
            //收起上次点击展开的cell;
            NSIndexPath *tempIndexPath = [self.selectIndex copy];
            self.selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            //展开新选择的cell;
            self.selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
            //若点击相同的cell，收起cell
            self.selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
   
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}



-(void)leftButtonClicked:(UIButton*)button{
    
    NSIndexPath *indexPath;
    if ([button.superview.superview isKindOfClass:[UITableViewCell class]]){
        UITableViewCell *cell = (UITableViewCell*)button.superview.superview;
         indexPath= [myTableView indexPathForCell:cell];
    }
    
    NSLog(@"Clicked leftButton of ROW:%d ", indexPath.row);
}

-(void)rightButtonClicked:(UIButton*)button{
    
    NSIndexPath *indexPath;
    if ([button.superview.superview isKindOfClass:[UITableViewCell class]]){
        UITableViewCell *cell = (UITableViewCell*)button.superview.superview;
        indexPath= [myTableView indexPathForCell:cell];
    }
    
    NSLog(@"Clicked rightButton of ROW:%d ", indexPath.row);
}

-(void)cancleButtonClicked:(UIButton*)button{
    NSIndexPath *indexPath;
    if ([button.superview.superview isKindOfClass:[UITableViewCell class]]){
        UITableViewCell *cell = (UITableViewCell*)button.superview.superview;
        indexPath= [myTableView indexPathForCell:cell];
    }
   
    //收起展开的cell
    self.selectIndex = nil;
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
