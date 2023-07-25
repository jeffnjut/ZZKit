//
//  ZZWidgetRippleView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZWidgetRippleView : UIView

#pragma mark - Public

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image rippleColor:(UIColor *)rippleColor cycleFillColor:(UIColor *)cycleFillColor scaledxy:(CGFloat)scaledxy animation:(NSTimeInterval)animation interval:(NSTimeInterval)interval;

/**
 *  停止Ripple动画（默认一次）
 */
- (void)zz_startRipple;

/**
 *  开始Ripple动画（自定义次数）
 */
- (void)zz_startRipple:(NSInteger)repeatTimes;

/**
 *  停止Ripple动画
 */
- (void)zz_stopRipple;

@end

NS_ASSUME_NONNULL_END
