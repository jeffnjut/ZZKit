//
//  ZZDispatchQueue.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZDispatchQueue : NSObject

+ (ZZDispatchQueue *)shared;

/**
 *  延迟GCD
 */
- (dispatch_block_t)dispatchAfter:(NSTimeInterval)seconds queue:(dispatch_queue_t)queue onMainThread:(BOOL)onMainThread key:(void *)key block:(void(^)(void))block;

/**
 *  取消GCD（Key）
 */
- (void)dispatchCancelKey:(void *)key;

/**
 *  取消GCD（Block）
 */
- (void)dispatchCancelBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
