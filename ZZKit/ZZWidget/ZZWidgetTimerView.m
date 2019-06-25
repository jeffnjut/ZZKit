//
//  ZZWidgetTimerView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetTimerView.h"
#import "UIView+ZZKit.h"
#import "UIView+ZZKit_Blocks.h"

@interface ZZWidgetTimerView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UILabel *labelSkip;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, assign) CGFloat kPace;
@property (nonatomic, assign) BOOL reverse;
@property (nonatomic, copy) void(^completionBlock)(ZZWidgetTimerView *zzWidgetTimerView);
@property (nonatomic, copy) void(^tapBlock)(ZZWidgetTimerView *zzWidgetTimerView);

@end

@implementation ZZWidgetTimerView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.zzFormattedTimeText = @"%ds";
    }
    return self;
}

#pragma mark - 属性

- (void)setZzSkipText:(NSAttributedString *)zzSkipText {
    
    self.labelSkip.attributedText = zzSkipText;
}

- (void)setZzSkipTextOffset:(UIOffset)zzSkipTextOffset {
    
    self.labelSkip.center = CGPointMake(self.labelSkip.center.x + zzSkipTextOffset.horizontal, self.labelSkip.center.y + zzSkipTextOffset.vertical);
}

- (void)setZzTimeTextOffset:(UIOffset)zzTimeTextOffset {
    
    self.labelTime.center = CGPointMake(self.labelTime.center.x + zzTimeTextOffset.horizontal, self.labelTime.center.y + zzTimeTextOffset.vertical);
}

#pragma mark - Public

/**
 *  创建倒计时View
 */
+ (ZZWidgetTimerView *)zz_quickAdd:(BOOL)reverse time:(CGFloat)time onView:(nullable UIView *)onView backgroundColor:(nullable UIColor *)backgroundColor borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor circleLineWidth:(CGFloat)circleLineWidth circleLineColor:(nullable UIColor *)circleLineColor circleLineFillColor:(nullable UIColor *)circleLineFillColor circleLineMargin:(CGFloat)circleLineMargin frame:(CGRect)frame tapBlock:(nullable void(^)(ZZWidgetTimerView *zzWidgetTimerView))tapBlock completionBlock:(nullable void(^)(ZZWidgetTimerView *zzWidgetTimerView))completionBlock {
    
    ZZWidgetTimerView *widgetTimerView = [[ZZWidgetTimerView alloc] initWithFrame:frame];
    widgetTimerView.time = time;
    if (time > 1000) {
        widgetTimerView.kPace = 1.0 / time;
    }else if (time > 100) {
        widgetTimerView.kPace = 0.001;
    }else {
        widgetTimerView.kPace = 0.01;
    }
    widgetTimerView.interval = time / (1.0 / widgetTimerView.kPace);
    widgetTimerView.completionBlock = completionBlock;
    widgetTimerView.reverse = reverse;
    [widgetTimerView _buildUI:backgroundColor frame:frame borderWidth:borderWidth borderColor:borderColor circleLineWidth:circleLineWidth circleLineColor:circleLineColor circleLineFillColor:circleLineFillColor circleLineMargin:circleLineMargin time:time];
    if (onView) {
        [onView addSubview:widgetTimerView];
    }
    if (tapBlock) {
        widgetTimerView.tapBlock = tapBlock;
        __weak ZZWidgetTimerView *weakSelf = widgetTimerView;
        [widgetTimerView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
            __strong ZZWidgetTimerView *strongSelf = weakSelf;
            strongSelf.tapBlock == nil ? : strongSelf.tapBlock(strongSelf);
        }];
    }
    return widgetTimerView;
}

/**
 *  开始计时
 */
- (void)zz_start {
    
    [self _start];
}

/**
 *  开始计时
 */
- (void)zz_start:(void(^)(ZZWidgetTimerView *zzWidgetTimerView))completionBlock {
    
    self.completionBlock = completionBlock;
    [self _start];
}

#pragma mark - Private

