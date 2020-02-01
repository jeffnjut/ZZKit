//
//  ZZPhotoTuning.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZPhotoFilter.h"

typedef NS_ENUM(NSInteger, ZZPhotoTuningType) {
    // 亮度
    ZZPhotoTuningTypeBrightness,
    // 对比度
    ZZPhotoTuningTypeContrast,
    // 饱和度
    ZZPhotoTuningTypeSaturation,
    // 色温
    ZZPhotoTuningTypeTemperature,
    // 晕影
    ZZPhotoTuningTypeVignette
};

@protocol ZZPhotoTuning <NSObject>
@end

@interface ZZPhotoTuning : NSObject

// 亮度 [-100, 100] 默认 0
@property (nonatomic, assign) float brightnessValue;

// 对比度 [-100, 100] 默认 0
@property (nonatomic, assign) float contrastValue;

// 暖色调 [-100, 100] 默认 0
@property (nonatomic, assign) float saturationValue;

// 饱和度 [-100, 100] 默认 0
@property (nonatomic, assign) float temperatureValue;

// 晕影 [-100, 100] 默认 0
@property (nonatomic, assign) float vignetteValue;

// 固定滤镜
@property (nonatomic, assign) ZZPhotoFilterType filterType;

- (void)setType:(ZZPhotoTuningType)type value:(float)value;

@end
