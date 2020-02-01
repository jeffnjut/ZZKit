//
//  ZZPhotoFilterManager.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/2.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "ZZPhotoManager.h"

@interface ZZPhotoFilterManager : NSObject

// 原始的CoreImage
@property (nullable, nonatomic, strong, readonly) CIImage *originalCIImage;

// 基础滤镜（控制亮度、对比度和饱和度）
@property (nullable, nonatomic, strong, readonly) CIFilter *colorControlFilter;

// 色温滤镜
@property (nullable, nonatomic, strong, readonly) CIFilter *temperatureFilter;

// 晕影滤镜
@property (nullable, nonatomic, strong, readonly) CIFilter *vignetteFilter;

+ (nonnull ZZPhotoFilterManager *)shared;

/**
 * 设置当前图片
 */
- (void)setOriginalImage:(nonnull UIImage *)originalImage;

/**
 * 获取CoreImage Filter（亮度、对比度、饱和度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation;

/**
 * 获取CoreImage Filter（亮度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage brightness:(float)brightness;

/**
 * 获取CoreImage Filter（对比度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage contrast:(float)contrast;

/**
 * 获取CoreImage Filter（饱和度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage saturation:(float)saturation;

/**
 * 获取CoreImage Filter（色温）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage temperature:(float)temperature;

/**
 * 获取CoreImage Filter（晕影）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage vignette:(float)vignette;

/**
 * 获取Image Filter（Filter Type）
 */
- (nonnull UIImage *)image:(nonnull UIImage *)image filterType:(ZZPhotoFilterType)filterType;

/**
 * 获取一组滤镜后的照片（滤镜中已经设置inputImage）
 */
- (nonnull UIImage *)image:(nonnull NSArray<CIFilter *> *)filters;

/**
 * 获取Tuning和滤镜类型效果的照片（输入UIImage）
 */
- (nonnull UIImage *)image:(nonnull UIImage *)image tuningObject:(nonnull ZZPhotoTuning *)tuningObject appendFilterType:(ZZPhotoFilterType)filterType;

/**
 * 获取Tuning和滤镜类型效果的照片（输入PHAsset）
 */
- (nonnull UIImage *)imageWithAsset:(nonnull PHAsset *)asset tuningObject:(nonnull ZZPhotoTuning *)tuningObject appendFilterType:(ZZPhotoFilterType)filterType;

/**
 * 异步方式获取一组滤镜后的照片（滤镜中已经设置inputImage）
 */
- (void)asyncImageWithFilters:(nonnull NSArray<CIFilter *> *)filters result:(nonnull void(^)(UIImage * _Nonnull image))result;

/**
 * 根据FilterType获取ZZPhotoFilter
 */
- (nullable ZZPhotoFilter *)filter:(ZZPhotoFilterType)type;

/**
 * 支持的滤镜类型
 */
+ (nonnull NSArray *)filterTypes;


@end