- (void)_buildUI:(nullable UIColor *)backgroundColor frame:(CGRect)frame borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor circleLineWidth:(CGFloat)circleLineWidth circleLineColor:(nullable UIColor *)circleLineColor circleLineFillColor:(nullable UIColor *)circleLineFillColor circleLineMargin:(CGFloat)circleLineMargin time:(CGFloat)time {
    
    self.backgroundColor = backgroundColor;
    if (borderWidth > 0 && borderColor != nil) {
        [self zz_roundWithBorderWidth:borderWidth borderColor:borderColor];
    }else {
        [self zz_round];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(circleLineMargin, circleLineMargin, frame.size.width - circleLineMargin * 2.0, frame.size.height - circleLineMargin * 2.0)];
    [self addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.shapeLayer = shapeLayer;
    [view.layer addSublayer:shapeLayer];
    shapeLayer.frame = CGRectMake(0 + circleLineWidth / 2.0, 0 + circleLineWidth / 2.0, view.bounds.size.width - circleLineWidth, view.bounds.size.height - circleLineWidth);
    shapeLayer.fillColor = circleLineFillColor.CGColor;
    shapeLayer.lineWidth = circleLineWidth;
    shapeLayer.strokeColor = circleLineColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(shapeLayer.frame.size.width / 2.0, shapeLayer.frame.size.height / 2.0) radius:shapeLayer.frame.size.width / 2.0 startAngle: - M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];;
    shapeLayer.path = path.CGPath;
    if (self.reverse) {
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = 1.0;
    }else {
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = 0;
    }
    // 辅助文案
    UILabel *labelSkip = [[UILabel alloc] initWithFrame:CGRectMake(0, view.bounds.size.height / 2.0 - 14.0, view.bounds.size.width, 14.0)];
    [view addSubview:labelSkip];
    labelSkip.font = [UIFont systemFontOfSize:12.0];
    labelSkip.textColor = [UIColor whiteColor];
    labelSkip.textAlignment = NSTextAlignmentCenter;
    labelSkip.text = @"跳过";
    labelSkip.numberOfLines = 1;
    self.labelSkip = labelSkip;
    
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(0, view.bounds.size.height / 2.0, view.bounds.size.width, 14.0)];
    [view addSubview:labelTime];
    if (self.zzTimeTextAttibutes) {
        labelTime.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:self.zzFormattedTimeText,(int)time] attributes:self.zzTimeTextAttibutes];
    }else {
        labelTime.font = [UIFont systemFontOfSize:12.0];
        labelTime.textColor = [UIColor whiteColor];
        labelTime.textAlignment = NSTextAlignmentCenter;
        labelTime.text = [NSString stringWithFormat:self.zzFormattedTimeText,(int)time];
    }
    labelTime.numberOfLines = 1;
    self.labelTime = labelTime;
}

- (void)_start {
    
    __weak typeof(self) weakSelf = self;
    
    if (self.reverse) {
        CGFloat currentStart = self.shapeLayer.strokeStart;
        if (currentStart >= 1.0) {
            self.shapeLayer.strokeStart = 1.0;
            [self _updateTime:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.completionBlock == nil ? : weakSelf.completionBlock(weakSelf);
            });
            return;
        }else{
            self.shapeLayer.strokeStart += self.kPace;
            int t = (int)self.time - (int)floorf(self.shapeLayer.strokeStart / (1.0 / self.time));
            [self _updateTime:t];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.interval  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf _start];
        });
    }else {
        CGFloat currentEnd = self.shapeLayer.strokeEnd;
        if (currentEnd + self.kPace >= 1.0) {
            self.shapeLayer.strokeEnd = 1.0;
            [self _updateTime:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.completionBlock == nil ? : weakSelf.completionBlock(weakSelf);
            });
            return;
        }else{
            self.shapeLayer.strokeEnd += self.kPace;
            int t = (int)self.time - (int)floorf(self.shapeLayer.strokeEnd / (1.0 / self.time));
            [self _updateTime:t];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.interval  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf _start];
        });
    }
}

- (void)_updateTime:(int)remainingTime {
    
    if (self.zzTimeTextAttibutes) {
        self.labelTime.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:self.zzFormattedTimeText, remainingTime] attributes:self.zzTimeTextAttibutes];
    }else {
        self.labelTime.text = [NSString stringWithFormat:self.zzFormattedTimeText, remainingTime];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
