//
//  ZZPingTester.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZPingTester.h"
#import <pthread.h>

@implementation ZZPingItem

@end

@interface ZZPingTester() <SimplePingDelegate>
{
    NSTimer *_timer;
    NSDate *_beginDate;
}

@property (nonatomic, copy) NSString *host;

@property (nonatomic, strong) SimplePing* simplePing;

@property (nonatomic, strong) NSMutableArray<ZZPingItem*>* pingItems;

@property (nonatomic, copy) void(^block)(float time, ZZPingStatus status, NSError *error);

@end

@implementation ZZPingTester

- (instancetype)initWithHostName:(nonnull NSString *)hostName block:(void(^)(float time, ZZPingStatus status, NSError *error))block {
    
    if(self = [super init]) {
        self.host = hostName;
        self.block = block;
        self.simplePing = [[SimplePing alloc] initWithHostName:hostName];
        self.simplePing.delegate = self;
        self.simplePing.addressStyle = SimplePingAddressStyleAny;
        self.pingItems = [NSMutableArray new];
    }
    return self;
}

/**
 *  开始Ping
 */
- (void)startPing {
    
    [self.simplePing start];
}

/**
 *  停止Ping
 */
- (void)stopPing {
    
    [_timer invalidate];
    _timer = nil;
    [self.simplePing stop];
}

- (void)_actionTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_sendPingData) userInfo:nil repeats:YES];
}

- (void)_sendPingData {
    
    [self.simplePing sendPingWithData:nil];
}

#pragma mark - SimplePing Delegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    
    [self _actionTimer];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    
    NSLog(@"ping失败--->%@", error);
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    
    ZZPingItem* item = [ZZPingItem new];
    item.sequence = sequenceNumber;
    [self.pingItems addObject:item];
    
    _beginDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self.pingItems containsObject:item])
        {
            NSLog(@"超时---->");
            [self.pingItems removeObject:item];
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(zz_didPing:status:error:)])
            {
                [self.delegate zz_didPing:0 status:ZZPingStatusSendTimeout error:[NSError errorWithDomain:NSURLErrorDomain code:111 userInfo:nil]];
            }
            if (self.block != nil) {
                self.block(0, ZZPingStatusSendTimeout, [NSError errorWithDomain:NSURLErrorDomain code:111 userInfo:nil]);
            }
        }
    });
}
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    
    NSLog(@"发包失败--->%@", error);
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(zz_didPing:status:error:)]) {
        [self.delegate zz_didPing:0 status:ZZPingStatusSendFailed error:error];
    }
    if (self.block != nil) {
        self.block(0, ZZPingStatusSendFailed, error);
    }
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    
    float delayTime = [[NSDate date] timeIntervalSinceDate:_beginDate] * 1000;
    [self.pingItems enumerateObjectsUsingBlock:^(ZZPingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.sequence == sequenceNumber) {
            [self.pingItems removeObject:obj];
        }
    }];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(zz_didPing:status:error:)]) {
        [self.delegate zz_didPing:delayTime status:ZZPingStatusReceived error:nil];
    }
    if (self.block != nil) {
        self.block(delayTime, ZZPingStatusReceived, nil);
    }
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    
}

@end
