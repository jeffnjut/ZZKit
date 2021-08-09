//
//  AppDelegate.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZWebView.h"
#import "NSString+ZZKit.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self applyNotificationAuth];
    NSLog(@"%d", [@"" zz_greaterThan:@""] == false);
    NSLog(@"%d", [@"1" zz_greaterThan:@""] == true);
    
    NSLog(@"%d", [@"8.4.2" zz_greaterThan:@"8.4.1"] == true);
    NSLog(@"%d", [@"8.4.2" zz_greaterThan:@"8.3.9"] == true);
    NSLog(@"%d", [@"9.4.2" zz_greaterThan:@"8.3.9"] == true);
    NSLog(@"%d", [@"8.4.2" zz_greaterThan:@"8.4"] == true);
    NSLog(@"%d", [@"8.5" zz_greaterThan:@"8.4.1"] == true);
    
    NSLog(@"%d", [@"8.4.0" zz_greaterThan:@"8.4"] == false);
    NSLog(@"%d", [@"7.4.2" zz_greaterThan:@"8.3.9"] == false);
    NSLog(@"%d", [@"8.1.2" zz_greaterThan:@"8.3.9"] == false);
    NSLog(@"%d", [@"8.3.2" zz_greaterThan:@"8.3.9"] == false);
    NSLog(@"%d", [@"8.5" zz_greaterThan:@"9"] == false);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 推送

- (void)applyNotificationAuth {
    
    if (@available(iOS 10.0, *)) {
        // 通知中心
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        // 创建通知分类
        UNTextInputNotificationAction *textInputAction = [UNTextInputNotificationAction actionWithIdentifier:@"textInputAction"
                                                                                                       title:@"输入信息" options:UNNotificationActionOptionAuthenticationRequired
                                                                                        textInputButtonTitle:@"输入"
                                                                                        textInputPlaceholder:@"还有多少话要说..."];
        
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"foreGround"
                                                                             title:@"打开"
                                                                           options:UNNotificationActionOptionForeground];
        
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"backGround"
                                                                             title:@"关闭"
                                                                           options:UNNotificationActionOptionDestructive];
        
        UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1"
                                                                                   actions:@[textInputAction, action1, action2]
                                                                         intentIdentifiers:@[]
                                                                                   options:UNNotificationCategoryOptionCustomDismissAction];
        
        [center setNotificationCategories:[NSSet setWithObjects:category1, nil]];
        
        // 请求授权
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                NSLog(@"授权成功");
            }
        }];
        
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - UNUserNotificationCenterDelegate

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)) {
    
    // APP处于前台收到通知
    //弹出一个网页
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 400, 500)];
    webview.center = self.window.center;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.window addSubview:webview];
    
    //弹出动画
    webview.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        webview.alpha = 1;
    }];
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0)) __API_UNAVAILABLE(tvos) {
    
    //根据identifer判断按钮类型，如果是textInput则获取输入的文字
    if ([response.actionIdentifier isEqualToString:@"textInputAction"]) {
        
        //获取文本响应
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
        NSLog(@"输入的内容为：%@",textResponse.userText);
    }
    
    //处理其他时间
    NSLog(@"%@",response.actionIdentifier);
}

// The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification __API_AVAILABLE(macos(10.14), ios(12.0)) __API_UNAVAILABLE(watchos, tvos) {
    
    NSLog(@"");
}

@end
