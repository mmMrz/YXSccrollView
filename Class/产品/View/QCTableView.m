//
//  QCTableView.m
//  Jwo2o
//
//  Created by 张燕枭 on 2020/5/28.
//  Copyright © 2020 ZhangYanXiao. All rights reserved.
//

#import "QCTableView.h"

@interface QCTableView()


@end

@implementation QCTableView

// 返回YES表示可以继续传递触摸事件，这样便可实现了两个嵌套的scrollView同时滚动。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
