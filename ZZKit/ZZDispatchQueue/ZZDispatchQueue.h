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
 *  async = NO, queue = 非主线程的并发队列 或 onMianThread = NO，【同步执行+并发队列】，不会开启新线程，任务在当前线程（可以是主线程也可以是非主线程）上串行执行，此时barrier无效
 *  async = NO, queue = 非主线程的串行队列，【同步执行+串行队列】，不会开启新线程，任务在当前线程（可以是主线程也可以是非主线程）上串行执行，此时barrier无效
 *  async = NO. queue = 主线程，或者 onMianThread = YES，【同步执行+串行队列（主线程）】如果当前线程为主线程，死锁；如果当前线程为非主线程，任务在主线程串行执行
 *  async = YES,queue = 自定义或系统的并发队列，开启一个或多个新线程，任务在各自的线程中交替执行完毕
 *  asymc = YES,queue = 自定义串行队列或主线程，开启一个线程或主线程中，逐个完成任务
 *  barrier,在并发队列中异步执行有格栅效果，其它情况无效
 */
- (dispatch_block_t)dispatchAfter:(NSTimeInterval)seconds queue:(nullable dispatch_queue_t)queue onMainThread:(BOOL)onMainThread async:(BOOL)async barrier:(BOOL)barrier key:(nullable id)key block:(void(^)(void))block;

/**
 *  取消GCD（Key）
 */
- (void)dispatchCancelKey:(id)key;

/**
 *  取消GCD（Block）
 */
- (void)dispatchCancelBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
