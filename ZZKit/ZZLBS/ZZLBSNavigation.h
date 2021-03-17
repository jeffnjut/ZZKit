//
//  ZZLBSNavigation.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ZZLocationCoordinate.h"

typedef void(^ZZLBSNavigationVoidBlock)(void);

// 苹果地图
#define SCHEME_MAP_APPLE  @"self"
// Google地图
#define SCHEME_MAP_GOOGLE @"comgooglemaps://"
// 高德地图
#define SCHEME_MAP_GAODE  @"iosamap://"
// 百度地图
#define SCHEME_MAP_BAIDU  @"baidumap://"
// 腾讯地图
#define SCHEME_MAP_QQ     @"qqmap://"

NS_ASSUME_NONNULL_BEGIN

@interface ZZLBSNavigation : NSObject

/**
 *  唤醒第三方导航（CLLocationCoordinate2D + ZZLocationCoordinateSystem）
 */
+ (void)zz_startNavigaion:(CLLocationCoordinate2D)destinationCoordinate
         coordinateSystem:(ZZLocationCoordinateSystem)coordinateSystem
          destinationName:(nonnull NSString *)destinationName
            yourAppScheme:(nonnull NSString *)yourAppScheme
               controller:(nonnull UIViewController *)controller
                     maps:(nullable NSArray<NSString *> *)maps
                    block:(nullable void(^)(NSDictionary *mapURLs, ZZLBSNavigationVoidBlock startNavigationBlock))block;

/**
 *  唤醒第三方导航（ZZLocationCoordinate）
 */
+ (void)zz_startNavigation:(nonnull ZZLocationCoordinate *)destinationCoordinate
           destinationName:(nonnull NSString *)destinationName
             yourAppScheme:(nonnull NSString *)yourAppScheme
                controller:(nullable UIViewController *)controller
                      maps:(nullable NSArray<NSString *> *)maps
                     block:(nullable void(^)(NSDictionary *mapURLs, ZZLBSNavigationVoidBlock startNavigationBlock))block;

@end

NS_ASSUME_NONNULL_END
