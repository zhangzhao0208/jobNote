//
//  ViewController.m
//  ZbarClass
//
//  Created by suorui on 16/8/25.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
           // 1.创建过滤器
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2.恢复默认
        [filter setDefaults];
        // 3.给过滤器添加数据(正则表达式/账号和密码)
        NSString *dataString = @"http://www.520it.com";
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
        // 4.获取输出的二维码
        CIImage *outputImage = [filter outputImage];
        // 5.将CIImage转换成UIImage，并放大显示
    self.imageView = [UIImageView new];
    self.imageView.frame = CGRectMake(50, 50, 200, 200);
        [self.view addSubview:self.imageView];
        self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    UIImageView*centerImageView =[UIImageView new];
    centerImageView.center = self.imageView.center;
    centerImageView.bounds = CGRectMake(0, 0, 50, 50);
    centerImageView.image = [UIImage imageNamed:@"IMG_0312"];
    [self.view addSubview:centerImageView];
    
}
    /**
     * 根据CIImage生成指定大小的UIImage
     *
     * @param image CIImage
     * @param size 图片宽度
     */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
    {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
        // 1.创建bitmap;
        size_t width = CGRectGetWidth(extent) * scale;
        size_t height = CGRectGetHeight(extent) * scale;
        CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        // 2.保存bitmap到图片
        CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
        CGContextRelease(bitmapRef);
        CGImageRelease(bitmapImage);
        return [UIImage imageWithCGImage:scaledImage];
}

    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
