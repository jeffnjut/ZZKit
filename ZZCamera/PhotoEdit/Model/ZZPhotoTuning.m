//
//  ZZPhotoTuning.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoTuning.h"

@implementation ZZPhotoTuning

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        self.brightnessValue = 0;
        self.contrastValue = 1.0;
        self.saturationValue = 1.0;
        self.temperatureValue = 6500.0;
        self.vignetteValue = 0;
        self.filterType = ZZPhotoFilterTypeOriginal;
    }
    return self;
}

- (void)setType:(ZZPhotoTuningType)type value:(float)value {
    
    switch (type) {
        case ZZPhotoTuningTypeBrightness:
        {
            self.brightnessValue = value;
            break;
        }
        case ZZPhotoTuningTypeContrast:
        {
            self.contrastValue = value;
            break;
        }
        case ZZPhotoTuningTypeSaturation:
        {
            self.saturationValue = value;
            break;
        }
        case ZZPhotoTuningTypeTemperature:
        {
            self.temperatureValue = value;
            break;
        }
        case ZZPhotoTuningTypeVignette:
        {
            self.vignetteValue = value;
            break;
        }
            
        default:
            break;
    }
}

@end
