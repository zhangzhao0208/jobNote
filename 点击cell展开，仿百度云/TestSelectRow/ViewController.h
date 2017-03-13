//
//  ViewController.h
//  TestSelectRow
//
//  Created by Raykle on 12-9-20.
//  Copyright (c) 2012年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(retain, nonatomic) NSIndexPath *selectIndex;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;

@end
