//
//  ZZReachability.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCellularData.h>
#import <CoreTelephony/CTCarrier.h>

@implementation ZZCarrier

@end

@implementation ZZReachability

/**
 *  获取Wifi名称
 */
+ (NSString *)zz_wifiName {
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

/**
 *  网络运营商
 */
+ (ZZCarrier *)zz_carrier {
    @autoreleasepool {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *ctCarrier = [info subscriberCellularProvider];
        // 国家码和网络码查询
        // https://en.wikipedia.org/wiki/Mobile_country_code
        ZZCarrier *carrier = [[ZZCarrier alloc] init];
        carrier.mcc = [[ctCarrier mobileCountryCode] copy];
        carrier.mnc = [[ctCarrier mobileNetworkCode] copy];
        carrier.carrierName = [[carrier carrierName] copy];
        carrier.isoCountryCode = [[carrier isoCountryCode] copy];
        carrier.allowsVOIP = [carrier allowsVOIP];
        carrier.radioAccessTechnology = [info.currentRadioAccessTechnology copy];
        if ([carrier.mcc isEqualToString:@"460"]) {
            switch ([carrier.mnc intValue]) {
                case 0:
                case 2:
                case 4:
                case 7:
                case 8:
                {
                    carrier.carrierType = 1;
                    break;
                }
                case 1:
                case 6:
                case 9:
                {
                    carrier.carrierType = 2;
                    break;
                }
                    break;
                case 3:
                case 5:
                case 11:
                {
                    carrier.carrierType = 3;
                    break;
                }
                case 20:
                {
                    carrier.carrierType = 4;
                    break;
                }
                default:
                    break;
            }
        }
        if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
            
            carrier.netconnType = @"GPRS";
            carrier.radioAccessTechnologyType = 0;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
            
            carrier.netconnType = @"2.75G EDGE";
            carrier.radioAccessTechnologyType = 1;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
            
            carrier.netconnType = @"3G";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
            
            carrier.netconnType = @"3.5G HSDPA";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
            
            carrier.netconnType = @"3.5G HSUPA";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
            
            carrier.netconnType = @"2G";
            carrier.radioAccessTechnologyType = 1;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
            
            carrier.netconnType = @"3G";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
            
            carrier.netconnType = @"3G";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
            
            carrier.netconnType = @"3G";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
            
            carrier.netconnType = @"HRPD";
            carrier.radioAccessTechnologyType = 2;
        }else if ([carrier.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
            
            carrier.netconnType = @"4G";
            carrier.radioAccessTechnologyType = 3;
        }else {
            
            carrier.netconnType = @"Unknown";
            carrier.radioAccessTechnologyType = 0;
        }
        return carrier;
    }
}

@end
