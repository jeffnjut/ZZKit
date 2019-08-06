//
//  UIViewController+ZZTrace.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIViewController+ZZTrace.h"
#import <objc/runtime.h>
#import "ZZTrace.h"
#import "UIViewController+ZZKit.h"

@implementation UIViewController (ZZTrace)

// 设置上一页的pref
- (void)zz_setPref:(NSString *)pref {
    
    if (pref == nil) {
        return;
    }
    objc_setAssociatedObject(self, @"Pref", pref, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取上一页的pref
- (NSString *)zz_getPref {
    
    return objc_getAssociatedObject(self, @"Pref");
}

// 设置上一页的pageHash
- (void)zz_setPrefHash:(NSString *)prefHash {
    
    if (prefHash == nil) {
        return;
    }
    objc_setAssociatedObject(self, @"PrepageHash", prefHash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取上一页的pageHash
- (NSString *)zz_getPrefHash {
    
    return objc_getAssociatedObject(self, @"PrepageHash");
}

// 设置上一页的pageHash的全路径
- (void)zz_setPageHashFullPath:(NSString *)prefHash {
    
    if (prefHash == nil) {
        return;
    }
    objc_setAssociatedObject(self, @"PageHashFullPath", prefHash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取上一页的pageHash的全路径
- (NSString *)zz_getPageHashFullPath {
    
    return objc_getAssociatedObject(self, @"PageHashFullPath");
}

// Push
- (void)zz_trace_push:(UIViewController *)viewController animated:(BOOL)animated {
    
    [ZZTrace tracePageView:viewController prePage:self];
    [self zz_push:viewController animated:animated];
}

// Present
- (void)zz_trace_present:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    
    [ZZTrace tracePageView:viewController prePage:self];
    [self zz_present:viewController animated:animated completion:completion];
    
}

@end
