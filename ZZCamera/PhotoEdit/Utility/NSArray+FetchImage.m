//
//  NSArray+FetchImage.m
//  ZZKit
//
//  Created by Fu Jie on 2020/1/31.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "NSArray+FetchImage.h"
#import "NSArray+ZZKit.h"
#import "ZZPhotoFilterManager.h"

@implementation NSArray (FetchImage)

/**
 * 不带滤镜和调整参数的图片数组
 */
- (NSArray<UIImage *> *)zz_imagesWithoutFilters {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (ZZPhotoAsset *asset in self) {
        if (![asset isKindOfClass:[ZZPhotoAsset class]]) {
            return nil;
        }
        [arr zz_arrayAddObject:asset.currentImage];
    }
    return arr;
}

/**
 * 带滤镜和调整参数的图片数组
 */
- (NSArray<UIImage *> *)zz_images {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (ZZPhotoAsset *asset in self) {
        if (![asset isKindOfClass:[ZZPhotoAsset class]]) {
            return nil;
        }
        UIImage *image = [[ZZPhotoFilterManager shared] image:asset.currentImage tuningObject:asset.tuningObject appendFilterType:asset.tuningObject.filterType];
        [arr zz_arrayAddObject:image];
    }
    return arr;
}

@end
