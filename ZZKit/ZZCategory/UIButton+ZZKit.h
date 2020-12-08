//
//  UIButton+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZZKit)

/**
 *  设置Title名称
 */
- (void)zz_setTitle:(nullable NSString *)title;

/**
 *  设置Highlighted Title名称
 */
- (void)zz_setHighlightedTitle:(nullable NSString *)title;

/**
 *  设置Title颜色
 */
- (void)zz_setTitleColor:(UIColor*)color;

/**
 *  设置Highlighted Title颜色
 */
- (void)zz_setHighlightedTitleColor:(UIColor*)color;

/**
 *  设置Title字体
 */
- (void)zz_setTitleFont:(UIFont *)font;

/**
 *  设置UIControlContentHorizontalAlignment
 */
- (void)zz_setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment;

/**
 *  设置NSTextAlignment
 */
- (void)zz_setTextAlignment:(NSTextAlignment)textAlignment;

/**
 *  防止重复点击
 */
- (void)zz_preventFromDoubleClick;

/**
 *  防止重复点击
 */
- (void)zz_preventFromDoubleClick:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
