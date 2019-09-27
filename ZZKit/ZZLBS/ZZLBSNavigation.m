//
//  ZZLBSNavigation.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLBSNavigation.h"
#import <UIKit/UIKit.h>
#import "UIViewController+ZZKit.h"

@implementation ZZLBSNavigation

+ (NSArray *)zz_availableMaps {
    
    NSMutableArray *availableMaps = nil;
    
    // 高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_GAODE]]) {
        if (availableMaps == nil) {
            availableMaps = [[NSMutableArray alloc] init];
        }
        [availableMaps addObject:SCHEME_MAP_GAODE];
    }
    
    // 腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_QQ]]) {
        if (availableMaps == nil) {
            availableMaps = [[NSMutableArray alloc] init];
        }
        [availableMaps addObject:SCHEME_MAP_QQ];
    }
    
    // 百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_BAIDU]]) {
        if (availableMaps == nil) {
            availableMaps = [[NSMutableArray alloc] init];
        }
        [availableMaps addObject:SCHEME_MAP_BAIDU];
    }
    
    // Google地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_GOOGLE]]) {
        if (availableMaps == nil) {
            availableMaps = [[NSMutableArray alloc] init];
        }
        [availableMaps addObject:SCHEME_MAP_GOOGLE];
    }
    return availableMaps;
}

/**
 *  唤醒第三方导航（CLLocationCoordinate2D + ZZLocationCoordinateSystem）
 */
+ (void)zz_startNavigaion:(CLLocationCoordinate2D)destinationCoordinate
         coordinateSystem:(ZZLocationCoordinateSystem)coordinateSystem
          destinationName:(nonnull NSString *)destinationName
            yourAppScheme:(nonnull NSString *)yourAppScheme
               controller:(nonnull UIViewController *)controller
                     maps:(nullable NSArray<NSString *> *)maps
                    block:(nullable void(^)(NSDictionary *mapURLs, ZZLBSNavigationVoidBlock startNavigationBlock))block {
    
    ZZLocationCoordinate *destCoordinate = [[ZZLocationCoordinate alloc] initWithCoordinate2D:destinationCoordinate coordinateSystem:coordinateSystem];
    [self zz_startNavigaion:destCoordinate destinationName:destinationName yourAppScheme:yourAppScheme controller:controller maps:maps block:block];
}

/**
 *  唤醒第三方导航（ZZLocationCoordinate）
 */
