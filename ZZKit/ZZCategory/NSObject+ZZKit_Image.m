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
                                                           [weakSelf _setImage:(image.renderingMode == renderingMode ? image : [image imageWithRenderingMode:renderingMode]) gifData:nil type:type isSelected:isSelected];
                                                       }];
        }else{
            UIImage *image = [UIImage imageNamed:anyResource];
            [self _setImage:(image.renderingMode == renderingMode ? image : [image imageWithRenderingMode:renderingMode]) gifData:nil type:type isSelected:isSelected];
        }
        
    }else if ([anyResource isKindOfClass:[UIImage class]]){
        UIImage *image = anyResource;
        [self _setImage:(image.renderingMode == renderingMode ? image : [image imageWithRenderingMode:renderingMode]) gifData:nil type:type isSelected:isSelected];
    }else if ([anyResource isKindOfClass:[NSData class]]) {
        [self _setImage:nil gifData:anyResource type:type isSelected:isSelected];
    }
}

#pragma mark - Private

- (void)_setImage:(UIImage *)image gifData:(NSData *)gifData type:(SelfType)type isSelected:(BOOL)isSelected {
    
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
                ((UIImageView *)self).image = image;
            }
                break;
            case SelfTypeUIButton:
            {
                [((UIButton *)self) setImage:image forState:UIControlStateNormal | UIControlStateHighlighted];
            }
                break;
            case SelfTypeBarButtonItem:
            {
                ((UIBarButtonItem *)self).image = image;
            }
                break;
            case SelfTypeTabBarItem:
            {
                if (isSelected) {
                    ((UITabBarItem *)self).selectedImage = image;
                }else {
                    ((UITabBarItem *)self).image = image;
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
