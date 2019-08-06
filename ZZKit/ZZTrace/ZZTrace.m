//
//  ZZTrace.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTrace.h"
#import <YYModel/YYModel.h>
#import "ZZStorage.h"
#import "NSDate+ZZKit.h"
#import "NSDictionary+ZZKit.h"
#import "UIViewController+ZZTrace.h"

#pragma mark - ZZTraceConfig

@implementation ZZTraceConfig

@end

#pragma mark - ZZTraceCommonObject

@implementation ZZTraceCommonObject

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end

#pragma mark - ZZTraceObject

@implementation ZZTraceObject

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end

#pragma mark - ZZTraceBatchData

@implementation ZZTraceBatchData

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end

// 字符串处理Nil转空
#define FILENAME @"TraceHistory.dat"

@interface ZZTrace ()

@property (nonatomic, strong) ZZTraceBatchData *batchData;
@property (nonatomic, strong) ZZTraceConfig *config;
@property (nonatomic, copy)   NSString *channel;
@property (nonatomic, strong) NSDictionary *channelKV;
@property (nonatomic, strong) NSDictionary *pvs;

@end

#pragma mark - ZZTrace

@implementation ZZTrace

static ZZTrace *SINGLETON = nil;
static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (ZZTrace *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    return SINGLETON;
}

#pragma mark - Life Cycle
+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedInstance];
}

- (id)copy {
    
    return [[ZZTrace alloc] init];
}

- (id)mutableCopy {
    
    return [[ZZTrace alloc] init];
}

- (id)init {
    
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

- (ZZTraceBatchData *)batchData {
    
    if (_batchData == nil) {
        /* 不读文件
         NSData *d = [ZZStorage readDocumentData:FILENAME];
         if ([d length] > 0) {
         _batchData = [[TraceBatchData alloc] initWithData:d error:nil];
         __weak typeof(self) weakSelf = self;
         if (_config.reUploadPolicy == UploadPolicy_Immediate) {
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [[weakSelf class] uploadBatchLog:YES];
         });
         }else{
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [[weakSelf class] uploadBatchLog:NO];
         });
         }
         
         }else{
         _batchData = [[TraceBatchData alloc] init];
         _batchData.traces = (NSMutableArray<TraceObject> *)[[NSMutableArray alloc] init];
         }
         */
        _batchData = [[ZZTraceBatchData alloc] init];
        _batchData.traces = (NSMutableArray<ZZTraceObject> *)[[NSMutableArray alloc] init];
    }
    return _batchData;
}

// 设置Config
+ (void)updateConfig:(ZZTraceConfig *)config {
    
    ZZTrace *manager = [self sharedInstance];
    manager.config = config;
}

// 更新APP内渠道、橱窗位
+ (void)updateChannel:(NSString *)channel channelKV:(NSDictionary *)channelKV {
    
    [self sharedInstance].channel = channel;
    [self sharedInstance].channelKV = channelKV;
}

// 每次启动的时候（或其它合适时机）调用批量上传
+ (void)uploadBatchLog:(BOOL)userImmediate {
    
    ZZTrace *manager = [self sharedInstance];
    __block NSUInteger cnt = [manager.batchData.traces count];
    __weak typeof(self) weakSelf = self;
    if ([manager.batchData.traces count] > 0) {
        
        if (userImmediate == YES) {
            
            if (manager.config.uploadImmediateBlock != nil) {
                
                __block int i = (int)[manager.batchData.traces count] - 1;
                for (; i >= 0; i--) {
                    ZZTraceObject *trace = [manager.batchData.traces objectAtIndex:i];
                    [[manager.batchData yy_modelToJSONObject] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if (obj != nil) {
                            if (![key isEqualToString:@"traces"]) {
                                [trace setValue:obj forKey:key];
                            }
                        }
                    }];
                    manager.config.uploadImmediateBlock(trace, ^{
                        @synchronized (weakSelf) {
                            [manager.batchData.traces removeObjectAtIndex:i];
                            if ([manager.batchData.traces count] > 0) {
                                [ZZStorage zz_sandboxSaveData:[manager.batchData yy_modelToJSONData] name:FILENAME];
                            }else{
                                [ZZStorage zz_sandboxSaveData:[NSData new] name:FILENAME];
                            }
                        }
                        
                    }, ^{
                        
                    });
                }
            }
            
        }else{
            manager.config.uploadBatchBlock == nil ? : manager.config.uploadBatchBlock(manager.batchData, ^{
                // 上传成功
                @synchronized (weakSelf) {
                    [manager.batchData.traces removeObjectsInRange:NSMakeRange(0, cnt)];
                    [ZZStorage zz_sandboxSaveData:[NSData new] name:FILENAME];
                }
                
            }, ^{
                // 上传失败
                @synchronized (weakSelf) {
                    [ZZStorage zz_sandboxSaveData:[manager.batchData yy_modelToJSONData] name:FILENAME];
                }
            });
        }
    }
}

