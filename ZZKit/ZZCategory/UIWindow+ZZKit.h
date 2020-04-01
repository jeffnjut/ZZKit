//
//  UIWindow+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ZZKit)

/**
 *  获取 KeyWindow
 */
+ (UIWindow *)zz_keyWindow;

/**
 *  获取 KeyWindow Actived UIViewController
 */
+ (UIViewController *)zz_keyWindowActivedViewController;

/**
 *  获取 KeyWindow Presented ViewController
 */
+ (UIViewController *)zz_keyWindowPresentedViewController;

/**
 *  获取 KeyWindow 当前TopViewController
 */
+ (UIViewController*)zz_keyWindowTopViewController;

/**
 *  获取 Actived UIViewController
 */
- (UIViewController *)zz_activedViewController;

/**
 *  获取 Presented ViewController
 */
- (UIViewController *)zz_presentedViewController;

/**
 *  获取 TopViewController
 */
- (UIViewController*)zz_topViewController;

/**
 *  Window上的 Root ViewController 是否初始化完成
 */
- (BOOL)zz_windowRootViewControllerLoaded;

/**
 * 获取第一响应者
 */
- (__kindof UIView *)zz_firstResponder;

@end

NS_ASSUME_NONNULL_END
