//
//  ZZWebView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWebView.h"
#import <Masonry/Masonry.h>
#import "ZZMacro.h"
#import "UIWindow+ZZKit.h"
#import "NSString+ZZKit.h"
#import "ZZEnumCompare.h"

@interface ZZWebView () <UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    @private
    ZZWebViewType _type;
    UIWebView *_webView;
    WKWebView *_wkWebView;
    JSContext *_context;
    BOOL _addedJavaScriptProcess;
    UIProgressView *_progressView;
    UIColor *_progressBarTintColor;
    double _estimatedProgress;
}

@end

@implementation ZZWebView

- (void)dealloc {
    
    for (NSString *name in _zzWKWebViewProcessJavaScriptCallingDictionary.allKeys) {
        [self.zzWKConfiguration.userContentController removeScriptMessageHandlerForName:name];
    }
    
    if (_progressBarTintColor) {
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [_wkWebView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - Property Setting & Getter

- (UIProgressView *)zzProgressView {
    
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
       [ _progressView setTrackTintColor :[UIColor whiteColor]];
        [_progressView setProgressTintColor:_progressBarTintColor ? _progressBarTintColor : @"#FF7A00".zz_color];
        [self addSubview:_progressView];
        __weak typeof(self) weakSelf = self;
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(weakSelf);
            make.height.equalTo(@2.0);
        }];
    }
    return _progressView;
}

- (UIWebView *)zzUIWebView {
    
    return _webView;
}

- (WKWebView *)zzWKWebView {
    
    return _wkWebView;
}

- (JSContext *)zzUIWebViewContext {
    
    return _context;
}

- (WKWebViewConfiguration *)zzWKConfiguration {
    
    return _wkWebView.configuration;
}

- (void)setZzUIWebViewProcessJavaScriptCallingDictionary:(NSDictionary<NSString *,id> *)zzUIWebViewProcessJavaScriptCallingDictionary {
    
    _zzUIWebViewProcessJavaScriptCallingDictionary = zzUIWebViewProcessJavaScriptCallingDictionary;
    if (_context) {
        __weak typeof(self) weakSelf = self;
        [zzUIWebViewProcessJavaScriptCallingDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->_context[key] = obj;
        }];
        _addedJavaScriptProcess = YES;
    }
}

- (void)setZzWKWebViewProcessJavaScriptCallingDictionary:(NSDictionary<NSString *,ZZUserContentProcessJavaScriptMessageBlock> *)zzWKWebViewProcessJavaScriptCallingDictionary {

    _zzWKWebViewProcessJavaScriptCallingDictionary = zzWKWebViewProcessJavaScriptCallingDictionary;
    for (NSString *name in zzWKWebViewProcessJavaScriptCallingDictionary.allKeys) {
        [self.zzWKConfiguration.userContentController addScriptMessageHandler:self name:name];
    }
}

#pragma mark - Public Method

/**
 *  获取UIWebView的默认User-Agent
 */
+ (NSString *)zz_getUIWebViewUserAgent {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *ua = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return ua;
}

/**
 *  设置全局User-Agent
 */
+ (void)zz_setUserAgent:(NSString *(^)(NSString *userAgent))userAgentBlock {
    
    if (userAgentBlock != nil) {
        // 全局User-Agent
        NSString *ua = [self zz_getUIWebViewUserAgent];
        NSString *newAgent = userAgentBlock(ua);
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : newAgent, @"User-Agent" : newAgent}];
    }
}

/**
 *  清除所有Cookies
 */
