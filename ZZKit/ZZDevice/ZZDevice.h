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
#define ZZ_DEVICE_IP4_WIDTH        (320.0)
#define ZZ_DEVICE_IP4_HEIGHT       (480.0)

// iPhone 5, iPhone 5c, iPhone 5s, iPhone se
#define ZZ_DEVICE_IP5_WIDTH        (320.0)
#define ZZ_DEVICE_IP5_HEIGHT       (568.0)

// iPhone 6, iPhone 6s, iPhone 7, iPhone 8
#define ZZ_DEVICE_IP6_WIDTH        (375.0)
#define ZZ_DEVICE_IP6_HEIGHT       (667.0)

// iPhone 6 plus, iPhone 6s plus, iPhone 7 plus, iPhone 8 plus
#define ZZ_DEVICE_IP6P_WIDTH       (414.0)
#define ZZ_DEVICE_IP6P_HEIGHT      (736.0)

// iPhone x, iPhone xs, iPhone 12 mini, iPhone 12, iPhone 11 Pro, iPhone 12 pro
#define ZZ_DEVICE_IPX_WIDTH        (375.0)
#define ZZ_DEVICE_IPX_HEIGHT       (812.0)

// iPhone xr, iPhone x max, iPhone xs max, iPhone 11, iPhone 11 pro max, iPhone 12 pro max
#define ZZ_DEVICE_IPXMAX_WIDTH     (414.0)
#define ZZ_DEVICE_IPXMAX_HEIGHT    (896.0)


#pragma mark - 判断iPhone类型

// 是否是iPad
#define ZZ_DEVICE_IS_IPAD_ALL           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 是否是iPhone
#define ZZ_DEVICE_IS_IPHONE_ALL         ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
// iPhone 4、4s
#define ZZ_DEVICE_IS_IPHONE_4           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone 5、5C、5S、5SE
#define ZZ_DEVICE_IS_IPHONE_5           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone 6、6S、7、8
#define ZZ_DEVICE_IS_IPHONE_6           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone 6 Plus、6S Plus、7 Plus、8Plus
#define ZZ_DEVICE_IS_IPHONE_6_PLUS      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone X、Xs、11 Pro
#define ZZ_DEVICE_IS_IPHONE_X           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone X-Max、11 Pro-Max
#define ZZ_DEVICE_IS_IPHONE_XMAX        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone XR、11
#define ZZ_DEVICE_IS_IPHONE_XR          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !ZZ_DEVICE_IS_IPAD_ALL : NO)
// iPhone X 刘海屏系列
#define ZZ_DEVICE_IS_IPHONE_X_ALL       (ZZ_DEVICE_IS_IPHONE_X || ZZ_DEVICE_IS_IPHONE_XMAX || ZZ_DEVICE_IS_IPHONE_XR)


#pragma mark - 设备UI组件常用常量

#define ZZ_DEVICE_STATUS_BAR_HEIGHT             (ZZ_DEVICE_IS_IPHONE_X_ALL ? 44 : 20)

#define ZZ_DEVICE_NAVIGATION_BAR_HEIGHT         (44.0)

#define ZZ_DEVICE_NAVIGATION_TOP_HEIGHT         (ZZ_DEVICE_IS_IPHONE_X_ALL ? 88 : 64)

#define ZZ_DEVICE_TAB_BAR_HEIGHT                (ZZ_DEVICE_IS_IPHONE_X_ALL ? 83 : 49)

#define ZZ_DEVICE_NAVIGATION_BAR_ICON_LENGTH    (20.0)

#define ZZ_DEVICE_TAB_ICON_LENGTH               (30.0)

#define ZZ_DEVICE_NAVIGATION_SAFE_DELTA_X       (ZZ_DEVICE_IS_IPHONE_X_ALL ? 20.0 : 0)

#define ZZ_DEVICE_TAB_SAFE_DELTA_X              (ZZ_DEVICE_IS_IPHONE_X_ALL ? 34.0 : 0)

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