+ (void)zz_startNavigaion:(nonnull ZZLocationCoordinate *)destinationCoordinate
          destinationName:(nonnull NSString *)destinationName
            yourAppScheme:(nonnull NSString *)yourAppScheme
               controller:(nullable UIViewController *)controller
                     maps:(nullable NSArray<NSString *> *)maps
                    block:(nullable void(^)(NSDictionary *mapURLs, ZZLBSNavigationVoidBlock startNavigationBlock))block {
    
    NSArray *_availableMaps = [self zz_availableMaps];
    
    NSMutableArray *_maps = nil;
    if (maps == nil || maps.count == 0) {
        _maps = (NSMutableArray *)_availableMaps;
    }else {
        _maps = [NSMutableArray arrayWithArray:maps];
        for (int i = (int)_maps.count - 1; i >= 0; i--) {
            NSString *map = [_maps objectAtIndex:i];
            BOOL find = NO;
            for (NSString *_available in _availableMaps) {
                if ([map isEqualToString:_available]) {
                    find = YES;
                    break;
                }
            }
            if (!find) {
                [_maps removeObjectAtIndex:i];
            }
        }
    }
    
    NSMutableArray *alertItems = nil;
    NSMutableDictionary *mapURLs = nil;
    if (block != nil) {
        mapURLs = [[NSMutableDictionary alloc] init];
    }else {
        alertItems = [[NSMutableArray alloc] init];
    }
    
    // 判断目的地地址是否在国内，在国内需要根据不同的三方导航转换坐标系
    __block BOOL _insideChina = [ZZLocationCoordinate zz_insideChina:destinationCoordinate.zzCurrentCoordinate2D];
    
    // 苹果自带导航
    ZZLBSNavigationVoidBlock _executeAppleDirection = ^{
        
        CLLocationCoordinate2D coordinate;
        if (_insideChina) {
            // 转成高德国内坐标系GCJ-02
            coordinate = destinationCoordinate.zzCoordinate2DGCJ02;
        }else {
            coordinate = destinationCoordinate.zzCurrentCoordinate2D;
        }
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        toLocation.name = destinationName;
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey:@YES}];
    };
    
    // iOS自带地图
    if (mapURLs) {
        [mapURLs setValue:SCHEME_MAP_APPLE forKey:SCHEME_MAP_APPLE];
    }else if (alertItems) {
        ZZAlertModel *alertModel = [ZZAlertModel zz_alertModel:@"苹果地图" style:UIAlertActionStyleDefault action:_executeAppleDirection color:[UIColor blackColor]];
        [alertItems addObject:alertModel];
    }
    
    // Google地图
    if ([_maps containsObject:SCHEME_MAP_GOOGLE]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], yourAppScheme, destinationCoordinate.zzCoordinate2DGCJ02.latitude, destinationCoordinate.zzCoordinate2DGCJ02.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], yourAppScheme, destinationCoordinate.zzCurrentCoordinate2D.latitude, destinationCoordinate.zzCurrentCoordinate2D.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        if (mapURLs) {
            [mapURLs setValue:url forKey:SCHEME_MAP_GOOGLE];
        }else if (alertItems) {
            ZZAlertModel *alertModel = [ZZAlertModel zz_alertModel:@"Google地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    
    // 高德地图
    if ([_maps containsObject:SCHEME_MAP_GAODE]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], yourAppScheme, destinationName, destinationCoordinate.zzCoordinate2DGCJ02.latitude, destinationCoordinate.zzCoordinate2DGCJ02.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], yourAppScheme, destinationName, destinationCoordinate.zzCurrentCoordinate2D.latitude, destinationCoordinate.zzCurrentCoordinate2D.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        if (mapURLs) {
            [mapURLs setValue:url forKey:SCHEME_MAP_GAODE];
        }else if (alertItems) {
            ZZAlertModel *alertModel = [ZZAlertModel zz_alertModel:@"高德地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    
    // 百度地图
    if ([_maps containsObject:SCHEME_MAP_BAIDU]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:0,0|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving", destinationCoordinate.zzCoordinate2DBD09.latitude, destinationCoordinate.zzCoordinate2DBD09.longitude, destinationName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:0,0|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving", destinationCoordinate.zzCurrentCoordinate2D.latitude, destinationCoordinate.zzCurrentCoordinate2D.longitude, destinationName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        if (mapURLs) {
            [mapURLs setValue:url forKey:SCHEME_MAP_BAIDU];
        }else if (alertItems) {
            ZZAlertModel *alertModel = [ZZAlertModel zz_alertModel:@"百度地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    
    // 腾讯地图
    if ([_maps containsObject:SCHEME_MAP_QQ]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0", destinationCoordinate.zzCoordinate2DGCJ02.latitude, destinationCoordinate.zzCoordinate2DGCJ02.longitude, destinationName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0", destinationCoordinate.zzCurrentCoordinate2D.latitude, destinationCoordinate.zzCurrentCoordinate2D.longitude, destinationName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        if (mapURLs) {
            [mapURLs setValue:url forKey:SCHEME_MAP_QQ];
        }else if (alertItems) {
            ZZAlertModel *alertModel = [ZZAlertModel zz_alertModel:@"腾讯地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    if (mapURLs) {
        block(mapURLs, _executeAppleDirection);
    }else if (alertItems) {
        [controller zz_alert:@"" message:@"请选择导航地图" items:alertItems cancel:YES cancelColor:[UIColor redColor] alertStyle:UIAlertControllerStyleActionSheet];
    }
}

@end
