//
//  ZZPhotoAsset.m
//  ZZKit
//
//  Created by Fu Jie on 2020/1/21.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "ZZPhotoAsset.h"
#import "ZZPhotoFilterManager.h"
#import "PHAsset+QuickEdit.h"
#import "UIImage+ZZKit.h"

@implementation ZZPhotoAsset

- (UIImage *)originalImage {
    
    if (_originalImage == nil) {
        _originalImage = [self.asset getGeneralTargetImage];
    }
    return _originalImage;
}

- (UIImage *)originalThumbImage {
    
    if (self.needCrop == NO) {
        if (_originalThumbImage == nil) {
            _originalThumbImage = [self.asset getSmallTargetImage];
            if (_originalThumbImage == nil) {
                if (_croppedImage != nil) {
                    _originalThumbImage = _croppedImage;
                }else {
                    _originalThumbImage = _originalImage;
                }
            }
        }
    }else {
        static CGPoint lastBeginPoint;
        if (_originalThumbImage == nil || !CGPointEqualToPoint(lastBeginPoint, self.beginCropPoint)) {
            _originalThumbImage = [[self.asset getSmallTargetImage] zz_imageCropBeginPointRatio:self.beginCropPoint endPointRatio:self.endCropPoint];
        }
        lastBeginPoint = self.beginCropPoint;
    }
    return _originalThumbImage;
}

- (UIImage *)currentImage {
    
    if (_croppedImage != nil) {
        return _croppedImage;
    }
    return self.originalImage;
}

- (UIImage *)currentFilteredImage {
    
    _currentImage = [[ZZPhotoFilterManager shared] image:self.currentImage tuningObject:self.tuningObject appendFilterType:self.tuningObject.filterType];
    return _currentImage;
}

- (nonnull NSMutableArray<UIImage *> *)filterThumbImages {
    
    if (_filterThumbImages == nil || _filterThumbImages.count == 0) {
        if (_filterThumbImages == nil) {
            _filterThumbImages = (NSMutableArray<UIImage *> *)[[NSMutableArray alloc] init];
        }
        for (int i = 0; i < [ZZPhotoFilterManager filterTypes].count; i++ ) {
            ZZPhotoFilterType type = [[[ZZPhotoFilterManager filterTypes] objectAtIndex:i] integerValue];
            UIImage *filteredSmallImage = [[ZZPhotoFilterManager shared] image:self.originalThumbImage filterType:type];
            if (filteredSmallImage) {
                [_filterThumbImages addObject:filteredSmallImage];
            }
        }
    }
    return _filterThumbImages;
}

- (nonnull id)init {
    self = [super init];
    if (self) {
        self.tuningObject = [[ZZPhotoTuning alloc] init];
        self.imageTags = (NSMutableArray<ZZPhotoTag *> *)[[NSMutableArray alloc] init];
        self.beginCropPoint = CGPointZero;
        self.endCropPoint = CGPointMake(1.0, 1.0);
    }
    return self;
}

/**
 * 初始化ZZPhotoAsset
 */
- (nonnull id)initWithAsset:(nonnull PHAsset *)asset {
    
    self = [self init];
    self.asset = asset;
    return self;
}

@end
