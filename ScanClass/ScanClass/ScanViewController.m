//
//  ScanViewController.m
//  ScanClass
//
//  Created by suorui on 16/8/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ScanViewController.h"
#import "Masonry.h"
#import "CustomWebViewController.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define khb_SCANNERWIDTH_RATE 520/750
//扫描框中心Y的偏移量
#define khb_SCANNERCENTER_OFFSET HEIGHT*100/667
#define RED(R,E,D,A) ([UIColor  colorWithRed:R/255.0 green:E/255.0 blue:D/255.0 alpha:A])



@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZBarReaderDelegate>

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden=YES;
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self instanceDevice];
}
- (void)instanceDevice{
    
    
    //        rc = [ZBarReaderViewController new];
    //        rc.supportedOrientationsMask = ZBarOrientationMaskAll;
    //        rc.readerDelegate = self;
    //        [self presentViewController:rc animated:YES completion:nil];
    //获取摄像设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:[devices firstObject] error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //获取扫描范围并设置
    double scannerViewWidth = WIDTH * khb_SCANNERWIDTH_RATE;
    double scannerViewHeight = scannerViewWidth;
    double scannerViewX = (WIDTH - scannerViewWidth)/2;
    double scannerViewY = (HEIGHT- 64 - scannerViewWidth)/2 - khb_SCANNERCENTER_OFFSET;
    output.rectOfInterest = CGRectMake(scannerViewY/HEIGHT,
                                       scannerViewX/WIDTH,
                                       scannerViewHeight/HEIGHT,
                                       scannerViewWidth/WIDTH);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prelayer = layer;
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    [self setOverlayPickerView];
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    //开始捕获
    [self.session startRunning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void  *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}
- (void)setOverlayPickerView {
    
    
    
    //中间扫描框
    UIImageView *scannerView = [[UIImageView alloc] init];
    [self.view addSubview:scannerView];
    self.scannerView = scannerView;
    scannerView.image = [UIImage imageNamed:@"扫描框.png"];
    scannerView.contentMode = UIViewContentModeScaleAspectFit;
    scannerView.backgroundColor = [UIColor clearColor];
    [scannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-khb_SCANNERCENTER_OFFSET);
        make.width.equalTo(@(WIDTH * khb_SCANNERWIDTH_RATE));
        make.height.equalTo(@(WIDTH * khb_SCANNERWIDTH_RATE));
    }];
    
    //左侧遮盖层
    UIImageView *leftView = [[UIImageView alloc] init];
    [self.view addSubview:leftView];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(scannerView.mas_left);
        make.top.bottom.equalTo(self.view);
    }];
    
    //右侧遮盖层
    UIImageView *rightView = [[UIImageView alloc] init];
    [self.view addSubview:rightView];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scannerView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.top.bottom.equalTo(self.view);
    }];
    //顶部遮盖层
    UIImageView* upView = [[UIImageView alloc] init];
    [self.view addSubview:upView];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(rightView.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(scannerView.mas_top);
    }];
    
    //底部遮盖层
    UIImageView * downView = [[UIImageView alloc] init];
    [self.view addSubview:downView];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(rightView.mas_left);
        make.top.equalTo(scannerView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //扫描线
    UIImageView *scannerLine = [[UIImageView alloc] init];
    [self.view addSubview:scannerLine];
    self.scannerLine = scannerLine;
    //    scannerLine.image = [UIImage imageNamed:@"扫描线.png"];
    //    scannerLine.contentMode = UIViewContentModeScaleAspectFill;
    scannerLine.backgroundColor = [UIColor redColor];
    [scannerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(scannerView);
        make.height.offset(1);
    }];
    
    //label
    UILabel *msgLabel = [[UILabel alloc] init];
    [self.view addSubview:msgLabel];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.text = @"将取景框对准二维码,即可自动扫描";
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scannerView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
    }];
    
    
    //相册识别
    UIButton *photoBtn = [[UIButton alloc] init];
    photoBtn.backgroundColor =[UIColor redColor];
    [self.view addSubview:photoBtn];
    //    photoBtn.titleLabel.text = @"相册";
    [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    [photoBtn setTitleColor:RED(188,188,188,1) forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"相册图标"] forState:UIControlStateNormal];
    [photoBtn setTitleColor:RED(188,188,188,1)  forState:UIControlStateHighlighted];
    [photoBtn setImage:[UIImage imageNamed:@"相册图标红"] forState:UIControlStateHighlighted];
    photoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(scannerView.mas_right).offset(-20);
        make.top.equalTo(msgLabel.mas_bottom).offset(30);
        
    }];
    
    //扫码按钮
    UIButton *scanBtn = [[UIButton alloc] init];
    [self.view addSubview:scanBtn];
    [scanBtn setTitle:@"扫码" forState:UIControlStateNormal];
    [scanBtn setTitleColor:RED(188,188,188,1) forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"扫描图标"] forState:UIControlStateNormal];
    
    [scanBtn setTitleColor:RED(188,188,188,1) forState:UIControlStateDisabled];
    [scanBtn setImage:[UIImage imageNamed:@"扫描图标红"] forState:UIControlStateDisabled];
    
    scanBtn.backgroundColor = [UIColor redColor];
    scanBtn.enabled = NO;
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scannerView.mas_left).offset(20);
        make.top.equalTo(msgLabel.mas_bottom).offset(30);
        
    }];
    
    
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self.session stopRunning];
            result = metadataObj.stringValue;
            [self doSomeThing:result];
        } else {
            NSLog(@"不是二维码");
        }
        
    }
}