// 埋点（更新CommonObject）
+ (void)updateParams:(NSDictionary *)params {
    
    __block ZZTrace *manager = [self sharedInstance];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.batchData setValue:obj forKey:key];
    }];
}

// 埋点（更新Controller对应的PV值）
+ (void)updatePVDictionary:(NSDictionary *)pvs {
    
    [self sharedInstance].pvs = pvs;
}

// 埋点（Launch事件）
+ (void)traceLaunch:(ZZTraceCommonObject *)traceCommonObject {
    
    if (self.sharedInstance.config == nil || (self.sharedInstance.config.uploadImmediateBlock == nil && self.sharedInstance.config.uploadBatchBlock == nil)) {
        return;
    }
    
    __block ZZTrace *manager = [self sharedInstance];
    __block ZZTraceObject *traceObject = [[ZZTraceObject alloc] init];
    [[traceCommonObject yy_modelToJSONObject] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj != nil) {
            [manager.batchData setValue:obj forKey:key];
        }
    }];
    
    // 时间
    traceObject.time = [NSDate zz_dateTimeStampSince1970];
    
    // 事件类型（Launch, PageView, Register, Event）
    traceObject.traceEvent = ZZTraceEventLaunch;
    
    [self _upload:traceObject];
}

// 埋点（PageView事件）
+ (void)tracePageView:(__kindof UIViewController *)page prePage:(__kindof UIViewController *)prePage {
    
    if (self.sharedInstance.config == nil || (self.sharedInstance.config.uploadImmediateBlock == nil && self.sharedInstance.config.uploadBatchBlock == nil)) {
        return;
    }
    
    if (page == nil || prePage == nil) {
        return;
    }
    
    __block ZZTraceObject *traceObject = [[ZZTraceObject alloc] init];
    
    // 橱窗
    if ([self sharedInstance].channel.length > 0) {
        traceObject.channel = [self sharedInstance].channel;
        [self sharedInstance].channel = nil;
        traceObject.kv = [[self sharedInstance].channelKV zz_toJSONString];
        [self sharedInstance].channelKV = nil;
    }
    
    // 时间
    traceObject.time = [NSDate zz_dateTimeStampSince1970];
    
    // 事件类型（Launch, PageView, Register, Event）
    traceObject.traceEvent = ZZTraceEventPageView;
    
    // 当前页面标识
    NSString *pv = [[self sharedInstance] _getPVType:page];
    traceObject.pageView = pv;
    
    // 前一页面标识
    NSString *ppv = [[self sharedInstance] _getPVType:prePage];
    traceObject.previousPageView = ppv;
    
    // 当前页面的Hash
    traceObject.pageViewHash = [NSString stringWithFormat:@"%lu",(unsigned long)[[self sharedInstance] _getPVValue:page]];
    
    // 前一页面的Hash
    traceObject.previousPageViewHash = [NSString stringWithFormat:@"%lu",(unsigned long)[[self sharedInstance] _getPVValue:prePage]];
    
    // 组装当前PageViewHash全路径
    // 获取前一页的Hash全路径
    NSString *ppvhFullPath = [[self sharedInstance] _getPVValueFullPath:prePage];
    // 当前页的Hash全路径
    NSString *pvhFullPath = nil;
    if (ppvhFullPath == nil || ppvhFullPath.length == 0) {
        ppvhFullPath = traceObject.previousPageViewHash;
    }
    pvhFullPath = [NSString stringWithFormat:@"%@,%@", ppvhFullPath, traceObject.pageViewHash];
    [page zz_setPageHashFullPath:pvhFullPath];
    traceObject.pageViewHashFullPath = pvhFullPath;
    traceObject.depth = (int)[[traceObject.pageViewHashFullPath componentsSeparatedByString:@","] count] - 1;
    
    // 将前页的url和hash带入打开页面
    [page zz_setPref:traceObject.previousPageView];
    [page zz_setPrefHash:traceObject.previousPageViewHash];
    
    [self _upload:traceObject];
}

