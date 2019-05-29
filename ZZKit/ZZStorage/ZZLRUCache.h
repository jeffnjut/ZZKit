//
//  ZZLRUCache.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZLRUCache : NSObject

// LRUCache的名称
@property (nonatomic, copy) NSString *name;

// LRUCache池里对象总和数（只读）
@property (nonatomic, readonly) NSUInteger totalCount;

// LRUCache池里对象消费总和数（只读）
@property (nonatomic, readonly) NSUInteger totalCost;

// 是否异步释放对象
@property (nonatomic, assign) BOOL safeThread;

// 是否在主线程上释放对象
@property (nonatomic, assign) BOOL releaseOnMainThread;

// 是否异步释放对象
@property (nonatomic, assign) BOOL releaseAsync;

// LRUCache是否开启超出限制后自动删除对象
@property (nonatomic, assign) BOOL shouldEvictObjectExipreLimit;

// LRUCache的总数量限制
@property (nonatomic, assign) NSUInteger countLimit;

// LRUCache的总消费限制
@property (nonatomic, assign) NSUInteger costLimit;

// LRUCache的生存周期限制
@property (nonatomic, assign) NSTimeInterval ageLimit;

// LRUCache自动删除对象的轮训周期
@property (nonatomic, assign) NSTimeInterval autoEvictInterval;

// 收到内存警告后是否删除所有对象
@property (nonatomic, assign) BOOL shouldEvictAllObjectsOnMemoryWarning;

// APP进入后台后是否删除所有对象
@property (nonatomic, assign) BOOL shouldEvictAllObjectsWhenEnteringBackground;

// 收到内存警告后删除所有对象之前的回调
@property (nonatomic, copy) void(^willEvictAllObjectsOnMemoryWarning)(ZZLRUCache *lruCache);

// APP进入后台后删除所有对象之前的回调
@property (nonatomic, copy) void(^willEvictAllObjectsWhenEnteringBackground)(ZZLRUCache *lruCache);

#pragma mark - Access控制

/**
 * LRUCache是否存在给定的Key对应的Value
 */
- (BOOL)containsObjectForKey:(nonnull id)key;

/**
 * LRUCache给定的Key对应的Value
 */
- (nullable id)objectForKey:(nonnull id)key;

/**
 * LRUCache添加给定的Key对应的Value
 */
- (void)setObject:(nullable id)object forKey:(nonnull id)key;

/**
 * LRUCache添加给定的Key对应的Value，消费
 */
- (void)setObject:(nullable id)object forKey:(nonnull id)key withCost:(NSUInteger)cost;

/**
 * LRUCache删除给定的Key和对应的Value
 */
- (void)removeObjectForKey:(nonnull id)key;

/**
 * LRUCaches删除所有Key和Value
 */
- (void)removeAllObjects;

#pragma mark - Evict控制

/**
 * 删除对象直到满足对象总数量小于等于countLimit
 */
- (void)evictToCountLimit:(NSUInteger)countLimit;

/**
 * 删除对象直到满足对象总消费小于等于costLimit
 */
- (void)evictToCostLimit:(NSUInteger)costLimit;

/**
 * 删除对象直到满足所有对象的生存周期未过期ageLimit
 */
- (void)evictToAgeLimit:(NSTimeInterval)ageLimit;

@end

NS_ASSUME_NONNULL_END
