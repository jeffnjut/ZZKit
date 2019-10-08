//
//  ZZLocationCoordinate.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZLocationCoordinateSystem) {
    
    // 地球坐标 ：（代号：GPS、WGS84，国际标准）CLLocationManager 获取的坐标，Google Earth、Google Map、GPS模块等
    ZZLocationCoordinateSystemWGS84,
    
    // 火星坐标 ：（代号：GCJ-02，中国坐标偏移标准）高德地图、腾讯地图、阿里云地图、灵图51地图
    ZZLocationCoordinateSystemGCJ02,
    
    // 百度坐标 ：（代号：BD-09，百度坐标偏移标准）百度坐标系统，百度坐标是在火星坐标的基础上再次加密计算
    ZZLocationCoordinateSystemBD09
};

@interface ZZLocationCoordinate : NSObject

// 当前维度
@property (nonatomic, assign) CLLocationDegrees zzCurrentLatitude;
// 当前经度
@property (nonatomic, assign) CLLocationDegrees zzCurrentLongitude;
// 当前经纬度
@property (nonatomic, assign) CLLocationCoordinate2D zzCurrentCoordinate2D;
// 当前经纬度坐标系系统
@property (nonatomic, assign) ZZLocationCoordinateSystem zzCurrentCoordinateSystem;

// WGS84坐标系
@property (nonatomic, assign, readonly) CLLocationCoordinate2D zzCoordinate2DWGS84;
// GCJ02坐标系
@property (nonatomic, assign, readonly) CLLocationCoordinate2D zzCoordinate2DGCJ02;
// BD09坐标系
@property (nonatomic, assign, readonly) CLLocationCoordinate2D zzCoordinate2DBD09;

#pragma mark - 初始化方法

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)currentCoordinate2D coordinateSystem:(ZZLocationCoordinateSystem)coordinateSystem;

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude coordinateSystem:(ZZLocationCoordinateSystem)coordinateSystem;

#pragma mark - 经纬度坐标系转换

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromWGSToGCJ:(CLLocationCoordinate2D)coordinate;

/**
 *  将GCJ-02(火星坐标)转为BD-09(百度坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromGCJToBaidu:(CLLocationCoordinate2D)coordinate;

/**
 *  将BD-09(百度坐标)转为GCJ-02(火星坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromBaiduToGCJ:(CLLocationCoordinate2D)coordinate;

/**
 *  将GCJ-02(火星坐标)转为WGS-84(地球坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromGCJToWGS:(CLLocationCoordinate2D)coordinate;

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标),输出维度
 */
+ (double)zz_transformLatitudeWithX:(double)x withY:(double)y;

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标),输出经度
 */
+ (double)zz_transformLongitudeWithX:(double)x withY:(double)y;

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标),输出经度
 */
+ (BOOL)zz_isContain:(CLLocationCoordinate2D)point coordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;

#pragma mark - 判断WGS-84坐标是否在中国区域内

/**
 *  判断是否在中国（简易判断）
 */
+ (BOOL)zz_insideChina:(CLLocationCoordinate2D)coordinate;

/**
 *  判断location是否在中国（较复杂和精确判断）
 */
+ (BOOL)zz_insideChinaHighAccuracy:(CLLocationCoordinate2D)coordinate;

#pragma mark - 计算两点之间的直线距离

/**
 *  计算两点之间的直线距离（2个参数）
 */
+ (CLLocationDistance)zz_distance:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;

/**
 *  计算两点之间的直线距离（4个参数）
 */
+ (CLLocationDistance)zz_distance:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2;

@end

NS_ASSUME_NONNULL_END
