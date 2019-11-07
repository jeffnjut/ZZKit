//
//  PHAsset+QuickEdit.m
//  FJCamera
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
        return [self fj_imageSyncTargetSize:CGSizeMake(FJCAMERA_IMAGE_WIDTH, FJCAMERA_IMAGE_HEIGHT) multiples:0.2 fast:NO];
    }
    return [self fj_imageSyncTargetSize:CGSizeMake(FJCAMERA_IMAGE_WIDTH, FJCAMERA_IMAGE_HEIGHT) multiples:0.2 fast:YES];
}

/**
 *  同步获取一般尺寸的图片
 */
- (UIImage *)getGeneralTargetImage {
    
    if (@available(iOS 13.0, *)) {
        return [self fj_imageSyncTargetSize:CGSizeMake(FJCAMERA_IMAGE_WIDTH, FJCAMERA_IMAGE_HEIGHT) multiples:2.0 fast:NO];
    }
    return [self fj_imageSyncTargetSize:CGSizeMake(FJCAMERA_IMAGE_WIDTH, FJCAMERA_IMAGE_HEIGHT) multiples:2.0 fast:YES];
}

/**
 *  同步获取一般尺寸的图片
 */
- (UIImage *)getLargeTargetImage {
    
    if (@available(iOS 13.0, *)) {
        return [self fj_imageSyncTargetSize:CGSizeMake(FJCAMERA_IMAGE_WIDTH, FJCAMERA_IMAGE_HEIGHT) multiples:3.0 fast:NO];
    }
    return [self fj_imageSyncTargetSize:CGSizeMake(FJCAMERA_IMAGE_WIDTH, FJCAMERA_IMAGE_HEIGHT) multiples:3.0 fast:YES];
}

@end
