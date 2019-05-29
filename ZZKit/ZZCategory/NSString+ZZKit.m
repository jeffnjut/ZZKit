//
//  NSString+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSString+ZZKit.h"
#import "UIColor+ZZKit.h"

@implementation NSString (ZZKit)

#pragma mark - Color

/**
 *  获取颜色
 */
- (UIColor *)zz_color {
    
    if ([self characterAtIndex:0] == '#') {
        if ([self length] == 9) {
            NSString *colorHex = [self substringToIndex:7];
            NSString *alphaPercent = [self substringFromIndex:7];
            float alpha = [alphaPercent floatValue] / 100.0;
            return [UIColor zz_colorHexString:colorHex withAlpha:alpha];
        }else if ([self length] == 7) {
            return [UIColor zz_colorHexString:self];
        }
    }else{
        if ([self length] == 8) {
            NSString *colorHex = [NSString stringWithFormat:@"#%@",[self substringToIndex:6]];
            NSString *alphaPercent = [self substringFromIndex:6];
            float alpha = [alphaPercent floatValue] / 100.0;
            return [UIColor zz_colorHexString:colorHex withAlpha:alpha];
        }else if ([self length] == 6) {
            return [UIColor zz_colorHexString:[NSString stringWithFormat:@"#%@",self]];
        }
    }
    return nil;
}

/**
 *  获取颜色, alpha
 */
- (UIColor *)zz_color:(CGFloat)alpha {
    
    return [[self zz_color] colorWithAlphaComponent:alpha];
}

@end
