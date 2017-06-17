//
//  ViewController.m
//  OCTransferJS
//
//  Created by suorui on 16/8/31.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *thisBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    thisBtn.frame = CGRectMake(100, 100, 140, 40);
    
    [thisBtn addTarget:self action:@selector(ocCallJS) forControlEvents:UIControlEventTouchUpInside];
    
    [thisBtn setTitle:@"点击oc调用js" forState:UIControlStateNormal];
    
    [self.view addSubview:thisBtn];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200)];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.delegate = self;
    
    
    
    NSString *webPath = [[NSBundle mainBundle] pathForResource:@"JStoOCfirstIndex" ofType:@"html"];
//    http://219.148.31.135:8182/dcmp/html.html
    NSURL *webURL = [NSURL fileURLWithPath:webPath];
//    NSURL *webURL = [NSURL URLWithString:@"http://219.148.31.135:8182/dcmp/html.html"];
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:webURL];
    
    [self.webView loadRequest:URLRequest];
    
    [self.view addSubview:self.webView];
 
    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    content[@"ag"] = ^() {
        
        NSLog(@"js调用oc---------begin--------");
        
        NSArray *thisArr = [JSContext currentArguments];
        
        for (JSValue *jsValue in thisArr) {
            
            NSLog(@"=======%@",jsValue);
            
        }
        
        //JSValue *this = [JSContext currentThis];
        
        //NSLog(@"this: %@",this);
        
        NSLog(@"js调用oc---------The End-------");
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"show();"];
        
    };
   
}

-(void)ocCallJS

{
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showTitleMessage('%@')",@"哈萨克哈萨克"]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
