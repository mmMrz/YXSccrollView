//
//  PushNotificationUtils.h
//  Jwo2o
//
//  Created by ZYX on 2019/1/16.
//  Copyright © 2019 WuBangXin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushNotificationUtils : NSObject

+ (PushNotificationUtils *)sharedUtils;
- (void)notifyWithApsInfo:(NSDictionary *)apsInfo;
- (void)cancelNotify;

@end

NS_ASSUME_NONNULL_END