+ (void)zz_clearAllCookie {
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSInteger i = cookies.count - 1; i >=0 ; i--) {
        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

/**
 *  清除某个URL下的Cookies
 */
+ (void)zz_clearCookie:(nonnull NSURL *)URL {
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:URL];
    for (NSInteger i = cookies.count - 1; i >=0 ; i--) {
        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

/**
 *  清除所有缓存方法
 */
+ (void)zz_clearAllCachedResponse:(ZZWebViewType)webViewType wkWebsiteDataTypes:(nullable NSArray<NSString *> *)wkWebsiteDataTypes {
    
    if ([ZZEnumCompare zz_has:webViewType aType:ZZWebViewTypeUIWebView]) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    }
    
    if ([ZZEnumCompare zz_has:webViewType aType:ZZWebViewTypeWKWebView]) {
        
        if (@available(iOS 9.0, *)) {
            NSMutableSet *_wkWebsiteDataTypes = nil;
            if (wkWebsiteDataTypes.count > 0) {
                _wkWebsiteDataTypes = [NSMutableSet setWithArray:wkWebsiteDataTypes];
            }else {
                _wkWebsiteDataTypes = [NSMutableSet setWithObjects:WKWebsiteDataTypeDiskCache,
                                       WKWebsiteDataTypeOfflineWebApplicationCache,
                                       WKWebsiteDataTypeMemoryCache,
                                       WKWebsiteDataTypeLocalStorage,
                                       WKWebsiteDataTypeSessionStorage,
                                       WKWebsiteDataTypeIndexedDBDatabases,
                                       WKWebsiteDataTypeWebSQLDatabases,
                                       WKWebsiteDataTypeCookies, nil];
                
                if (@available(iOS 11.3, *)) {
                    [_wkWebsiteDataTypes addObject:WKWebsiteDataTypeFetchCache];
                    [_wkWebsiteDataTypes addObject:WKWebsiteDataTypeServiceWorkerRegistrations];
                }
            }
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:_wkWebsiteDataTypes modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{}];
        }else {
            NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
            NSString *bundleId               = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            NSString *webkitFolderInLib      = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
            NSString *webKitFolderInCaches   = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
            NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
            NSError *error;
            if (@available(iOS 8.0, *)) {
                /* iOS8.0 WebView Cache的存放路径 */
                [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
                [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
            }else if (@available(iOS 7.0, *)) {
                /* iOS7.0 WebView Cache的存放路径 */
                [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
            }
        }
    }
}

/**
 *  清除某一个URL缓存的方法
 */
+ (void)zz_clearCachedResponse:(nonnull NSURL *)URL {
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:URL]];
}

/**
 *  加载HTML文本
 */
- (void)zz_loadHTMLString:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL {
    
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        if (@available(iOS 13.0, *)) {
        }else {
            [_webView loadHTMLString:string baseURL:baseURL];
        }
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        
    }
}

/**
 *  加载本地HTML文件
 */
- (void)zz_loadRequest:(nonnull NSString *)fileName ofType:(nonnull NSString *)ofType bunlde:(nullable NSBundle *)bundle headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields {
    
    ZZ_WEAK_SELF
    NSBundle *_bundle = bundle;
    if (!_bundle) {
        _bundle = [NSBundle mainBundle];
    }
    NSString *path = [_bundle pathForResource:fileName ofType:ofType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    BOOL available11 = NO;
    if (@available(iOS 11.0, *)) {
        available11 = YES;
    }
    
    if (_type == ZZWebViewTypeWKWebView && available11) {
        // WKWebView iOS 11以及以上
        [self _copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
            ZZ_STRONG_SELF
            [strongSelf->_wkWebView loadRequest:request];
        }];
        return;
    }else {
        for (NSString *headerField in headerFields.allKeys) {
            NSString *value = headerFields[headerField];
            [request addValue:value forHTTPHeaderField:headerField];
        }
    }
    
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        if (@available(iOS 13.0, *)) {
        }else {
            [_webView loadRequest:request];
        }
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        [_wkWebView loadRequest:request];
    }
}

/**
 *  加载URL
 */
- (void)zz_loadRequest:(nonnull id)url headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields {
    
    ZZ_WEAK_SELF
    NSMutableURLRequest *request = nil;
    if ([url isKindOfClass:[NSString class]]) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    }else if ([url isKindOfClass:[NSURL class]]) {
        request = [NSMutableURLRequest requestWithURL:url];
    }
    
    BOOL available11 = NO;
    if (@available(iOS 11.0, *)) {
        available11 = YES;
    }
    
    if (_type == ZZWebViewTypeWKWebView && available11) {
        // WKWebView iOS 11以及以上
        [self _copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
            ZZ_STRONG_SELF
            [strongSelf->_wkWebView loadRequest:request];
        }];
        return;
    }else {
        // 方法：通过一一设置Request Header
        for (NSString *headerField in headerFields.allKeys) {
            NSString *value = headerFields[headerField];
            [request addValue:value forHTTPHeaderField:headerField];
        }
        
        /*
        // 方法：通过设置Request Header
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
        //Cookies数组转换为requestHeaderFields
        NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        //设置请求头
        request.allHTTPHeaderFields = requestHeaderFields;
        */
    }
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        if (@available(iOS 13.0, *)) {
        }else {
            [_webView loadRequest:request];
        }
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        [_wkWebView loadRequest:request];
    }
}

