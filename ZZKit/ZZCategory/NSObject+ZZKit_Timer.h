//
//  NSObject+ZZKit_Timer.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTimer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZZKit_Timer)

/**
 *  倒计时状态
 */
- (ZZTimerStatus)zz_countdownStatus;

/**
 *  开始倒计时
 */
- (void)zz_startCountdown;

/**
 *  重启倒计时
 */
- (void)zz_reStartCountdown;

/**
 *  初始化
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  callback：回调
 */
- (void)zz_startCountdown:(NSUInteger)countdown interval:(NSUInteger)interval callback:(nullable ZZTimerBlock)callback;

/**
 *  开始倒计时
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  restart：是否重新开始，或继续接着之前的暂时时点开始
 */
- (void)zz_startCountdown:(NSUInteger)countdown interval:(float)interval restart:(BOOL)restart;

/**
 *  停止倒计时
 */
- (void)zz_stopCountdown;

/**
 *  暂停倒计时
 */
- (void)zz_suspendCountdown;

/**
 *  继续倒计时
 */
- (void)zz_resumeCountdown;

/**
 *  移除倒计时
 */
- (void)zz_removeCountdown;

@end

NS_ASSUME_NONNULL_END
