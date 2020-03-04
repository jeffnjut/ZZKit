//
//  UIButton+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIButton+ZZKit.h"

@implementation UIButton (ZZKit)

/**
 *  设置Title名称
 */
- (void)zz_setTitle:(nullable NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

/**
 *  设置Highlighted Title名称
 */
- (void)zz_setHighlightedTitle:(nullable NSString *)title {
    [self setTitle:title forState:UIControlStateHighlighted];
}

/**
 *  设置Title颜色
 */
- (void)zz_setTitleColor:(UIColor*)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

/**
 *  设置Highlighted Title颜色
 */
- (void)zz_setHighlightedTitleColor:(UIColor*)color {
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

/**
 *  设置Title字体
 */
- (void)zz_setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}

/**
 *  设置UIControlContentHorizontalAlignment
 */
- (void)zz_setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment {
    self.contentHorizontalAlignment = contentHorizontalAlignment;
}

/**
 *  设置NSTextAlignment
 */
- (void)zz_setTextAlignment:(NSTextAlignment)textAlignment {
    self.titleLabel.textAlignment = textAlignment;
}

/**
 *  防止重复点击
 */
- (void)zz_preventFromDoubleClick {
    
    [self setUserInteractionEnabled:NO];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setUserInteractionEnabled:YES];
    });
}

@end
