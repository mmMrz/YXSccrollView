//
//  QCTableView.h
//  Jwo2o
//
//  Created by 张燕枭 on 2020/5/28.
//  Copyright © 2020 ZhangYanXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCTableView : UITableView

///记录一下坐标，为了等下滑动的时候判断向上还是向下
@property (nonatomic, assign) CGFloat tableY;

@end

NS_ASSUME_NONNULL_END
