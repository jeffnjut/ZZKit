//
//  ZZFilterImageView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/1.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZFilterImageView.h"

@interface ZZFilterImageView ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL updated;

@end

@implementation ZZFilterImageView

- (void)dealloc
{
    
}

- (void)setHidden:(BOOL)hidden {
    
    if (hidden == YES) {
        self.updated = NO;
    }
    [super setHidden:hidden];
}

+ (ZZFilterImageView *)create:(CGRect)frame {
    
    ZZFilterImageView *view = ZZ_LOAD_NIB(@"ZZFilterImageView");
    view.frame = frame;
    return view;
}

- (void)updateImage:(UIImage *)image {
    
    if (self.updated) {
        return;
    }
    [[ZZPhotoFilterManager shared] setOriginalImage:image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    self.updated = YES;
}

- (void)updateCurrentTuning:(ZZPhotoTuning *)tuningObject {
    
    UIImage *image = [[ZZPhotoFilterManager shared] image:self.imageView.image tuningObject:tuningObject appendFilterType:tuningObject.filterType];
    self.imageView.image = image;
}

- (UIImage *)getFilterImage {
    
    return self.imageView.image;
}

- (void)updatePhoto:(ZZPhotoAsset *)photo brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation {

    ZZPhotoTuning *tuneObject = photo.tuningObject;
    CIFilter *filter1 = [[ZZPhotoFilterManager shared] coreImageFilter:[ZZPhotoFilterManager shared].originalCIImage brightness:brightness contrast:contrast saturation:saturation];
    CIFilter *filter2 = [[ZZPhotoFilterManager shared] coreImageFilter:nil temperature:tuneObject.temperatureValue];
    CIFilter *filter3 = [[ZZPhotoFilterManager shared] coreImageFilter:nil vignette:tuneObject.vignetteValue];
    CIFilter *filter4 = [[ZZPhotoFilterManager shared] filter:photo.tuningObject.filterType].filter;
    ZZ_WEAK_SELF
    NSArray *filters = nil;
    if (filter4 != nil) {
        filters = @[filter1, filter2, filter3, filter4];
    }else {
        filters = @[filter1, filter2, filter3];
    }
    [[ZZPhotoFilterManager shared] asyncImageWithFilters:filters result:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
}

- (void)updatePhoto:(ZZPhotoAsset *)photo temperature:(float)temperature {

    ZZPhotoTuning *tuneObject = photo.tuningObject;
    CIFilter *filter1 = [[ZZPhotoFilterManager shared] coreImageFilter:[ZZPhotoFilterManager shared].originalCIImage brightness:tuneObject.brightnessValue contrast:tuneObject.contrastValue saturation:tuneObject.saturationValue];
    CIFilter *filter2 = [[ZZPhotoFilterManager shared] coreImageFilter:nil temperature:temperature];
    CIFilter *filter3 = [[ZZPhotoFilterManager shared] coreImageFilter:nil vignette:tuneObject.vignetteValue];
    CIFilter *filter4 = [[ZZPhotoFilterManager shared] filter:photo.tuningObject.filterType].filter;
    ZZ_WEAK_SELF
    NSArray *filters = nil;
    if (filter4 != nil) {
        filters = @[filter1, filter2, filter3, filter4];
    }else {
        filters = @[filter1, filter2, filter3];
    }
    [[ZZPhotoFilterManager shared] asyncImageWithFilters:filters result:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
}

- (void)updatePhoto:(ZZPhotoAsset *)photo vignette:(float)vignette {

    ZZPhotoTuning *tuneObject = photo.tuningObject;
    CIFilter *filter1 = [[ZZPhotoFilterManager shared] coreImageFilter:[ZZPhotoFilterManager shared].originalCIImage brightness:tuneObject.brightnessValue contrast:tuneObject.contrastValue saturation:tuneObject.saturationValue];
    CIFilter *filter2 = [[ZZPhotoFilterManager shared] coreImageFilter:nil temperature:tuneObject.temperatureValue];
    CIFilter *filter3 = [[ZZPhotoFilterManager shared] coreImageFilter:nil vignette:vignette];
    CIFilter *filter4 = [[ZZPhotoFilterManager shared] filter:photo.tuningObject.filterType].filter;
    ZZ_WEAK_SELF
    NSArray *filters = nil;
    if (filter4 != nil) {
        filters = @[filter1, filter2, filter3, filter4];
    }else {
        filters = @[filter1, filter2, filter3];
    }
    [[ZZPhotoFilterManager shared] asyncImageWithFilters:filters result:^(UIImage *image) {
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
