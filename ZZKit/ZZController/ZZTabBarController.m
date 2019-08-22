//
//  ZZTabBarController.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTabBarController.h"
#import "NSObject+ZZKit_Image.h"
#import "ZZNavigationController.h"

@interface ZZTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, assign) NSUInteger zzPreviousIndex;

@end

@implementation ZZTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加视图控制器
 */
- (void)zz_addChildViewController:(nonnull UIViewController *)childController tabName:(nullable NSString *)tabname tabUnselectedImage:(nullable id)unselectedImage tabSelectedImage:(nullable id)selectedImage tabUnselectedTextAttrs:(nullable NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(nullable NSDictionary *)selectedTextAttrs navigationControllerClass:(nullable Class)navigationControllerClass {
    
    [self zz_addChildViewController:childController tabName:tabname tabUnselectedImage:unselectedImage tabSelectedImage:selectedImage tabUnselectedTextAttrs:unselectedTextAttrs tabSelectedTextAttrs:selectedTextAttrs imageEdgeInsets:UIEdgeInsetsZero textOffset:UIOffsetZero navigationControllerClass:navigationControllerClass];
}

/**
 *  添加视图控制器,可以调整文字和图片位移
 */
- (void)zz_addChildViewController:(nonnull UIViewController *)childController tabName:(nullable NSString *)tabname tabUnselectedImage:(nullable id)unselectedImage tabSelectedImage:(nullable id)selectedImage tabUnselectedTextAttrs:(nullable NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(nullable NSDictionary *)selectedTextAttrs imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets textOffset:(UIOffset)textOffset navigationControllerClass:(nullable Class)navigationControllerClass {
    
    // 设置未选中Tab图标
    [childController.tabBarItem zz_setImage:unselectedImage isSelected:NO];
    // 设置已选中Tab图片
    [childController.tabBarItem zz_setImage:selectedImage isSelected:YES];
    // 设置Tab名称
    childController.tabBarItem.title = tabname;
    // 设置未选中Tab名称文字式样
    if (unselectedTextAttrs != nil && [unselectedTextAttrs.allKeys count] != 0) {
        [childController.tabBarItem setTitleTextAttributes:unselectedTextAttrs forState:UIControlStateNormal];
    }
    // 设置已选中Tab名称文字式样
    if (selectedTextAttrs != nil && [selectedTextAttrs.allKeys count] != 0) {
        [childController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    }
    // 将childController作为NavigationController的根
    UINavigationController *nav = nil;
    if (navigationControllerClass != nil) {
        nav = [[navigationControllerClass alloc] initWithRootViewController:childController];
    }else{
        nav = [[ZZNavigationController alloc] initWithRootViewController:childController];
    }
    [self addChildViewController:nav];
    
    if (imageEdgeInsets.bottom != 0 || imageEdgeInsets.top != 0 || imageEdgeInsets.left != 0 || imageEdgeInsets.right != 0) {
        childController.tabBarItem.imageInsets = imageEdgeInsets;
    }
    if (textOffset.horizontal != 0 || textOffset.vertical != 0 ) {
        childController.tabBarItem.titlePositionAdjustment = textOffset;
    }
}

/**
 *  更新视图控制器
 */
- (void)zz_updateChildViewController:(NSInteger)index childController:(nonnull UIViewController *)childController tabName:(nullable NSString *)tabname tabUnselectedImage:(nullable id)unselectedImage tabSelectedImage:(nullable id)selectedImage tabUnselectedTextAttrs:(nullable NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(nullable NSDictionary *)selectedTextAttrs {
    
    UIViewController *childVC = nil;
    if (childController != nil) {
        childVC = childController;
    }else if (index >= 0 && index < self.childViewControllers.count) {
        childVC = [self.childViewControllers objectAtIndex:index];
    }
    // 设置未选中Tab图标
    [childVC.tabBarItem zz_setImage:unselectedImage isSelected:NO];
    // 设置已选中Tab图片
    [childVC.tabBarItem zz_setImage:selectedImage isSelected:YES];
    // 设置Tab名称
    childVC.tabBarItem.title = tabname;
    // 设置未选中Tab名称文字式样
    if (unselectedTextAttrs != nil && [unselectedTextAttrs.allKeys count] != 0) {
        [childVC.tabBarItem setTitleTextAttributes:unselectedTextAttrs forState:UIControlStateNormal];
    }
    // 设置已选中Tab名称文字式样
    if (selectedTextAttrs != nil && [selectedTextAttrs.allKeys count] != 0) {
        [childVC.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    }
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (self.zzShouldSelectViewController != nil) {
        return self.zzShouldSelectViewController(tabBarController, viewController);
    }
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (self.zzDidSelectViewController != nil) {
        self.zzDidSelectViewController(tabBarController, viewController);
    }
    self.zzPreviousIndex = tabBarController.selectedIndex;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
