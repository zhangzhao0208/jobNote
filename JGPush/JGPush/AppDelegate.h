//
//  AppDelegate.h
//  JGPush
//clang: error: linker command failed with exit code 1 (use -v to see invocation)



//  Created by suorui on 17/3/29.
//  Copyright © 2017年 suorui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

