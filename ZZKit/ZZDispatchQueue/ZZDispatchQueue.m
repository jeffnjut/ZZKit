//
//  ZZDispatchQueue.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZDispatchQueue.h"
#import <pthread.h>

static ZZDispatchQueue *SINGLETON;

@interface ZZDispatchQueue()
{
    CFMutableDictionaryRef _dict;
    pthread_mutex_t _lock;
}

@end

@implementation ZZDispatchQueue

#pragma mark - Singleton Initialization

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _dict = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

+ (ZZDispatchQueue *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    return SINGLETON;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [ZZDispatchQueue shared];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    return [ZZDispatchQueue shared];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    
    return [ZZDispatchQueue shared];
}

#pragma mark - Public

/**
 *  延迟GCD
 */
- (dispatch_block_t)dispatchAfter:(NSTimeInterval)seconds queue:(nullable dispatch_queue_t)queue onMainThread:(BOOL)onMainThread async:(BOOL)async barrier:(BOOL)barrier key:(nullable id)key block:(void(^)(void))block {
    
    dispatch_block_t _block = dispatch_block_create( barrier ? DISPATCH_BLOCK_BARRIER : DISPATCH_BLOCK_DETACHED, block);
    dispatch_queue_t _queue = NULL;
    if (!queue) {
        _queue = onMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }else {
        _queue = queue;
    }
    if (seconds <= 0) {
        if (async) {
            dispatch_async(_queue, _block);
        }else {
            dispatch_sync(_queue, _block);
        }
    }else {
        if (async) {
            dispatch_sync(queue, ^{
                sleep(seconds);
                _block == nil ? : _block();
            });
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), _queue, _block);
        }
    }
    if (key) {
        pthread_mutex_lock(&_lock);
        CFDictionarySetValue(_dict, (__bridge void const *)key, (__bridge void const *)_block);
        pthread_mutex_unlock(&_lock);
    }
    return _block;
}

/**
 *  取消GCD（Key）
 */
- (void)dispatchCancelKey:(id)key {
    
    dispatch_block_t block = NULL;
    pthread_mutex_lock(&_lock);
    block = CFDictionaryGetValue(_dict, (__bridge void const *)key);
    CFDictionaryRemoveValue(_dict, (__bridge void const *)key);
    pthread_mutex_unlock(&_lock);
    [self dispatchCancelBlock:block];
}

/**
 *  取消GCD（Block）
 */
- (void)dispatchCancelBlock:(dispatch_block_t)block {
    
    if (block != nil) {
        dispatch_block_cancel(block);
    }
}

@end