/**
 *  OC执行JavaScript,没有异常捕获
 */
- (nullable NSString *)zz_evaluateScript:(nonnull NSString *)script {
    
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        if (@available(iOS 13.0, *)) {
        }else {
            return [_webView stringByEvaluatingJavaScriptFromString:@"document.titledss"];
        }
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        NSAssert(NO, @"请使用方法zz_evaluateScript:result:");
    }
    return nil;
}

/**
 *  OC执行JavaScript,回调有异常捕获
 */
- (void)zz_evaluateScript:(nonnull NSString *)script result:(void(^)(JSContext *context, ZZWebViewJavaScriptResult *data))result {
    
    __weak typeof(self) weakSelf = self;
    
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        
        if (@available(iOS 13.0, *)) {
        }else {
            if (_context == nil) {
                _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            }
            __block BOOL _isErrorRaised = NO;
            _context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
                _isErrorRaised = YES;
                ZZWebViewJavaScriptResult *resultData = [ZZWebViewJavaScriptResult create];
                resultData.error = exception;
                result == nil ? : result(context, resultData);
            };
            __block JSValue *jsValue = [_context evaluateScript:script];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                if (!_isErrorRaised && result != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        ZZWebViewJavaScriptResult *resultData = [ZZWebViewJavaScriptResult create];
                        resultData.data = jsValue;
                        result == nil ? : result(strongSelf->_context, resultData);
                    });
                }
            });
        }
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        
        [_wkWebView evaluateJavaScript:script completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            
            ZZWebViewJavaScriptResult *resultData = [ZZWebViewJavaScriptResult create];
            resultData.wkData = data;
            resultData.wkError = error;
            result == nil ? : result(nil, resultData);
        }];
    }
}

/**
 *  快速新建ZZWebView的方法(默认开启进度条)
 */
+ (nonnull ZZWebView *)zz_quickAdd:(ZZWebViewType)type onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock {
    
    return [ZZWebView zz_quickAdd:type onView:onView frame:frame progressBarTintColor:@"#FF7A00".zz_color constraintBlock:constraintBlock];
}

/**
 *  快速新建ZZWebView的方法(Base)
 */
+ (nonnull ZZWebView *)zz_quickAdd:(ZZWebViewType)type onView:(nullable UIView *)onView frame:(CGRect)frame progressBarTintColor:(nullable UIColor *)progressBarTintColor constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock {
    
    ZZWebView *zzWebView = [[ZZWebView alloc] initWithFrame:frame];
    if (onView != nil) {
        [onView addSubview:zzWebView];
        if (constraintBlock != nil) {
            [zzWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                constraintBlock(onView, make);
            }];
        }
    }
    zzWebView->_type = type;
    zzWebView->_progressBarTintColor = progressBarTintColor;
    [zzWebView _buildUI];
    return zzWebView;
}

/**
 *  URL Schemes时候执行处理方法
 */
+ (BOOL)zz_handleOpenURL:(nonnull NSURL *)url option:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)option {
    
    ZZWebView *zzWebView = [ZZWebView _getActiveZZWebView];
    if (zzWebView != nil && zzWebView.zzUIWebViewOpenURLBlock != nil) {
        if (@available(iOS 13.0, *)) {
        }else {
            return zzWebView.zzUIWebViewOpenURLBlock(url, option);
        }
    }
    return NO;
}

#pragma mark - Private

+ (ZZWebView *)_getActiveZZWebView {
    
    UIViewController *viewController = [ZZ_KEY_WINDOW zz_topViewController];
    for (ZZWebView *subView in viewController.view.subviews) {
        if ([subView isKindOfClass:[ZZWebView class]]) {
            return subView;
        }
    }
    
    viewController = [ZZ_KEY_WINDOW zz_presentedViewController];
    for (ZZWebView *subView in viewController.view.subviews) {
        if ([subView isKindOfClass:[ZZWebView class]]) {
            return subView;
        }
    }
    
    viewController = [ZZ_KEY_WINDOW zz_activedViewController];
    for (ZZWebView *subView in viewController.view.subviews) {
        if ([subView isKindOfClass:[ZZWebView class]]) {
            return subView;
        }
    }
    
    return nil;
}

