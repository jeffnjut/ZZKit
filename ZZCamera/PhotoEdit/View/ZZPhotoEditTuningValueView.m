//
//  ZZPhotoEditTuningValueView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoEditTuningValueView.h"
#import "ZZMacro.h"

@interface ZZPhotoEditTuningValueView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UISlider *valueSlider;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) float min;
@property (nonatomic, assign) float max;
@property (nonatomic, assign) float defaultValue;

@end

@implementation ZZPhotoEditTuningValueView

+ (ZZPhotoEditTuningValueView *)create:(CGRect)frame title:(NSString *)title value:(float)value defaultValue:(float)defaultValue range:(NSArray *)range valueChangedBlock:(void(^)(float value))valueChangedBlock editingBlock:(void(^)(BOOL inEditing))editingBlock okBlock:(void(^)(float value))okBlock {
    
    ZZPhotoEditTuningValueView *view = ZZ_LOAD_NIB(@"ZZPhotoEditTuningValueView");
    view.frame = frame;
    if (range.count == 2) {
        view.min = [range[0] floatValue];
        view.max = [range[1] floatValue];
    }
    view.defaultValue = defaultValue;
    view.value = value;
    [view updateTitle:title];
    view.editingBlock = editingBlock;
    view.valueChangedBlock = valueChangedBlock;
    view.okBlock = okBlock;
    view.valueSlider.value = [view _untranslatedValue:value];
    view.valueLabel.text = [NSString stringWithFormat:@"%d", (int)view.valueSlider.value];
    [view.valueSlider addTarget:view action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    valueChangedBlock == nil ? : valueChangedBlock(value);
    return view;
}

- (void)updateTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

// Slider Value 转成 Range Value
- (void)updateValue:(float)value {
    
    if (self.value == [self _translateValue:value]) {
        return;
    }
    self.value = [self _translateValue:value];
    self.valueChangedBlock == nil ? : self.valueChangedBlock(self.value);
}

- (IBAction)_tapBack:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(NO);
    [self removeFromSuperview];
}

- (IBAction)_tapOK:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(NO);
    self.okBlock == nil ? : self.okBlock(self.value);
    [self removeFromSuperview];
}

- (void)_sliderValueChanged:(UISlider *)slider {
    
    [self updateValue:slider.value];
    self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
}

- (float)_translateValue:(float)value {
    
    float v = 0;
    float step = 0;
    if (value >= 0) {
        step = (self.max - self.defaultValue) / 100.0;
        v = self.defaultValue + value * step;
    }else {
        step = (self.defaultValue - self.min) / 100.0;
        v = self.min + (value + 100.0) * step;
    }
    return v;
}

- (int)_untranslatedValue:(float)value {
    
    int v = 0;
    float step = 0;
    if (value >= self.defaultValue) {
        step = 100.0 / (self.max - self.defaultValue);
        v = (value - self.defaultValue) * step;
    }else {
        step = 100.0 / (self.defaultValue - self.min);
        v = -100.0 + (value - self.min) * step;
    }
    return v;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
