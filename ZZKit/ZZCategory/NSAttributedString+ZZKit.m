//
//  NSAttributedString+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSAttributedString+ZZKit.h"

@implementation NSAttributedString (ZZKit)

#pragma mark - 字符串size、height、width

/**
 *  获得字符串高度
 */
- (CGFloat)zz_height:(CGFloat)renderWidth {
    
    return [self zz_size:CGSizeMake(renderWidth, MAXFLOAT) enableCeil:YES].height;
}

/**
 *  获得字符串宽度
 */
- (CGFloat)zz_width:(CGFloat)renderHeight {
    
    return [self zz_size:CGSizeMake(MAXFLOAT, renderHeight) enableCeil:YES].width;
}

/**
 *  获得字符串尺寸
 */
- (CGSize)zz_size:(CGSize)renderSize enableCeil:(BOOL)enableCeil {
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;
    CGSize size = [self boundingRectWithSize:renderSize options:options context:nil].size;
    if (enableCeil) {
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    return size;
}

@end
