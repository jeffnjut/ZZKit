//
//  UIColor+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZZColorGradientDirection) {
    ZZColorGradientDirectionHorizontal,           // 水平渐变
    ZZColorGradientDirectionVertical,             // 竖直渐变
    ZZColorGradientDirectionDiagonalUpwards,      // 向下对角线渐变
    ZZColorGradientDirectionDiagonalDownwards,    // 向上对角线渐变
};

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZZKit)

/**
 * 十六进制颜色
 */
+ (UIColor *)zz_colorHexString:(nonnull NSString *)hexString;

/**
 * 十六进制颜色（alpha）
 */
+ (UIColor *)zz_colorHexString:(nonnull NSString *)hexString withAlpha:(CGFloat)alpha;

/**
 * 渐变颜色
 */
+ (UIColor *)zz_colorGradient:(CGSize)size direction:(ZZColorGradientDirection)direction startColor:(nonnull UIColor *)startcolor endColor:(nonnull UIColor *)endColor;

/**
 * 渐变颜色
 */
+ (UIColor *)zz_colorGradient:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint startColor:(nonnull UIColor *)startcolor endColor:(nonnull UIColor *)endColor;

/**
 * 颜色是否相同
 */
- (BOOL)zz_colorIsEqual:(nonnull UIColor *)anotherColor;

/**
 * 求当前颜色相反的背景色，只支持黑白
 */
- (UIColor *)zz_colorInversion;

/**
 *  获取颜色的Red值
 */
- (CGFloat)zz_red;

/**
 *  获取颜色的Green值
 */
- (CGFloat)zz_green;

/**
 *  获取颜色的Blue值
 */
- (CGFloat)zz_blue;

/**
 *  获取颜色的Alpha值
 */
- (CGFloat)zz_alpha;

/**
 *  生成颜色的背景图片
 */
- (nonnull UIImage *)zz_image:(CGSize)size;

/**
 *  随机颜色
 */
+ (UIColor *)zz_randomColor;

@end

NS_ASSUME_NONNULL_END
