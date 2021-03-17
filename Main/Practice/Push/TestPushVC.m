//
//  TestPushVC.m
//  ZZKit
//
//  Created by Fu Jie on 2021/3/10.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "TestPushVC.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface TestPushVC ()

@end

@implementation TestPushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tapLocalNotification:(id)sender {
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            NSLog(@"当前通知授权状态:%zd", settings.authorizationStatus);
            
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                
                // 创建通知内容
                
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.title = @"ZZKit";
                content.subtitle = @"测试通知";
                content.body = @"欢迎来到ZZKit";
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @99;
                
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
                
                // 通知设置分类
                content.categoryIdentifier = @"category1";
                
                // 添加附件
                NSString *path = [[NSBundle mainBundle] pathForResource:@"wmd" ofType:@"jpg"];
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image"
                                                                                                      URL:[NSURL fileURLWithPath:path]
                                                                                                  options:nil
                                                                                                    error:nil];
                content.attachments = @[attachment];
                
                // 创建通知请求
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"localNotification" content:content trigger:trigger];
                
                // 添加通知请求
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    
                    if (error == nil) {
                        NSLog(@"发送通知成功");
                    }else {
                        NSLog(@"%@", error);
                    }
                }];
                
            }
            
        }];
    } else {
        
    }
}

- (IBAction)tapLocalRemoveNotification:(id)sender {
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        // 删除未送达的通知
        [center removeAllPendingNotificationRequests];
        
        // 删除已送达的通知
        [center removeAllDeliveredNotifications];
    } else {
        // Fallback on earlier versions
    }
}

- (IBAction)tapLocalRemoveSpecifiedNotification:(id)sender {
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        // 删除未送达的通知
        [center removeDeliveredNotificationsWithIdentifiers:@[@"localNotification"]];
        
        // 删除已送达的通知
        [center removePendingNotificationRequestsWithIdentifiers:@[@"localNotification"]];
    } else {
        // Fallback on earlier versions
    }
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
