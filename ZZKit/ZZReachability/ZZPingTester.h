//
//  ZZPingTester.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZPingItem : NSObject

@property(nonatomic, assign) uint16_t sequence;

@end

@protocol ZZPingDelegate <NSObject>

@optional

- (void)zz_didPing:(float)time error:(nullable NSError*) error;

@end


@interface ZZPingTester : NSObject<SimplePingDelegate>

@property (nonatomic, weak, readwrite) id<ZZPingDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithHostName:(nonnull NSString *)hostName block:(void(^)(float time, NSError *error))block NS_DESIGNATED_INITIALIZER;

/**
 *  开始Ping
 */
- (void)startPing;

/**
 *  停止Ping
 */
- (void)stopPing;

@end

NS_ASSUME_NONNULL_END
