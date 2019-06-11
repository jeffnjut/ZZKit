//
//  ZZTimer.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTimer.h"

@interface ZZTimer ()
{
    @private
    NSUInteger _countdown;
    NSUInteger _interval;
    NSUInteger _curDays;
    NSUInteger _curHours;
    NSUInteger _curMinutes;
    NSUInteger _curSeconds;
    NSUInteger _curTimeout;
    dispatch_source_t _timer;
    ZZTimerBlock _block;
}

@property (nonatomic, weak) id owner;

@end

@implementation ZZTimer

- (void)dealloc {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

/**
 *  倒计时数
 */
- (NSInteger)countdown {
    
    return _countdown;
}

/**
 *  间隔时数
 */
- (float)interval {
    
    return _interval;
}

/**
 *  初始化
 *  owner：掌管timer的对象
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  callback：回调
 */
- (id)initWithOwner:(id)owner countdown:(NSUInteger)countdown interval:(NSUInteger)interval callback:(nullable ZZTimerBlock)callback {
    
    self = [super init];
    if (self) {
        _owner = owner;
        _countdown = countdown;
        _interval = interval;
        _block = callback;
    }
    return self;
}

/**
 *  设置回调
 */
- (void)zz_setTimerCallback:(nullable ZZTimerBlock)callback {
    
    _block = callback;
}

/**
 *  是否在进行倒计时
 */
- (BOOL)zz_isCountingDown {
    
    return _timer != nil;
}

/**
 *  开始倒计时
 */
- (void)zz_start {
    
    [self zz_start:_countdown interval:_interval restart:NO];
}

/**
 *  重启倒计时
 */
- (void)zz_reStart {
    
    [self zz_start:_countdown interval:_interval restart:YES];
}

/**
 *  开始倒计时
 *  countdown：倒计时时长
 *  interval：间隔时长
 *  restart：是否重新开始，或继续接着之前的暂时时点开始
 */
- (void)zz_start:(NSUInteger)countdown interval:(float)interval restart:(BOOL)restart {
    
    if (restart == YES) {
        if (_timer) {
            dispatch_source_set_event_handler(_timer, NULL);
            _timer = nil;
        }
    }
    if (_timer == nil) {
        __block NSUInteger time = countdown;
        if (time != 0 && interval != 0) {
            __weak typeof(self) weakSelf = self;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            // 每period秒执行一次
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(_timer, ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if(time <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(strongSelf->_timer);
                    strongSelf->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf _setCurrentDays:0 hours:0 minutes:0 seconds:0];
                        strongSelf->_block == nil ? : strongSelf->_block(strongSelf->_owner,0,0,0,0,0);
                    });
                }else{
                    NSUInteger days = time / (3600 * 24);
                    NSUInteger hours = (time - days * 24 * 3600) / 3600;
                    NSUInteger minute = (time - days * 24 * 3600 - hours * 3600) / 60;
                    NSUInteger second = time - days * 24 * 3600 - hours * 3600 - minute * 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (strongSelf != nil) {
                            [strongSelf _setCurrentDays:days hours:hours minutes:minute seconds:second];
                        }
                        strongSelf->_block == nil ? : strongSelf->_block(strongSelf->_owner, days, hours, minute, second, days * 24 * 60 * 60 + hours * 60 * 60 + minute * 60 + second);
                    });
                    time--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

/**
 *  停止倒计时
 */
- (void)zz_stop {
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    self->_countdown = 0;
    self->_interval = 0;
    [self _setCurrentDays:0 hours:0 minutes:0 seconds:0];
    _block == nil ? : _block(_owner,0,0,0,0,0);
}

/**
 *  暂停倒计时
 */
- (void)zz_suspend {
    
    [self zz_start:0 interval:0 restart:YES];
    _block == nil ? : _block(_owner, _curDays, _curHours, _curMinutes, _curSeconds, _curDays * 24 * 60 * 60 + _curHours * 60 * 60 + _curMinutes * 60 + _curSeconds );
}

/**
 *  继续倒计时
 */
- (void)zz_resume {
    
    [self zz_start:_curTimeout interval:_interval restart:YES];
}

#pragma mark - Private

- (void)_setCurrentDays:(NSUInteger)days hours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds {
    
    _curDays = days;
    _curHours = hours;
    _curMinutes = minutes;
    _curSeconds = seconds;
    _curTimeout = (days * days * 24 * 3600) + (hours * 3600) + (minutes * 60) + seconds;
}

@end
