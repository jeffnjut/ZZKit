//
//  PHAsset+QuickEdit.h
//  FJCamera
//
//  Created by Fu Jie on 2018/12/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Photos/Photos.h>
#import "PHAsset+Utility.h"

// 用于FJPhotoEditViewController
#define FJCAMERA_IMAGE_WIDTH  (800.0)
#define FJCAMERA_IMAGE_HEIGHT (1000.0)

@interface PHAsset (QuickEdit)

/**
 *  同步获取小尺寸的图片
 */
- (UIImage *)getSmallTargetImage;

/**
 *  同步获取一般尺寸的图片
 */
- (UIImage *)getGeneralTargetImage;

/**
 *  同步获取一般尺寸的图片
 */
- (UIImage *)getLargeTargetImage;

@end
