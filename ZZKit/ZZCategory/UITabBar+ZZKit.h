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
 *  以圆点显示Badge
 */
- (void)zz_tabBarSetBadgePoint:(NSUInteger)index tabBarItemCount:(NSUInteger)tabBarItemCount badgeSize:(CGSize)badgeSize tabbarBadgeBackgroundColor:(nullable UIColor *)tabbarBadgeBackgroundColor;

/**
 *  以数字显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index value:(NSUInteger)value badgeSize:(CGSize)badgeSize badgeBackgroundColor:(UIColor *)badgeBackgroundColor textColor:(nonnull UIColor *)textColor textFont:(nonnull UIFont *)textFont offset:(UIOffset)offset;

/**
 *  移除Badge
 */
- (void)zz_tabBarRemoveBadge:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