// 埋点（Event事件）
+ (void)traceEvent:( NSString * _Nonnull )eventId kv:(NSDictionary *)kv page:(__kindof UIViewController *)page {
    
    if (self.sharedInstance.config == nil || (self.sharedInstance.config.uploadImmediateBlock == nil && self.sharedInstance.config.uploadBatchBlock == nil)) {
        return;
    }
    
    __block ZZTraceObject *traceObject = [[ZZTraceObject alloc] init];
    
    // 时间
    traceObject.time = [NSDate zz_dateTimeStampSince1970];
    
    // 事件类型（Launch, PageView, Register, Event）
    traceObject.traceEvent = ZZTraceEventEvent;
    
    // Event事件动作
    traceObject.eventID = eventId;
    
    // 描述Event事件的参数
    traceObject.kv = [kv zz_toJSONString];
    
    // purl pref purlh prefh
    if (page != nil) {
        traceObject.pageView = [[self sharedInstance] _getPVType:page];
        traceObject.pageViewHash = [NSString stringWithFormat:@"%lu",(unsigned long)[[self sharedInstance] _getPVValue:page]];
        traceObject.previousPageView =  [page zz_getPref];
        traceObject.previousPageViewHash = [page zz_getPrefHash];
    }
    
    [self _upload:traceObject];
}

#pragma mark - Private Upload
// 获得PV类型
- (NSString *)_getPVType:(__kindof UIViewController *)controller {
    
    NSString *value = [self.pvs objectForKey:NSStringFromClass([controller class])];
    if (value.length > 0) {
        return value;
    }
    
    // 针对UINavigationController和UITabBarController处理顶部Controller
    UIViewController *targetController = nil;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        targetController = ((UINavigationController *) controller).viewControllers.lastObject;
    }else if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *subController = ((UITabBarController *)controller).selectedViewController;
        if ([subController isKindOfClass:[UINavigationController class]]) {
            targetController = ((UINavigationController *) subController).viewControllers.lastObject;
        }
    }
    
    // PV Protocol
    if (targetController) {
        if (targetController.childViewControllers.count > 0 && [targetController respondsToSelector:@selector(zz_tracePVType)]) {
            NSString *pv = [(UIViewController<ZZTraceDelegate> *)targetController zz_tracePVType];
            if (pv.length > 0) {
                return pv;
            }
        }
    }else {
        if (controller.childViewControllers.count > 0 && [controller respondsToSelector:@selector(zz_tracePVType)]) {
            NSString *pv = [(UIViewController<ZZTraceDelegate> *)controller zz_tracePVType];
            if (pv.length > 0) {
                return pv;
            }
        }
    }
    
    // 非PV Protocol
    if (targetController) {
        NSString *value = [self.pvs objectForKey:NSStringFromClass([targetController class])];
        if (value.length > 0) {
            return value;
        }
        return [NSString stringWithFormat:@"OriginalClass:%@", NSStringFromClass([targetController class])];
    }else {
        NSString *value = [self.pvs objectForKey:NSStringFromClass([controller class])];
        if (value.length > 0) {
            return value;
        }
        return [NSString stringWithFormat:@"OriginalClass:%@", NSStringFromClass([controller class])];
    }
}

