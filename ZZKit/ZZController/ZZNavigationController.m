//
//  ZZNavigationController.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZNavigationController.h"
#import "ZZDevice.h"

@interface ZZNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation ZZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 默认开启侧滑返回
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setZzDisablePopGesture:(BOOL)zzDisablePopGesture {
    
    _zzDisablePopGesture = zzDisablePopGesture;
    if (zzDisablePopGesture) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }else {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

// Override [pushViewController:animated:]
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 解决push多个控制器后，popToRootViewController TabBar消失
        if (self.childViewControllers.count > 1) {
            viewController.hidesBottomBarWhenPushed = NO;
        }
    }
    
    [super pushViewController:viewController animated:animated];
    
    // 适配iPhoneX，修改tabBar的frame
    if (ZZ_DEVICE_IS_IPHONE_X_ALL) {
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self.viewControllers count] <= 1) {
        return NO;
    }else{
        if (self.zzPopGestureBlock != nil) {
            __weak typeof(self) weakSelf = self;
            return self.zzPopGestureBlock(weakSelf);
        }
        return YES;
    }
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
