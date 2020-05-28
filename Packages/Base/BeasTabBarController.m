//
//  BeasTabBarController.m
//  Jwo2o
//
//  Created by JWW on 2017/11/17.
//  Copyright © 2017年 WuBangXin. All rights reserved.
//

#import "BeasTabBarController.h"
#import "BaseNavigationController.h"
#import "QCProductVC.h"

@interface BeasTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BeasTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance]setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance]setBackgroundColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:235/255.0 alpha:1/1.0]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    self.tabBar.translucent = NO;
    self.tabBar.opaque = YES;
    self.tabBar.barTintColor = UIColorRGB(0xFEFEFE);
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:UIColorRGB(0xEBEDF1)];
    [self.tabBar addSubview:line];
    
    self.delegate = self;
    
    [self addChildVCs];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)addChildVCs {
    [self addChildVC:[[QCProductVC alloc]init]  title:@"产品" imageName:@"general_tab_icon_product"];
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName {
    vc.tabBarItem.title = title;
    NSString *defaultImageName = [NSString stringWithFormat:@"%@_default", imageName];
    NSString *selectImageName = [NSString stringWithFormat:@"%@_click", imageName];
    vc.tabBarItem.image = [[UIImage imageNamed:defaultImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(4, 0.0, -4, 0.0)];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

@end