// 获得PV值
- (NSUInteger)_getPVValue:(__kindof UIViewController *)controller {
    
    // 针对UINavigationController和UITabBarController处理顶部Controller
    UIViewController *targetController = nil;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        targetController = ((UINavigationController *) controller).viewControllers.lastObject;
    }else if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *subController = ((UITabBarController *)controller).selectedViewController;
        if ([subController isKindOfClass:[UINavigationController class]]) {
            targetController = ((UINavigationController *) subController).viewControllers.lastObject;
        }
    }
    
    // PV Protocol
    if (targetController) {
        if (targetController.childViewControllers.count > 0 && [targetController respondsToSelector:@selector(zz_tracePVValue)]) {
            NSUInteger pvh = [(UIViewController<ZZTraceDelegate> *)targetController zz_tracePVValue];
            if (pvh > 0) {
                return pvh;
            }
        }
    }else {
        if (controller.childViewControllers.count > 0 && [controller respondsToSelector:@selector(zz_tracePVValue)]) {
            NSUInteger pvh = [(UIViewController<ZZTraceDelegate> *)controller zz_tracePVValue];
            if (pvh > 0) {
                return pvh;
            }
        }
    }
    
    // 非PV Protocol
    if (targetController) {
        return [targetController hash];
    }else {
        return [controller hash];
    }
}

// 获得PV Hash Full Path值
- (NSString *)_getPVValueFullPath:(__kindof UIViewController *)controller {
    
    // 针对UINavigationController和UITabBarController处理顶部Controller
    UIViewController *targetController = nil;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        targetController = ((UINavigationController *) controller).viewControllers.lastObject;
    }else if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *subController = ((UITabBarController *)controller).selectedViewController;
        if ([subController isKindOfClass:[UINavigationController class]]) {
            targetController = ((UINavigationController *) subController).viewControllers.lastObject;
        }
    }
    
    // 非PV Protocol
    if (targetController) {
        return [targetController zz_getPageHashFullPath];
    }else {
        return [controller zz_getPageHashFullPath];
    }
}

// 上传
+ (void)_upload:(ZZTraceObject *)traceObject {
    
    // __weak typeof(self) weakSelf = self;
    ZZTrace *manager = [self sharedInstance];
    
    switch (manager.config.uploadPolicy) {
        case ZZTraceUploadPolicyImmediate:
        {
            // 即时上传
            // 公共参数
            [[manager.batchData yy_modelToJSONObject] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (obj != nil) {
                    if (![key isEqualToString:@"traces"]) {
                        [traceObject setValue:obj forKey:key];
                    }
                }
            }];
            [manager _uploadImmediate:traceObject success:^{
                
            } error:^{
                /* Deprecated Failure Process
                 @synchronized (weakSelf) {
                 [[manager.batchData toDictionary] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                 if (![key isEqualToString:@"traces"]) {
                 [traceObject setValue:nil forKey:key];
                 }
                 }];
                 @synchronized (weakSelf) {
                 [manager.batchData.traces addObject:traceObject];
                 [ZZStorage writeDocumentData:[manager.batchData toJSONData] name:FILENAME];
                 }
                 }
                 */
            }];
            
            break;
        }
        case ZZTraceUploadPolicyBatch:
        {
            // 批量上传
            /* 尚未支持
             [manager.batchData.traces addObject:traceObject];
             */
            break;
        }
    }
}

// 即时上传
- (void)_uploadImmediate:(ZZTraceObject *)trace success:(ZZNetworkVoidBlock)success error:(ZZNetworkVoidBlock)error {
    
    self.config.uploadImmediateBlock == nil ? : self.config.uploadImmediateBlock(trace, success, error);
}

// 批量上传
- (void)_uploadBatch:(ZZNetworkVoidBlock)success error:(ZZNetworkVoidBlock)error {
    
    self.config.uploadBatchBlock == nil ? : self.config.uploadBatchBlock(self.batchData, success, error);
}

@end
