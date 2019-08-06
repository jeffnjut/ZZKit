//
//  ZZTrace.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZTraceObject,ZZTraceBatchData;

// BI事件类型
#define ZZTraceEventLaunch    @"launch"
#define ZZTraceEventPageView  @"pageView"
#define ZZTraceEventEvent     @"event"

// 公共参数类型
#define ZZParamUID            @"userID"
#define ZZParamAdsID          @"adsID"
#define ZZParamBusinessID     @"businessID"
#define ZZParamVersion        @"version"
#define ZZParamPlatform       @"platform"
#define ZZParamDevice         @"device"
#define ZZParamTraceEvent     @"traceEvent"
#define ZZParamTime           @"time"
#define ZZParamExternal       @"externalChannel"
#define ZZParamChannel        @"channel"
#define ZZParamKeyValues      @"kv"
#define ZZParamCurrentPV      @"pageView"
#define ZZParamCurrentPVHash  @"pageViewHash"
#define ZZParamPreviousPV     @"previousPageView"
#define ZZParamPreviousPVHash @"previousPageViewHash"
#define ZZParamEventID        @"eventID"

// 上传策略
typedef NS_ENUM(NSInteger, ZZTraceUploadPolicy) {
    ZZTraceUploadPolicyImmediate,   // 即时上传
    ZZTraceUploadPolicyBatch        // 批量上传
};

typedef void(^ZZNetworkVoidBlock)(void);

typedef void(^ZZUploadImmediateBlock)(ZZTraceObject *object, ZZNetworkVoidBlock success, ZZNetworkVoidBlock error);

typedef void(^ZZUploadBatchBlock)(ZZTraceBatchData *data, ZZNetworkVoidBlock success, ZZNetworkVoidBlock error);

#pragma mark - ZZTraceConfig

@interface ZZTraceConfig : NSObject

// 上传策略
@property (nonatomic, assign) ZZTraceUploadPolicy uploadPolicy;

// 上传策略（失败复传）
@property (nonatomic, assign) ZZTraceUploadPolicy retryUploadPolicy;

// Debug的Windows
@property (nonatomic, copy) UIWindow*(^keyWindow)(void);

// 即时上传回调，用户实现[上传TraceObject，如果有异常回调error]
@property (nonatomic, copy) ZZUploadImmediateBlock uploadImmediateBlock;

// 批量上传回调，用户实现[上传TraceBatchData，如果有正常回调success]
@property (nonatomic, copy) ZZUploadBatchBlock uploadBatchBlock;

@end

#pragma mark - ZZTraceCommonObject

@interface ZZTraceCommonObject : NSObject

// 用户ID
@property (nonatomic, copy) NSString *userID;
// AdervertisementID (安卓GAID，苹果IDFA)
@property (nonatomic, copy) NSString *adsID;
// 业务ID BusinessID（哪个APP）
@property (nonatomic, copy) NSString *businessID;
// 应用版本号
@property (nonatomic, copy) NSString *version;
// 平台（iOS/Android平台）
@property (nonatomic, copy) NSString *platform;
// Device信息（设备信息，例如："v=iOS12.1.4&model=iphone5s&width=320.0&height=480.0&lng=121.122&lat=31.239"）
@property (nonatomic, copy) NSString *device;
// 渠道（APP外渠道,自然，魔窗，推送）
@property (nonatomic, copy) NSString *externalChannel;

@end

#pragma mark - ZZTraceObject

@interface ZZTraceObject : ZZTraceCommonObject

// TraceEvent 版本号
@property (nonatomic, copy) NSString *format;

// TraceEvent 跟踪记录的类型（launch, pageView, event）
@property (nonatomic, copy) NSString *traceEvent;
// 时间（TimeStamp Since 1970）
@property (nonatomic, assign) long long time;
// 渠道（APP内渠道，橱窗编码）
@property (nonatomic, copy) NSString *channel;

// 预留参数
// Launch事件：保存额外传入的参数用于跟踪
// PageView事件：描述当前页面的ID或者关键字
// Event事件：描述当前动作的ID或者关键字
@property (nonatomic, copy) NSString *kv;

///// PageView事件 /////
// 当前页面标识（Controller或Activiyty的类型编码）
@property (nonatomic, copy) NSString *pageView;
// 当前页面Hash（Controller或Activiyty的内存Hash）
@property (nonatomic, copy) NSString *pageViewHash;
// 当前页面Hashw完整路径（以逗号分隔，Controller或Activiyty的内存Hash）
@property (nonatomic, copy) NSString *pageViewHashFullPath;
// 前一页面标识
@property (nonatomic, copy) NSString *previousPageView;
// 前一页面Hash
@property (nonatomic, copy) NSString *previousPageViewHash;
// 当前页面深度
@property (nonatomic, assign) int depth;

///// Event事件 /////
// Event事件动作（Event编码）
@property (nonatomic, copy) NSString *eventID;

@end

@protocol ZZTraceObject <NSObject>
@end

#pragma mark - ZZTraceBatchData

@interface ZZTraceBatchData : ZZTraceCommonObject

// 用户的Trace数据
@property (nonatomic, strong) NSMutableArray<ZZTraceObject> *traces;

@end

@protocol ZZTraceBatchData <NSObject>

@end

@protocol ZZTraceDelegate <NSObject>

@required

- (NSString *)zz_tracePVType;

- (NSUInteger)zz_tracePVValue;

@end

#pragma mark - ZZTrace

@interface ZZTrace : NSObject

// 设置Config
+ (void)updateConfig:(ZZTraceConfig *)config;

// 更新APP内渠道、橱窗位
+ (void)updateChannel:(NSString *)channel channelKV:(NSDictionary *)channelKV;

// 埋点（更新Launch事件的Params）
+ (void)updateParams:(NSDictionary *)params;

// 埋点（更新Controller对应的PV值）
+ (void)updatePVDictionary:(NSDictionary *)pvs;

// 埋点（Launch事件）
+ (void)traceLaunch:(ZZTraceCommonObject *)traceCommonObject;

// 埋点（PageView事件）
+ (void)tracePageView:(__kindof UIViewController *)page prePage:(__kindof UIViewController *)prePage;

// 埋点（Event事件）
+ (void)traceEvent:( NSString * _Nonnull )eventId kv:(NSDictionary *)kv page:(__kindof UIViewController *)page;

@end

NS_ASSUME_NONNULL_END
