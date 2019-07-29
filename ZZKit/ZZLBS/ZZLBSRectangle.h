//
//  ZZLBSRectangle.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZLBSRectangle : NSObject

@property (nonatomic, assign, readonly) CLLocationDegrees west;
@property (nonatomic, assign, readonly) CLLocationDegrees north;
@property (nonatomic, assign, readonly) CLLocationDegrees east;
@property (nonatomic, assign, readonly) CLLocationDegrees south;

/**
 *  根据东西经度和南北维度确定矩形围栏（4个CLLocationDegrees参数）
 */
+ (ZZLBSRectangle *)zz_lbsRectangle:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2;

/**
 *  根据东西经度和南北维度确定矩形围栏（2个CLLocationCoordinate2D参数）
 */
+ (ZZLBSRectangle *)zz_lbsRectangle:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;

/**
 *  coordinate是否落在矩形围栏内（4个CLLocationDegrees参数）
 */
+ (BOOL)zz_point:(CLLocationCoordinate2D)coordinate inside:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2;

/**
 *  coordinate是否落在矩形围栏内（2个CLLocationCoordinate2D参数）
 */
+ (BOOL)zz_point:(CLLocationCoordinate2D)coordinate inside:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;

/**
 *  coordinate是否落在矩形围栏内
 */
- (BOOL)zz_pointInside:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