#pragma mark- ImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
     NSLog(@"==++++=%@",info);
    //获取到图片
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
   _carmeImageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_carmeImageView];
    //获取到内容
    ZBarReaderController* read = [ZBarReaderController new];
    read.readerDelegate = self;
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol* symbol = nil;
    for(symbol in [read scanImage:cgImageRef])
        break; 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.text = symbol.data;
    [self.view addSubview:label];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"%s",__FUNCTION__);
//        NSLog(@"===%@",data);
    [self doSomeThing:symbol.data];
    
}

-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry{
    
    if (retry) {
        //retry == 1 选择图片为非二维码。
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"臣妾找不到啊_(:з)∠)_" delegate:self cancelButtonTitle:nil otherButtonTitles:@"朕知道了", nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    return;
    
}

- (void)doSomeThing:(NSString *)str{
    if ([str hasPrefix:@"tel://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if([str hasPrefix:@"http://"])
    {
        CustomWebViewController *customWeb =[CustomWebViewController new];
        customWeb.url = str;
        [self.navigationController pushViewController:customWeb animated:YES];
        
    }else
    {
        [_carmeImageView removeFromSuperview];
          NSLog(@"不是二维码");
    }
    
    
}
- (void)photoBtnClicked {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.随便给他一个转场动画
        controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:NULL];
        
    }else{
        NSLog(@"设备不支持访问相册，请在设置->隐私->照片中进行设置！");
    }
    
}


- (void)addAnimation {
    //    UIView *line = [self.view viewWithTag:self.line_tag];
    //    line.hidden = NO;
    self.scannerLine.hidden = NO;
    CABasicAnimation *animation = [ScanViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:@(WIDTH * khb_SCANNERWIDTH_RATE - 5) rep:OPEN_MAX];
    //    [line.layer addAnimation:animation forKey:@"LineAnimation"];
    [self.scannerLine.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep {
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}
/**
 *  去除扫码动画
 */
- (void)removeAnimation {
    //    UIView *line = [self.view viewWithTag:self.line_tag];
    //    [line.layer removeAnimationForKey:@"LineAnimation"];
    //    line.hidden = YES;
    [self.scannerLine.layer removeAnimationForKey:@"LineAnimation"];
    self.scannerLine.hidden = YES;
}
/**
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview {
    [self.session stopRunning];
    [self.prelayer removeFromSuperlayer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
