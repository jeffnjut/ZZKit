//
//  PHAsset+QuickEdit.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/12/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Photos/Photos.h>
#import "PHAsset+Utility.h"

// 用于ZZPhotoEditViewController
#define ZZCAMERA_IMAGE_WIDTH  (400.0)
#define ZZCAMERA_IMAGE_HEIGHT (480.0)

@interface PHAsset (QuickEdit)

/**
 *  同步获取小尺寸的图片
 */
- (UIImage *)getSmallTargetImage;

/**
 *  同步获取一般尺寸的图片
 */
- (UIImage *)getGeneralTargetImage;

@end
