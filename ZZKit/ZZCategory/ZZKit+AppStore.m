//
//  ZZKit+AppStore.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZKit+AppStore.h"
#import <UIKit/UIKit.h>

#define _APPSTORE_DEFAULT_URL     @"itms-apps://appsto.re/cn/Geex4.i"
#define _APPSTORE_URL(mk,id)      [NSString stringWithFormat:@"itms-apps://itunes.apple.com/%@/app/id%zd?mt=8", mk, id]

@implementation ZZKit (AppStore)

/**
 * 跳转到某个app（AppleId, 默认CN）
 */
- (void)appStoreRedirect:(NSUInteger)appID result:(void(^)(BOOL success))result {
    
    NSString *region = nil;
    
    if (@available(iOS 10.0, *)) {
        region = [NSLocale currentLocale].countryCode;
    }
    
    if (region == nil) {
        region = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    }
    
    if (region == nil) {
        region = @"cn";
    }
    
    [self appStoreRedirect:appID region:region result:result];
}

/**
 * 跳转到某个app（AppleId、Region/Country Market）
 */
- (void)appStoreRedirect:(NSUInteger)appID region:(nonnull NSString *)region result:(void(^)(BOOL success))result {
    
    __weak typeof(self) weakSelf = self;
    NSString *url = _APPSTORE_URL(result, appID);
    [self appStoreRedirectUrl:url result:^(BOOL success) {
        if (success == NO) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf appStoreRedirectUrl:_APPSTORE_DEFAULT_URL result:nil];
        }
    }];
}

/**
 * 打开跳转到某个app（Url）
 */
- (void)appStoreRedirectUrl:(nonnull NSString *)url result:(nullable void(^)(BOOL success))result {
    
    NSURL *URL = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }else {
            [[UIApplication sharedApplication] openURL:URL];
        }
        result == nil ? : result(YES);
    }else{
        result == nil ? : result(NO);
    }
}

/**
 * 是否安装了某个app
 */
- (BOOL)isInstalled:(nonnull NSString *)appScheme {
    
    NSURL *URL = [NSURL URLWithString:appScheme];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        return NO;
    }
    return YES;
}

/**
 * 跳转至系统的Setting界面
 */
- (void)openSystemSetting {
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success){}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
