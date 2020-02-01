//
//  ZZPhotoEditTuningView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoEditTuningView.h"
#import "ZZMacro.h"

@interface ZZPhotoEditTuningView ()

@end

@implementation ZZPhotoEditTuningView

+ (ZZPhotoEditTuningView *)create:(CGRect)frame editingBlock:(void(^)(BOOL inEditing))editingBlock tuneBlock:(void(^)(ZZPhotoTuningType type, float value, BOOL confirm))tuneBlock {
    
    ZZPhotoEditTuningView *view = ZZ_LOAD_NIB(@"ZZPhotoEditTuningView");
    view.frame = frame;
    view.editingBlock = editingBlock;
    view.tuneBlock = tuneBlock;
    return view;
}

- (IBAction)_tapLight:(id)sender {
    
    ZZ_WEAK_SELF
    self.editingBlock == nil ? : self.editingBlock(YES);
    ZZPhotoTuning *object = ZZPhotoManager.shared.currentPhoto.tuningObject;
    ZZPhotoEditTuningValueView *view = [ZZPhotoEditTuningValueView create:self.bounds title:@"亮度" value:object.brightnessValue defaultValue:0 range:@[@(-0.5), @(0.5)] valueChangedBlock:^(float value) {
        weakSelf.editingBlock == nil ? : weakSelf.editingBlock(YES);
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeBrightness, value, NO);
    } editingBlock:self.editingBlock okBlock:^(float value) {
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeBrightness, value, YES);
    }];
    [self addSubview:view];
}

- (IBAction)_tapContrast:(id)sender {

    ZZ_WEAK_SELF
    self.editingBlock == nil ? : self.editingBlock(YES);
    ZZPhotoTuning *object = ZZPhotoManager.shared.currentPhoto.tuningObject;
    ZZPhotoEditTuningValueView *view = [ZZPhotoEditTuningValueView create:self.bounds title:@"对比度" value:object.contrastValue defaultValue:1.0 range:@[@(0.25), @(4.0)] valueChangedBlock:^(float value) {
        weakSelf.editingBlock == nil ? : weakSelf.editingBlock(YES);
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeContrast, value, NO);
    } editingBlock:self.editingBlock okBlock:^(float value) {
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeContrast, value, YES);
    }];
    [self addSubview:view];
}

- (IBAction)_tapSaturation:(id)sender {
    
    ZZ_WEAK_SELF
    self.editingBlock == nil ? : self.editingBlock(YES);
    ZZPhotoTuning *object = ZZPhotoManager.shared.currentPhoto.tuningObject;
    ZZPhotoEditTuningValueView *view = [ZZPhotoEditTuningValueView create:self.bounds title:@"饱和度" value:object.saturationValue defaultValue:1.0 range:@[@(0), @(2.0)] valueChangedBlock:^(float value) {
        weakSelf.editingBlock == nil ? : weakSelf.editingBlock(YES);
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeSaturation, value, NO);
    } editingBlock:self.editingBlock okBlock:^(float value) {
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeSaturation, value, YES);
    }];
    [self addSubview:view];
}

- (IBAction)_tapWarm:(id)sender {
    
    ZZ_WEAK_SELF
    self.editingBlock == nil ? : self.editingBlock(YES);
    ZZPhotoTuning *object = ZZPhotoManager.shared.currentPhoto.tuningObject;
    ZZPhotoEditTuningValueView *view = [ZZPhotoEditTuningValueView create:self.bounds title:@"暖色调" value:object.temperatureValue defaultValue:6500.0 range:@[@(3000.0), @(15000.0)] valueChangedBlock:^(float value) {
        weakSelf.editingBlock == nil ? : weakSelf.editingBlock(YES);
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeTemperature, value, NO);
    } editingBlock:self.editingBlock okBlock:^(float value) {
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeTemperature, value, YES);
    }];
    [self addSubview:view];
}

- (IBAction)_tapHalation:(id)sender {
    
    ZZ_WEAK_SELF
    self.editingBlock == nil ? : self.editingBlock(YES);
    ZZPhotoTuning *object = ZZPhotoManager.shared.currentPhoto.tuningObject;
    ZZPhotoEditTuningValueView *view = [ZZPhotoEditTuningValueView create:self.bounds title:@"晕影" value:object.vignetteValue defaultValue:0 range:@[@(-1.0), @(1.0)] valueChangedBlock:^(float value) {
        weakSelf.editingBlock == nil ? : weakSelf.editingBlock(YES);
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeVignette, value, NO);
    } editingBlock:self.editingBlock okBlock:^(float value) {
        weakSelf.tuneBlock == nil ? : weakSelf.tuneBlock(ZZPhotoTuningTypeVignette, value, YES);
    }];
    [self addSubview:view];
}

- (IBAction)_tapBack:(id)sender {
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
