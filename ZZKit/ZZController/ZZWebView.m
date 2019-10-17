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

@interface ZZWebView () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *zzWKWebView;

@property (nonatomic, strong) UIProgressView *zzProgressView;

@property (nonatomic, strong) UIColor *zzProgressBarTintColor;

@property (nonatomic, assign) double zzEstimatedProgress;

@end

@implementation ZZWebView

- (void)dealloc {
    
    for (NSString *name in _zzWKWebViewProcessJavaScriptCallingDictionary.allKeys) {
        [self.zzWKConfiguration.userContentController removeScriptMessageHandlerForName:name];
    }
    
    if (_zzProgressBarTintColor) {
        [_zzWKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [_zzWKWebView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - Property Setting & Getter

- (UIProgressView *)zzProgressView {
    
    if (_zzProgressView == nil) {
        _zzProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
       [ _zzProgressView setTrackTintColor:[UIColor whiteColor]];
        [_zzProgressView setProgressTintColor:_zzProgressBarTintColor ? _zzProgressBarTintColor : @"#FF7A00".zz_color];
        [self addSubview:_zzProgressView];
        __weak typeof(self) weakSelf = self;
        [_zzProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(weakSelf);
            make.height.equalTo(@2.0);
        }];
    }
    return _zzProgressView;
}

- (WKWebViewConfiguration *)zzWKConfiguration {
    
    return _zzWKWebView.configuration;
}

- (void)setZzWKWebViewProcessJavaScriptCallingDictionary:(NSDictionary<NSString *,ZZUserContentProcessJavaScriptMessageBlock> *)zzWKWebViewProcessJavaScriptCallingDictionary {

    _zzWKWebViewProcessJavaScriptCallingDictionary = zzWKWebViewProcessJavaScriptCallingDictionary;
    for (NSString *name in zzWKWebViewProcessJavaScriptCallingDictionary.allKeys) {
        [self.zzWKConfiguration.userContentController addScriptMessageHandler:self name:name];
    }
}

#pragma mark - Public Method

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
+ (void)zz_clearAllCachedResponseWebsiteDataTypes:(nullable NSArray<NSString *> *)wkWebsiteDataTypes {
            
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

/**
 *  清除某一个URL缓存的方法
 */
+ (void)zz_clearCachedResponse:(nonnull NSURL *)URL {
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:URL]];
}

/**
 *  加载HTML文本
 */
- (void)zz_loadHTMLString:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields {
    
    [self.zzWKWebView loadHTMLString:string baseURL:baseURL];
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
    
    if (@available(iOS 11.0, *)) {
        // WKWebView iOS 11以及以上
        [self _copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
            for (NSString *headerField in headerFields.allKeys) {
                NSString *value = headerFields[headerField];
                [request addValue:value forHTTPHeaderField:headerField];
            }
            [weakSelf.zzWKWebView loadRequest:request];
        }];
    }else {
        for (NSString *headerField in headerFields.allKeys) {
            NSString *value = headerFields[headerField];
            [request addValue:value forHTTPHeaderField:headerField];
        }
        [self.zzWKWebView loadRequest:request];
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
    
    if (@available(iOS 11.0, *)) {
        // WKWebView iOS 11以及以上
        [self _copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:^{
            for (NSString *headerField in headerFields.allKeys) {
                NSString *value = headerFields[headerField];
                [request addValue:value forHTTPHeaderField:headerField];
            }
            [weakSelf.zzWKWebView loadRequest:request];
        }];
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
        [weakSelf.zzWKWebView loadRequest:request];
    }
}

/**
 *  OC执行JavaScript,回调有异常捕获
 */
- (void)zz_evaluateScript:(nonnull NSString *)script result:(nullable void(^)(JSContext *context, ZZWebViewJavaScriptResult *data))result {
    
    [self.zzWKWebView evaluateJavaScript:script completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
        ZZWebViewJavaScriptResult *resultData = [ZZWebViewJavaScriptResult create];
        resultData.wkData = data;
        resultData.wkError = error;
        result == nil ? : result(nil, resultData);
    }];
}

/**
 *  快速新建ZZWebView的方法(默认开启进度条)
 */
+ (nonnull ZZWebView *)zz_quickAdd:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock {
    
    return [ZZWebView zz_quickAdd:onView frame:frame progressBarTintColor:@"#FF7A00".zz_color constraintBlock:constraintBlock];
}

/**
 *  快速新建ZZWebView的方法(Base)
 */
+ (nonnull ZZWebView *)zz_quickAdd:(nullable UIView *)onView frame:(CGRect)frame progressBarTintColor:(nullable UIColor *)progressBarTintColor constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock {
    
    ZZWebView *zzWebView = [[ZZWebView alloc] initWithFrame:frame];
    if (onView != nil) {
        [onView addSubview:zzWebView];
        if (constraintBlock != nil) {
            [zzWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                constraintBlock(onView, make);
            }];
        }
    }
    zzWebView.zzProgressBarTintColor = progressBarTintColor;
    [zzWebView _buildUI];
    return zzWebView;
}

#pragma mark - Private

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
    
    ZZ_WEAK_SELF
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    configuration.userContentController = controller;
    _zzWKWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    // 允许右滑返回上个链接，左滑前进
    _zzWKWebView.allowsBackForwardNavigationGestures = YES;
    // 允许链接3D Touch
    if (@available(iOS 9.0, *)) {
        _zzWKWebView.allowsLinkPreview = YES;
    } else {
        // Fallback on earlier versions
    }
    _zzWKWebView.UIDelegate = self;
    _zzWKWebView.navigationDelegate = self;
    [self addSubview:_zzWKWebView];
    [_zzWKWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    if (_zzProgressBarTintColor != nil) {
        [self zzProgressView];
        [_zzWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    [_zzWKWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Observe Estimated Progress
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    
    ZZ_WEAK_SELF
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.zzEstimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        if (_zzProgressView != nil) {
            [self bringSubviewToFront:_zzProgressView];
            [_zzProgressView setProgress:_zzEstimatedProgress animated:NO];
            if (_zzEstimatedProgress >= 0.89) {
                int64_t delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf.zzEstimatedProgress >= 0.89) {
                        // 几乎完成加载了
                    }
                });
                if (_zzEstimatedProgress == 1.0) {
                    _zzProgressView.alpha = 0;
                    _zzEstimatedProgress = 0;
                }
            }else {
                _zzProgressView.alpha = 1.0;
            }
        }
        self.zzWebViewProgressBlock == nil ? : self.zzWebViewProgressBlock(_zzEstimatedProgress);
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
        WKHTTPCookieStore *cookieStore = _zzWKWebView.configuration.websiteDataStore.httpCookieStore;
        if (cookies.count == 0) {
            !theCompletionHandler ? : theCompletionHandler();
            return;
        }
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStore setCookie:cookie completionHandler:^{
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

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDecidePolicyForNavigationAction, webView, navigationAction, nil, nil, decisionHandler, nil, nil);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDecidePolicyForNavigationResponse, webView, nil, navigationResponse, nil, nil, decisionHandler, nil);
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidStartNavigation, webView, nil, nil, navigation, nil, nil, nil);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidFinishNavigation, webView, nil, nil, navigation, nil, nil, nil);
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    if (self.zzWebNavigationBlock != nil) {
        self.zzWebNavigationBlock(ZZWebViewNavigationStatusDidFailedWithNavigation, webView, nil, nil, navigation, nil, nil, nil);
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
    [_zzWKWebView reload];
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
