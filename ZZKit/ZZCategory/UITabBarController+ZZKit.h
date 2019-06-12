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
