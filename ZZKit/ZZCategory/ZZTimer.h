//
//  ZZTimer.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZTimerStatus) {
    ZZTimerStatusRaw,      // 未初始化
    ZZTimerStatusReady,    // 初始化完成
    ZZTimerStatusPaused,   // 暂停
    ZZTimerStatusStarting, // 进行中
    ZZTimerStatusStopped   // 停止
};

typedef void(^ZZTimerBlock) (id _Nonnull owner, NSUInteger days, NSUInteger hours, NSUInteger minutes, NSUInteger seconds, NSUInteger totalSeconds);

NS_ASSUME_NONNULL_BEGIN

@interface ZZTimer : NSObject

/**
 *  倒计时数
 */
- (NSInteger)countdown;

/**
 *  间隔时数
 */
- (float)interval;

/**
 *  倒计时状态
 */
- (ZZTimerStatus)status;

/**
 *  初始化
 *  owner：掌管timer的对象
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  callback：回调
 */
- (id)initWithOwner:(id)owner countdown:(NSUInteger)countdown interval:(NSUInteger)interval callback:(nullable ZZTimerBlock)callback;

/**
 *  设置回调
 */
- (void)zz_setTimerCallback:(nullable ZZTimerBlock)callback;

/**
 *  开始倒计时
 */
- (void)zz_start;

/**
 *  重启倒计时
 */
- (void)zz_reStart;

/**
 *  开始倒计时
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  restart：是否重新开始，或继续接着之前的暂时时点开始
 */
- (void)zz_start:(NSUInteger)countdown interval:(float)interval restart:(BOOL)restart;

/**
 *  停止倒计时
 */
- (void)zz_stop;

/**
 *  停止并删除回调倒计时
 */
- (void)zz_remove;

/**
 *  暂停倒计时
 */
- (void)zz_suspend;

/**
 *  继续倒计时
 */
- (void)zz_resume;

@end

NS_ASSUME_NONNULL_END
