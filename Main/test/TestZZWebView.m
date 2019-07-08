//
//  TestZZWebView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/3.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZWebView.h"
#import "ZZWebView.h"
#import "UIView+ZZKit_Blocks.h"
#import "UIViewController+ZZKit.h"
#import "NSString+ZZKit.h"
#import <Masonry/Masonry.h>
#import <Typeset/Typeset.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TestZZWebView ()

@property (nonatomic, strong) ZZWebView *webView;

@end

@implementation TestZZWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self testWKWebView];
}

- (void)testWKWebView {
    
    __weak typeof(self) weakSelf = self;
    self.webView = [ZZWebView zz_quickAdd:ZZWebViewTypeWKWebView onView:self.view frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    }];

    
    // 添加脚本
    // WKUserScript *newCookieScript = [[WKUserScript alloc] initWithSource:@"document.cookie = 'DarkAngelCookie=DarkAngel;'" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    // WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:@"alert(document.cookie);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];

    // [self.webView.wkConfiguration.userContentController addUserScript:newCookieScript];
    // [self.webView.wkConfiguration.userContentController addUserScript:cookieScript];
    
    static NSString *jsSource;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    });
    //添加自定义的脚本
    // WKUserScript *js = [[WKUserScript alloc] initWithSource:jsSource injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    // [self.webView.zzWKConfiguration.userContentController addUserScript:js];
    
    [self.webView zz_loadRequest:@"test" ofType:@"html" bunlde:nil headerFields:@{@"A":@"AAA",@"Set-Cookie":@"customCookieName=1314521;"}];
    
    /*
     share({
     title: "title",
     imgUrl: "http://img.dd.com/xxx.png",
     link: location.href,
     result: function(res) {
     // 函数作为参数
     myAlert(res);
     // setTimeout(function(){alert(res);},0);
     // console.log(res ? "success" : "failure");
     }
     });
     */
    
    self.webView.zzWKWebViewProcessJavaScriptCallingDictionary =
    @{
      @"Call": ^(WKUserContentController *controller, WKScriptMessage *message) {
          NSLog(@"name : %@\nbody : %@", message.name, message.body);
      },
      @"share": ^(WKUserContentController *controller, WKScriptMessage *message) {
          NSLog(@"name : %@\nbody : %@", message.name, message.body);
          // 模拟回调
          __block NSString *script = [message.body objectForKey:@"callback"];
          script = [script stringByReplacingOccurrencesOfString:@"__PARAM__" withString:[NSString stringWithFormat:@"\'%@\'", [message.body objectForKey:@"title"]]];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [weakSelf.webView zz_evaluateScript:script result:^(JSContext * _Nonnull context, ZZWebViewJavaScriptResult * _Nonnull data) {
                  if (data.error) {
                      NSLog(@"异常：%@", data.error);
                  }else {
                      NSLog(@"%@", data.data);
                  }
              }];
          });
      }
      };
    
    [self zz_navigationAddRightBarTextButton:@"OC调JavaScript".typeset.string action:^{
        
        [weakSelf.webView zz_evaluateScript:@"myAlert('hahah')" result:^(JSContext * _Nonnull context, ZZWebViewJavaScriptResult * _Nonnull data) {
            if (data.error) {
                NSLog(@"异常：%@", data.error);
            }else {
                NSLog(@"%@", data.data);
            }
        }];
    }];
    
    self.webView.zzWebNavigationBlock = ^BOOL(ZZWebViewNavigationStatus status, UIWebView * _Nullable webView, WKWebView * _Nullable wkWebView, NSURLRequest * _Nullable request, UIWebViewNavigationType type, WKNavigationAction * _Nullable navigationAction, WKNavigationResponse * _Nullable navigationResponse, WKNavigation * _Nullable navigation, void (^ _Nullable decisionRequestHandler)(WKNavigationActionPolicy), void (^ _Nullable decisionResponseHandler)(WKNavigationResponsePolicy), NSError * _Nullable error) {
        if (status == ZZWebViewNavigationStatusDecidePolicyForNavigationAction) {
            NSString *url = navigationAction.request.URL.absoluteString;
            if ([url hasPrefix:@"zzkit://"]) {
                decisionRequestHandler(WKNavigationActionPolicyCancel);
            }else if ([url hasPrefix:@"ifly://"]) {
                decisionRequestHandler(WKNavigationActionPolicyCancel);
            }else if ([url hasPrefix:@"https://"]) {
                decisionRequestHandler(WKNavigationActionPolicyAllow);
            }else if ([url hasPrefix:@"http://"]) {
                decisionRequestHandler(WKNavigationActionPolicyCancel);
            }
            decisionRequestHandler(WKNavigationActionPolicyAllow);
        }else if (status == ZZWebViewNavigationStatusDecidePolicyForNavigationResponse) {
            decisionResponseHandler(WKNavigationResponsePolicyAllow);
        }
        return YES;
    };
    
    self.webView.zzWebViewOpenURLBlock = ^BOOL(NSURL * _Nonnull url, NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nonnull options) {
        
        if ([url.absoluteString hasPrefix:@"zzkit://"]) {
            UIViewController *testVC = [[UIViewController alloc] init];
            testVC.view.backgroundColor = [UIColor redColor];
            [weakSelf.navigationController zz_push:testVC animated:YES];
            
            [testVC.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
                UIViewController *controller = (UIViewController *)[sender nextResponder];
                if ([controller isKindOfClass:[UIViewController class]]) {
                    [controller zz_dismiss];
                }
            }];
            return YES;
        }else if ([url.absoluteString hasPrefix:@"ifly://"]) {
            
        }
        return NO;
    };
}

