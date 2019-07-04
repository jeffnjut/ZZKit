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

@interface ZZWebView () <UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    @private
    ZZWebViewType _type;
    UIWebView *_webView;
    WKWebView *_wkWebView;
    JSContext *_context;
    BOOL _addedJavaScriptProcess;
}

@end

@implementation ZZWebView

#pragma mark - Property Setting & Getter

- (UIWebView *)webView {
    
    return _webView;
}

- (WKWebView *)wkWebView {
    
    return _wkWebView;
}

- (JSContext *)zzContext {
    
    return _context;
}

- (WKWebViewConfiguration *)wkConfiguration {
    
    return _wkWebView.configuration;
}

- (void)setZzProcessJavaScriptCallingDictionary:(NSDictionary<NSString *,id> *)zzProcessJavaScriptCallingDictionary {
    
    _zzProcessJavaScriptCallingDictionary = zzProcessJavaScriptCallingDictionary;
    if (_context) {
        __weak typeof(self) weakSelf = self;
        [zzProcessJavaScriptCallingDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->_context[key] = obj;
        }];
        _addedJavaScriptProcess = YES;
    }
}

#pragma mark - Public Method

/**
 *  加载HTML文本
 */
- (void)zz_loadHTMLStringL:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL {
    
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        [_webView loadHTMLString:string baseURL:baseURL];
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        
    }
}

/**
 *  加载本地HTML文件
 */
- (void)zz_loadRequest:(nonnull NSString *)fileName ofType:(nonnull NSString *)ofType bunlde:(nullable NSBundle *)bundle headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields {
    
    NSBundle *_bundle = bundle;
    if (!_bundle) {
        _bundle = [NSBundle mainBundle];
    }
    NSString *path = [_bundle pathForResource:fileName ofType:ofType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    for (NSString *headerField in headerFields.allKeys) {
        NSString *value = headerFields[headerField];
        [request addValue:value forHTTPHeaderField:headerField];
    }
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        [_webView loadRequest:request];
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        [_wkWebView loadRequest:request];
    }
}

/**
 *  加载URL
 */
- (void)zz_loadRequest:(nonnull NSString *)url headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    for (NSString *headerField in headerFields.allKeys) {
        NSString *value = headerFields[headerField];
        [request addValue:value forHTTPHeaderField:headerField];
    }
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        [_webView loadRequest:request];
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        [_wkWebView loadRequest:request];
    }
}

/**
 *  OC执行JavaScript,没有异常捕获
 */
- (nullable NSString *)zz_evaluateScript:(nonnull NSString *)script {
    
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        return [_webView stringByEvaluatingJavaScriptFromString:@"document.titledss"];
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        
    }
    return nil;
}

/**
 *  OC执行JavaScript,回调有异常捕获
 */
- (void)zz_evaluateScript:(nonnull NSString *)script result:(void(^)(JSContext *context, JSValue *value, JSValue *exception))result {
    
    __weak typeof(self) weakSelf = self;
    if (_type == ZZWebViewTypeUIWebView && _webView != nil) {
        
        if (_context == nil) {
            _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        }
        __block BOOL _isErrorRaised = NO;
        _context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            _isErrorRaised = YES;
            result == nil ? : result(context, nil, exception);
        };
        JSValue *jsValue = [_context evaluateScript:script];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if (!_isErrorRaised && result != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    result(strongSelf->_context, jsValue, nil);
                });
            }
        });
    }else if (_type == ZZWebViewTypeWKWebView && _wkWebView != nil) {
        
    }
}

/**
 *  快速新建ZZWebView的方法
 */
+ (nonnull ZZWebView *)zz_quickAdd:(ZZWebViewType)type onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock {
    
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
    [zzWebView _buildUI];
    return zzWebView;
}

/**
 *  URL Schemes时候执行处理方法
 */
+ (BOOL)zz_handleOpenURL:(nonnull NSURL *)url option:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)option {
    
    ZZWebView *zzWebView = [ZZWebView _getActiveZZWebView];
    if (zzWebView != nil && zzWebView.zzOpenURLBlock != nil) {
        return zzWebView.zzOpenURLBlock(url, option);
    }
    return NO;
}

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
        _wkWebView.allowsLinkPreview = YES;
        // 自定义UA，UIWebView就没有此功能，后面会讲到通过其他方式实现
        _wkWebView.customUserAgent = @"WebViewDemo/1.0.0";
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        [self addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
    if (self.zzShouldLoadRequestBlock != nil) {
        
        return self.zzShouldLoadRequestBlock(request);
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
    if (_context == nil) {
        _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    
    if (!_addedJavaScriptProcess) {
        __weak typeof(self) weakSelf = self;
        [_zzProcessJavaScriptCallingDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->_context[key] = obj;
        }];
        _addedJavaScriptProcess = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

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
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
