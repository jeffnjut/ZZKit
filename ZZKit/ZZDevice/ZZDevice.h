//
//  ZZDevice.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

// 各类iPhone产品类型的屏幕宽、高
#pragma mark - 各类iPhone产品类型的屏幕宽、高

#define ZZ_DEVICE_IP4_WIDTH        (320.0)
#define ZZ_DEVICE_IP4_HEIGHT       (480.0)
#define ZZ_DEVICE_IP5_WIDTH        (320.0)
#define ZZ_DEVICE_IP5_HEIGHT       (568.0)
#define ZZ_DEVICE_IP6_WIDTH        (375.0)
#define ZZ_DEVICE_IP6_HEIGHT       (667.0)
#define ZZ_DEVICE_IP6P_WIDTH       (414.0)
#define ZZ_DEVICE_IP6P_HEIGHT      (736.0)
#define ZZ_DEVICE_IPX_WIDTH        (375.0)
#define ZZ_DEVICE_IPX_HEIGHT       (812.0)
#define ZZ_DEVICE_IPXMAX_WIDTH     (414.0)
#define ZZ_DEVICE_IPXMAX_HEIGHT    (896.0)
#define ZZ_DEVICE_IPXR_WIDTH       (414.0)
#define ZZ_DEVICE_IPXR_HEIGHT      (896.0)

// 主流iPhone产品类型的定义
#pragma mark - 主流iPhone产品类型的定义

typedef NS_ENUM(NSInteger, ZZDeviceProductType) {
    ZZDeviceProductTypeOther        = 0x00000000,
    ZZDeviceProductTypeIphone4      = 0x00000001,
    ZZDeviceProductTypeIphone4S     = 0x00000002,
    ZZDeviceProductTypeIphone5      = 0x00000004,
    ZZDeviceProductTypeIphone5C     = 0x00000008,
    ZZDeviceProductTypeIphone5S     = 0x00000010,
    ZZDeviceProductTypeIphoneSE     = 0x00000020,
    ZZDeviceProductTypeIphone6      = 0x00000040,
    ZZDeviceProductTypeIphone6Plus  = 0x00000080,
    ZZDeviceProductTypeIphone6S     = 0x00000100,
    ZZDeviceProductTypeIphone6SPlus = 0x00000200,
    ZZDeviceProductTypeIphone7      = 0x00000400,
    ZZDeviceProductTypeIphone7Plus  = 0x00000800,
    ZZDeviceProductTypeIphone8      = 0x00001000,
    ZZDeviceProductTypeIphone8Plus  = 0x00002000,
    ZZDeviceProductTypeIphoneX      = 0x00004000,
    ZZDeviceProductTypeIphoneXS     = 0x00008000,
    ZZDeviceProductTypeIphoneXMax   = 0x00010000,
    ZZDeviceProductTypeIphoneXR     = 0x00020000,
    
    ZZDeviceProductTypeIphone4Series = ZZDeviceProductTypeIphone4 | ZZDeviceProductTypeIphone4S,
    ZZDeviceProductTypeIphone5Series = ZZDeviceProductTypeIphone5 | ZZDeviceProductTypeIphone5C | ZZDeviceProductTypeIphone5S | ZZDeviceProductTypeIphoneSE,
    ZZDeviceProductTypeIphone6Series = ZZDeviceProductTypeIphone6 | ZZDeviceProductTypeIphone6S | ZZDeviceProductTypeIphone7 | ZZDeviceProductTypeIphone8,
    ZZDeviceProductTypeIphone6PlusSeries = ZZDeviceProductTypeIphone6Plus | ZZDeviceProductTypeIphone6SPlus | ZZDeviceProductTypeIphone7Plus | ZZDeviceProductTypeIphone8Plus,
    ZZDeviceProductTypeIphoneXSeries = ZZDeviceProductTypeIphoneX | ZZDeviceProductTypeIphoneXS,
    ZZDeviceProductTypeIphoneXAllSeries = ZZDeviceProductTypeIphoneX | ZZDeviceProductTypeIphoneXS | ZZDeviceProductTypeIphoneXMax | ZZDeviceProductTypeIphoneXR,
    
    ZZDeviceProductTypeIPadSeries = 0x10000000
};

// 判断iPhone类型
#pragma mark - 判断iPhone类型

#define ZZ_DEVICE_isiPad               ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ZZ_DEVICE_isiPhone4            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhone5            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhone6            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhone6P           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhoneX            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhoneXMAX         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhoneXR           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_isiPad : NO)
#define ZZ_DEVICE_isiPhoneXSeries      ZZ_DEVICE_isiPhoneX
#define ZZ_DEVICE_isiPhoneXAllSeries   (ZZ_DEVICE_isiPhoneX || ZZ_DEVICE_isiPhoneXMAX || ZZ_DEVICE_isiPhoneXR)

// 设备UI组件常用常量
#pragma mark - 设备UI组件常用常量

#define ZZ_DEVICE_STATUS_BAR_HEIGHT             (ZZ_DEVICE_isiPhoneXAllSeries ? 44 : 20)
#define ZZ_DEVICE_NAVIGATION_BAR_HEIGHT         (44.0)
#define ZZ_DEVICE_NAVIGATION_TOP_HEIGHT         (ZZ_DEVICE_isiPhoneXAllSeries ? 88 : 64)
#define ZZ_DEVICE_TAB_BAR_HEIGHT                (ZZ_DEVICE_isiPhoneXAllSeries ? 83 : 49)
#define ZZ_DEVICE_NAVIGATION_BAR_ICON_LENGTH    (20.0)
#define ZZ_DEVICE_TAB_ICON_LENGTH               (30.0)

NS_ASSUME_NONNULL_BEGIN

@interface ZZDevice : UIDevice

/**
 *  屏幕宽度
 */
+ (CGFloat)zz_screenWidth;

/**
 *  屏幕高度
 */
+ (CGFloat)zz_screenHeight;

/**
 *  屏幕尺寸
 */
+ (CGRect)zz_screenBounds;

/**
 *  屏幕正中心
 */
+ (CGPoint)zz_screenCenterPoint;

/**
 *  不同机型的屏幕宽度
 */
+ (CGFloat)zz_screenWidth:(ZZDeviceProductType)type;

#pragma mark - 设备产品名称、类型

/**
 *  是否是iPad
 */
+ (BOOL)zz_isIpadSeries;

/**
 *  是否是iPhone
 */
+ (BOOL)zz_isIphoneSeries;

/**
 *  是否是某个iPhone类型
 */
+ (BOOL)zz_isIphone:(ZZDeviceProductType)type;

/**
 *  不同机型的屏幕宽度
 */
+ (CGFloat)zz_screenHeight:(ZZDeviceProductType)type;

/**
 *  手机设备型号
 */
+ (NSString *)zz_productName;

/**
 *  是否是模拟器
 */
+ (BOOL)zz_isSimulator;

@end

NS_ASSUME_NONNULL_END
