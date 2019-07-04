//
//  ZZWebView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class MASConstraintMaker;

typedef NS_ENUM(NSInteger, ZZWebViewType) {
    ZZWebViewTypeUIWebView,   // UIWebView
    ZZWebViewTypeWKWebView    // WKWebView
};

NS_ASSUME_NONNULL_BEGIN

@interface ZZWebView : UIView

@property (nonatomic, readonly) UIWebView *webView;

@property (nonatomic, readonly) WKWebView *wkWebView;

@property (nonatomic, readonly) JSContext *zzContext;

@property (nonatomic, readonly) WKWebViewConfiguration *wkConfiguration;

@property (nonatomic, copy) BOOL(^zzShouldLoadRequestBlock)(NSURLRequest *request);

@property (nonatomic, copy) BOOL(^zzOpenURLBlock)(NSURL *url, NSDictionary<UIApplicationOpenURLOptionsKey,id> *options);

@property (nonatomic, strong) NSDictionary<NSString *, id> *zzProcessJavaScriptCallingDictionary;

/**
 *  加载HTML文本
 */
- (void)zz_loadHTMLStringL:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL;

/**
 *  加载本地HTML文件
 */
- (void)zz_loadRequest:(nonnull NSString *)fileName ofType:(nonnull NSString *)ofType bunlde:(nullable NSBundle *)bundle headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields;

/**
 *  加载URL
 */
- (void)zz_loadRequest:(nonnull NSString *)url headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields;

/**
 *  OC执行JavaScript,没有异常捕获
 */
- (nullable NSString *)zz_evaluateScript:(nonnull NSString *)script;

/**
 *  OC执行JavaScript,回调有异常捕获
 */
- (void)zz_evaluateScript:(nonnull NSString *)script result:(void(^)(JSContext *context, JSValue *value, JSValue *exception))result;

/**
 *  快速新建ZZWebView的方法
 */
+ (nonnull ZZWebView *)zz_quickAdd:(ZZWebViewType)type onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock;

/**
 *  URL Schemes时候执行处理方法
 */
+ (BOOL)zz_handleOpenURL:(nonnull NSURL *)url option:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)option;

@end

NS_ASSUME_NONNULL_END
