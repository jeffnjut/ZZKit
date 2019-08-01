//
//  UIColor+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIColor+ZZKit.h"

@implementation UIColor (ZZKit)

#pragma mark - Public

/**
 * 十六进制颜色
 */
+ (UIColor *)zz_colorHexString:(nonnull NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/**
 * 十六进制颜色（alpha）
 */
+ (UIColor *)zz_colorHexString:(nonnull NSString *)hexString withAlpha:(CGFloat)alpha {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

/**
 * 渐变颜色
 */
+ (UIColor *)zz_colorGradient:(CGSize)size direction:(ZZColorGradientDirection)direction startColor:(nonnull UIColor *)startcolor endColor:(nonnull UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    CGPoint startPoint = CGPointZero;
    if (direction == ZZColorGradientDirectionDiagonalDownwards) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case ZZColorGradientDirectionHorizontal:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case ZZColorGradientDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case ZZColorGradientDirectionDiagonalUpwards:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case ZZColorGradientDirectionDiagonalDownwards:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

/**
 * 颜色是否相同
 */
- (BOOL)zz_colorIsEqual:(nonnull UIColor *)anotherColor {
    
    if (CGColorEqualToColor(self.CGColor, anotherColor.CGColor)) {
        return YES;
    }else {
        if (self.zz_red == anotherColor.zz_red &&
            self.zz_green == anotherColor.zz_green &&
            self.zz_blue == anotherColor.zz_blue &&
            self.zz_alpha == anotherColor.zz_alpha) {
            return YES;
        }
        return NO;
    }
}

/**
 * 求当前颜色相反的背景色，只支持黑白
 */
- (UIColor *)zz_colorInversion {
    
    CGFloat red = 0, green = 0, blue = 0;
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    if (count == 4) {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        // 获取RGB颜色
        red = components[0];
        green = components[1];
        blue = components[2];
    }
    if (red > 185/255.0 && green > 185/255.0 && blue > 185/255.0) {
        return [UIColor blackColor];
    }
    return [UIColor whiteColor];
}

/**
 *  获取颜色的Red值
 */
- (CGFloat)zz_red {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

/**
 *  获取颜色的Green值
 */
- (CGFloat)zz_green {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self _colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

/**
 *  获取颜色的Blue值
 */
- (CGFloat)zz_blue {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self _colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

/**
 *  获取颜色的Alpha值
 */
- (CGFloat)zz_alpha {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[CGColorGetNumberOfComponents(self.CGColor) - 1];
}

/**
 *  生成颜色的背景图片
 */
- (nonnull UIImage *)zz_image:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 设置背景颜色
    [self set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Private

/**
 * 获取ColorSpaceModel
 */
- (CGColorSpaceModel)_colorSpaceModel {
    
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

@end
