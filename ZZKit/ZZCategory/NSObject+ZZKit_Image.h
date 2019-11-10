//
//  NSObject+ZZKit_Image.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZZKit_Image)

/**
 *  设置任意图片源
 */
- (void)zz_setImage:(id)anyResource;

/**
 *  设置任意图片源(isSelected)
 */
- (void)zz_setImage:(id)anyResource isSelected:(BOOL)isSelected;

/**
 *  设置任意图片源(Base, isSelect, renderingMode)
 */
- (void)zz_setImage:(id)anyResource isSelected:(BOOL)isSelected renderingMode:(UIImageRenderingMode)renderingMode;

/**
 *  设置任意图片源(Base, isSelect, renderingMode, scale, fixedWidth[与scale、fixedWidth设置一个，fixedWidth和Height是等比缩放])
 */
- (void)zz_setImage:(id)anyResource isSelected:(BOOL)isSelected renderingMode:(UIImageRenderingMode)renderingMode scale:(nullable NSNumber *)scale fixedWidth:(nullable NSNumber *)fixedWidth;

@end

NS_ASSUME_NONNULL_END
