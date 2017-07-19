//
//  ZYCustomTabBar.m
//  ZYTabBarController
//
//  Created by admin on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ZYCustomTabBar.h"
#import "ZYCustomButton.h"


//RGB颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//title默认颜色
#define TitleColor   [UIColor grayColor]
//title选中颜色
#define TitleColor_Sel  RGBCOLOR(255, 143, 23)
//title字体大小
#define TitleFontSize 11.0
//TabBar背景色
#define TabBarBackgroundColor [UIColor whiteColor]

//数字角标直径
#define NumMark_W_H 20
//小红点直径
#define PointMark_W_H 12
@interface ZYCustomTabBar ()

@property(nonatomic , strong)UIButton * selectButton;
@property(nonatomic , strong)UIView * tabBarView;
@property(nonatomic , assign)CGFloat customTabbarHeight;
@property(nonatomic , strong)NSArray * titleArray;
@property(nonatomic , strong)NSArray * imageArray;
@property(nonatomic , strong)NSArray * selImageArray;
@property(nonatomic , strong)NSArray * controllerArray;
@property(nonatomic , strong)NSMutableArray * buttonArray;

@end

@implementation ZYCustomTabBar

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(instancetype)init{

    self = [super init];
    if (self) {
        
        [self initData];
        [self initTabbar];
    }
    
    return self;
}

-(NSMutableArray *)buttonArray{

    if (_buttonArray == nil) {
        
        _buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    return _buttonArray;
}

-(instancetype)initWithControllerArray:(NSArray *)controllerArray titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray selImageArray:(NSArray *)selImageArray height:(CGFloat)height{

    self = [super init];
    if (self) {
        
        self.controllerArray = controllerArray;
        self.titleArray = titleArray;
        self.imageArray = imageArray;
        self.selImageArray = selImageArray;
        self.customTabbarHeight = height;
        
        [self initTabbar];
        
    }
    
    return self;
}

/**
 *  若想外部代码更简洁,可调alloc init 初始化tabbar : XHTabBar *tabbar = [[XHTabBar alloc] init];但必须在这里初始化相关数据,如下:
 */
-(void)initData{

    
    
}

-(void)initTabbar{

    /**
     *  创建VC
     */
    [self createControllerByControllerArray:self.controllerArray];
    
    /**
     *  创建tabBarView
     */
    [self creatTabBarView];
    
    /**
     *  设置TabbarLine
     */
    [self setTabBarLine];

}

-(void)createControllerByControllerArray:(NSArray *)controllerArray{

    if (controllerArray.count == 0) {
        
        NSLog(@"控制器数组为nil,请初始化");
    }
    NSMutableArray * tabBarArr = [[NSMutableArray alloc]init];
    for (NSString * className in controllerArray) {
        
        Class class = NSClassFromString(className);
        UIViewController * viewController = [[class alloc]init];
        /**
         此处可以加载自定义的nav
         */
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        
        [tabBarArr addObject:nav];
        
    }
    
    self.viewControllers = tabBarArr;
    
}

-(void)creatTabBarView{

    if (!self.customTabbarHeight || self.customTabbarHeight < 49.0) {
        
        self.customTabbarHeight = 49.0;
    }

    self.tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.0 - self.customTabbarHeight, [[UIScreen mainScreen]bounds].size.width, self.customTabbarHeight)];
    [self.tabBar addSubview:self.tabBarView];
    if (self.selImageArray.count == 0) {
        NSLog(@"选中图片数组为nil,请初始化");
    }
    if (self.imageArray.count == 0) {
        NSLog(@"图片数组为nil,请初始化");
    }
    if (self.titleArray.count == 0) {
        NSLog(@"title数组为nil,请初始化");
    }
    
    int num = (int)self.controllerArray.count;
    for(int i=0;i<num;i++)
    {
        ZYCustomButton *button = [[ZYCustomButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/num*i, 0, [UIScreen mainScreen].bounds.size.width/num,self.customTabbarHeight)];
        button.tag = 100+i;
        
        //常态文字颜色
        [button setTitleColor:TitleColor forState:UIControlStateNormal];
        //选中文字颜色
        [button setTitleColor:TitleColor_Sel forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:TitleFontSize];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.selImageArray[i]] forState:UIControlStateSelected];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self.tabBarView  addSubview:button];
        if (i==0)
        {
            //默认选中
            button.selected=YES;
            self.selectButton = button;
        }
        
        //角标
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width/2.0+6, 3, NumMark_W_H, NumMark_W_H)];
        numLabel.layer.masksToBounds = YES;
        numLabel.layer.cornerRadius = 10;
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.tag = 200+i;
        numLabel.hidden = YES;
        [button addSubview:numLabel];
        
    }
    
}

