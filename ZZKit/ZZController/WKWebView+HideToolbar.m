//
//  WKWebView+HideToolbar.m
//  ZZKit
//
//  Created by Fu Jie on 2020/2/12.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "WKWebView+HideToolbar.h"
#import  <objc/runtime.h>

@implementation WKWebView (HideToolbar)

static const char * const hackishFixClassName = "WKContentViewMinusAccessoryView";

static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    
    UIScrollView *scrollView = self.scrollView;
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        NSLog(@"%@",NSStringFromClass([subview class]));
        if ([NSStringFromClass([subview class]) hasPrefix:@"WKContentView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}


- (id)methodReturningNil {
    
    return nil;
}


- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {

    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        hackishFixClass = newClass;
    }
}


- (BOOL)hackishlyHidesInputAccessoryView {
    
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}


- (void)setHackishlyHidesInputAccessoryView:(BOOL)value {
    
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }else {
        Class normalClass = objc_getClass("WKContentView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}

@end
