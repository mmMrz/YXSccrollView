//
//  PushKitHandle.m
//  Jwo2o
//
//  Created by ZYX on 2019/1/11.
//  Copyright © 2019 WuBangXin. All rights reserved.
//

#import "PushKitHandle.h"
#import <PushKit/PushKit.h>
#import "PushNotificationUtils.h"
#import "TTSUtils.h"

@interface PushKitHandle()<PKPushRegistryDelegate>

@property (nonatomic,strong) PushNotificationUtils *pushNotificationUtils;

@end

@implementation PushKitHandle

+ (PushKitHandle *)sharedHandle {
    static  PushKitHandle *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PushKitHandle alloc] init];
        }
    });
    return instance;
}

- (void)initHandle
{
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}

//应用启动此代理方法会返回设备Token 、一般在此将token上传服务器
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    NSString * tokenString = [[[[credentials.token description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"获取PushKit Token:%@",tokenString);
}

//当VoIP推送过来会调用此方法，一般在这里调起本地通知实现连续响铃、接收视频呼叫请求等操作
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    NSLog(@"收到PushKit推送:\n%@",payload.dictionaryPayload);
    _pushNotificationUtils = [PushNotificationUtils sharedUtils];
    [_pushNotificationUtils notifyWithApsInfo:payload.dictionaryPayload[@"aps"]];
    if ([payload.dictionaryPayload[@"type"] isEqualToString:@"speech_txt"]) {
        TTSUtils *ttsUtils = [[TTSUtils alloc] init];
        NSString *speechContent = payload.dictionaryPayload[@"url"];
        speechContent = [speechContent stringByReplacingOccurrencesOfString:@"i生活" withString:@"爱生活"];
        [ttsUtils playVoiceWithText:speechContent];
    }
}




- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    NSLog(@"PushToken无效");
}

@end
