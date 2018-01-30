//
//  UIView+LayoutCompleteChecker.m
//  abc
//
//  Created by zhengzhiwen on 2018/1/29.
//  Copyright © 2018年 1. All rights reserved.
//

#import "UIView+LayoutCompleteChecker.h"

#import <objc/runtime.h>

const static float kCheckInterval = .2;
const static float kTolerance = .05;

@implementation UIView (LayoutCompleteChecker)

- (NSString *)viewTreeString
{
    return objc_getAssociatedObject(self, @selector(viewTreeString));
}

- (void)setViewTreeString:(NSString *)treeString
{
    objc_setAssociatedObject(self, @selector(viewTreeString), treeString, OBJC_ASSOCIATION_COPY);
}

- (NSNumber *)hasLayoutCompleted
{
    NSNumber *result = objc_getAssociatedObject(self, @selector(hasLayoutCompleted));
    if (!result) {
        return @(NO);
    } else {
        return result;
    }
}

- (void)setLayoutCompleted:(NSNumber *)result
{
    objc_setAssociatedObject(self, @selector(hasLayoutCompleted), result, OBJC_ASSOCIATION_RETAIN);
}

- (CADisplayLink *)displayLink
{
    CADisplayLink *link = objc_getAssociatedObject(self, @selector(displayLink));
    if (!link) {
        link = [CADisplayLink displayLinkWithTarget:self selector:@selector(p_checkerTick)];
        objc_setAssociatedObject(self, @selector(displayLink), link, OBJC_ASSOCIATION_RETAIN);
    }
    return link;
}

- (void)p_checkerTick
{
    NSString *treeString = self.viewTreeString;
    NSString *currentTreeString = self.currentLayoutString;
    if (![treeString isEqualToString:currentTreeString]) {
        [self setViewTreeString:currentTreeString];
    } else {
        [self setLayoutCompleted:@(YES)];
    }
}

- (NSString *)currentLayoutString
{
    NSMutableString *layoutString = [NSMutableString stringWithFormat:@"%@", self];
    if (self.subviews.count) {
        for (int i = 0; i < self.subviews.count; i++) {
            UIView *subView = self.subviews[i];
            NSString *subViewString = [subView currentLayoutString];
            [layoutString appendString:subViewString];
        }
    }
    return [layoutString copy];
}

- (void)startCheckingWithCompletionBlock:(callback)callback
{
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, kCheckInterval * NSEC_PER_SEC, kTolerance * NSEC_PER_SEC);
    id __weak weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        NSNumber *result = self.hasLayoutCompleted;
        if ([result boolValue]) {
            id __strong strongSelf = weakSelf;
            dispatch_source_cancel(timer);
            [[strongSelf displayLink] invalidate];
            callback();
        }
    });
    dispatch_resume(timer);
}

@end
