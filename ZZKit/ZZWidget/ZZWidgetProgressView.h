//
//  ZZWidgetProgressView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - FJProgressView

@interface ZZWidgetProgressView : UIView

/**
 *  快速创建ProgressView
 */
+ (nonnull ZZWidgetProgressView *)zz_quickAdd:(nullable UIView *)onView frame:(CGRect)frame progressTintColor:(nullable UIColor *)progressTintColor progressedTintColor:(nullable UIColor *)progressedTintColor progressBorderWidth:(CGFloat)progressBorderWidth progressBorderColor:(nullable UIColor *)progressBorderColor containerBorderWidth:(CGFloat)containerBorderWidth containerBorderColor:(nullable UIColor *)containerBorderColor round:(BOOL)round progress:(CGFloat)progress;

/**
 *  更新Progress进度
 *  progress范围[0,100]
 */
- (void)zz_updateProgress:(CGFloat)progress;

/**
 *  更新Progress进度
 *  progress范围[0,100]
 */
// - (void)zz_updateProgress:(NSUInteger)progress animated:(BOOL)animated;

/**
 *  Progress进度
 */
- (CGFloat)zz_progress;

@end
