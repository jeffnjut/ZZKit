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

- (instancetype)init
{
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
- (dispatch_block_t)dispatchAfter:(NSTimeInterval)seconds queue:(dispatch_queue_t)queue onMainThread:(BOOL)onMainThread key:(void *)key block:(void(^)(void))block {
    
    dispatch_block_t _block = dispatch_block_create(DISPATCH_BLOCK_BARRIER, block);
    dispatch_queue_t _queue = NULL;
    if (!queue) {
        _queue = onMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }else {
        _queue = queue;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), _queue, _block);
    pthread_mutex_lock(&_lock);
    // CFDictionaryAddValue(_dict, key, (__bridge void *)callback);
    pthread_mutex_unlock(&_lock);
    return _block;
}

/**
 *  取消GCD（Key）
 */
- (void)dispatchCancelKey:(void *)key {
    
    dispatch_block_t block = CFDictionaryGetValue(_dict, key);
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
