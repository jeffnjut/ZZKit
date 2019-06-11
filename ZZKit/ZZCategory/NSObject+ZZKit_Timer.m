//
//  NSObject+ZZKit_Timer.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSObject+ZZKit_Timer.h"
#import <objc/runtime.h>

@implementation NSObject (ZZKit_Timer)


/**
 *  是否在进行倒计时
 */
- (BOOL)zz_isCountingDown {
    
    return YES;
}

/**
 *  开始倒计时
 */
- (void)zz_start {
    
    [self zz_start:self._zzTimer.countdown interval:self._zzTimer.interval restart:NO];
}

/**
 *  重启倒计时
 */
- (void)zz_reStart {
    
    [self zz_start:self._zzTimer.countdown interval:self._zzTimer.interval restart:YES];
}

/**
 *  初始化
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  callback：回调
 */
- (void)zz_start:(NSUInteger)countdown interval:(NSUInteger)interval callback:(nullable ZZTimerBlock)callback {
    
    ZZTimer *_timer = objc_getAssociatedObject(self, "_ZZTimer");
    if (!_timer) {
        _timer = [[ZZTimer alloc] initWithOwner:self countdown:countdown interval:interval callback:callback];
        objc_setAssociatedObject(self, "_ZZTimer", _timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self zz_start];
}

/**
 *  开始倒计时
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  restart：是否重新开始，或继续接着之前的暂时时点开始
 */
- (void)zz_start:(NSUInteger)countdown interval:(float)interval restart:(BOOL)restart {
    
    [self._zzTimer zz_start:countdown interval:interval restart:restart];
}

/**
 *  停止倒计时
 */
- (void)zz_stop {
    
    [self._zzTimer zz_stop];
}

/**
 *  暂停倒计时
 */
- (void)zz_suspend {
    
    [self._zzTimer zz_suspend];
}

/**
 *  继续倒计时
 */
- (void)zz_resume {
    
    [self._zzTimer zz_resume];
}

/**
 *  移除倒计时
 */
- (void)zz_remove {
    
    [self._zzTimer zz_stop];
    objc_setAssociatedObject(self, "_ZZTimer", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private

- (ZZTimer *)_zzTimer {
    
    ZZTimer *_timer = objc_getAssociatedObject(self, "_ZZTimer");
    return _timer;
}

@end
