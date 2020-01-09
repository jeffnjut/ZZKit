//
//  ZZDevice.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZDevice.h"
#import "sys/utsname.h"

@implementation ZZDevice

#pragma mark - 设备屏幕相关

/**
 *  屏幕宽度
 */
+ (CGFloat)zz_screenWidth {
    
    return UIScreen.mainScreen.bounds.size.width;
}

/**
 *  屏幕高度
 */
+ (CGFloat)zz_screenHeight {
    
    return UIScreen.mainScreen.bounds.size.height;
}

/**
 *  屏幕尺寸
 */
+ (CGRect)zz_screenBounds {
    
    return UIScreen.mainScreen.bounds;
}

/**
 *  屏幕正中心
 */
+ (CGPoint)zz_screenCenterPoint {
    
    return CGPointMake(UIScreen.mainScreen.bounds.size.width / 2.0, UIScreen.mainScreen.bounds.size.height / 2.0);
}

#pragma mark - 设备产品名称、类型

/**
 *  手机设备型号
 */
+ (NSString *)zz_productName {
    
    // 持续更新地址
    // https://www.jianshu.com/p/4f6c01dbe0cd
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //模拟器
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone_3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone_3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone_4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone_4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone_4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone_4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone_5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone_5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone_5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone_5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone_5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone_5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone_6_Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone_6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone_6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone_6s_Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone_SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone_7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone_7_Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone_7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone_7_Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone_XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone_XS_Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone_XS_Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone_XR";
    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone_11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone_11Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone_11Pro_Max";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad_2nd";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad_2nd";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad_2nd";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad_2nd";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad_mini";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad_mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad_mini";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad_3rd";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad_3rd";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad_3rd";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad_4th";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad_4th";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad_4th";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad_mini_2nd";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad_mini_2nd";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad_mini_2nd";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad_mini_3rd";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad_mini_3rd";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad_mini_3rd";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad_mini_4th";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad_mini_4th";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPadAir_2nd";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPadAir_2nd";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPadPro_9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPadPro_9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPadPro_12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPadPro_12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad_5th";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad_5th";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPadPro_12.9_2nd";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPadPro_12.9_2nd";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPadPro_10.5";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPadPro_10.5";
    if ([deviceString isEqualToString:@"iPad7,5"])      return @"iPad_6th";
    if ([deviceString isEqualToString:@"iPad7,6"])      return @"iPad_6th";
    if ([deviceString isEqualToString:@"iPad7,11"])     return @"iPad_7th";
    if ([deviceString isEqualToString:@"iPad7,12"])     return @"iPad_7th";
    if ([deviceString isEqualToString:@"iPad8,1"])      return @"iPadPro_11";
    if ([deviceString isEqualToString:@"iPad8,2"])      return @"iPadPro_11";
    if ([deviceString isEqualToString:@"iPad8,3"])      return @"iPadPro_11";
    if ([deviceString isEqualToString:@"iPad8,4"])      return @"iPadPro_11";
    if ([deviceString isEqualToString:@"iPad8,5"])      return @"iPadPro_12.9_3rd";
    if ([deviceString isEqualToString:@"iPad8,6"])      return @"iPadPro_12.9_3rd";
    if ([deviceString isEqualToString:@"iPad8,7"])      return @"iPadPro_12.9_3rd";
    if ([deviceString isEqualToString:@"iPad8,8"])      return @"iPadPro_12.9_3rd";
    if ([deviceString isEqualToString:@"iPad11,1"])     return @"iPad_mini_5th";
    if ([deviceString isEqualToString:@"iPad11,2"])     return @"iPad_mini_5th";
    if ([deviceString isEqualToString:@"iPad11,3"])     return @"iPadAir_3rd";
    if ([deviceString isEqualToString:@"iPad11,4"])     return @"iPadAir_3rd";
    
    //iPod touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod_touch";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod_touch_2nd";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod_touch_3rd";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod_touch_4th";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod_touch_5th";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod_touch_6th";
    if ([deviceString isEqualToString:@"iPod9,1"])      return @"iPod_touch_7th";
    
    //Apple Watch
    if ([deviceString isEqualToString:@"Watch1,1"])    return @"Apple_Watch_1st";
    if ([deviceString isEqualToString:@"Watch1,2"])    return @"Apple_Watch_1st";
    if ([deviceString isEqualToString:@"Watch2,6"])    return @"Apple_Watch_Series_1";
    if ([deviceString isEqualToString:@"Watch2,7"])    return @"Apple_Watch_Series_1";
    if ([deviceString isEqualToString:@"Watch2,3"])    return @"Apple_Watch_Series_2";
    if ([deviceString isEqualToString:@"Watch2,4"])    return @"Apple_Watch_Series_2";
    if ([deviceString isEqualToString:@"Watch3,1"])    return @"Apple_Watch_Series_3";
    if ([deviceString isEqualToString:@"Watch3,2"])    return @"Apple_Watch_Series_3";
    if ([deviceString isEqualToString:@"Watch3,3"])    return @"Apple_Watch_Series_3";
    if ([deviceString isEqualToString:@"Watch3,4"])    return @"Apple_Watch_Series_3";
    if ([deviceString isEqualToString:@"Watch4,1"])    return @"Apple_Watch_Series_4";
    if ([deviceString isEqualToString:@"Watch4,2"])    return @"Apple_Watch_Series_4";
    if ([deviceString isEqualToString:@"Watch4,3"])    return @"Apple_Watch_Series_4";
    if ([deviceString isEqualToString:@"Watch4,4"])    return @"Apple_Watch_Series_4";
    if ([deviceString isEqualToString:@"Watch5,1"])    return @"Apple_Watch_Series_5";
    if ([deviceString isEqualToString:@"Watch5,2"])    return @"Apple_Watch_Series_5";
    if ([deviceString isEqualToString:@"Watch5,3"])    return @"Apple_Watch_Series_5";
    if ([deviceString isEqualToString:@"Watch5,4"])    return @"Apple_Watch_Series_5";
    
    //Apple TV
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"AppleTV_2nd";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"AppleTV_3rd";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"AppleTV_3rd";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"AppleTV_4th";
    if ([deviceString isEqualToString:@"AppleTV6,2"])    return @"AppleTV_4K";
    
    //AirPods
    if ([deviceString isEqualToString:@"AirPods1,1"])    return @"AirPods_1st";
    if ([deviceString isEqualToString:@"AirPods2,1"])    return @"AirPods_2nd";
    
    //HomePod
    if ([deviceString isEqualToString:@"AudioAccessory1,1"])    return @"HomePod";
    if ([deviceString isEqualToString:@"AudioAccessory1,2"])    return @"HomePod";
    
    return deviceString;
}

/**
 *  是否是模拟器
 */
+ (BOOL)zz_isSimulator {
    
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        // 模拟器
        return YES;
    }else {
        // 真机
        return NO;
    }
}

@end
