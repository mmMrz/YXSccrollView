//
//  TTSConfig.m
//  Jwo2o
//
//  Created by ZYX on 2018/1/31.
//  Copyright © 2018年 WuBangXin. All rights reserved.
//

#import "TTSConfig.h"
#import <Security/Security.h>

#define KEYCHAINSERVICE  @"testService"

@implementation TTSConfig

+ (BOOL)setTTSConfig:(NSString *)config
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ilifemc.nse"];
    [shared setObject:config forKey:@"PLAYTTS"];
    [shared synchronize];
    return YES;
}

+ (NSString*)ttsConfig
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.ilifemc.nse"];
    NSString *config = [shared objectForKey:@"PLAYTTS"];
    return config;
}

@end
