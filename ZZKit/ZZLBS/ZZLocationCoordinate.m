//
//  ZZLocationCoordinate.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLocationCoordinate.h"
#import "ZZLBSRectangle.h"

static const double a   = 6378245.0;
static const double ee  = 0.00669342162296594323;
static const double pi  = M_PI;
static const double xPi = M_PI * 3000.0 / 180.0;

@interface ZZLocationCoordinate ()

// WGS84坐标系
@property (nonatomic, assign) CLLocationCoordinate2D zzCoordinate2DWGS84;
// GCJ02坐标系
@property (nonatomic, assign) CLLocationCoordinate2D zzCoordinate2DGCJ02;
// BD09坐标系
@property (nonatomic, assign) CLLocationCoordinate2D zzCoordinate2DBD09;

@end

@implementation ZZLocationCoordinate

#pragma mark - 初始化方法

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)currentCoordinate2D coordinateSystem:(ZZLocationCoordinateSystem)coordinateSystem {
    
    if (self = [super init]) {
        self.zzCurrentLatitude = currentCoordinate2D.latitude;
        self.zzCurrentLongitude = currentCoordinate2D.longitude;
        self.zzCurrentCoordinate2D = currentCoordinate2D;
        self.zzCurrentCoordinateSystem = coordinateSystem;
    }
    return self;
}

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude coordinateSystem:(ZZLocationCoordinateSystem)coordinateSystem {
    
    if (self = [super init]) {
        self.zzCurrentLatitude = latitude;
        self.zzCurrentLongitude = longitude;
        self.zzCurrentCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        self.zzCurrentCoordinateSystem = coordinateSystem;
    }
    return self;
}

#pragma mark - 设置

- (void)setZzCurrentLatitude:(CLLocationDegrees)zzCurrentLatitude {
    
    _zzCurrentLatitude = zzCurrentLatitude;
    self.zzCurrentCoordinate2D = CLLocationCoordinate2DMake(_zzCurrentLatitude, _zzCurrentLongitude);
    [self _tranformCoordinate];
}

- (void)setZzCurrentLongitude:(CLLocationDegrees)zzCurrentLongitude {
    
    _zzCurrentLongitude = zzCurrentLongitude;
    self.zzCurrentCoordinate2D = CLLocationCoordinate2DMake(_zzCurrentLatitude, _zzCurrentLongitude);
    [self _tranformCoordinate];
}

- (void)setZzCurrentCoordinate2D:(CLLocationCoordinate2D)zzCurrentCoordinate2D {
    
    _zzCurrentCoordinate2D = zzCurrentCoordinate2D;
    [self _tranformCoordinate];
}

- (void)setZzCurrentCoordinateSystem:(ZZLocationCoordinateSystem)zzCurrentCoordinateSystem {
    
    _zzCurrentCoordinateSystem = zzCurrentCoordinateSystem;
    [self _tranformCoordinate];
}

