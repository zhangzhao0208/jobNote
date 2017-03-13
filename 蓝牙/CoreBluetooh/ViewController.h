//
//  ViewController.h
//  CoreBluetooh
//
//  Created by suorui on 16/8/26.
//  Copyright © 2016年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController : UIViewController
{
    //系统蓝牙设备管理对象，可以把他理解为主设备，通过他，可以去扫描和链接外设
    CBCentralManager *manager;
    //用于保存被发现设备
    NSMutableArray *peripherals;
}

@end

