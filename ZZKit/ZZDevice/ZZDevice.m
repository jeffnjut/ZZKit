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

/**
 *  不同机型的屏幕宽度
 */
+ (CGFloat)zz_screenWidth:(ZZDeviceProductType)type {
    
    switch (type) {
        case ZZDeviceProductTypeIphone4:
        case ZZDeviceProductTypeIphone4S:
        case ZZDeviceProductTypeIphone4Series:
            return ZZ_DEVICE_IP4_WIDTH;
        
        case ZZDeviceProductTypeIphone5:
        case ZZDeviceProductTypeIphone5C:
        case ZZDeviceProductTypeIphone5S:
        case ZZDeviceProductTypeIphoneSE:
        case ZZDeviceProductTypeIphone5Series:
            return ZZ_DEVICE_IP5_WIDTH;
        
        case ZZDeviceProductTypeIphone6:
        case ZZDeviceProductTypeIphone6S:
        case ZZDeviceProductTypeIphone7:
        case ZZDeviceProductTypeIphone8:
        case ZZDeviceProductTypeIphone6Series:
            return ZZ_DEVICE_IP6_WIDTH;
            
        case ZZDeviceProductTypeIphone6Plus:
        case ZZDeviceProductTypeIphone6SPlus:
        case ZZDeviceProductTypeIphone7Plus:
        case ZZDeviceProductTypeIphone8Plus:
        case ZZDeviceProductTypeIphone6PlusSeries:
            return ZZ_DEVICE_IP6P_WIDTH;
        
        case ZZDeviceProductTypeIphoneX:
        case ZZDeviceProductTypeIphoneXS:
        case ZZDeviceProductTypeIphoneXSeries:
            return ZZ_DEVICE_IPX_WIDTH;
            
        case ZZDeviceProductTypeIphoneXMax:
            return ZZ_DEVICE_IPXMAX_WIDTH;
            
        case ZZDeviceProductTypeIphoneXR:
            return ZZ_DEVICE_IPXR_WIDTH;
            
        case ZZDeviceProductTypeOther:
        default:
            return 0;
    }
}

#pragma mark - 设备产品名称、类型

/**
 *  是否是iPad
 */
+ (BOOL)zz_isIpadSeries {
    
    return [[self currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

/**
 *  是否是iPhone
 */
+ (BOOL)zz_isIphoneSeries {
    
    return [[self currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

/**
 *  是否是某个iPhone类型
 */
+ (BOOL)zz_isIphone:(ZZDeviceProductType)type {
    
    return YES;
}

/**
 *  不同机型的屏幕宽度
 */
+ (CGFloat)zz_screenHeight:(ZZDeviceProductType)type {
    
    switch (type) {
        case ZZDeviceProductTypeIphone4:
        case ZZDeviceProductTypeIphone4S:
        case ZZDeviceProductTypeIphone4Series:
            return ZZ_DEVICE_IP4_HEIGHT;
            
        case ZZDeviceProductTypeIphone5:
        case ZZDeviceProductTypeIphone5C:
        case ZZDeviceProductTypeIphone5S:
        case ZZDeviceProductTypeIphoneSE:
        case ZZDeviceProductTypeIphone5Series:
            return ZZ_DEVICE_IP5_HEIGHT;
            
        case ZZDeviceProductTypeIphone6:
        case ZZDeviceProductTypeIphone6S:
        case ZZDeviceProductTypeIphone7:
        case ZZDeviceProductTypeIphone8:
        case ZZDeviceProductTypeIphone6Series:
            return ZZ_DEVICE_IP6_HEIGHT;
            
        case ZZDeviceProductTypeIphone6Plus:
        case ZZDeviceProductTypeIphone6SPlus:
        case ZZDeviceProductTypeIphone7Plus:
        case ZZDeviceProductTypeIphone8Plus:
        case ZZDeviceProductTypeIphone6PlusSeries:
            return ZZ_DEVICE_IP6P_HEIGHT;
            
        case ZZDeviceProductTypeIphoneX:
        case ZZDeviceProductTypeIphoneXS:
        case ZZDeviceProductTypeIphoneXSeries:
            return ZZ_DEVICE_IPX_HEIGHT;
            
        case ZZDeviceProductTypeIphoneXMax:
            return ZZ_DEVICE_IPXMAX_HEIGHT;
            
        case ZZDeviceProductTypeIphoneXR:
            return ZZ_DEVICE_IPXR_HEIGHT;
            
        case ZZDeviceProductTypeOther:
        default:
            return 0;
    }
}


/**
 *  手机设备型号
 */
+ (NSString *)zz_productName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,3"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";      // "国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)"; // "港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";       // "美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";  // "美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    
    // iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([deviceString isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    // iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    // iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    // iPad
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    // iPad Air
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    // iPad Mini
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    // iPad Air
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    // iPad Pro
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad(5G)";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad(5G)";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro (12.9-inch, 2g)";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro(12.9-inch, 2g)";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5-inch)";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    
    // Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"iPhoneSimulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"iPhoneSimulator";
    
    // 未匹配到
    if ([deviceString containsString:@"iPhone"])        return @"iPhone";
    if ([deviceString containsString:@"iPad"])          return @"iPad";
    if ([deviceString containsString:@"iPod"])          return @"iPod";
    
    return @"";
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
