//
//  ViewController.m
//  CoreBluetooh
//
//  Created by suorui on 16/8/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CBCentralManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
     设置主设备的委托,CBCentralManagerDelegate
     必须实现的：
     - (void)centralManagerDidUpdateState:(CBCentralManager *)central;//主设备状态改变的委托，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
     其他选择实现的委托中比较重要的：
     - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设的委托
     - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
     - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
     - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
     */
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    

    
}
 - (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    

switch (central.state) {
    case CBCentralManagerStateUnknown:
        NSLog(@">>>CBCentralManagerStateUnknown");
        break;
    case CBCentralManagerStateResetting:
        NSLog(@">>>CBCentralManagerStateResetting");
        break;
    case CBCentralManagerStateUnsupported:
        NSLog(@">>>CBCentralManagerStateUnsupported");
        break;
    case CBCentralManagerStateUnauthorized:
        NSLog(@">>>CBCentralManagerStateUnauthorized");
        break;
    case CBCentralManagerStatePoweredOff:
        NSLog(@">>>CBCentralManagerStatePoweredOff");
        break;
    case CBCentralManagerStatePoweredOn:
        NSLog(@">>>CBCentralManagerStatePoweredOn");
        //开始扫描周围的外设
        /*
         第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
         - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
         */
        [manager scanForPeripheralsWithServices:nil options:nil];
        
        break;
    default:
        break;
}
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"当扫描到设备:%@",peripheral.name);
    //接下来可以连接设备
    //接下连接我们的测试设备，如果你没有设备，可以下载一个app叫lightbule的app去模拟一个设备
    //这里自己去设置下连接规则，我设置的是P开头的设备
    if ([peripheral.name hasPrefix:@"P"]){
        /*
         一个主设备最多能连7个外设，每个外设最多只能给一个主设备连接,连接成功，失败，断开会进入各自的委托
         - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
         - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
         - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
         */
        
        //找到的设备必须持有它，否则CBCentralManager中也不会保存peripheral，那么CBPeripheralDelegate中的方法也不会被调用！！
        [peripherals addObject:peripheral];
        //连接设备
        [manager connectPeripheral:peripheral options:nil];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
}

//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
