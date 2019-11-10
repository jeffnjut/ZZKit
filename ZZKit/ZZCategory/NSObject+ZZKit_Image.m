//
//  NSObject+ZZKit_Image.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSObject+ZZKit_Image.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import "UIImage+ZZKit.h"
#import "NSData+ZZKit.h"

typedef NS_ENUM(NSInteger, SelfType) {
    SelfTypeUnknown,
    SelfTypeUIImageView,
    SelfTypeUIButton,
    SelfTypeBarButtonItem,
    SelfTypeTabBarItem
};


@implementation NSObject (ZZKit_Image)

/**
 *  设置任意图片源
 */
- (void)zz_setImage:(id)anyResource {
    
    [self zz_setImage:anyResource isSelected:NO];
}

/**
 *  设置任意图片源(isSelected)
 */
- (void)zz_setImage:(id)anyResource isSelected:(BOOL)isSelected {
    
    [self zz_setImage:anyResource isSelected:isSelected renderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 *  设置任意图片源(Base, isSelect, renderingMode)
 */
- (void)zz_setImage:(id)anyResource isSelected:(BOOL)isSelected renderingMode:(UIImageRenderingMode)renderingMode {
    
    [self zz_setImage:anyResource isSelected:isSelected renderingMode:renderingMode scale:nil fixedWidth:nil];
}

/**
 *  设置任意图片源(Base, isSelect, renderingMode, scale, fixedWidth[与scale、fixedWidth设置一个，fixedWidth和Height是等比缩放])
 */
- (void)zz_setImage:(id)anyResource isSelected:(BOOL)isSelected renderingMode:(UIImageRenderingMode)renderingMode scale:(nullable NSNumber *)scale fixedWidth:(nullable NSNumber *)fixedWidth {
    
    if (anyResource == nil || !([anyResource isKindOfClass:[NSString class]] || [anyResource isKindOfClass:[NSData class]] || [anyResource isKindOfClass:[UIImage class]])) {
        return;
    }
    __block SelfType type = SelfTypeUnknown;
    if ([self isKindOfClass:[UIImageView class]]) {
        type = SelfTypeUIImageView;
    }else if ([self isKindOfClass:[UIButton class]]) {
        type = SelfTypeUIButton;
    }else if ([self isKindOfClass:[UIBarButtonItem class]]) {
        type = SelfTypeBarButtonItem;
    }else if ([self isKindOfClass:[UITabBarItem class]]) {
        type = SelfTypeTabBarItem;
    }else{
        return;
    }
    
    if ([anyResource isKindOfClass:[NSString class]]) {
        
        if ([(NSString *)anyResource containsString:@"http://"] || [(NSString *)anyResource containsString:@"https://"]) {
            __weak typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:anyResource]
                                                        options:SDWebImageContinueInBackground | SDWebImageRetryFailed
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                           
                                                       } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                           [weakSelf _setImage:(image.renderingMode == renderingMode ? image : [image imageWithRenderingMode:renderingMode]) gifData:nil type:type isSelected:isSelected scale:scale ? scale.floatValue : image.scale fixedWidth:fixedWidth.floatValue];
                                                       }];
        }else{
            UIImage *image = [UIImage imageNamed:anyResource];
            [self _setImage:(image.renderingMode == renderingMode ? image : [image imageWithRenderingMode:renderingMode]) gifData:nil type:type isSelected:isSelected scale:scale ? scale.floatValue : image.scale fixedWidth:fixedWidth.floatValue];
        }
        
    }else if ([anyResource isKindOfClass:[UIImage class]]) {
        
        UIImage *image = anyResource;
        [self _setImage:(image.renderingMode == renderingMode ? image : [image imageWithRenderingMode:renderingMode]) gifData:nil type:type isSelected:isSelected scale:scale ? scale.floatValue : image.scale fixedWidth:fixedWidth.floatValue];
    }else if ([anyResource isKindOfClass:[NSData class]]) {
        
        [self _setImage:nil gifData:anyResource type:type isSelected:isSelected scale:scale ? scale.floatValue : ((NSData *)anyResource).zz_image.scale fixedWidth:fixedWidth.floatValue];
    }
}

#pragma mark - Private

