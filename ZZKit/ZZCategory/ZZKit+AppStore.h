//
//  ZZKit+AppStore.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZKit (AppStore)

/**
 * 跳转到某个app（AppleId, 默认CN）
 */
- (void)appStoreRedirect:(NSUInteger)appID result:(void(^)(BOOL success))result;

/**
 * 跳转到某个app（AppleId、Region/Country Market）
 */
- (void)appStoreRedirect:(NSUInteger)appID region:(nonnull NSString *)region result:(void(^)(BOOL success))result;

/**
 * 打开跳转到某个app（Url）
 */
- (void)appStoreRedirectUrl:(nonnull NSString *)url result:(void(^)(BOOL success))result;

/**
 * 是否安装了某个app
 */
- (BOOL)isInstalled:(nonnull NSString *)appScheme;

/**
 * 跳转至系统的Setting界面
 */
- (void)openSystemSetting;

@end

NS_ASSUME_NONNULL_END
