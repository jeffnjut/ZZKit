//
//  ZZLRUCache.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLRUCache.h"
#import <pthread.h>
#import <limits.h>
#import <float.h>
#import <UIKit/UIApplication.h>
#import "ZZLinkedMap.h"

@interface ZZLRUCache()
{
    ZZLinkedMap *_lruLinkedMap;
    pthread_mutex_t _lock;
    dispatch_queue_t _queue;
}

@end

@implementation ZZLRUCache

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        
        pthread_mutex_init(&_lock, NULL);
        _lruLinkedMap = [[ZZLinkedMap alloc] init];
        _queue = dispatch_queue_create("zzlrucache.zzstorage", DISPATCH_QUEUE_SERIAL);
        
        // 默认线程安全
        _safeThread = YES;
        
        // 默认是无限制的
        _shouldEvictObjectExipreLimit = YES;
        _countLimit = NSUIntegerMax;
        _costLimit = NSUIntegerMax;
        _ageLimit = DBL_MAX;
        _autoEvictInterval = 10.0;
        
        // 默认
        _shouldEvictAllObjectsOnMemoryWarning = YES;
        _shouldEvictAllObjectsWhenEnteringBackground = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didEndterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [self _evictRecursively];
    }
    return self;
}

- (void)dealloc {
    
    if (_safeThread) pthread_mutex_destroy(&_lock);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Private
- (void)_didReceiveMemoryWarning {
    
    self.willEvictAllObjectsOnMemoryWarning == nil ? : self.willEvictAllObjectsOnMemoryWarning(self);
    
    if (_shouldEvictAllObjectsOnMemoryWarning) {
        [self evictAllObjects];
    }
}

- (void)_didEndterBackground {
    
    self.willEvictAllObjectsWhenEnteringBackground == nil ? : self.willEvictAllObjectsWhenEnteringBackground(self);
    
    if (_shouldEvictAllObjectsWhenEnteringBackground) {
        [self evictAllObjects];
    }
}

- (void)_evictRecursively {
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoEvictInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _evictBackground:YES];
        [strongSelf _evictRecursively];
    });
}

- (void)_evictBackground:(BOOL)lock {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        [weakSelf _evictToCostLimit:weakSelf.countLimit lock:lock];
        [weakSelf _evictToCostLimit:weakSelf.costLimit lock:lock];
        [weakSelf _evictToAgeLimit:weakSelf.ageLimit lock:lock];
    });
}

- (void)_evictExpire:(int)type countLimit:(NSUInteger)countLimit costLimit:(NSUInteger)costLimit ageLimit:(NSTimeInterval)ageLimit lock:(BOOL)lock {
    
    NSTimeInterval now = CACurrentMediaTime();
    if (_safeThread && lock) pthread_mutex_lock(&_lock);
    if (type == 0) {
        if (countLimit == 0) {
            [self evictAllObjects];
            return;
        }else if(_lruLinkedMap->_count <= countLimit) {
            return;
        }
    }else if (type == 1) {
        if (costLimit == 0) {
            [self evictAllObjects];
            return;
        }else if(_lruLinkedMap->_cost <= costLimit) {
            return;
        }
    }else if (type == 2) {
        if (ageLimit == 0) {
            [self evictAllObjects];
            return;
        }else if (_lruLinkedMap->_tail && now - _lruLinkedMap->_tail->_time > ageLimit) {
            return;
        }
    }else {
        return;
    }
    if (_safeThread && lock) pthread_mutex_unlock(&_lock);
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    while (YES) {
        if (_safeThread && lock && pthread_mutex_trylock(&_lock) == 0) {
            
            if (type == 0) {
                if (_lruLinkedMap->_count > countLimit) {
                    ZZLinkedMapNode *node = [_lruLinkedMap removeTail];
                    if (node) {
                        [tempArray addObject:node];
                    }else {
                        break;
                    }
                }else {
                    break;
                }
            }else if (type == 1) {
                if (_lruLinkedMap->_cost > costLimit) {
                    ZZLinkedMapNode *node = [_lruLinkedMap removeTail];
                    if (node) {
                        [tempArray addObject:node];
                    }else {
                        break;
                    }
                }else {
                    break;
                }
            }else if (type == 2) {
                if (_lruLinkedMap->_tail && (now - _lruLinkedMap->_tail->_time) > ageLimit) {
                    ZZLinkedMapNode *node = [_lruLinkedMap removeTail];
                    if (node) {
                        [tempArray addObject:node];
                    }else {
                        break;
                    }
                }
            }
            if (_safeThread && lock) pthread_mutex_unlock(&_lock);
        }else {
            usleep(10 * 1000);
        }
    }
    
    if (tempArray.count > 0) {
        dispatch_queue_t queue = _lruLinkedMap->_releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_async(queue, ^{
            [tempArray count];
        });
    }
}