- (void)_setImage:(UIImage *)image gifData:(NSData *)gifData type:(SelfType)type isSelected:(BOOL)isSelected scale:(CGFloat)scale fixedWidth:(CGFloat)fixedWidth {
    
    if (gifData != nil && [UIImage zz_imageType:gifData] == ZZImageTypeGIF) {
        switch (type) {
            case SelfTypeUIImageView:
            {
                ((UIImageView *)self).image = [UIImage sd_animatedGIFWithData:gifData];
            }
                break;
            case SelfTypeUIButton:
            {
                [((UIButton *)self) setImage:[UIImage sd_animatedGIFWithData:gifData] forState:UIControlStateNormal | UIControlStateHighlighted];
            }
                break;
            case SelfTypeBarButtonItem:
            {
                ((UIBarButtonItem *)self).image = [UIImage sd_animatedGIFWithData:gifData];
            }
                break;
            case SelfTypeTabBarItem:
            {
                if (isSelected) {
                    ((UITabBarItem *)self).selectedImage = [UIImage sd_animatedGIFWithData:gifData];
                }else {
                    ((UITabBarItem *)self).image = [UIImage sd_animatedGIFWithData:gifData];
                }
            }
                break;
            case SelfTypeUnknown:
            default:
                break;
        }
    }else{
        switch (type) {
            case SelfTypeUIImageView:
            {
                if (fixedWidth > 0) {
                    
                    CGFloat _scale = scale;
                    if (_scale != 1.0 && _scale != 2.0 && _scale != 3.0) {
                        _scale = 2.0;
                    }
                    ((UIImageView *)self).image = [image zz_imageAdjustSize:CGSizeMake(fixedWidth, fixedWidth * (image.size.height / image.size.width)) scale:_scale cropped:NO];
                }else {
                    ((UIImageView *)self).image = [image zz_imageTuningScale:scale orientation:image.imageOrientation];
                }
            }
                break;
            case SelfTypeUIButton:
            {
                if (fixedWidth > 0) {
                    
                    CGFloat _scale = scale;
                    if (_scale != 1.0 && _scale != 2.0 && _scale != 3.0) {
                        _scale = 2.0;
                    }
                    [((UIButton *)self) setImage:[image zz_imageAdjustSize:CGSizeMake(fixedWidth, fixedWidth * (image.size.height / image.size.width)) scale:_scale cropped:NO] forState:UIControlStateNormal | UIControlStateHighlighted];
                }else {
                    [((UIButton *)self) setImage:[image zz_imageTuningScale:scale orientation:image.imageOrientation] forState:UIControlStateNormal | UIControlStateHighlighted];
                }
            }
                break;
            case SelfTypeBarButtonItem:
            {
                if (fixedWidth > 0) {
                    
                    CGFloat _scale = scale;
                    if (_scale != 1.0 && _scale != 2.0 && _scale != 3.0) {
                        _scale = 2.0;
                    }
                    ((UIBarButtonItem *)self).image = [image zz_imageAdjustSize:CGSizeMake(fixedWidth, fixedWidth * (image.size.height / image.size.width)) scale:_scale cropped:NO];
                }else {
                    ((UIBarButtonItem *)self).image = [image zz_imageTuningScale:scale orientation:image.imageOrientation];
                }
            }
                break;
            case SelfTypeTabBarItem:
            {
                if (fixedWidth > 0) {
                    
                    CGFloat _scale = scale;
                    if (_scale != 1.0 && _scale != 2.0 && _scale != 3.0) {
                        _scale = 2.0;
                    }
                    if (isSelected) {
                        ((UITabBarItem *)self).selectedImage = [image zz_imageAdjustSize:CGSizeMake(fixedWidth, fixedWidth * (image.size.height / image.size.width)) scale:_scale cropped:NO];
                    }else {
                        ((UITabBarItem *)self).image = [image zz_imageAdjustSize:CGSizeMake(fixedWidth, fixedWidth * (image.size.height / image.size.width)) scale:_scale cropped:NO];
                    }
                }else {
                    if (isSelected) {
                        ((UITabBarItem *)self).selectedImage = [image zz_imageTuningScale:scale orientation:image.imageOrientation];
                    }else {
                        ((UITabBarItem *)self).image = [image zz_imageTuningScale:scale orientation:image.imageOrientation];
                    }
                }
            }
                break;
            case SelfTypeUnknown:
            default:
                break;
        }
    }
}

@end
