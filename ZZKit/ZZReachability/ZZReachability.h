//
//  ZZReachability.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO

NS_ASSUME_NONNULL_BEGIN

@interface ZZCarrier : NSObject

@property (nonatomic, copy) NSString *mcc;  // 国家码
@property (nonatomic, copy) NSString *mnc;  // 网络码 如：01
@property (nonatomic, copy) NSString *isoCountryCode;  // 国家简称
@property (nonatomic, assign) BOOL allowsVOIP;  // 是否支持VOIP
@property (nonatomic, copy) NSString *carrierName;  // 运营商名称，中国联通
// 0 - 未知  1 - 中国移动  2 - 中国联通  3 - 中国电信  4 - 中国铁通
@property (nonatomic, assign) NSUInteger carrierType;
@property (nonatomic, copy) NSString *radioAccessTechnology;  // 无线连接技术，如CTRadioAccessTechnologyLTE
@property (nonatomic, copy) NSString *netconnType; // 无线连接技术，俗称
// 0 - 未知  1 - 2G  2 - 3G  3 - 4G  4 - 5G
@property (nonatomic, assign) NSUInteger radioAccessTechnologyType;

@end

@interface ZZReachability : NSObject

/**
 *  获取WIFI名称
 */
+ (NSString *)zz_wifiName;

/**
 *  网络运营商
 */
+ (ZZCarrier *)zz_carrier;

@end

NS_ASSUME_NONNULL_END
