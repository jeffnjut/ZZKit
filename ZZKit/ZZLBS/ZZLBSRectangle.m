//
//  ZZLBSRectangle.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLBSRectangle.h"

@interface ZZLBSRectangle()

@property (nonatomic, assign) CLLocationDegrees west;
@property (nonatomic, assign) CLLocationDegrees north;
@property (nonatomic, assign) CLLocationDegrees east;
@property (nonatomic, assign) CLLocationDegrees south;

@end

@implementation ZZLBSRectangle

- (instancetype)initWithLongitude1:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2 {
    
    self = [super init];
    if (self) {
        self.west =  MIN(longitude1, longitude2);
        self.east =  MAX(longitude1, longitude2);
        self.north = MAX(latitude1, latitude2);
        self.south = MIN(latitude1, latitude2);
    }
    return self;
}

/**
 *  根据东西经度和南北维度确定矩形围栏（4个CLLocationDegrees参数）
 */
+ (ZZLBSRectangle *)zz_lbsRectangle:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2 {

    return [[ZZLBSRectangle alloc] initWithLongitude1:longitude1 latitude1:latitude1 longitude2:longitude2 latitude2:latitude2];
}

/**
 *  根据东西经度和南北维度确定矩形围栏（2个CLLocationCoordinate2D参数）
 */
+ (ZZLBSRectangle *)zz_lbsRectangle:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2 {

    return [[ZZLBSRectangle alloc] initWithLongitude1:coordinate1.longitude latitude1:coordinate1.latitude longitude2:coordinate2.longitude latitude2:coordinate2.latitude];
}

/**
 *  coordinate是否落在矩形围栏内（4个CLLocationDegrees参数）
 */
+ (BOOL)zz_point:(CLLocationCoordinate2D)coordinate inside:(CLLocationDegrees)longitude1 latitude1:(CLLocationDegrees)latitude1 longitude2:(CLLocationDegrees)longitude2 latitude2:(CLLocationDegrees)latitude2 {
    
    ZZLBSRectangle *rectangle = [ZZLBSRectangle zz_lbsRectangle:longitude1 latitude1:latitude1 longitude2:longitude2 latitude2:latitude2];
    return [rectangle zz_pointInside:coordinate];
}

/**
 *  coordinate是否落在矩形围栏内（2个CLLocationCoordinate2D参数）
 */
+ (BOOL)zz_point:(CLLocationCoordinate2D)coordinate inside:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2 {
    
    ZZLBSRectangle *rectangle = [ZZLBSRectangle zz_lbsRectangle:coordinate1 coordinate2:coordinate2];
    return [rectangle zz_pointInside:coordinate];
}

/**
 *  coordinate是否落在矩形围栏内
 */
- (BOOL)zz_pointInside:(CLLocationCoordinate2D)coordinate {
    
    return self.west <= coordinate.longitude && self.east >= coordinate.longitude && self.north >= coordinate.latitude && self.south <= coordinate.latitude;
}

@end
