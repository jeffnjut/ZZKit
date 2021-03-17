//
//  NotificationViewController.m
//  NotificationController
//
//  Created by Fu Jie on 2021/3/10.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property IBOutlet UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
    
    UNNotificationAttachment *attachment = (UNNotificationAttachment *)notification.request.content.attachments.firstObject;
    NSData *data = [NSData dataWithContentsOfURL:attachment.URL];
    self.imageView.image = [UIImage imageWithData:data];
}

@end
