//
//  ZZFilterImageView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/1.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMacro.h"
#import <CoreImage/CoreImage.h>
#import "ZZPhotoManager.h"
#import "ZZPhotoFilterManager.h"

@interface ZZFilterImageView : UIView

+ (ZZFilterImageView *)create:(CGRect)frame;

- (void)updateImage:(UIImage *)image;

- (void)updateCurrentTuning:(ZZPhotoTuning *)tuningObject;

- (UIImage *)getFilterImage;

- (void)updatePhoto:(ZZPhotoAsset *)photo brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation;

- (void)updatePhoto:(ZZPhotoAsset *)photo temperature:(float)temperature;

- (void)updatePhoto:(ZZPhotoAsset *)photo vignette:(float)vignette;

@end
