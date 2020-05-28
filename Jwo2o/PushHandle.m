//
//  PushHandle.m
//  Jwo2o
//
//  Created by ZYX on 2018/1/5.
//  Copyright © 2018年 WuBangXin. All rights reserved.
//

#import "PushHandle.h"
#import "BeasWebViewController.h"
#import "TTSUtils.h"
#import "AppDelegate.h"
#import "OrderViewController.h"

@implementation PushHandle

- (void)handlePushInfo:(NSDictionary *)pushInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSString *url = pushInfo[@"url"];
    if ([pushInfo[@"type"] isEqualToString:@"speech_txt"]) {
        //读语音
        //新老系统都走VoIP读语音
        if (@available(iOS 10.0,*)) {
        }else{
            TTSUtils *ttsUtils = [[TTSUtils alloc] init];
            [ttsUtils playVoiceWithText:[url stringByReplacingOccurrencesOfString:@"i生活" withString:@"爱生活"]];
        }
        if ([PromptTools topViewController].tabBarController.viewControllers.count>1) {
            [[PromptTools topViewController] dismissViewControllerAnimated:YES completion:nil];
            [[PromptTools topViewController].tabBarController setSelectedIndex:1];
            OrderViewController *orderViewController = [(UINavigationController*)[PromptTools topViewController].tabBarController.viewControllers[1] viewControllers][0];
            [orderViewController requsetstarHTMLPage];
        }
    }else if ([pushInfo[@"type"] isEqualToString:@"refresh_order"]) {
        //刷订单
        if ([PromptTools topViewController].tabBarController.viewControllers.count>1) {
            [[PromptTools topViewController] dismissViewControllerAnimated:YES completion:nil];
            [[PromptTools topViewController].tabBarController setSelectedIndex:1];
            OrderViewController *orderViewController = [(UINavigationController*)[PromptTools topViewController].tabBarController.viewControllers[1] viewControllers][0];
            [orderViewController requsetstarHTMLPage];
        }
    }else if ([pushInfo[@"type"] isEqualToString:@"type_shp_web"]) {
        //推网页
        BeasWebViewController *baseWebVC = [[BeasWebViewController alloc] init];
        [baseWebVC setUrlStr:url];
        if ([PromptTools topViewController].navigationController.viewControllers>0) {
            [[PromptTools topViewController].navigationController pushViewController:baseWebVC animated:YES];
        }else{
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:baseWebVC];
            [[PromptTools topViewController].navigationController presentViewController:nav animated:YES completion:nil];
        }
    }else{
        //仅仅打开APP
    }
}

@end
