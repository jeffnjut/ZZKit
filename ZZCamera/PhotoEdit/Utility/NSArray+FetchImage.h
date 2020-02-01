//
//  NSArray+FetchImage.h
//  ZZKit
//
//  Created by Fu Jie on 2020/1/31.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZPhotoAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (FetchImage)

/**
 * 不带滤镜和调整参数的图片数组
 */
- (NSArray<UIImage *> *)zz_imagesWithoutFilters;

/**
 * 带滤镜和调整参数的图片数组
 */
- (NSArray<UIImage *> *)zz_images;

@end

NS_ASSUME_NONNULL_END
