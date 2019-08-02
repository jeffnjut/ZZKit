//
//  ZZWidgetRippleView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetRippleView.h"

@interface ZZWidgetRippleView ()

@property (nonatomic, strong) UIColor *rippleColor;
@property (nonatomic, strong) UIColor *cycleFillColor;
@property (nonatomic, assign) CGFloat scaledxy;
@property (nonatomic, assign) NSTimeInterval animation;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) BOOL inRippling;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZZWidgetRippleView

#pragma mark - Life Cycle

- (void)dealloc {
    
    [_timer invalidate];
    _timer = nil;
}

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image rippleColor:(UIColor *)rippleColor cycleFillColor:(UIColor *)cycleFillColor scaledxy:(CGFloat)scaledxy animation:(NSTimeInterval)animation interval:(NSTimeInterval)interval {
    
    self = [super initWithFrame:frame];
    if (self) {
        if (image) {
            // 添加ImageView
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.image = image;
            [self addSubview:imageView];
        }
        self.layer.cornerRadius = self.bounds.size.width / 2.0;
        self.rippleColor = rippleColor;
        self.cycleFillColor = cycleFillColor;
        self.scaledxy = scaledxy;
        self.animation = animation;
        self.interval = interval;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Public

/**
 *  停止Ripple动画（默认一次）
 */
- (void)zz_startRipple {
    
    if (self.inRippling) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [weakSelf _startRippleOnce];
    if (_timer == nil) {
        if (@available(iOS 10.0, *)) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.animation + self.interval repeats:YES block:^(NSTimer * _Nonnull timer) {
                [weakSelf _startRippleOnce];
            }];
        } else {
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.animation + self.interval target:self selector:@selector(_startRippleOnce) userInfo:nil repeats:YES];
        }
    }
}

/**
 *  开始Ripple动画（自定义次数）
 */
- (void)zz_startRipple:(NSInteger)repeatTimes {
    
    UIColor *stroke = self.rippleColor ? self.rippleColor : [UIColor whiteColor];
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition =  [self convertPoint:self.center fromView:self.superview];
    __block CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = self.cycleFillColor ? self.cycleFillColor.CGColor : [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 1;
    [self.layer insertSublayer:circleShape atIndex:0];
    [CATransaction begin];
    //remove layer after animation completed
    [CATransaction setCompletionBlock:^{
        [circleShape removeFromSuperlayer];
    }];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.scaledxy, self.scaledxy, 1)];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = self.animation;
    animation.repeatCount = repeatTimes;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
    [CATransaction commit];
}

/**
 *  停止Ripple动画
 */
- (void)zz_stopRipple {
    
    if (self.inRippling) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Private

- (void)_startRippleOnce {
    
    [self zz_startRipple:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
