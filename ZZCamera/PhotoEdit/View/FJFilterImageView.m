//
//  FJFilterImageView.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/1.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJFilterImageView.h"

@interface FJFilterImageView ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL updated;

@end

@implementation FJFilterImageView

- (void)dealloc
{
    
}

- (void)setHidden:(BOOL)hidden {
    
    if (hidden == YES) {
        self.updated = NO;
    }
    [super setHidden:hidden];
}

+ (FJFilterImageView *)create:(CGRect)frame {
    
    FJFilterImageView *view = ZZ_LOAD_NIB(@"FJFilterImageView");
    view.frame = frame;
    return view;
}

- (void)updateImage:(UIImage *)image {
    
    if (self.updated) {
        return;
    }
    [[FJFilterManager shared] updateImage:image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    self.updated = YES;
}

- (void)updateCurrentTuning:(FJTuningObject *)tuningObject {
    
    UIImage *image = [[FJFilterManager shared] getImage:self.imageView.image tuningObject:tuningObject appendFilterType:tuningObject.filterType];
    self.imageView.image = image;
}

- (UIImage *)getFilterImage {
    
    return self.imageView.image;
}

- (void)updatePhoto:(FJPhotoModel *)photo brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation {

    FJTuningObject *tuneObject = photo.tuningObject;
    CIFilter *filter1 = [[FJFilterManager shared] filterApplyTo:[FJFilterManager shared].originalCIImage brightness:brightness contrast:contrast saturation:saturation];
    CIFilter *filter2 = [[FJFilterManager shared] filterApplyTo:nil temperature:tuneObject.temperatureValue];
    CIFilter *filter3 = [[FJFilterManager shared] filterApplyTo:nil vignette:tuneObject.vignetteValue];
    CIFilter *filter4 = [[FJFilterManager shared] filterBy:photo.tuningObject.filterType];
    ZZ_WEAK_SELF
    NSArray *filters = nil;
    if (filter4 != nil) {
        filters = @[filter1, filter2, filter3, filter4];
    }else {
        filters = @[filter1, filter2, filter3];
    }
    [[FJFilterManager shared] getImageCombine:filters result:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
}

- (void)updatePhoto:(FJPhotoModel *)photo temperature:(float)temperature {

    FJTuningObject *tuneObject = photo.tuningObject;
    CIFilter *filter1 = [[FJFilterManager shared] filterApplyTo:[FJFilterManager shared].originalCIImage brightness:tuneObject.brightnessValue contrast:tuneObject.contrastValue saturation:tuneObject.saturationValue];
    CIFilter *filter2 = [[FJFilterManager shared] filterApplyTo:nil temperature:temperature];
    CIFilter *filter3 = [[FJFilterManager shared] filterApplyTo:nil vignette:tuneObject.vignetteValue];
    CIFilter *filter4 = [[FJFilterManager shared] filterBy:photo.tuningObject.filterType];
    ZZ_WEAK_SELF
    NSArray *filters = nil;
    if (filter4 != nil) {
        filters = @[filter1, filter2, filter3, filter4];
    }else {
        filters = @[filter1, filter2, filter3];
    }
    [[FJFilterManager shared] getImageCombine:filters result:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
}

- (void)updatePhoto:(FJPhotoModel *)photo vignette:(float)vignette {

    FJTuningObject *tuneObject = photo.tuningObject;
    CIFilter *filter1 = [[FJFilterManager shared] filterApplyTo:[FJFilterManager shared].originalCIImage brightness:tuneObject.brightnessValue contrast:tuneObject.contrastValue saturation:tuneObject.saturationValue];
    CIFilter *filter2 = [[FJFilterManager shared] filterApplyTo:nil temperature:tuneObject.temperatureValue];
    CIFilter *filter3 = [[FJFilterManager shared] filterApplyTo:nil vignette:vignette];
    CIFilter *filter4 = [[FJFilterManager shared] filterBy:photo.tuningObject.filterType];
    ZZ_WEAK_SELF
    NSArray *filters = nil;
    if (filter4 != nil) {
        filters = @[filter1, filter2, filter3, filter4];
    }else {
        filters = @[filter1, filter2, filter3];
    }
    [[FJFilterManager shared] getImageCombine:filters result:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
