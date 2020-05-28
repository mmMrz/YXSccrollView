//
//  AppSysConfig.h
//  JinwowoNew
//  应用的基本固定配置项
//  Created by jww_mac_002 on 2017/2/21.
//  Copyright © 2017年 wubangxin. All rights reserved.
//




#ifndef AppMacro_h
#define AppMacro_h

#define APPShortVersion [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"0" withString:@"."]

#ifdef DEBUG

#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else

#define NSLog(format, ...)

#endif


// 网络请求成功回调
typedef void(^_Nullable SuccessBlock)(_Nullable id obj);
// 网络请求失败回调
typedef void(^_Nullable FailureBlock)(_Nullable id error);
///开发本地打印打印日志
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define PLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else
#   define DLog(...)
#endif

////上传日志到服务器支持开发本地打印日志和日志等级输出
#define RLog(logContent,logTyps) [EkLog rlogContent:logContent withLogType:logTyps];

//获取屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//获取状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//获取TABBAR高度
#define kTabBarHeight self.tabBarController.tabBar.frame.size.height

///操作系统的判读
#define iOS7LATER ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8LATER ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10LATER ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
#define iOS11LATER ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)

//判断是否是iPhoneX, iPhoneXS, iPhoneXR, iPhoneXS Max
#define KIsiPhoneX ((int)((SCREEN_HEIGHT/SCREEN_WIDTH)*100) == 216)?YES:NO

//通过RGB(或alpha)初始化颜色
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define UIColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:a])

//字体的快捷方法
#define Font(size_s) [UIFont fontWithName:@"PingFangSC-Regular" size:size_s]
#define MediumFont(size_s) [UIFont fontWithName:@"PingFangSC-Medium" size:size_s]
#define SemiboldFont(size_s) [UIFont fontWithName:@"PingFangSC-Semibold" size:size_s]

///本地默认分享图片名称
#define SHARE_ImgName           @"defshare"

// 弱引用
#define EKWeakSelf __weak typeof(self) weakSelf = self;


///开发测试耗时查看
#define DEVE_TIME_CONSUMING_property_time      @property(nonatomic,strong) NSDate *date1;

#define DEVE_TIME_CONSUMING_start   self.date1=[NSDate date];

#define DEVE_TIME_CONSUMING_end      NSTimeInterval time = [self.date1 timeIntervalSinceDate:[NSDate date]]; \
[PromptTools alertShowOneBntTitleText:@"功能耗时测试" withContentText: [NSString stringWithFormat:@"耗时【%f】",time] withLeftBntTitleText:@"确定" leftBlock:^(CKAlertAction *action) {}];


#endif



