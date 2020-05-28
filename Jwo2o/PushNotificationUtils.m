//
//  PushNotificationUtils.m
//  Jwo2o
//
//  Created by ZYX on 2019/1/16.
//  Copyright © 2019 WuBangXin. All rights reserved.
//

#import "PushNotificationUtils.h"
#import <UserNotifications/UserNotifications.h>

@interface PushNotificationUtils(){
    UILocalNotification *callNotification;//iOS10以下用这个不用notificationRequest
    API_AVAILABLE(ios(10.0))
    UNNotificationRequest *request;//iOS10以上用这个不用callNotification
}

@end

@implementation PushNotificationUtils

+ (PushNotificationUtils *)sharedUtils {
    static  PushNotificationUtils *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PushNotificationUtils alloc] init];
        }
    });
    return instance;
}

- (void)notifyWithApsInfo:(NSDictionary *)apsInfo {
    NSString *contentStr = apsInfo[@"alert"];
    NSString *soundName = apsInfo[@"sound"];
    if (@available(iOS 10,*)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body =[NSString localizedUserNotificationStringForKey:contentStr arguments:nil];;
//        UNNotificationSound *customSound = [UNNotificationSound soundNamed:soundName];
//        content.sound = customSound;
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:1 repeats:NO];
        request = [UNNotificationRequest requestWithIdentifier:@"Amount_VoIPPush"
                                                       content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];
    }else {
        callNotification = [[UILocalNotification alloc] init];
        callNotification.alertBody = contentStr;
//        callNotification.soundName = soundName;
        [[UIApplication sharedApplication]
         presentLocalNotificationNow:callNotification];
    }
}

- (void)cancelNotify {
    //取消通知栏
    if (@available(iOS 10,*)) {
        NSMutableArray *arraylist = [[NSMutableArray alloc]init];
        [arraylist addObject:@"Amount_VoIPPush"];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:arraylist];
    }else {
        [[UIApplication sharedApplication] cancelLocalNotification:callNotification];
    }
}

@end
