//
//  PushKitHandle.h
//  Jwo2o
//
//  Created by ZYX on 2019/1/11.
//  Copyright © 2019 WuBangXin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushKitHandle : NSObject

+ (PushKitHandle *)sharedHandle;

- (void)initHandle;

@end

NS_ASSUME_NONNULL_END
