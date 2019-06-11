//
//  NSAttributedString+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZZKit)

#pragma mark - 字符串size、height、width

/**
 *  获得字符串高度
 */
- (CGFloat)zz_height:(CGFloat)renderWidth;

/**
 *  获得字符串宽度
 */
- (CGFloat)zz_width:(CGFloat)renderHeight;

/**
 *  获得字符串尺寸
 */
- (CGSize)zz_size:(CGSize)renderSize enableCeil:(BOOL)enableCeil;

@end

NS_ASSUME_NONNULL_END
