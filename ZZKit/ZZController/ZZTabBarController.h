//
//  ZZTabBarController.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTabBarController : UITabBarController

// shouldSelectViewController
@property(nonatomic, copy) BOOL(^zzShouldSelectViewController)(__weak __kindof UITabBarController *tabController, __weak UIViewController *viewController);

// didSelectViewController
@property(nonatomic, copy) void(^zzDidSelectViewController)(__weak __kindof UITabBarController *tabController, __weak UIViewController *viewController);

/**
 *  添加视图控制器
 */
- (void)zz_addChildViewController:(nonnull UIViewController *)childController
                          tabName:(nullable NSString *)tabname
               tabUnselectedImage:(nullable id)unselectedImage
                 tabSelectedImage:(nullable id)selectedImage
           tabUnselectedTextAttrs:(nullable NSDictionary *)unselectedTextAttrs
             tabSelectedTextAttrs:(nullable NSDictionary *)selectedTextAttrs
        navigationControllerClass:(nullable Class)navigationControllerClass;

/**
 *  添加视图控制器,可以调整文字和图片位移
 */
- (void)zz_addChildViewController:(nonnull UIViewController *)childController
                          tabName:(nullable NSString *)tabname
               tabUnselectedImage:(nullable id)unselectedImage
                 tabSelectedImage:(nullable id)selectedImage
           tabUnselectedTextAttrs:(nullable NSDictionary *)unselectedTextAttrs
             tabSelectedTextAttrs:(nullable NSDictionary *)selectedTextAttrs
                  imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                       textOffset:(UIOffset)textOffset
        navigationControllerClass:(nullable Class)navigationControllerClass;

/**
 *  更新视图控制器
 */
- (void)zz_updateChildViewController:(NSInteger)index
                     childController:(nonnull UIViewController *)childController
                             tabName:(nullable NSString *)tabname
                  tabUnselectedImage:(nullable id)unselectedImage tabSelectedImage:(nullable id)selectedImage tabUnselectedTextAttrs:(nullable NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(nullable NSDictionary *)selectedTextAttrs;

@end

NS_ASSUME_NONNULL_END
