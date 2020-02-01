//
//  ZZPhotoImageTagPointView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/12/11.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoImageTagPointView.h"
#import "UIView+ZZKit.h"

@interface ZZPhotoImageTagPointView ()

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) FJPulseLayer *pulseLayer;

@end

@implementation ZZPhotoImageTagPointView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _setup];
    }
    return self;
}

- (void)_setup {
    
    _centerView = [[UIView alloc] initWithFrame:self.bounds];
    _centerView.backgroundColor = [UIColor whiteColor];
    [_centerView zz_round];
    [self addSubview:_centerView];
    _pulseLayer = [[FJPulseLayer alloc] init];
    _pulseLayer.fromValueForRadius = 0.35;
    _pulseLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.layer addSublayer:_pulseLayer];
}

- (void)startAnimation {
    
    [self.pulseLayer startAnimation];
}

- (void)stopAnimation {
    
    [self.pulseLayer stopAnimation];
}

@end

@interface FJPulseLayer ()

@property (nonatomic, strong) CALayer *targetLayer;
@property (nonatomic, strong) CAAnimationGroup *animationGroup;

@end

@implementation FJPulseLayer

@dynamic repeatCount;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLayer];
        
        [self _setup];
    }
    return self;
}

- (void)_setup {
    
    _fromValueForRadius = 0.0;
    _fromValueForAlpha = 0.45;
    _keyTimeForHalfOpacity = 0.2;
    _animationDuration = 1.0;
    self.repeatCount = INFINITY;
    self.radius = 15;
    self.focusLayerNumber = 1;
    self.instanceDelay = 1;
    self.backgroundColor = [[UIColor whiteColor] CGColor];
    [self stopAnimation];
}

- (void)setupLayer {
    
    self.targetLayer = [CALayer new];
    self.targetLayer.contentsScale = [UIScreen mainScreen].scale;
    self.targetLayer.opacity = 0;
    [self addSublayer:self.targetLayer];
}

- (void)startAnimation {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if (!weakSelf.animationGroup) {
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.duration = weakSelf.animationDuration;
            animationGroup.repeatCount = weakSelf.repeatCount;
            animationGroup.removedOnCompletion = NO;
            
            CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            animationGroup.timingFunction = defaultCurve;
            
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
            scaleAnimation.fromValue = @(weakSelf.fromValueForRadius);
            scaleAnimation.toValue = @1.0;
            scaleAnimation.duration = weakSelf.animationDuration;
            
            CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.duration = weakSelf.animationDuration;
            opacityAnimation.values = @[@(weakSelf.fromValueForAlpha), @0.45, @0];
            opacityAnimation.keyTimes = @[@0, @(weakSelf.keyTimeForHalfOpacity), @1];
            opacityAnimation.removedOnCompletion = NO;
            
            NSArray *animations = @[scaleAnimation, opacityAnimation];
            animationGroup.animations = animations;
            weakSelf.animationGroup = animationGroup;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            weakSelf.opacity = 1.0;
            [weakSelf.targetLayer addAnimation:weakSelf.animationGroup forKey:@"focus"];
        });
    });
}

- (void)stopAnimation {
    
    self.opacity = 0.0;
    [self.targetLayer removeAllAnimations];
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    self.targetLayer.backgroundColor = backgroundColor;
}

- (void)setRadius:(CGFloat)radius {
    
    _radius = radius;
    CGFloat diameter = self.radius * 2;
    self.targetLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    self.targetLayer.cornerRadius = self.radius;
}

- (void)setFocusLayerNumber:(NSInteger)focusLayerNumber {
    
    _focusLayerNumber = focusLayerNumber;
    self.instanceCount = focusLayerNumber;
    self.instanceDelay = (self.animationDuration) / focusLayerNumber;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {

    _animationDuration = animationDuration;
    self.animationGroup.duration = animationDuration;
    for (CAAnimation *anAnimation in self.animationGroup.animations) {
        anAnimation.duration = animationDuration;
    }
    [self stopAnimation];
    [self.targetLayer addAnimation:self.animationGroup forKey:@"focus"];
    self.instanceDelay = (self.animationDuration) / self.focusLayerNumber;
}

@end