- (void)_tranformCoordinate {
    
    switch (self.zzCurrentCoordinateSystem) {
        case ZZLocationCoordinateSystemWGS84:
        {
            self.zzCoordinate2DWGS84 = self.zzCurrentCoordinate2D;
            self.zzCoordinate2DGCJ02 = [ZZLocationCoordinate zz_transformFromWGSToGCJ:self.zzCoordinate2DWGS84];
            self.zzCoordinate2DBD09  = [ZZLocationCoordinate zz_transformFromGCJToBaidu:self.zzCoordinate2DGCJ02];
        }
            break;
        case ZZLocationCoordinateSystemGCJ02:
        {
            self.zzCoordinate2DGCJ02 = self.zzCurrentCoordinate2D;
            self.zzCoordinate2DWGS84 = [ZZLocationCoordinate zz_transformFromGCJToWGS:self.zzCoordinate2DGCJ02];
            self.zzCoordinate2DBD09  = [ZZLocationCoordinate zz_transformFromGCJToBaidu:self.zzCoordinate2DGCJ02];
        }
            break;
        case ZZLocationCoordinateSystemBD09:
        {
            self.zzCoordinate2DBD09  = self.zzCurrentCoordinate2D;
            self.zzCoordinate2DGCJ02 = [ZZLocationCoordinate zz_transformFromBaiduToGCJ:self.zzCoordinate2DBD09];
            self.zzCoordinate2DWGS84 = [ZZLocationCoordinate zz_transformFromGCJToWGS:self.zzCoordinate2DGCJ02];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 经纬度坐标系转换

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromWGSToGCJ:(CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D _coordinate;
    if(![self zz_insideChina:coordinate]) {
        // 在国内
        _coordinate = coordinate;
    } else{
        double adjustLat = [self zz_transformLatitudeWithX:coordinate.longitude - 105.0 withY:coordinate.latitude - 35.0];
        double adjustLon = [self zz_transformLongitudeWithX:coordinate.longitude - 105.0 withY:coordinate.latitude - 35.0];
        long double radLat = coordinate.latitude / 180.0 * pi;
        long double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        long double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        _coordinate.latitude = coordinate.latitude + adjustLat;
        _coordinate.longitude = coordinate.longitude + adjustLon;
    }
    return _coordinate;
}

/**
 *  将GCJ-02(火星坐标)转为BD-09(百度坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromGCJToBaidu:(CLLocationCoordinate2D)coordinate {
    
    long double z = sqrt(coordinate.longitude * coordinate.longitude + coordinate.latitude * coordinate.latitude) + 0.00002 * sqrt(coordinate.latitude * pi);
    long double theta = atan2(coordinate.latitude, coordinate.longitude) + 0.000003 * cos(coordinate.longitude * pi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude = (z * sin(theta) + 0.006);
    geoPoint.longitude = (z * cos(theta) + 0.0065);
    return geoPoint;
}

/**
 *  将BD-09(百度坐标)转为GCJ-02(火星坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromBaiduToGCJ:(CLLocationCoordinate2D)coordinate {
    
    double x = coordinate.longitude - 0.0065, y = coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = z * sin(theta);
    geoPoint.longitude = z * cos(theta);
    return geoPoint;
}

/**
 *  将GCJ-02(火星坐标)转为WGS-84(地球坐标)
 */
+ (CLLocationCoordinate2D)zz_transformFromGCJToWGS:(CLLocationCoordinate2D)coordinate {
    
    double threshold = 0.00001;
    // The boundary
    double minLat = coordinate.latitude - 0.5;
    double maxLat = coordinate.latitude + 0.5;
    double minLng = coordinate.longitude - 0.5;
    double maxLng = coordinate.longitude + 0.5;
    double delta = 1;
    int maxIteration = 30;
    // Binary search
    while(true) {
        CLLocationCoordinate2D leftBottom  = [ZZLocationCoordinate zz_transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = minLng}];
        CLLocationCoordinate2D rightBottom = [ZZLocationCoordinate zz_transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = maxLng}];
        CLLocationCoordinate2D leftUp      = [ZZLocationCoordinate zz_transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = maxLat,.longitude = minLng}];
        CLLocationCoordinate2D midPoint    = [ZZLocationCoordinate zz_transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2.0),.longitude = ((minLng + maxLng) / 2.0)}];
        delta = fabs(midPoint.latitude - coordinate.latitude) + fabs(midPoint.longitude - coordinate.longitude);
        if( maxIteration-- <= 0 || delta <= threshold ) {
            return (CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2.0),.longitude = ((minLng + maxLng) / 2.0)};
        }
        if(zz_isContain(coordinate, leftBottom, midPoint)) {
            maxLat = (minLat + maxLat) / 2.0;
            maxLng = (minLng + maxLng) / 2.0;
        }else if(zz_isContain(coordinate, rightBottom, midPoint)) {
            maxLat = (minLat + maxLat) / 2.0;
            minLng = (minLng + maxLng) / 2.0;
        }else if(zz_isContain(coordinate, leftUp, midPoint)) {
            minLat = (minLat + maxLat) / 2.0;
            maxLng = (minLng + maxLng) / 2.0;
        }else {
            minLat = (minLat + maxLat) / 2.0;
            minLng = (minLng + maxLng) / 2.0;
        }
    }
}

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标),输出维度
 */
+ (double)zz_transformLatitudeWithX:(double)x withY:(double)y {
    
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标),输出经度
 */
+ (double)zz_transformLongitudeWithX:(double)x withY:(double)y {
    
    double lng = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lng += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lng += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lng += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lng;
}