- (UIViewController *)_responder:(UIView *)view {
    
    if (view == nil) {
        return nil;
    }
    
    id nextResponder = view.nextResponder;
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }
    return [self _responder:nextResponder];
}

- (void)_buildUI {
    
    __weak typeof(self) weakSelf = self;
    if (_type == ZZWebViewTypeUIWebView) {
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }else if (_type == ZZWebViewTypeWKWebView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        configuration.userContentController = controller;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        // 允许右滑返回上个链接，左滑前进
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 允许链接3D Touch
        if (@available(iOS 9.0, *)) {
            _wkWebView.allowsLinkPreview = YES;
        } else {
            // Fallback on earlier versions
        }
        // 自定义UA，UIWebView就没有此功能，后面会讲到通过其他方式实现
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        [self addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }
    if (_progressBarTintColor) {
        [self zzProgressView];
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Observe Estimated Progress
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    
    ZZ_WEAK_SELF
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        if (_progressView) {
            [_progressView setProgress:_estimatedProgress animated:NO];
            if (_estimatedProgress >= 0.89) {
                int64_t delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf->_estimatedProgress >= 0.89) {
                        
                    }
                });
                if (_estimatedProgress == 1.0) {
                    _progressView.alpha = 0;
                    _estimatedProgress = 0;
                }
            }else {
                _progressView.alpha = 1.0;
            }
        }
        self.zzWebViewProgressBlock == nil ? : self.zzWebViewProgressBlock(_estimatedProgress);
    }
    else if ([keyPath isEqualToString:@"title"]) {
        
        NSString *title = change[NSKeyValueChangeNewKey];
        self.zzWebViewTitleBlock == nil ? : self.zzWebViewTitleBlock(title);
        
    }else {
        [self willChangeValueForKey:keyPath];
        [self didChangeValueForKey:keyPath];
    }
}



- (void)_copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void (^)(void))theCompletionHandler {
    
    if (@available(iOS 11.0, *)) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        WKHTTPCookieStore *cookieStroe = _wkWebView.configuration.websiteDataStore.httpCookieStore;
        if (cookies.count == 0) {
            !theCompletionHandler ? : theCompletionHandler();
            return;
        }
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStroe setCookie:cookie completionHandler:^{
                if ([[cookies lastObject] isEqual:cookie]) {
                    !theCompletionHandler ? : theCompletionHandler();
                    return;
                }
            }];
        }
    } else {
        !theCompletionHandler ? : theCompletionHandler();
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
    if (self.zzWebNavigationBlock != nil) {
        return self.zzWebNavigationBlock(ZZWebViewNavigationStatusShouldStartNavigation, webView, nil, request, navigationType, nil, nil, nil, nil, nil, nil);
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
 
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidStartNavigation, webView, nil, nil, 0, nil, nil, nil, nil, nil, nil);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
    if (_context == nil) {
        _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    
    if (!_addedJavaScriptProcess) {
        __weak typeof(self) weakSelf = self;
        [_zzUIWebViewProcessJavaScriptCallingDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->_context[key] = obj;
        }];
        _addedJavaScriptProcess = YES;
    }
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidFinishNavigation, webView, nil, nil, 0, nil, nil, nil, nil, nil, nil);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidFailedWithNavigation, webView, nil, nil, 0, nil, nil, nil, nil, nil, error);
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDecidePolicyForNavigationAction, nil, webView, nil, 0, navigationAction, nil, nil, decisionHandler, nil, nil);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDecidePolicyForNavigationResponse, nil, webView, nil, 0, nil, navigationResponse, nil, nil, decisionHandler, nil);
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidStartNavigation, nil, webView, nil, 0, nil, nil, navigation, nil, nil, nil);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidFinishNavigation, nil, webView, nil, 0, nil, nil, navigation, nil, nil, nil);
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidFailedWithNavigation, nil, webView, nil, 0, nil, nil, navigation, nil, nil, nil);
    }
}

/*
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}
*/

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
    // WKWebView白屏处理
    [_wkWebView reload];
}


