//
//  ZZLBSBackgroundTask.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZLBSBackgroundTask : NSObject

/**
 *  单例
 */
+ (ZZLBSBackgroundTask *)sharedTask;

/**
 *  开启新的后台任务
 */
- (UIBackgroundTaskIdentifier)zz_beginNewBackgroundTask;

/**
 *  停止后台任务
 *  all : yes 关闭所有 ,no 只留下主后台任务
 *  note : all = yes 为了去处多余残留的后台任务，只保留最新的创建的
 */
-(void)zz_endBackGroundTask:(BOOL)all;

@end

@interface ZZLBSBackgroundTaskManager : NSObject

/**
 *  单例
 */
+ (CLLocationManager *)shared;

/**
 *  开始监听GPS Location监听服务
 */
- (void)zz_startLocation:(void(^)(void))disabledBlock notAuthorizatedBlock:(void(^)(void))notAuthorizatedBlock authorizedBlock:(void(^)(void))authorizedBlock updateLocationBlock:(void(^)(CLLocation *location))updateLocationBlock errorBlock:(void(^)(NSError *error, NSString *title, NSString *message))errorBlock;

/**
 *  停止监听GPS Location监听服务
 */
- (void)zz_stopLocation;

@end

NS_ASSUME_NONNULL_END
