//
//  NSObject+ZZKit_Notification.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZZKit_Notification)

#pragma mark - KVO监听

/**
 *  添加KVO监听
 */
- (void)zz_addObserverBlockForKeyPath:(nonnull NSString *)keyPath block:(nullable void(^)(id object, id oldValue, id newValue))block;

/**
 *  移除KVO监听
 */
- (void)zz_removeObserverBlockForKeyPath:(nonnull NSString *)keyPath;

/**
 *  移除全部KVO监听
 */
- (void)zz_removeAllObserverBlocks;

#pragma mark - Notification监听

/**
 *  添加通知
 */
- (void)zz_addNotificationBlockForName:(nonnull NSString *)name block:(nullable void(^)(NSNotification *notification))block;

/**
 *  移除通知
 */
- (void)zz_removeNotificationBlockForName:(nonnull NSString *)name;

/**
 *  移除全部通知
 */
- (void)zz_removeAllNotificationBlocks;

/**
 *  发送通知
 */
- (void)zz_postNotificationWithName:(nonnull NSString *)name;

/**
 *  发送通知
 */
- (void)zz_postNotificationWithName:(nonnull NSString *)name userInfo:(nonnull NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
