//
//  RootViewController.m
//  TableView--test
//
//  Created by kaizuomac2 on 16/8/2.
//  Copyright © 2016年 kaizuo. All rights reserved.
//

#import "RootViewController.h"
#import "MyModel.h"
#import "TableViewCell.h"
#import "Header.h"

@interface RootViewController ()<ImageDelegate>

@property (strong, nonatomic) TableViewCell *cell;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"cell高度动态计算";
    [self addDataSource];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
}

-(NSMutableArray *)dataArray{

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark 添加数据源
-(void)addDataSource{

    NSArray *imgArray = @[@"headImg,headImg,headImg,headImg",@"headImg,headImg,headImg,headImg,headImg,headImg",@"headImg",@"headImg,headImg",@"headImg,headImg,headImg,headImg,headImg",@"headImg,headImg,headImg,headImg",@"headImg,headImg,headImg,headImg,headImg,headImg,headImg,headImg,headImg,headImg,headImg,headImg",@"headImg,headImg,headImg"];
    NSArray *content = @[@"十四年之后再重看《东邪西毒》（编注：写于2008年），不只我看懂了，其他人也看懂了。不知道是不是王家卫的思想领先了我们整整十四年？",@"十四年前在威尼斯影展，我第一次看《东邪西毒》没看懂。心想：“为什么每个人说话都没有眼神接触？好像个个都对着空气讲话。到底谁爱谁？到底谁跟谁好？这么多人物，谁是谁都搞不清楚，怎么会好看？”看完电影我失望地吐出三个字：“不好看！”",@"十四年后，经过重新配乐（马友友演奏）和调色，音乐美，颜色浓。每个画面就像是一张完美鲜艳的油画。加上人生阅历多了，对人、对事、对感情的看法也不像从前那么简单，我终于看出了苗头。那年在榆林，每天将近黄昏时刻，所有演员都得把妆化好，在山洞口等天黑。吃完便当，天一黑就得进山洞。就那么一点大的空间，又打灯，又放烟，再加上工作人员抽烟，空气坏得使人几乎窒息。",@"有一天晚上，在拍戏空档，我坐在洞口躺椅上休息，他走过来告诉我他后脑勺给蝎子螫了。大家傻了眼，蝎子是有毒的，这可怎么了得？",@"收了工回酒店，见他坐在大厅椅子上低着头，旁边两个黑黑瘦瘦的当地人，拿着一瓶满是蝎子泡的水让他搽，说是比看医生管用。国荣已被吓得六神无主，只有一试。那晚，他一直没敢合眼。第二天就没事了，也不知道是不是以毒攻毒的效果。",@"第一天到片场，混在所有大牌演员（梁朝伟、张国荣、张学友、梁家辉、张曼玉、刘嘉玲、杨采妮）之间，简直不知道自己该怎么演才好。记得那天是十一月三日，正好是我的生日，公司准备了一个大蛋糕，让所有演员围着蛋糕唱生日快乐歌，可是我一点都快乐不起来。后来听刘嘉玲说，那天我还哭了呢。真丢脸，这点小事……",@"结果《东邪西毒》里的我，还真的不像东方不败。那是一种……一种带点神秘感的男人味。",@"二十多年拍了一百部戏，巧的是第一部《窗外》和第一百部《东邪西毒》的版权都在王家卫的手上。”"];
    for (NSInteger i=0; i<content.count; i++) {
        MyModel *model = [[MyModel alloc]init];
        model.name = @"景甜";
        model.headImg = @"headImg";
        model.trends = content[i];
        model.contentImgs = imgArray[i];
        [self.dataArray addObject:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCellID"];
    NSInteger width = kWidth - 75;
    MyModel *model = self.dataArray[indexPath.row];
    NSString *contentText = model.trends;
    NSInteger H = 55;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize size = [contentText boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    NSInteger imgcount = [model.contentImgs componentsSeparatedByString:@","].count;
    CGFloat imgH = (kSpace+imgWidth)*(imgcount/4+1);
    [cell setNeedsUpdateConstraints];
    [cell updateConstraints];
    return H + size.height+ imgH ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellID = @"myCellID";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyModel *model = self.dataArray[indexPath.row];
    cell.myModel = model;
    self.cell  =cell;
    cell.myDelegate = self;
    return cell;
}

-(void)checkImage:(NSString *)imgname{

    self.navigationController.navigationBar.alpha = 0;
    self.tableView.scrollEnabled = NO;
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImage.image = [UIImage imageNamed:imgname];
    bgImage.contentMode = UIViewContentModeScaleToFill;
    bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [bgImage addGestureRecognizer:tap];
    [self.view addSubview:bgImage];
}

-(void)tapClick:(UITapGestureRecognizer*)tap{

    self.navigationController.navigationBar.alpha = 1;
    self.tableView.scrollEnabled = YES;
    [tap.view removeFromSuperview];
}

@end
