//
//  FJFilterManager.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/2.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "FJPhotoManager.h"

@interface FJFilterManager : NSObject

@property (nullable, nonatomic, strong, readonly) CIImage *originalCIImage;

// 控制Brightness, contrast, saturation的滤镜
@property (nullable, nonatomic, strong, readonly) CIFilter *colorControlFilter;
// 控制色温滤镜
@property (nullable, nonatomic, strong, readonly) CIFilter *temperatureFilter;
// 暗角滤镜
@property (nullable, nonatomic, strong, readonly) CIFilter *vignetteFilter;

+ (nonnull FJFilterManager *)shared;

- (void)updateImage:(nonnull UIImage *)image;

- (void)setFilter:(nonnull CIFilter *)filter inputImage:(nonnull CIImage *)ciImage;

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation;

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage brightness:(float)brightness;

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage contrast:(float)contrast;

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage saturation:(float)saturation;

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage temperature:(float)temperature;

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage vignette:(float)vignette;

- (nonnull UIImage *)getImage:(nonnull UIImage *)image filterType:(FJFilterType)filterType;

- (void)getImageCombine:(nonnull NSArray<CIFilter *> *)filters result:(nonnull void(^)(UIImage * _Nonnull image))result;

- (nonnull UIImage *)getImageCombine:(nonnull NSArray<CIFilter *> *)filters;

- (nonnull UIImage *)getImage:(nonnull UIImage *)image tuningObject:(nonnull FJTuningObject *)tuningObject appendFilterType:(FJFilterType)filterType;

- (nonnull UIImage *)getImageAsset:(nonnull PHAsset *)asset tuningObject:(nonnull FJTuningObject *)tuningObject appendFilterType:(FJFilterType)filterType;

- (nonnull CIFilter *)filterBy:(FJFilterType)type;

@end