#pragma mark - 设置属性
- (NSUInteger)totalCount {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    NSUInteger count = _lruLinkedMap->_count;
    if (_safeThread) pthread_mutex_unlock(&_lock);
    return count;
}

- (NSUInteger)totalCost {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    NSUInteger cost = _lruLinkedMap->_cost;
    if (_safeThread) pthread_mutex_unlock(&_lock);
    return cost;
}

- (void)setReleaseOnMainThread:(BOOL)releaseOnMainThread {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    _lruLinkedMap->_releaseOnMainThread = releaseOnMainThread;
    if (_safeThread) pthread_mutex_unlock(&_lock);
}

- (BOOL)releaseOnMainThread {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    BOOL ret = _lruLinkedMap->_releaseOnMainThread;
    if (_safeThread) pthread_mutex_unlock(&_lock);
    return ret;
}

- (void)setReleaseAsync:(BOOL)releaseAsync {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    _lruLinkedMap->_releaseAsync = releaseAsync;
    if (_safeThread) pthread_mutex_unlock(&_lock);
}

- (BOOL)releaseAsync {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    BOOL ret = _lruLinkedMap->_releaseAsync;
    if (_safeThread) pthread_mutex_unlock(&_lock);
    return ret;
}

#pragma mark - Access控制

/**
 * LRUCache是否存在给定的Key对应的Value
 */
- (BOOL)containsObjectForKey:(nonnull id)key {
    
    if (key) {
        if (_safeThread) pthread_mutex_lock(&_lock);
        BOOL contain = [_lruLinkedMap containKey:key];
        if (_safeThread) pthread_mutex_unlock(&_lock);
        return contain;
    }
    return NO;
}

/**
 * LRUCache给定的Key对应的Value
 */
- (nullable id)objectForKey:(nonnull id)key {
    
    if (key) {
        if (_safeThread) pthread_mutex_lock(&_lock);
        ZZLinkedMapNode *node = [_lruLinkedMap objectForKey:key];
        if (node) {
            node->_time = CACurrentMediaTime();
            [_lruLinkedMap bringHead:node];
        }
        if (_safeThread) pthread_mutex_unlock(&_lock);
    }
    return nil;
}

/**
 * LRUCache添加给定的Key对应的Value
 */
- (void)setObject:(nullable id)object forKey:(nonnull id)key {
    
    [self setObject:object forKey:key withCost:0];
}

/**
 * LRUCache添加给定的Key对应的Value，消费
 */
