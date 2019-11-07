//
//  FJFilterImageView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/1.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMacro.h"
#import <CoreImage/CoreImage.h>
#import "FJPhotoManager.h"
#import "FJFilterManager.h"

@interface FJFilterImageView : UIView

+ (FJFilterImageView *)create:(CGRect)frame;

- (void)updateImage:(UIImage *)image;

- (void)updateCurrentTuning:(FJTuningObject *)tuningObject;

- (UIImage *)getFilterImage;

- (void)updatePhoto:(FJPhotoModel *)photo brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation;

- (void)updatePhoto:(FJPhotoModel *)photo temperature:(float)temperature;

- (void)updatePhoto:(FJPhotoModel *)photo vignette:(float)vignette;

@end
