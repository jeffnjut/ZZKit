//
//  FJTuningObject.m
//  FJCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJTuningObject.h"

@implementation FJTuningObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.brightnessValue = 0;
        self.contrastValue = 1.0;
        self.saturationValue = 1.0;
        self.temperatureValue = 6500.0;
        self.vignetteValue = 0;
        self.filterType = FJFilterTypeOriginal;
    }
    return self;
}

- (void)setType:(FJTuningType)type value:(float)value {
    
    switch (type) {
        case FJTuningTypeBrightness:
        {
            self.brightnessValue = value;
            break;
        }
        case FJTuningTypeContrast:
        {
            self.contrastValue = value;
            break;
        }
        case FJTuningTypeSaturation:
        {
            self.saturationValue = value;
            break;
        }
        case FJTuningTypeTemperature:
        {
            self.temperatureValue = value;
            break;
        }
        case FJTuningTypeVignette:
        {
            self.vignetteValue = value;
            break;
        }
            
        default:
            break;
    }
}

@end
