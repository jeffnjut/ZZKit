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
    if (zzWebView != nil && zzWebView.zzWebViewOpenURLBlock != nil) {
        return zzWebView.zzWebViewOpenURLBlock(url, option);
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

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
}
*/

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
            NSDictionary *args = [_dict objectForKey:@"arguments"];
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

@implementation ZZWebViewJavaScriptResult

+ (ZZWebViewJavaScriptResult *)create {
    
    ZZWebViewJavaScriptResult *result = [[ZZWebViewJavaScriptResult alloc] init];
    return result;
}

@end
