//
//  ZZWidgetProgressView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetProgressView.h"
#import "UIView+ZZKit.h"

#pragma mark - ZZWidgetProgressView

@interface ZZWidgetProgressView()
{
    @private
    CGFloat _progress;
    CAShapeLayer *_progressedLayer;
    CGFloat _containerBorderWidth;
    CGFloat _progressBorderWidth;
}

@end

@implementation ZZWidgetProgressView

/**
 *  快速创建ProgressView
 */
+ (nonnull ZZWidgetProgressView *)zz_quickAdd:(nullable UIView *)onView frame:(CGRect)frame progressTintColor:(nullable UIColor *)progressTintColor progressedTintColor:(nullable UIColor *)progressedTintColor progressBorderWidth:(CGFloat)progressBorderWidth progressBorderColor:(nullable UIColor *)progressBorderColor containerBorderWidth:(CGFloat)containerBorderWidth containerBorderColor:(nullable UIColor *)containerBorderColor round:(BOOL)round progress:(CGFloat)progress {
    
    ZZWidgetProgressView *progressView = [[ZZWidgetProgressView alloc] initWithFrame:frame];
    if (onView != nil) {
        [onView addSubview:progressView];
    }
    [progressView _build:progressTintColor progressedTintColor:progressedTintColor progressBorderWidth:progressBorderWidth progressBorderColor:progressBorderColor containerBorderWidth:containerBorderWidth containerBorderColor:containerBorderColor round:NO progress:progress];
    return progressView;
}

/**
 *  更新Progress进度
 *  progress范围[0,100]
 */
- (void)zz_updateProgress:(CGFloat)progress {
    
    [self zz_updateProgress:progress animated:NO];
}

/**
 *  更新Progress进度
 *  progress范围[0,100]
 */
- (void)zz_updateProgress:(CGFloat)progress animated:(BOOL)animated {
    
    _progress = progress;
    _progressedLayer.frame = CGRectMake(_containerBorderWidth + _progressBorderWidth,
                                        _containerBorderWidth + _progressBorderWidth,
                                        (self.frame.size.width - 2.0 * _containerBorderWidth - 2.0 * _progressBorderWidth) * _progress,
                                        self.frame.size.height - 2.0 * _containerBorderWidth - 2.0 * _progressBorderWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_progressedLayer.bounds];
    _progressedLayer.path = path.CGPath;
}

/**
 *  Progress进度
 */
- (CGFloat)zz_progress {
    
    return _progress;
}

- (void)_build:(nullable UIColor *)progressTintColor progressedTintColor:(nullable UIColor *)progressedTintColor progressBorderWidth:(CGFloat)progressBorderWidth progressBorderColor:(nullable UIColor *)progressBorderColor containerBorderWidth:(CGFloat)containerBorderWidth containerBorderColor:(nullable UIColor *)containerBorderColor round:(BOOL)round progress:(CGFloat)progress {
    
    _progress = progress;
    _containerBorderWidth = containerBorderWidth;
    _progressBorderWidth = progressBorderWidth;
    
    self.backgroundColor = progressTintColor;
    
    if (round) {
        [self zz_cornerRadius:self.bounds.size.height / 2.0 borderWidth:containerBorderWidth boderColor:containerBorderColor];
    }else {
        [self zz_cornerRadius:0 borderWidth:containerBorderWidth boderColor:containerBorderColor];
    }
    
    // Progress Layer
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    [self.layer addSublayer:progressLayer];
    progressLayer.frame = CGRectMake(containerBorderWidth + progressBorderWidth / 2.0 ,
                                     containerBorderWidth + progressBorderWidth / 2.0,
                                     self.frame.size.width - 2.0 * containerBorderWidth - progressBorderWidth,
                                     self.frame.size.height - 2.0 * containerBorderWidth - progressBorderWidth);
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = 5.0;
    progressLayer.strokeColor = progressBorderColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:progressLayer.bounds];
    progressLayer.path = path.CGPath;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 1.0;
    
    // Progressed Layer
    CAShapeLayer *progressedLayer = [CAShapeLayer layer];
    _progressedLayer = progressedLayer;
    [self.layer addSublayer:progressedLayer];
    progressedLayer.frame = CGRectMake(containerBorderWidth + progressBorderWidth,
                                       containerBorderWidth + progressBorderWidth,
                                       (self.frame.size.width - 2.0 * containerBorderWidth - 2.0 * progressBorderWidth) * _progress,
                                       self.frame.size.height - 2.0 * containerBorderWidth - 2.0 * progressBorderWidth);
    progressedLayer.fillColor = progressedTintColor.CGColor;
    progressedLayer.lineWidth = 0;
    progressedLayer.strokeColor = [UIColor clearColor].CGColor;
    path = [UIBezierPath bezierPathWithRect:progressedLayer.bounds];
    progressedLayer.path = path.CGPath;
    progressedLayer.strokeStart = 0;
    progressedLayer.strokeEnd = 1.0;
}

@end
