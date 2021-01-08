//
//  ZZDevice.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - 各类iPhone产品类型的屏幕宽、高
// iPhone 4, iPhone 4s
#define ZZ_DEVICE_IP4_WIDTH         (320.0)
#define ZZ_DEVICE_IP4_HEIGHT        (480.0)

// iPhone 5, iPhone 5c, iPhone 5s, iPhone se
#define ZZ_DEVICE_IP5_WIDTH         (320.0)
#define ZZ_DEVICE_IP5_HEIGHT        (568.0)

// iPhone 6, iPhone 6s, iPhone 7, iPhone 8
#define ZZ_DEVICE_IP6_WIDTH         (375.0)
#define ZZ_DEVICE_IP6_HEIGHT        (667.0)

// iPhone 6 plus, iPhone 6s plus, iPhone 7 plus, iPhone 8 plus
#define ZZ_DEVICE_IP6P_WIDTH        (414.0)
#define ZZ_DEVICE_IP6P_HEIGHT       (736.0)

// iPhone x, iPhone xs, iPhone 12 mini, iPhone 11 Pro,
#define ZZ_DEVICE_IPX_WIDTH         (375.0)
#define ZZ_DEVICE_IPX_HEIGHT        (812.0)

// iPhone xr, iPhone x max, iPhone xs max, iPhone 11, iPhone 11 pro max
#define ZZ_DEVICE_IPXMAX_WIDTH      (414.0)
#define ZZ_DEVICE_IPXMAX_HEIGHT     (896.0)

// iPhone 12, iPhone 12 pro
#define ZZ_DEVICE_IP12_WIDTH        (390.0)
#define ZZ_DEVICE_IP12_HEIGHT       (844.0)

// iPhone 12 pro max
#define ZZ_DEVICE_IP12PROMAX_WIDTH  (428.0)
#define ZZ_DEVICE_IP12PROMAX_HEIGHT (926.0)


#pragma mark - 判断iPhone类型

// 是否是iPad
#define ZZ_DEVICE_IS_IPAD_ALL           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 是否是iPhone
#define ZZ_DEVICE_IS_IPHONE_ALL         ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
// 4、4s
#define ZZ_DEVICE_IS_IPHONE_4           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 5、5c、5s、5se
#define ZZ_DEVICE_IS_IPHONE_5           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 6、6s、7、8
#define ZZ_DEVICE_IS_IPHONE_6           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 6Plus、6splus、7plus、8plus
#define ZZ_DEVICE_IS_IPHONE_6plus      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// X、Xs、11pro
#define ZZ_DEVICE_IS_IPHONE_X           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// Xmax、11promax
#define ZZ_DEVICE_IS_IPHONE_Xmax        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !ZZ_DEVICE_IS_IPAD_ALL : NO)
// Xr、11
#define ZZ_DEVICE_IS_IPHONE_Xr          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 12、12Pro
#define ZZ_DEVICE_IS_IPHONE_12          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 12Promax
#define ZZ_DEVICE_IS_IPHONE_12promax    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 12mini
#define ZZ_DEVICE_IS_IPHONE_12mini      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// 刘海屏系列
#define ZZ_DEVICE_IS_IPHONE_X_ALL       ((([UIScreen instanceMethodForSelector:@selector(currentMode)] == NO) || (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)) ? NO : CGSizeEqualToSize(CGSizeMake(1125, 2436), UIScreen.mainScreen.currentMode.size) || CGSizeEqualToSize(CGSizeMake(1242, 2688), UIScreen.mainScreen.currentMode.size)  || CGSizeEqualToSize(CGSizeMake(828, 1792), UIScreen.mainScreen.currentMode.size) || CGSizeEqualToSize(CGSizeMake(1170, 2532), UIScreen.mainScreen.currentMode.size) || CGSizeEqualToSize(CGSizeMake(1284, 2778), UIScreen.mainScreen.currentMode.size) || CGSizeEqualToSize(CGSizeMake(1080, 2340), UIScreen.mainScreen.currentMode.size))


#pragma mark - 设备UI组件常用常量

#define ZZ_DEVICE_STATUS_BAR_HEIGHT             (ZZ_DEVICE_IS_IPHONE_X_ALL ? 44 : 20)

#define ZZ_DEVICE_NAVIGATION_BAR_HEIGHT         (44.0)

#define ZZ_DEVICE_NAVIGATION_TOP_HEIGHT         (ZZ_DEVICE_IS_IPHONE_X_ALL ? 88 : 64)

#define ZZ_DEVICE_TAB_BAR_HEIGHT                (ZZ_DEVICE_IS_IPHONE_X_ALL ? 83 : 49)

#define ZZ_DEVICE_NAVIGATION_BAR_ICON_LENGTH    (20.0)

#define ZZ_DEVICE_TAB_ICON_LENGTH               (30.0)

#define ZZ_DEVICE_NAVIGATION_SAFE_DELTA_X       (ZZ_DEVICE_IS_IPHONE_X_ALL ? 20.0 : 0)

#define ZZ_DEVICE_TAB_SAFE_DELTA_X              (ZZ_DEVICE_IS_IPHONE_X_ALL ? 34.0 : 0)

#pragma mark - 设备屏幕比例

#define ZZ_DEVICE_RATE_IF_IP4     ((UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width) <= 1.5)
#define ZZ_DEVICE_RATE_IF_IP6P    ((UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width) <= 2.0 && (UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width) > 1.5)
#define ZZ_DEVICE_RATE_IF_IPXMAX  ((UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width) <= 3.0 && (UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width) > 2.0)

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

#pragma mark - 设备产品名称、类型

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
