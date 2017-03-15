//
//  ViewController.m
//  TaxAssistant
//
//  Created by suorui on 16/10/7.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "ClassViewController.h"
#define kGuidePageCount 3
@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createGuidPage];
}

-(void)createGuidPage
{
    if (!USERD_K(@"showGuide")){
        USERD_VK(@"showGuide", @"showGuide");
        
        [self.view addSubview:[self launchScroll:_launchScroll]];
    }else{

        [self createHomePage];
    }
    
}

-(void)createHomePage
{
    UIWindow*window = [[UIApplication sharedApplication].delegate window];
    UITabBarController*taxAssistantTabBar =[[UITabBarController alloc]init];
    UINavigationController*tabbarNC = [[UINavigationController alloc]initWithRootViewController:taxAssistantTabBar];
    tabbarNC.navigationBar.hidden=YES;
    taxAssistantTabBar.automaticallyAdjustsScrollViewInsets=NO;
    
    FirstViewController*first = [[FirstViewController alloc]init];
    [self setUpAllChildViewController:first title:@"主页"  image:@"ico_sy" seletedImage:@"ico_sy_select"];
    ClassViewController*class = [[ClassViewController alloc]init];
    [self setUpAllChildViewController:class title:@"证书" image:@"ico_certificate" seletedImage:@"ico_certificate_select"];
    if (WIDTH>320) {
        [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeFont:[UIFont systemFontOfSize:12]}            forState:UIControlStateNormal];
    }
    
    taxAssistantTabBar.viewControllers = @[first,class];
    window.rootViewController = tabbarNC;
    
}
- (void)setUpAllChildViewController:(UIViewController*)viewController title:(NSString *)title image:(NSString*)image seletedImage:(NSString *)selectedImage{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image =[UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


-(UIScrollView*)launchScroll:(UIScrollView*)launchScrollView
{
    launchScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    launchScrollView.bounces=NO;
    launchScrollView.contentSize = CGSizeMake(self.view.frame.size.width*kGuidePageCount, self.view.frame.size.height);
    launchScrollView.backgroundColor = [UIColor blackColor];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate=self;
    launchScrollView.backgroundColor = [UIColor clearColor];
    
    for (int i=0; i<kGuidePageCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width,self.view.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome%d",i+1]]];
        [launchScrollView addSubview:imageView];
        
    }
    
    return launchScrollView;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x==self.view.frame.size.width*2) {
        self.view.userInteractionEnabled=YES;
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        _tapGesture.numberOfTapsRequired = 1; //点击次数
        _tapGesture.numberOfTouchesRequired = 1;
        
        [self.view addGestureRecognizer:_tapGesture];
        
    }else
    {
        [self.view removeGestureRecognizer:_tapGesture ];
    }
}

-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    
   
    [self createHomePage];
    [self.view removeGestureRecognizer:_tapGesture ];
    [_launchScroll removeFromSuperview];
    _launchScroll=nil;
    _tapGesture=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
