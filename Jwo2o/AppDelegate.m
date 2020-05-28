//
//  AppDelegate.m
//  Jwo2o
//
//  Created by jww_mac_002 on 2017/11/14.
//  Copyright © 2017年 WuBangXin. All rights reserved.
//

#import "AppDelegate.h"
#import "BeasTabBarController.h"

AppDelegate *AppDelegateInstance = nil;

@interface AppDelegate (){
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [BeasTabBarController new];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    return YES;
}

@end
