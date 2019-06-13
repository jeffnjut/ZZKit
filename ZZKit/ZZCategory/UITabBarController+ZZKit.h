//
//  UITabBarController+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (ZZKit)

#pragma mark - Tabbar消息数、红点

/**
 *  以系统默认的方式设置消息数
 */
- (void)zz_setSystemBadge:(NSUInteger)index value:(NSUInteger)value color:(nullable UIColor *)color;

/**
 *  以圆点显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index pointColor:(nullable UIColor *)pointColor badgeSize:(CGSize)badgeSize offset:(UIOffset)offset;

/**
 *  以数字显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index value:(NSUInteger)value badgeSize:(CGSize)badgeSize badgeBackgroundColor:(UIColor *)badgeBackgroundColor textColor:(nonnull UIColor *)textColor textFont:(nonnull UIFont *)textFont offset:(UIOffset)offset;

/**
 *  移除Badge
 */
- (void)zz_removeBadge:(NSUInteger)index;

#pragma mark - Tabbar隐藏

/**
 *  获取 tabbar hidden
 */
- (BOOL)zz_tabBarHidden;

/**
 *  设置隐藏TabBar(hidden)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden;

/**
 *  设置隐藏TabBar(hidden,animated)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 *  设置隐藏TabBar(hidden,animated,completion)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/**
 *  设置隐藏TabBar(hidden,animated,delaysContentResizing,completion)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