/**
 *  将WGS-84(地球坐标)转为GCJ-02(火星坐标),输出经度
 */
static bool zz_isContain(CLLocationCoordinate2D point, CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
    
    return (point.latitude >= MIN(coordinate1.latitude, coordinate2.latitude) && point.latitude <= MAX(coordinate1.latitude, coordinate2.latitude)) && (point.longitude >= MIN(coordinate1.longitude, coordinate2.longitude) && point.longitude <= MAX(coordinate1.longitude, coordinate2.longitude));
}

#pragma mark - 判断WGS-84坐标是否在中国区域内

/**
 *  判断是否在中国（简易判断）
 */
+ (BOOL)zz_insideChina:(CLLocationCoordinate2D)coordinate {
    
    if (coordinate.longitude >= 72.004 && coordinate.longitude <= 137.8347 && coordinate.latitude >= 0.8293 && coordinate.latitude <= 55.8271) {
        return YES;
    }
    return NO;
}

/**
 *  判断location是否在中国（较复杂和精确判断）
 */
+ (BOOL)zz_insideChinaHighAccuracy:(CLLocationCoordinate2D)coordinate {
    
    // 范围矩形列表
    NSArray *regionRectangle = [[NSArray alloc] initWithObjects:
                                [ZZLBSRectangle zz_lbsRectangle:079.446200 latitude1:49.220400 longitude2:096.330000 latitude2:42.889900],
                                [ZZLBSRectangle zz_lbsRectangle:109.687200 latitude1:54.141500 longitude2:135.000200 latitude2:39.374200],
                                [ZZLBSRectangle zz_lbsRectangle:073.124600 latitude1:42.889900 longitude2:124.143255 latitude2:29.529700],
                                [ZZLBSRectangle zz_lbsRectangle:082.968400 latitude1:29.529700 longitude2:097.035200 latitude2:26.718600],
                                [ZZLBSRectangle zz_lbsRectangle:097.025300 latitude1:29.529700 longitude2:124.367395 latitude2:20.414096],
                                [ZZLBSRectangle zz_lbsRectangle:107.975793 latitude1:20.414096 longitude2:111.744104 latitude2:17.871542],
                                nil];
    
    // 范围内排除的矩形列表
    NSArray *excludeRectangle = [[NSArray alloc] initWithObjects:
                                 [ZZLBSRectangle zz_lbsRectangle:119.921265 latitude1:25.398623 longitude2:122.497559 latitude2:21.785006],
                                 [ZZLBSRectangle zz_lbsRectangle:101.865200 latitude1:22.284000 longitude2:106.665000 latitude2:20.098800],
                                 [ZZLBSRectangle zz_lbsRectangle:106.452500 latitude1:21.542200 longitude2:108.051000 latitude2:20.487800],
                                 [ZZLBSRectangle zz_lbsRectangle:109.032300 latitude1:55.817500 longitude2:119.127000 latitude2:50.325700],
                                 [ZZLBSRectangle zz_lbsRectangle:127.456800 latitude1:55.817500 longitude2:137.022700 latitude2:49.557400],
                                 [ZZLBSRectangle zz_lbsRectangle:131.266200 latitude1:44.892200 longitude2:137.022700 latitude2:42.569200],
                                 nil];
    
    for (ZZLBSRectangle *r in regionRectangle) {
        if ([r zz_pointInside:coordinate]) {
            for (ZZLBSRectangle *e in excludeRectangle) {
                if ([e zz_pointInside:coordinate]) {
                    return NO;
                }
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - 计算两点之间的直线距离

/**
 *  计算两点之间的直线距离（2个参数）
 */
+ (CLLocationDistance)zz_distance:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2 {
    
    return [[self class] zz_distance:coordinate1.longitude latitude1:coordinate1.latitude longitude2:coordinate2.longitude latitude2:coordinate2.latitude];
}

/**
 *  计算两点之间的直线距离（4个参数）
 */
+ (CLLocationDistance)zz_distance:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2 {
    
    // 第一个坐标
    CLLocation *start = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    // 第二个坐标
    CLLocation *end = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    // 计算距离
    CLLocationDistance meters = [start distanceFromLocation:end];
    return meters;
}

@end
