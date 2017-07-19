//
//  ViewController.m
//  ApplePayTest
//
//  Created by tiger on 16/4/19.
//  Copyright © 2016年 韩山虎. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Type : 类型
//    PKPaymentButtonTypePlain
//    PKPaymentButtonTypeBuy
//    PKPaymentButtonTypeSetUp
    
//    style : 样式
//    PKPaymentButtonStyleWhite
//    PKPaymentButtonStyleWhiteOutline
//    PKPaymentButtonStyleBlack
    
    //以上的样式和类型，大家可以更换下，运行后可以直接查看到效果。在这里就不在解释。
    PKPaymentButton * payButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleWhiteOutline];
    payButton.center = self.view.center;
    [payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    
    

}

-(void)payAction:(PKPaymentButton *)button
{
    //系统提供了API来判断当前设备是否支持Apple Pay支付的功能。
    if([PKPaymentAuthorizationViewController canMakePayments]){
        //设备支持支付
        //PKPayment类来创建支付请求
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        //国家 //HK 香港   CN :  中国大陆
        request.countryCode = @"CN";
        //人民币 // HKD  港币  CNY : 人民币    USD : 美元
        request.currencyCode = @"CNY";// 其他国家以及币种的缩写自行百度
        ///由商家支持的支付网络 所支持的卡类型
        //此属性限制支付卡，可以支付。
        //        PKPaymentNetworkAmex : 美国运通
        //        PKPaymentNetworkChinaUnionPay : 中国银联
        //        PKPaymentNetworkVisa  : Visa卡
        //        PKPaymentNetworkMasterCard : 万事达信用卡

        //        PKPaymentNetworkDiscover
        //        PKPaymentNetworkInterac
        //        PKPaymentNetworkPrivateLabel
        //        PKEncryptionSchemeECC_V2
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkChinaUnionPay, PKPaymentNetworkDiscover, PKPaymentNetworkInterac, PKPaymentNetworkMasterCard, PKPaymentNetworkPrivateLabel, PKPaymentNetworkVisa, PKEncryptionSchemeECC_V2];
        
        //        PKMerchantCapability3DS // 美国的一个卡 必须支持
        //        PKMerchantCapabilityEMV // 欧洲的卡
        //        PKMerchantCapabilityCredit //信用卡
        //        PKMerchantCapabilityDebit //借记卡
        
        //商家的支付处理能力
        //PKMerchantCapabilityEMV : 他的旗下有三大银行 ： 中国银联 Visa卡 万事达信用卡
        //也就是说merchantCapabilities指的支付的银行卡的范围。
        request.merchantCapabilities =   PKMerchantCapabilityDebit | PKMerchantCapabilityCredit | PKMerchantCapabilityEMV;
        
        //merchantIdentifier 要和你在开发者中心生成的id保持一致
        request.merchantIdentifier = @"merchant.com.lanou3g.hanshanhuApplePayTest";
        
        
        //需要的配送信息和账单信息
        request.requiredBillingAddressFields = PKAddressFieldAll;
        request.requiredShippingAddressFields = PKAddressFieldAll;

        //运输方式
        NSDecimalNumber * shippingPrice = [NSDecimalNumber decimalNumberWithString:@"11.0"];
        PKShippingMethod *method = [PKShippingMethod summaryItemWithLabel:@"快递公司" amount:shippingPrice];
        method.detail = @"24小时送到！";
        method.identifier = @"kuaidi";
        request.shippingMethods = @[method];
        request.shippingType = PKShippingTypeServicePickup;
        
        
        // 2.9 存储额外信息
        // 使用applicationData属性来存储一些在你的应用中关于这次支付请求的唯一标识信息，比如一个购物车的标识符。在用户授权支付之后，这个属性的哈希值会出现在这次支付的token中。
        request.applicationData = [@"商品ID:123456" dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //添加物品到支付页
        //创建物品并显示，这个对象描述了一个物品和它的价格，数组最后的对象必须是总价格。
        //使用PKPaymentSummaryItem来创建商品信息
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"蓝鸥iOS培训" amount:[NSDecimalNumber decimalNumberWithString:@"20.0"]];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"蓝鸥H5培训" amount:[NSDecimalNumber decimalNumberWithString:@"10.0"]];
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"蓝鸥H5+iOS培训" amount:[NSDecimalNumber decimalNumberWithString:@"25.0"]];
        
        request.paymentSummaryItems = @[widget1, widget2, total];
        //        request.paymentSummaryItems = @[widget1];
        
        //显示认证视图
        PKPaymentAuthorizationViewController * paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        
        [self presentViewController:paymentPane animated:TRUE completion:nil];
        
        
    }else{
        //设备不支持支付
        NSLog(@"设备不支持支付");
    }
}


#pragma mark -PKPaymentAuthorizationViewControllerDelegate
//这个代理方法指的是支付过程中会进行调用
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    //payment:代表的是一个支付对象， 支付相关的所有信息都在他的身上：1.token.   2.address
     
    //completion : 是一个回调的block  ，block回调的参数，直接影响到界面结果的展示。
    
    /*PKPaymentAuthorizationStatus 交易状态
    
    PKPaymentAuthorizationStatusSuccess, // 成功交易
    PKPaymentAuthorizationStatusFailure // 没有授权交易
    PKPaymentAuthorizationStatusInvalidBillingPostalAddress  // 拒绝账单地址
    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // 拒绝收货地址
    PKPaymentAuthorizationStatusInvalidShippingContact //提供的信息不够
    PKPaymentAuthorizationStatusPINRequired  // 交易需要指纹输入
    PKPaymentAuthorizationStatusPINIncorrect // 输入不正确,重新输入.
    PKPaymentAuthorizationStatusPINLockout// 输入次数超出
    */
    
    PKPaymentToken * token = payment.token;
    NSLog(@"获取token---%@", token);
    //获取订单地址
    NSString * address = payment.billingContact.postalAddress.city;
    NSLog(@"获取到地址： %@", address);
    NSLog(@"验证通过后, 需要开发者继续完成交易");
    // 在这个位置， 我们开发人员需要把token值和商品的其他信息如：地址 id  这些 ， 上传到自己公司的服务器。然后公司的服务器和银行的商家接口进行接口的调用，并将接口调用返回的支付结果信息返回到这里。
    //根据不同的支付结果状态，让block调用不同的交易状态；
    //比如说：服务器调用支付结果是成功的， 就让        completion(PKPaymentAuthorizationStatusSuccess);          如果失败 调用        completion(PKPaymentAuthorizationStatusFailure);
    //如：
    BOOL isSuccess = YES;
    if (isSuccess) {
        completion(PKPaymentAuthorizationStatusSuccess);
    }else
    {
        completion(PKPaymentAuthorizationStatusFailure);
    }
}
// 当授权成功之后或者取消授权之后会调用这个代理方法
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"取消或者交易完成");
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
