//
//  TableViewCell.h
//  TableView--test
//
//  Created by kaizuomac2 on 16/8/3.
//  Copyright © 2016年 kaizuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

@protocol ImageDelegate <NSObject>

-(void)checkImage:(NSString*)imgname;

@end

@interface TableViewCell : UITableViewCell

{
    __weak IBOutlet UIImageView *headImg;

    __weak IBOutlet UILabel *username;
 
    __weak IBOutlet UILabel *contentText;
    
    __weak IBOutlet UIView *newImage;
}

@property (weak, nonatomic) id<ImageDelegate>myDelegate;

@property (strong, nonatomic) MyModel *myModel;

@end
