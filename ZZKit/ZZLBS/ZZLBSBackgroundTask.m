//
//  ZZLBSBackgroundTask.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLBSBackgroundTask.h"
#import "ZZMacro.h"

@interface ZZLBSBackgroundTask ()

// 后台任务数组
@property (nonatomic, strong) NSMutableArray *taskIdList;

// 当前后台任务id
@property (nonatomic, assign) UIBackgroundTaskIdentifier masterTaskId;

@end

@implementation ZZLBSBackgroundTask

/**
 *  单例
 */
+ (ZZLBSBackgroundTask *)sharedTask {
    
    static ZZLBSBackgroundTask *task;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        task = [[ZZLBSBackgroundTask alloc] init];
    });
    return task;
}

/**
 *  初始化
 */
- (instancetype)init {
    
    if (self == [super init]) {
        _taskIdList = [[NSMutableArray alloc] init];
        _masterTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

/**
 *  开启新的后台任务
 */
- (UIBackgroundTaskIdentifier)zz_beginNewBackgroundTask {
    
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    @try {
        bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            
            ZZLog(@"bgTask 过期 %lu",(unsigned long)bgTaskId);
            
            // 过期任务从后台数组删除
            [self.taskIdList removeObject:@(bgTaskId)];
            bgTaskId = UIBackgroundTaskInvalid;
            [application endBackgroundTask:bgTaskId];
        }];
    }@catch (NSException *ex) {}
    // 如果上次记录的后台任务已经失效了，就记录最新的任务为主任务
    if (_masterTaskId == UIBackgroundTaskInvalid) {
        self.masterTaskId = bgTaskId;
        ZZLog(@"开启后台任务 %lu",(unsigned long)bgTaskId);
    }else {
        // 如果上次开启的后台任务还未结束，就提前关闭了，使用最新的后台任务
        // add this id to our list
        ZZLog(@"保持后台任务 %lu", (unsigned long)bgTaskId);
        [self.taskIdList addObject:@(bgTaskId)];
        [self zz_endBackGroundTask:NO];//留下最新创建的后台任务
    }
    return bgTaskId;
}

/**
 *  停止后台任务
 *  all : yes 关闭所有 ,no 只留下主后台任务
 *  note : all = yes 为了去处多余残留的后台任务，只保留最新的创建的
 */
-(void)zz_endBackGroundTask:(BOOL)all {
    
    UIApplication *application = [UIApplication sharedApplication];
    // 如果为all 清空后台任务数组
    // 不为all 留下数组最后一个后台任务,也就是最新开启的任务
    @try {
        for (int i = 0; i < (all ? _taskIdList.count : _taskIdList.count - 1); i++) {
            UIBackgroundTaskIdentifier bgTaskId = [self.taskIdList[0]integerValue];
            ZZLog(@"关闭后台任务 %lu",(unsigned long)bgTaskId);
            [application endBackgroundTask:bgTaskId];
            [self.taskIdList removeObjectAtIndex:0];
        }
    }@catch (NSException *ex) {}
    // 如果数组大于0 所有剩下最后一个后台任务正在跑
    if(self.taskIdList.count > 0) {
        ZZLog(@"后台任务正在保持运行 %ld",(long)[_taskIdList[0]integerValue]);
    }
    if(all) {
        [application endBackgroundTask:self.masterTaskId];
        self.masterTaskId = UIBackgroundTaskInvalid;
    }else {
        ZZLog(@"kept master background task id %lu", (unsigned long)self.masterTaskId);
    }
}

@end

@interface ZZLBSBackgroundTaskManager () <CLLocationManagerDelegate>

// 后台任务
@property (nonatomic, strong) ZZLBSBackgroundTask *task;

// 更新LBS回调
@property (nonatomic, copy) void(^updateLocationBlock)(CLLocation *location);

// 异常回调
@property (nonatomic, copy) void(^errorBlock)(NSError *error, NSString *alertTitle, NSString *alertMessage);

@end

@implementation ZZLBSBackgroundTaskManager

#pragma mark - 初始化API

/**
 *  初始化
 */
- (instancetype)init {
    
    if(self == [super init]) {
        
        self.task = [ZZLBSBackgroundTask sharedTask];
        
        //监听进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

#pragma mark - Public API

/**
 *  单例
 */
+ (CLLocationManager *)shared {
    
    static CLLocationManager *SINGLETON;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        SINGLETON = [[CLLocationManager alloc] init];
        SINGLETON.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        SINGLETON.distanceFilter = kCLDistanceFilterNone;
        if (@available(iOS 9.0, *)) {
            SINGLETON.allowsBackgroundLocationUpdates = YES;
        }
        SINGLETON.pausesLocationUpdatesAutomatically = NO;
    });
    return SINGLETON;
}

/**
 *  开始监听GPS Location监听服务
 */
- (void)zz_startLocation:(void(^)(void))disabledBlock notAuthorizatedBlock:(void(^)(void))notAuthorizatedBlock authorizedBlock:(void(^)(void))authorizedBlock updateLocationBlock:(void(^)(CLLocation *location))updateLocationBlock errorBlock:(void(^)(NSError *error, NSString *title, NSString *message))errorBlock {
    
    self.errorBlock = errorBlock;
    self.updateLocationBlock = updateLocationBlock;
    
    // 开启定位
    if ([CLLocationManager locationServicesEnabled] == NO) {
        disabledBlock == nil ? : disabledBlock();
    }else {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if( authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted ){
            notAuthorizatedBlock == nil ? : notAuthorizatedBlock();
        } else {
            CLLocationManager *locationManager = [ZZLBSBackgroundTaskManager shared];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.delegate = self;
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

/**
 *  停止监听GPS Location监听服务
 */
- (void)zz_stopLocation {
    
    CLLocationManager *locationManager = [ZZLBSBackgroundTaskManager shared];
    [locationManager stopUpdatingLocation];
}

#pragma mark - Private API

//后台监听方法
- (void)_applicationEnterBackground {
    
    // 进入后台
    CLLocationManager *locationManager = [ZZLBSBackgroundTaskManager shared];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    // 不移动也可以后台刷新回调
    if (@available(iOS 8.0, *)) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_task zz_beginNewBackgroundTask];
}

/**
 *  重启监听GPS Location监听服务
 */
- (void)_restartLocation {
    
    // 重新启动定位
    CLLocationManager *locationManager = [ZZLBSBackgroundTaskManager shared];
    locationManager.delegate = self;
    // 不移动也可以后台刷新回调
    locationManager.distanceFilter = kCLDistanceFilterNone;
    if (@available(iOS 8.0, *)) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_task zz_beginNewBackgroundTask];
}

#pragma mark - CLLocationManagerDelegate

// 定位回调里执行重启定位和关闭定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.updateLocationBlock == nil ? : self.updateLocationBlock(locations[0]);
}

// 异常
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    switch([error code])
    {
        case kCLErrorNetwork:
        {
            // general, network-related error
            self.errorBlock == nil ? : self.errorBlock(error, @"网络错误", @"请检查网络连接");
        }
            break;
        case kCLErrorDenied:
        {
            self.errorBlock == nil ? : self.errorBlock(error, @"请开启后台服务", @"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启");
        }
            break;
        default:
            self.errorBlock == nil ? : self.errorBlock(error, @"GPS错误", @"GPS错误");
            break;
    }
}


@end