/**
 *  创建tabbar上面的横线
 */
-(void)setTabBarLine{

    if (self.customTabbarHeight > 49.0) {
        
        [self.tabBar setShadowImage:[[UIImage alloc]init]];
        [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self.tabBarView addSubview:lineLabel];
        
    }
    
}

/**
 *  tabbar上自定义按钮的点击事件
 */
-(void)buttonAction:(UIButton *)selectButton{

    NSInteger index = selectButton.tag - 100;
    [self showControllerIndex:index];
    
    /**
     *  中间按钮的点击变化
     */
    if (index == 2) {
        
        [self hideMarkIndex:2];
        ZYCustomButton * mainbutton = self.buttonArray[2];
        
        [mainbutton setImage:[UIImage imageNamed:@"artPark"] forState:UIControlStateNormal];
        [mainbutton setTitle:@"艺乐园" forState:UIControlStateNormal];
        [mainbutton setTitle:@"" forState:UIControlStateSelected];
        [mainbutton setImage:[[UIImage imageNamed:@"pubDynamic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [mainbutton hideTitle:YES];
        
    }else{
    
        ZYCustomButton * mainbutton = self.buttonArray[2];
        [mainbutton hideTitle:NO];
        
    }
    
}

/**
 *  切换显示控制器
 */
-(void)showControllerIndex:(NSInteger)index{

    if (index >= self.controllerArray.count) {
        
        NSLog(@"index取值超出范围");
    }
    self.selectButton.selected = NO;
    ZYCustomButton * zyButton = (ZYCustomButton *)[self.tabBarView viewWithTag:100+index];
    zyButton.selected = YES;
    self.selectButton = zyButton;
    self.selectedIndex = index;
    
}

/**
 *  数字角标
 *
 *  @param bage  所要显示的数字
 *  @param index 位置
 */
-(void)showBadgeMark:(NSInteger)bage index:(NSInteger)index{

    if (index >= self.controllerArray.count) {
        
        NSLog(@"index取值超出范围");
        return;
    }
    
    UILabel * numLabel = (UILabel *)[self.tabBarView viewWithTag:200+index];
    numLabel.hidden = NO;
    CGRect nFrame = numLabel.frame;
    if (bage <= 0) {
        
        [self hideMarkIndex:index];
        
    }else{
    
        if(bage>0&&bage<=9)
        {
            nFrame.size.width = NumMark_W_H;
        }
        else if (bage>9&&bage<=19)
        {
            nFrame.size.width = NumMark_W_H+5;
        }
        else
        {
            nFrame.size.width = NumMark_W_H+10;
        }
        nFrame.size.height = NumMark_W_H;
        numLabel.frame = nFrame;
        numLabel.layer.cornerRadius = NumMark_W_H/2.0;
        numLabel.text = [NSString stringWithFormat:@"%ld",bage];
        if(bage>99)
        {
            numLabel.text =@"99+";
        }
    }
    
}

/**
 *  小红点
 *
 *  @param index 位置
 */
-(void)showPointMarkIndex:(NSInteger)index
{
    if(index >= self.controllerArray.count)
    {
        NSLog(@"index取值超出范围");
        return;
    }
    UILabel *numLabel = (UILabel *)[self.tabBarView viewWithTag:200+index];
    numLabel.hidden=NO;
    CGRect nFrame = numLabel.frame;
    nFrame.size.height=PointMark_W_H;
    nFrame.size.width = PointMark_W_H;
    numLabel.frame = nFrame;
    numLabel.layer.cornerRadius = PointMark_W_H/2.0;
    numLabel.text = @"";
}

/**
 *  影藏指定位置角标
 *
 *  @param index 位置
 */
-(void)hideMarkIndex:(NSInteger)index
{
    if(index >= self.controllerArray.count)
    {
        NSLog(@"index取值超出范围");
        return;
    }
    
    UILabel *numLabel = (UILabel *)[self.tabBarView viewWithTag:200+index];
    numLabel.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
