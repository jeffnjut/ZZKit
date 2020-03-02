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
 *  倒计时状态
 */
- (ZZTimerStatus)zz_countdownStatus {
    
    return [self._zzTimer status];
}

/**
 *  开始倒计时
 */
- (void)zz_startCountdown {
    
    [self._zzTimer zz_start];
}

/**
 *  重启倒计时
 */
- (void)zz_reStartCountdown {
    
    [self._zzTimer zz_reStart];
}

/**
 *  初始化
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  callback：回调
 */
- (void)zz_startCountdown:(NSUInteger)countdown interval:(NSUInteger)interval callback:(nullable ZZTimerBlock)callback {
    
    
    [self zz_removeCountdown];
    
    ZZTimer *_timer = objc_getAssociatedObject(self, "_ZZTimer");
    if (!_timer) {
        _timer = [[ZZTimer alloc] initWithOwner:self countdown:countdown interval:interval callback:callback];
        objc_setAssociatedObject(self, "_ZZTimer", _timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self zz_startCountdown];
}

/**
 *  开始倒计时
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  restart：是否重新开始，或继续接着之前的暂时时点开始
 */
- (void)zz_startCountdown:(NSUInteger)countdown interval:(float)interval restart:(BOOL)restart {
    
    [self._zzTimer zz_start:countdown interval:interval restart:restart];
}

/**
 *  停止倒计时
 */
- (void)zz_stopCountdown {
    
    [self._zzTimer zz_stop];
}

/**
 *  暂停倒计时
 */
- (void)zz_suspendCountdown {
    
    [self._zzTimer zz_suspend];
}

/**
 *  继续倒计时
 */
- (void)zz_resumeCountdown {
    
    [self._zzTimer zz_resume];
}

/**
 *  移除倒计时
 */
- (void)zz_removeCountdown {
    
    if (self._zzTimer) {
        [self._zzTimer zz_remove];
        objc_setAssociatedObject(self, "_ZZTimer", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - Private

- (ZZTimer *)_zzTimer {
    
    ZZTimer *_timer = objc_getAssociatedObject(self, "_ZZTimer");
    return _timer;
}

@end
