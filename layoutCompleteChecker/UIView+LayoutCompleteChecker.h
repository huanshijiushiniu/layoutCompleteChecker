//
//  UIView+LayoutCompleteChecker.h
//  abc
//
//  Created by zhengzhiwen on 2018/1/29.
//  Copyright © 2018年 1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callback)();
@interface UIView (LayoutCompleteChecker)

- (void)startCheckingWithCompletionBlock:(callback)callback;

@end
