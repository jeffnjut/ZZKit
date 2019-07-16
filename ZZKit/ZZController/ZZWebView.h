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
    ZZWebViewTypeUIWebView = 0x0001,   // UIWebView
    ZZWebViewTypeWKWebView = 0x0002    // WKWebView
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

typedef void(^ZZUserContentProcessJavaScriptMessageBlock)(WKUserContentController * _Nullable userContentController, WKScriptMessage * _Nullable message);

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
 *  获取UIWebView的默认User-Agent
 */
+ (NSString *)zz_getUIWebViewUserAgent;

/**
 *  设置全局User-Agent
 */
+ (void)zz_setUserAgent:(NSString *(^)(NSString *userAgent))userAgentBlock;

/**
 *  清除所有Cookies
 */
+ (void)zz_clearAllCookie;

/**
 *  清除某个URL下的Cookies
 */
+ (void)zz_clearCookie:(nonnull NSURL *)URL;

/**
 *  清除所有缓存方法
 */
+ (void)zz_clearAllCachedResponse:(ZZWebViewType)webViewType wkWebsiteDataTypes:(nullable NSArray<NSString *> *)wkWebsiteDataTypes;

/**
 *  清除某一个URL缓存的方法
 */
+ (void)zz_clearCachedResponse:(nonnull NSURL *)URL;

/**
 *  加载HTML文本
 */
- (void)zz_loadHTMLString:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL;

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

#pragma mark - Class ZZWebViewJavaScriptResult

@interface ZZWebViewJavaScriptResult : NSObject

@property (nonatomic, strong) JSValue *data;
@property (nonatomic, strong) JSValue *error;
@property (nonatomic, strong) id wkData;
@property (nonatomic, strong) NSError *wkError;

+ (ZZWebViewJavaScriptResult *)create;

@end

#pragma mark - Class ZZCookieManager

typedef BOOL (^ZZCookieFilter)(NSHTTPCookie *, NSURL *);

@interface ZZCookieManager : NSObject

+ (instancetype)shared;

/**
 * 指定URL匹配Cookie策略
 * @param filter 匹配器
 */
- (void)zz_setCookieFilter:(ZZCookieFilter)filter;

/**
 * 处理HTTP Reponse携带的Cookie并存储
 * @param headerFields HTTP Header Fields
 * @param URL 根据匹配策略获取查找URL关联的Cookie
 * @return 返回添加到存储的Cookie
 */
- (NSArray<NSHTTPCookie *> *)zz_handleHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL;

/**
 * 匹配本地Cookie存储，获取对应URL的request cookie字符串
 * @param URL 根据匹配策略指定查找URL关联的Cookie
 * @return 返回对应URL的request Cookie字符串
 */
- (NSString *)zz_getRequestCookieHeaderForURL:(NSURL *)URL;

/**
 * 删除存储cookie
 * @param URL 根据匹配策略查找URL关联的cookie
 * @return 返回成功删除cookie数
 */
- (NSInteger)zz_deleteCookieForURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
