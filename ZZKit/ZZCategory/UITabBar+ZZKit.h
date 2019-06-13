//
//  UITabBar+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (ZZKit)

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

@end

NS_ASSUME_NONNULL_END
