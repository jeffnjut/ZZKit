//
//  PHAsset+QuickEdit.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/12/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "PHAsset+QuickEdit.h"

@implementation PHAsset (QuickEdit)

/**
 *  同步获取小尺寸的图片
 */
- (UIImage *)getSmallTargetImage {
    
    if (@available(iOS 13.0, *)) {
        return [self zz_imageSyncTargetSize:CGSizeMake(ZZCAMERA_IMAGE_WIDTH, ZZCAMERA_IMAGE_HEIGHT) multiples:1.0 fast:NO];
    }
    return [self zz_imageSyncTargetSize:CGSizeMake(ZZCAMERA_IMAGE_WIDTH, ZZCAMERA_IMAGE_HEIGHT) multiples:1.0 fast:YES];
}

/**
 *  同步获取一般尺寸的图片
 */
- (UIImage *)getGeneralTargetImage {
    
    if (@available(iOS 13.0, *)) {
        return [self zz_imageSyncTargetSize:CGSizeMake(ZZCAMERA_IMAGE_WIDTH, ZZCAMERA_IMAGE_HEIGHT) multiples:4.0 fast:NO];
    }
    return [self zz_imageSyncTargetSize:CGSizeMake(ZZCAMERA_IMAGE_WIDTH, ZZCAMERA_IMAGE_HEIGHT) multiples:4.0 fast:YES];
}

@end
