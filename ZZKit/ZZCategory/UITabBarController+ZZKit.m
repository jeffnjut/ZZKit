//
//  UITabBarController+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UITabBarController+ZZKit.h"
#import "UITabBar+ZZKit.h"
#import <objc/runtime.h>

@implementation UITabBarController (ZZKit)

#pragma mark - Tabbar消息数、红点

/**
 *  以系统默认的方式设置消息数
 */
- (void)zz_setSystemBadge:(NSUInteger)index value:(NSUInteger)value color:(nullable UIColor *)color {
    [self.tabBar zz_setSystemBadge:index value:value color:color];
}

/**
 *  以圆点显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index pointColor:(nullable UIColor *)pointColor badgeSize:(CGSize)badgeSize offset:(UIOffset)offset {
    [self.tabBar zz_setBadge:index pointColor:pointColor badgeSize:badgeSize offset:offset];
}

/**
 *  以数字显示Badge
 */
- (void)zz_setBadge:(NSUInteger)index value:(NSUInteger)value badgeSize:(CGSize)badgeSize badgeBackgroundColor:(UIColor *)badgeBackgroundColor textColor:(nonnull UIColor *)textColor textFont:(nonnull UIFont *)textFont offset:(UIOffset)offset {
    [self.tabBar zz_setBadge:index value:value badgeSize:badgeSize badgeBackgroundColor:badgeBackgroundColor textColor:textColor textFont:textFont offset:offset];
}

/**
 *  移除Badge
 */
- (void)zz_removeBadge:(NSUInteger)index {
    [self.tabBar zz_removeBadge:index];
}

#pragma mark - Tabbar隐藏

/**
 *  获取 tabbar hidden
 */
- (BOOL)zz_tabBarHidden {
    return self.tabBar.hidden;
}

/**
 *  设置隐藏TabBar(hidden)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden {
    [self zz_setTabBarHidden:hidden animated:NO completion:nil];
}

/**
 *  设置隐藏TabBar(hidden,animated)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [self zz_setTabBarHidden:hidden animated:animated delaysContentResizing:NO completion:nil];
}

/**
 *  设置隐藏TabBar(hidden,animated,completion)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(void))completion {
    [self zz_setTabBarHidden:hidden animated:animated delaysContentResizing:NO completion:completion];
}

/**
 *  设置隐藏TabBar(hidden,animated,delaysContentResizing,completion)
 */
- (void)zz_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(nullable void (^)(void))completion {
    if ( [self.view.subviews count] < 2 ) return;
    UIView *transitionView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        // iOS4
        transitionView = [self.view.subviews objectAtIndex:1];
    } else {
        // UITransitionView over iOS5
        transitionView = [self.view.subviews objectAtIndex:0];
    }
    if (!hidden) {
        self.tabBar.hidden = NO;
    }
    [self _setTabBarAnimating:YES];
    [UIView animateWithDuration:(animated ? UINavigationControllerHideShowBarDuration : 0)
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGFloat tabBarTop = 0;
                         if (hidden) {
                             CGRect viewFrame = [self.view convertRect:self.view.bounds toView:self.tabBar.superview];
                             tabBarTop = viewFrame.origin.y+viewFrame.size.height;
                             transitionView.frame = self.view.bounds;
                         }
                         else {
                             CGRect viewFrame = [self.view convertRect:self.view.bounds toView:self.tabBar.superview];
                             tabBarTop = viewFrame.origin.y+viewFrame.size.height-self.tabBar.frame.size.height;
                             if (!delaysContentResizing) {
                                 transitionView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                   self.view.bounds.origin.y,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height-self.tabBar.frame.size.height);
                             }
                         }
                         CGRect frame;
                         frame = self.tabBar.frame;
                         frame.origin.y = tabBarTop;
                         self.tabBar.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (hidden) {
                             self.tabBar.hidden = YES;
                         }
                         else {
                             if (delaysContentResizing && finished) {
                                 transitionView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                   self.view.bounds.origin.y,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - self.tabBar.frame.size.height);
                             }
                         }
                         [self _setTabBarAnimating:NO];
                         if (completion) {
                             completion();
                         }
                     }];
}

#pragma mark - Private

// get property tabBarAnimating
- (BOOL)_tabBarAnimating {
    
    return [objc_getAssociatedObject(self, "_ZZTabBarAnimatingKey") boolValue];
}

// set property tabBarAnimating
- (void)_setTabBarAnimating:(BOOL)tabBarAnimating {
    
    objc_setAssociatedObject(self, "_ZZTabBarAnimatingKey", [NSNumber numberWithBool:tabBarAnimating], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