- (void)testUIWebView {
    
    __weak typeof(self) weakSelf = self;
    self.webView = [ZZWebView zz_quickAdd:ZZWebViewTypeUIWebView onView:self.view frame:CGRectMake(0, 0, 0, 0) constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    self.webView.zzWebNavigationBlock = ^BOOL(ZZWebViewNavigationStatus status, UIWebView * _Nullable webView, WKWebView * _Nullable wkWebView, NSURLRequest * _Nullable request, UIWebViewNavigationType type, WKNavigationAction * _Nullable navigationAction, WKNavigationResponse * _Nullable navigationResponse, WKNavigation * _Nullable navigation, void (^ _Nullable decisionRequestHandler)(WKNavigationActionPolicy), void (^ _Nullable decisionResponseHandler)(WKNavigationResponsePolicy), NSError * _Nullable error) {
        NSString *url = request.URL.absoluteString;
        if ([url hasPrefix:@"zzkit://"]) {
            return YES;
        }else if ([url hasPrefix:@"ifly://"]) {
            return YES;
        }else if ([url hasPrefix:@"https://"]) {
            return YES;
        }else if ([url hasPrefix:@"http://"]) {
            return NO;
        }
        return YES;
    };
    
    self.webView.zzWebViewOpenURLBlock = ^BOOL(NSURL * _Nonnull url, NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nonnull options) {
        
        if ([url.absoluteString hasPrefix:@"zzkit://"]) {
            UIViewController *testVC = [[UIViewController alloc] init];
            testVC.view.backgroundColor = [UIColor redColor];
            [weakSelf.navigationController zz_push:testVC animated:YES];
            
            [testVC.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
                UIViewController *controller = (UIViewController *)[sender nextResponder];
                if ([controller isKindOfClass:[UIViewController class]]) {
                    [controller zz_dismiss];
                }
            }];
            return YES;
        }else if ([url.absoluteString hasPrefix:@"ifly://"]) {
            
        }
        return NO;
    };
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    //    [request setValue:@"A" forHTTPHeaderField:@"User-Agent"];
    //    [request setValue:@"A" forHTTPHeaderField:@"A"];
    //    [self.webView.webView loadRequest:request];
    
    
    [self.webView zz_loadRequest:@"test" ofType:@"html" bunlde:nil headerFields:@{@"A":@"AAA",@"Set-Cookie":@"customCookieName=1314521;"}];
    
    //    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{
    //                                                                NSHTTPCookieName: @"customCookieName",
    //                                                                NSHTTPCookieValue: @"1314521",
    //                                                                NSHTTPCookieDomain: @".baidu.com",
    //                                                                NSHTTPCookiePath: @"/"
    //                                                                }];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [self.webView zz_loadRequest:@"https://www.baidu.com" headerFields:nil];
    
    [self zz_navigationAddRightBarTextButton:@"OC调JavaScript".typeset.string action:^{
        
        [weakSelf.webView zz_evaluateScript:@"document.title" result:^(JSContext * _Nonnull context, ZZWebViewJavaScriptResult * _Nonnull data) {
            if (data.error) {
                NSLog(@"异常：%@", data.error);
            }else {
                NSLog(@"%@", data.data);
            }
        }];
    }];
    
    self.webView.zzUIWebViewProcessJavaScriptCallingDictionary =
    
    @{@"share" : ^(JSValue *shareData) {
        //首先这里要注意，回调的参数不能直接写NSDictionary类型，为何呢？
        //仔细看，打印出的确实是一个NSDictionary，但是result字段对应的不是block而是一个NSDictionary
        NSLog(@"%@", [shareData toObject]);
        //获取shareData对象的result属性，这个JSValue对应的其实是一个javascript的function。
        JSValue *resultFunction = [shareData valueForProperty:@"result"];
        //回调block，将js的function转换为OC的block
        __block void (^result)(BOOL) = ^(BOOL isSuccess) {
            [resultFunction callWithArguments:@[@(isSuccess)]];
        };
        //模拟异步回调
        dispatch_async(dispatch_get_main_queue(), ^{
            result(YES);
        });
        
    },
      @"add" : ^NSString* (NSInteger a, NSInteger b){
          return [NSString stringWithFormat:@"%ld+%ld=%ld", a, b , a+b];
      },
      @"callNative" : ^(){
          [weakSelf.webView zz_loadRequest:@"https://www.baidu.com" headerFields:@{@"B":@"CCC",@"Set-Cookie":@"customCookieName=1314521;"}];
      }
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
