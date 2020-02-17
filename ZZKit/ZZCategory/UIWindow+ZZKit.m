//
//  UIWindow+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIWindow+ZZKit.h"

@implementation UIWindow (ZZKit)

/**
 *  获取 KeyWindow
 */
+ (UIWindow *)zz_window {
    
    return [[UIApplication sharedApplication] keyWindow];
}

/**
 *  获取 KeyWindow Actived UIViewController
 */
+ (UIViewController *)zz_windowActivedViewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window zz_activedViewController];
}

/**
 *  获取 KeyWindow Presented ViewController
 */
+ (UIViewController *)zz_windowPresentedViewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window zz_presentedViewController];
}

/**
 *  获取 KeyWindow 当前TopViewController
 */
+ (UIViewController*)zz_windowTopViewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window zz_topViewController];
}

/**
 *  获取 Actived UIViewController
 */
- (UIViewController *)zz_activedViewController {
    
    UIViewController* activityViewController = nil;
    if(self.windowLevel != UIWindowLevelNormal) {
        return nil;
    }
    NSArray *viewsArray = [self subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray firstObject];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        } else {
            activityViewController = self.rootViewController;
        }
    }
    return activityViewController;
}

/**
 *  获取 Presented ViewController
 */
- (UIViewController *)zz_presentedViewController {
    
    UIViewController* topVC = nil;
    if(self.windowLevel != UIWindowLevelNormal) {
        return nil;
    }
    topVC = self.rootViewController;
    while (YES) {
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }else {
            break;
        }
    }
    return topVC;
}

/**
 *  获取 TopViewController
 */
- (UIViewController*)zz_topViewController {
    
    UIViewController *currentViewController = self.rootViewController;
    while ([currentViewController presentedViewController]) {
        currentViewController = [currentViewController presentedViewController];
    }
    if ([currentViewController isKindOfClass:[UITabBarController class]]
        && ((UITabBarController*)currentViewController).selectedViewController != nil ) {
        currentViewController = ((UITabBarController*)currentViewController).selectedViewController;
    }
    while ([currentViewController isKindOfClass:[UINavigationController class]]
           && [(UINavigationController*)currentViewController topViewController]) {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    return currentViewController;
}

/**
 *  Window上的 Root ViewController 是否初始化完成
 */
- (BOOL)zz_windowRootViewControllerLoaded {
    
    if (self.rootViewController == nil) {
        return NO;
    }
    if ([self.rootViewController isKindOfClass:[UITabBarController class]] && self.rootViewController.childViewControllers.count > 0) {
        UIViewController *firstTabChildController = [self.rootViewController.childViewControllers objectAtIndex:0];
        if ([firstTabChildController isKindOfClass:[UINavigationController class]]) {
            // UITabController+UINavigationController结构
            if (((UINavigationController *)firstTabChildController).viewControllers.count > 0) {
                // UINavigationController的Controller栈非空
                UIViewController *firstNavController = [((UINavigationController *)firstTabChildController).viewControllers objectAtIndex:0];
                return firstNavController.isViewLoaded;
            }else{
                // UINavigationController的Controller栈空
                return firstTabChildController.isViewLoaded;
            }
        }else if ([firstTabChildController isKindOfClass:[UIViewController class]]) {
            // UITabController+UIViewController结构
            return firstTabChildController.isViewLoaded;
        }
    }else if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        // UINavigationController结构
        if (((UINavigationController *)self.rootViewController).viewControllers.count > 0) {
            // UINavigationController的Controller栈非空
            UIViewController *firstNavController = [((UINavigationController *)self.rootViewController).viewControllers objectAtIndex:0];
            return firstNavController.isViewLoaded;
        }else {
            // UINavigationController的Controller栈空
            return self.rootViewController.isViewLoaded;
        }
    }else if ([self.rootViewController isKindOfClass:[UIViewController class]]) {
        // UIViewController结构
        return self.rootViewController.isViewLoaded;
    }
    return YES;
}

/**
 * 获取第一响应者
 */
- (__kindof UIView *)zz_firstResponder {
    
    UIView *firstResponder = [self performSelector:@selector(firstResponder)];
    return firstResponder;
}



@end
