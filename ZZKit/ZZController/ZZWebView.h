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
@class ZZWebViewJavaScriptResult;

typedef NS_ENUM(NSInteger, ZZWebViewType) {
    ZZWebViewTypeUIWebView,   // UIWebView
    ZZWebViewTypeWKWebView    // WKWebView
};

typedef NS_ENUM(NSInteger, ZZWebViewNavigationStatus) {
    
    // 根据Request判断是否允许导航
    ZZWebViewNavigationStatusShouldStartNavigation,
    // 根据Request判断是否允许导航
    ZZWebViewNavigationStatusDecidePolicyForNavigationAction,
    // 根据Response判断是否允许导航
    ZZWebViewNavigationStatusDecidePolicyForNavigationResponse,
    // 开始导航
    ZZWebViewNavigationStatusDidStartNavigation,
    // 完成导航
    ZZWebViewNavigationStatusDidFinishNavigation,
    // 导航失败
    ZZWebViewNavigationStatusDidFailedWithNavigation
};

typedef void(^ZZUserContentProcessJavaScriptMessageBlock)(WKUserContentController *userContentController, WKScriptMessage *message);

NS_ASSUME_NONNULL_BEGIN

@interface ZZWebView : UIView

@property (nonatomic, readonly) UIWebView *zzUIWebView;

@property (nonatomic, readonly) WKWebView *zzWKWebView;

@property (nonatomic, readonly) JSContext *zzUIWebViewContext;

@property (nonatomic, readonly) WKWebViewConfiguration *zzWKConfiguration;

// UIWebView的处理URL Scheme方式调用自身Navtive的事件处理和跳转
@property (nonatomic, copy) BOOL(^zzUIWebViewOpenURLBlock)(NSURL *url, NSDictionary<UIApplicationOpenURLOptionsKey,id> *options);

// UIWebView的处理JavaScript调用Navtive的事件预设
@property (nonatomic, strong) NSDictionary<NSString *, id> *zzUIWebViewProcessJavaScriptCallingDictionary;

// WKWebView的处理JavaScript调用Navtive的事件预设
@property (nonatomic, strong) NSDictionary<NSString *, ZZUserContentProcessJavaScriptMessageBlock> *zzWKWebViewProcessJavaScriptCallingDictionary;

@property (nonatomic, copy) BOOL(^zzWebNavigationBlock)(ZZWebViewNavigationStatus status, UIWebView * _Nullable webView, WKWebView * _Nullable wkWebView, NSURLRequest * _Nullable request, UIWebViewNavigationType type, WKNavigationAction * _Nullable navigationAction, WKNavigationResponse * _Nullable navigationResponse, WKNavigation * _Nullable navigation, void (^ _Nullable decisionRequestHandler)(WKNavigationActionPolicy), void (^ _Nullable decisionResponseHandler)(WKNavigationResponsePolicy), NSError * _Nullable error);

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
- (void)zz_evaluateScript:(nonnull NSString *)script result:(void(^)(JSContext *context, ZZWebViewJavaScriptResult *data))result;

/**
 *  快速新建ZZWebView的方法
 */
+ (nonnull ZZWebView *)zz_quickAdd:(ZZWebViewType)type onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock;

/**
 *  URL Schemes时候执行处理方法
 */
+ (BOOL)zz_handleOpenURL:(nonnull NSURL *)url option:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)option;

@end

@interface ZZWebViewJavaScriptResult : NSObject

@property (nonatomic, strong) JSValue *data;
@property (nonatomic, strong) JSValue *error;
@property (nonatomic, strong) id wkData;
@property (nonatomic, strong) NSError *wkError;

+ (ZZWebViewJavaScriptResult *)create;

@end

NS_ASSUME_NONNULL_END