#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    
    UIViewController *nextResponder = [self _responder:self.superview];
    if (nextResponder) {
        [nextResponder presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    id dict = [prompt zz_jsonToCocoaObject];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *_dict = dict;
        
        NSString *type = [_dict objectForKey:@"type"];
        if (type && [type isEqualToString:@"JSbridge"])
        {
            NSString *returnValue = @"";
            NSString *functionName = [_dict objectForKey:@"functionName"];
            // NSDictionary *args = [_dict objectForKey:@"arguments"];
            if ([functionName isEqualToString:@"OC_Fun_05"])
            {
                returnValue = @"Fun:OC_Fun_05";
            }
            else if ([functionName isEqualToString:@"OC_Fun_06"])
            {
                returnValue = @"Fun:OC_Fun_06";
            }
            
            completionHandler(@"test");
        }
    }
}



#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    ZZUserContentProcessJavaScriptMessageBlock wkProcessBlock = [_zzWKWebViewProcessJavaScriptCallingDictionary objectForKey:message.name];
    if (wkProcessBlock) {
        wkProcessBlock(userContentController, message);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - Class ZZWebViewJavaScriptResult

@implementation ZZWebViewJavaScriptResult

+ (ZZWebViewJavaScriptResult *)create {
    
    ZZWebViewJavaScriptResult *result = [[ZZWebViewJavaScriptResult alloc] init];
    return result;
}

@end

#pragma mark - Class ZZCookieManager

@implementation ZZCookieManager
{
    ZZCookieFilter cookieFilter;
}

- (instancetype)init {
    
    if (self = [super init]) {
        /*
         此处设置的Cookie和URL匹配策略比较简单，检查URL.host是否包含Cookie的domain字段
         通过调用setCookieFilter接口设定Cookie匹配策略，
         比如可以设定Cookie的domain字段和URL.host的后缀匹配 | URL是否符合Cookie的path设定
         细节匹配规则可参考RFC 2965 3.3节
        */
        cookieFilter = ^BOOL(NSHTTPCookie *cookie, NSURL *URL) {
            if ([URL.host containsString:cookie.domain]) {
                return YES;
            }
            return NO;
        };
    }
    return self;
}

+ (instancetype)shared {
    
    static id singletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singletonInstance) {
            singletonInstance = [[super allocWithZone:NULL] init];
        }
    });
    return singletonInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return self;
}

/**
 * 指定URL匹配Cookie策略
 * @param filter 匹配器
 */
- (void)zz_setCookieFilter:(ZZCookieFilter)filter {
    
    if (filter != nil) {
        cookieFilter = filter;
    }
}

/**
 * 处理HTTP Reponse携带的Cookie并存储
 * @param headerFields HTTP Header Fields
 * @param URL 根据匹配策略获取查找URL关联的Cookie
 * @return 返回添加到存储的Cookie
 */
- (NSArray<NSHTTPCookie *> *)zz_handleHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL {
    
    NSArray *cookieArray = [NSHTTPCookie cookiesWithResponseHeaderFields:headerFields forURL:URL];
    if (cookieArray != nil) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArray) {
            if (cookieFilter(cookie, URL)) {
                NSLog(@"Add a cookie: %@", cookie);
                [cookieStorage setCookie:cookie];
            }
        }
    }
    return cookieArray;
}

/**
 * 匹配本地Cookie存储，获取对应URL的request cookie字符串
 * @param URL 根据匹配策略指定查找URL关联的Cookie
 * @return 返回对应URL的request Cookie字符串
 */
- (NSString *)zz_getRequestCookieHeaderForURL:(NSURL *)URL {
    
    NSArray *cookieArray = [self _searchAppropriateCookies:URL];
    if (cookieArray != nil && cookieArray.count > 0) {
        NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        if ([cookieDic objectForKey:@"Cookie"]) {
            return cookieDic[@"Cookie"];
        }
    }
    return nil;
}

- (NSArray *)_searchAppropriateCookies:(NSURL *)URL {
    
    NSMutableArray *cookieArray = [NSMutableArray array];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if (cookieFilter(cookie, URL)) {
            NSLog(@"Search an appropriate cookie: %@", cookie);
            [cookieArray addObject:cookie];
        }
    }
    return cookieArray;
}

/**
 * 删除存储cookie
 * @param URL 根据匹配策略查找URL关联的cookie
 * @return 返回成功删除cookie数
 */
- (NSInteger)zz_deleteCookieForURL:(NSURL *)URL {
    
    int delCount = 0;
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if (cookieFilter(cookie, URL)) {
            NSLog(@"Delete a cookie: %@", cookie);
            [cookieStorage deleteCookie:cookie];
            delCount++;
        }
    }
    return delCount;
}

@end