- (void)setObject:(nullable id)object forKey:(nonnull id)key withCost:(NSUInteger)cost {
    
    if (key) {
        if (object == nil) {
            [self removeObjectForKey:key];
        }else {
            if (_safeThread) pthread_mutex_lock(&_lock);
            ZZLinkedMapNode *node = [_lruLinkedMap objectForKey:key];
            if (node) {
                _lruLinkedMap->_cost -= node->_cost;
                _lruLinkedMap->_cost += cost;
                node->_value = object;
                node->_time = CACurrentMediaTime();
                node->_cost = cost;
                [_lruLinkedMap bringHead:node];
            }else {
                node = [[ZZLinkedMapNode alloc] init];
                node->_key = key;
                node->_value = object;
                node->_time = CACurrentMediaTime();
                node->_cost = cost;
                [_lruLinkedMap insertHead:node];
            }
            if (_lruLinkedMap->_count > _countLimit) {
                __weak typeof(self) weakSelf = self;
                dispatch_async(_queue, ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    [self _evictToCountLimit:self->_countLimit lock:YES];
                });
            }
            if (_lruLinkedMap->_cost > _costLimit) {
//                __weak typeof(self) weakSelf = self;
//                dispatch_async(_queue, ^{
//                    __strong typeof(weakSelf) self = weakSelf;
//                    [self _evictToCostLimit:self->_costLimit lock:NO];
//                });
            }
            if (_safeThread) pthread_mutex_unlock(&_lock);
        }
    }
}

/**
 * LRUCache删除给定的Key和对应的Value
 */
- (void)removeObjectForKey:(nonnull id)key {
    
    if (key) {
        if (_safeThread) pthread_mutex_lock(&_lock);
        ZZLinkedMapNode *node = [_lruLinkedMap objectForKey:key];
        if (node) {
            [_lruLinkedMap removeNode:node];
            if (_lruLinkedMap->_releaseAsync) {
                dispatch_queue_t queue = _lruLinkedMap->_releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
                dispatch_async(queue, ^{
                    [node class];
                });
            }else if (_lruLinkedMap->_releaseOnMainThread && pthread_main_np() == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [node class];
                });
            }
        }
        if (_safeThread) pthread_mutex_unlock(&_lock);
    }
}

/**
 * LRUCaches删除所有Key和Value
 */
- (void)removeAllObjects {
    if (_safeThread) pthread_mutex_lock(&_lock);
    [_lruLinkedMap removeAll];
    if (_safeThread) pthread_mutex_unlock(&_lock);
}

#pragma mark - Evict控制

/**
 * 删除对象直到满足对象总数量小于等于countLimit
 */
- (void)evictToCountLimit:(NSUInteger)countLimit {
    
    [self _evictToCountLimit:countLimit lock:YES];
}

/**
 * 删除对象直到满足对象总消费小于等于costLimit
 */
- (void)evictToCostLimit:(NSUInteger)costLimit {
    
    [self _evictToCostLimit:costLimit lock:YES];
}

/**
 * 删除对象直到满足所有对象的生存周期未过期ageLimit
 */
- (void)evictToAgeLimit:(NSTimeInterval)ageLimit {
    
    [self _evictToAgeLimit:ageLimit lock:YES];
}

/**
 * 删除对象直到满足对象总数量小于等于countLimit
 */
- (void)_evictToCountLimit:(NSUInteger)countLimit lock:(BOOL)lock {
    
    [self _evictExpire:0 countLimit:countLimit costLimit:0 ageLimit:0 lock:lock];
}


/**
 * 删除对象直到满足对象总消费小于等于costLimit
 */
- (void)_evictToCostLimit:(NSUInteger)costLimit lock:(BOOL)lock {
    
    [self _evictExpire:1 countLimit:0 costLimit:costLimit ageLimit:0 lock:lock];
}

/**
 * 删除对象直到满足所有对象的生存周期未过期ageLimit
 */
- (void)_evictToAgeLimit:(NSTimeInterval)ageLimit lock:(BOOL)lock {
    
    [self _evictExpire:2 countLimit:0 costLimit:0 ageLimit:ageLimit lock:lock];
}

/**
 * 删除所有对象
 */
- (void)evictAllObjects {
    
    if (_safeThread) pthread_mutex_lock(&_lock);
    [_lruLinkedMap removeAll];
    if (_safeThread) pthread_mutex_unlock(&_lock);
}

@end
