//
//  UITabBar+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UITabBar+ZZKit.h"
#import "UIView+ZZKit.h"

#define _BASETAG (888)

@implementation UITabBar (ZZKit)

/**
 *  以系统默认的方式设置消息数
 */
- (void)zz_setSystemBadge:(NSUInteger)index value:(NSUInteger)value color:(nullable UIColor *)color {
    
    UITabBarController *tabbarController = (UITabBarController *)[[self superview] nextResponder];
    if (![tabbarController isKindOfClass:[UITabBarController class]] || tabbarController.childViewControllers.count == 0 || index < 0 || index >= tabbarController.childViewControllers.count ) {
        return;
    }
    UIViewController *controller = [tabbarController.childViewControllers objectAtIndex:index];
    controller.tabBarItem.badgeValue = [self _tabbarTransforBadgeNumber:value];
    if (color) {
        if (@available(iOS 10.0, *)) {
            controller.tabBarItem.badgeColor = color;
        } else {
        }
    }
}

/**
 *  以圆点显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index pointColor:(nullable UIColor *)pointColor badgeSize:(CGSize)badgeSize offset:(UIOffset)offset {
    
    UITabBarController *tabbarController = (UITabBarController *)[[self superview] nextResponder];
    if (![tabbarController isKindOfClass:[UITabBarController class]] || tabbarController.childViewControllers.count == 0 || index < 0 || index >= tabbarController.childViewControllers.count ) {
        return;
    }
    
    //移除之前的Badge
    [self zz_removeBadge:index];
    //新建小红点
    UIView *badgeView         = [[UIView alloc] init];
    badgeView.tag             = _BASETAG + index;
    badgeView.backgroundColor = pointColor;
    CGRect tabFrame           = self.frame;
    //确定小红点的位置
    float percentX            = (index + 0.5) / tabbarController.childViewControllers.count;
    CGFloat x                 = ceilf(percentX * tabFrame.size.width);
    CGFloat y                 = tabFrame.size.height / 2.0;
    badgeView.frame           = CGRectMake(0, 0, badgeSize.width, badgeSize.height);
    if (UIOffsetEqualToOffset(offset, UIOffsetZero)) {
        badgeView.center      = CGPointMake(x + badgeSize.width + 4.0, y - (tabFrame.size.height / 2.0 - badgeSize.height / 2.0 - 6.0));
    }else {
        badgeView.center      = CGPointMake(x + offset.horizontal, y + offset.vertical);
    }
    [self addSubview:badgeView];
    [badgeView zz_round];
}

/**
 *  以数字显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index value:(NSUInteger)value badgeSize:(CGSize)badgeSize badgeBackgroundColor:(UIColor *)badgeBackgroundColor textColor:(nonnull UIColor *)textColor textFont:(nonnull UIFont *)textFont offset:(UIOffset)offset {
    
    UITabBarController *tabbarController = (UITabBarController *)[[self superview] nextResponder];
    if (![tabbarController isKindOfClass:[UITabBarController class]] || tabbarController.childViewControllers.count == 0 || index < 0 || index >= tabbarController.childViewControllers.count ) {
        return;
    }
    
    //移除之前的Badge
    [self zz_removeBadge:index];
    if (value <= 0) {
        return;
    }
    //新建Badge
    UILabel *badgeView        = [[UILabel alloc] init];
    badgeView.textAlignment   = NSTextAlignmentCenter;
    badgeView.tag             = _BASETAG + index;
    badgeView.backgroundColor = badgeBackgroundColor;
    badgeView.text            = [self _tabbarTransforBadgeNumber:value];
    badgeView.textColor       = textColor;
    badgeView.font            = textFont;
    CGRect tabFrame           = self.frame;
    //确定数字Badge的位置
    float percentX            = (index + 0.5) / tabbarController.childViewControllers.count;
    CGFloat x                 = ceilf(percentX * tabFrame.size.width);
    CGFloat y                 = tabFrame.size.height / 2.0;
    badgeView.frame           = CGRectMake(0, 0, badgeSize.width, badgeSize.height);
    if (UIOffsetEqualToOffset(offset, UIOffsetZero)) {
        badgeView.center      = CGPointMake(x + badgeSize.width, y - (tabFrame.size.height / 2.0 - badgeSize.height / 2.0 - 4.0));
    }else {
        badgeView.center      = CGPointMake(x + offset.horizontal, y + offset.vertical);
    }
    [self addSubview:badgeView];
    [badgeView zz_round];
}

/**
 *  移除Badge
 */
- (void)zz_removeBadge:(NSUInteger)index {
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == _BASETAG + index) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - Private

- (NSString *)_tabbarTransforBadgeNumber:(NSUInteger)value {
    
    if (value > 99) {
        return @"99";
    }else if (value > 0) {
        return [NSString stringWithFormat:@"%d", (int)value];
    }else {
        return nil;
    }
}

@end
