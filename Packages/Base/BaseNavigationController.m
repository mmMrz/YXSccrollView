//
//  BaseNavigationController.m
//  Jwo2o
//
//  Created by JWW on 2018/1/6.
//  Copyright © 2018年 WuBangXin. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()
{
}

@end

@implementation BaseNavigationController

- (instancetype)init
{
    self = [super init];
    self.modalPresentationStyle = 0;
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    self.modalPresentationStyle = 0;
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.modalPresentationStyle = 0;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.modalPresentationStyle = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
 if([gestureRecognizer isEqual:self.interactivePopGestureRecognizer] && self.viewControllers.count==1){
         
         return NO;
     }else{
         
         return YES;
     }
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
