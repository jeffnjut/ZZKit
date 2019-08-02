//
//  ZZWidgetSpinnerView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetSpinnerView.h"

#pragma mark - ZZWidgetSpinnerView

#define kInvalidatedTimestamp -1

@interface ZZWidgetSpinnerView () <CAAnimationDelegate>

@property BOOL isAnimating;
@property NSUInteger colorIndex;
@property CAShapeLayer *foregroundRailLayer;
@property CAShapeLayer *backgroundRailLayer;
@property BOOL isFirstCycle;

@end

@implementation ZZWidgetSpinnerView

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 25, 25)]) {
        [self setup];
    }
    
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window && self.isAnimating) {
        [self startAnimating];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.foregroundRailLayer = [[CAShapeLayer alloc] init];
    self.backgroundRailLayer = [[CAShapeLayer alloc] init];

    self.rotationDirection = ZZWidgetSpinnerRotationDirectionClockwise;
    self.drawCycleDuration = 0.75;
    self.rotationCycleDuration = 1.5;
    self.staticArcLength = 0;
    self.maximumArcLength = (2 * M_PI) - M_PI_4;
    self.minimumArcLength = 0.1;
    self.lineWidth = 2.;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.drawTimingFunction = [ZZWidgetSpinnerLoadingTimingFunction easeInOut];
    
    self.colorSequence = @[
                           [UIColor redColor],
                           [UIColor orangeColor],
                           [UIColor purpleColor],
                           [UIColor blueColor]
                           ];
    
    self.backgroundRailLayer.fillColor = [UIColor clearColor].CGColor;
    self.backgroundRailLayer.strokeColor = [UIColor clearColor].CGColor;
    self.backgroundRailLayer.hidden = YES;
    
    self.foregroundRailLayer.fillColor = [UIColor clearColor].CGColor;
    self.foregroundRailLayer.anchorPoint = CGPointMake(.5, .5);
    self.foregroundRailLayer.strokeColor = self.colorSequence.firstObject.CGColor;
    self.foregroundRailLayer.hidden = YES;
    
    self.backgroundRailLayer.actions = @{
                                         @"lineWidth": [NSNull null],
                                         @"strokeEnd": [NSNull null],
                                         @"strokeStart": [NSNull null],
                                         @"transform": [NSNull null],
                                         @"hidden": [NSNull null]
                                         };
    
    self.foregroundRailLayer.actions = @{
                                         @"lineWidth": [NSNull null],
                                         @"strokeEnd": [NSNull null],
                                         @"strokeStart": [NSNull null],
                                         @"transform": [NSNull null],
                                         @"hidden": [NSNull null]
                                         };
    
    // If we have an apperance specified, then use it to override the defaults.
    if(nil != [ZZWidgetSpinnerView appearance].colorSequence)
    {
        self.colorSequence = [ZZWidgetSpinnerView appearance].colorSequence;
    }
    
    [self refreshCircleFrame];
}

#pragma mark - Accessors

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self refreshCircleFrame];
    //    [self insertPlane:self.foregroundRailLayer];
}

- (void)setRotationDirection:(ZZWidgetSpinnerRotationDirection)rotationDirection {
    
    _rotationDirection = rotationDirection;
    switch (rotationDirection) {
        case ZZWidgetSpinnerRotationDirectionCounterClockwise:
            self.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
            break;
        case ZZWidgetSpinnerRotationDirectionClockwise:
        default:
            self.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            break;
    }
}

- (void)setStaticArcLength:(CGFloat)staticArcLength {
    
    _staticArcLength = staticArcLength;
    if (!self.isAnimating) {
        self.foregroundRailLayer.hidden = NO;
        self.backgroundRailLayer.hidden = NO;
        self.foregroundRailLayer.strokeColor = self.colorSequence.firstObject.CGColor;
        self.foregroundRailLayer.strokeStart = 0;
        self.foregroundRailLayer.strokeEnd = [self proportionFromArcLengthRadians:staticArcLength];
        self.foregroundRailLayer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 0, 1);
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    
    self.foregroundRailLayer.lineWidth = lineWidth;
    self.backgroundRailLayer.lineWidth = lineWidth;
}

- (CGFloat)lineWidth {
    
    return self.foregroundRailLayer.lineWidth;
}

- (void)setBackgroundRailColor:(UIColor *)backgroundRailColor {
    
    self.backgroundRailLayer.strokeColor = backgroundRailColor.CGColor;
}

- (UIColor *)backgroundRailColor {
    
    return [UIColor colorWithCGColor:self.backgroundRailLayer.strokeColor];
}

#pragma mark - Layout

- (void)refreshCircleFrame {
    
    CGFloat sideLen = MIN(self.layer.frame.size.width, self.layer.frame.size.height) - (2 * self.lineWidth);
    CGFloat xOffset = ceilf((self.frame.size.width - sideLen) / 2.0);
    CGFloat yOffset = ceilf((self.frame.size.height - sideLen) / 2.0);
    
    self.foregroundRailLayer.frame = CGRectMake(xOffset, yOffset, sideLen, sideLen);
    self.foregroundRailLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, sideLen, sideLen)].CGPath;
    
    self.backgroundRailLayer.frame = CGRectMake(xOffset, yOffset, sideLen, sideLen);
    self.backgroundRailLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, sideLen, sideLen)].CGPath;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    
    if (!self.backgroundRailLayer.superlayer) {
        [self.layer addSublayer:self.backgroundRailLayer];
    }
    
    if (!self.foregroundRailLayer.superlayer) {
        [self.layer addSublayer:self.foregroundRailLayer];
    }
}

#pragma mark - Animation control

- (void)startAnimating {
    
    [self stopAnimating];
    self.foregroundRailLayer.hidden = NO;
    self.backgroundRailLayer.hidden = NO;
    
    self.isAnimating = YES;
    self.isFirstCycle = YES;
    self.foregroundRailLayer.strokeEnd = [self proportionFromArcLengthRadians:self.minimumArcLength];
    
    self.colorIndex = 0;
    self.foregroundRailLayer.strokeColor = [self.colorSequence[self.colorIndex] CGColor];
    
    [self addAnimationsToLayer:self.foregroundRailLayer reverse:NO rotationOffset:-M_PI_2];
}

- (void)stopAnimating {
    
    self.isAnimating = NO;
    self.foregroundRailLayer.hidden = YES;
    self.backgroundRailLayer.hidden = YES;
    [self.foregroundRailLayer removeAllAnimations];
}

#pragma mark - Auto Layout

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(40, 40);
}

- (void)addAnimationsToLayer:(CAShapeLayer *)layer reverse:(BOOL)reverse rotationOffset:(CGFloat)rotationOffset {
    
    CABasicAnimation *strokeAnimation;
    CGFloat strokeDuration = self.drawCycleDuration;
    CGFloat currentDistanceToStrokeStart = 2 * M_PI * layer.strokeStart;
    
    if (reverse) {
        [CATransaction begin];
        
        strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        CGFloat newStrokeStart = self.maximumArcLength - self.minimumArcLength;
        
        layer.strokeEnd = [self proportionFromArcLengthRadians:self.maximumArcLength];
        layer.strokeStart = [self proportionFromArcLengthRadians:newStrokeStart];
        
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @([self proportionFromArcLengthRadians:newStrokeStart]);
        
    } else {
        CGFloat strokeFromValue = self.minimumArcLength;
        CGFloat rotationStartRadians = rotationOffset;
        
        if (self.isFirstCycle) {
            if (self.staticArcLength > 0) {
                if (self.staticArcLength > self.maximumArcLength) {
                    NSLog(@"ZZWidgetSpinnerLoadingSpinner: staticArcLength is set to a value greater than maximumArcLength. You probably didn't mean to do this.");
                }
                
                strokeFromValue = self.staticArcLength;
                strokeDuration *= (self.staticArcLength / self.maximumArcLength);
            }
            
            self.isFirstCycle = NO;
        } else {
            rotationStartRadians += currentDistanceToStrokeStart;
        }
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(rotationStartRadians);
        rotationAnimation.toValue = @(rotationStartRadians + (2 * M_PI));
        rotationAnimation.timingFunction = [ZZWidgetSpinnerLoadingTimingFunction linear];
        rotationAnimation.duration = self.rotationCycleDuration;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.fillMode = kCAFillModeForwards;
        
        [layer removeAnimationForKey:@"rotation"];
        [layer addAnimation:rotationAnimation forKey:@"rotation"];
        
        
        [CATransaction begin];
        
        strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @([self proportionFromArcLengthRadians:strokeFromValue]);
        strokeAnimation.toValue = @([self proportionFromArcLengthRadians:self.maximumArcLength]);
        
        layer.strokeStart = 0;
        layer.strokeEnd = [strokeAnimation.toValue doubleValue];
    }
    
    strokeAnimation.delegate = self;
    strokeAnimation.fillMode = kCAFillModeForwards;
    strokeAnimation.timingFunction = self.drawTimingFunction;
    [CATransaction setAnimationDuration:strokeDuration];
    
    [layer removeAnimationForKey:@"stroke"];
    [layer addAnimation:strokeAnimation forKey:@"stroke"];
    
    [CATransaction commit];
}

- (void)advanceColorSequence {
    
    self.colorIndex = (self.colorIndex + 1) % self.colorSequence.count;
    self.foregroundRailLayer.strokeColor = [self.colorSequence[self.colorIndex] CGColor];
}

- (CGFloat)proportionFromArcLengthRadians:(CGFloat)radians {
    
    return ((fmodf(radians, 2 * M_PI)) / (2 * M_PI));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    
    if (finished && [anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        BOOL isStrokeStart = [basicAnim.keyPath isEqualToString:@"strokeStart"];
        BOOL isStrokeEnd = [basicAnim.keyPath isEqualToString:@"strokeEnd"];
        
        CGFloat rotationOffset = fmodf([[self.foregroundRailLayer.presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue], 2 * M_PI);
        [self addAnimationsToLayer:self.foregroundRailLayer reverse:isStrokeEnd rotationOffset:rotationOffset];
        
        if (isStrokeStart) {
            [self advanceColorSequence];
        }
    }
}

@end

#pragma mark - ZZWidgetSpinnerLoadingTimingFunction

@implementation ZZWidgetSpinnerLoadingTimingFunction

+ (CAMediaTimingFunction *)linear {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

+ (CAMediaTimingFunction *)easeIn {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
}

+ (CAMediaTimingFunction *)easeOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
}

+ (CAMediaTimingFunction *)easeInOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
}

+ (CAMediaTimingFunction *)sharpEaseInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
}

@end

#pragma mark - ZZWidgetSpinnerRefreshControl

@interface ZZWidgetSpinnerRefreshControl () <UIScrollViewDelegate>

@property (strong) ZZWidgetSpinnerView *loadingSpinner;
@property (weak) UITableViewController *tableViewController;
@property BOOL awaitingRefreshEnd;

@property (strong) UIRefreshControl *refreshControl;
@property (weak) UIScrollView *scrollView;
@property (weak) id originalDelegate;
@property (strong) void (^refreshBlock)(void);
@property (weak) id refreshTarget;
@property (assign) SEL refreshSelector;

@end

@implementation ZZWidgetSpinnerRefreshControl

- (instancetype)init {
    
    if (self = [super init]) {
        self.loadingSpinner = [[ZZWidgetSpinnerView alloc] init];
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshControlTriggered:) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl addSubview:self.loadingSpinner];
    }
    
    return self;
}

- (void)addToTableViewController:(UITableViewController *)tableViewController refreshBlock:(void (^)(void))refreshBlock {
    
    [self addToTableViewController:tableViewController];
    self.refreshBlock = refreshBlock;
}

- (void)addToTableViewController:(UITableViewController *)tableViewController target:(id)target selector:(SEL)selector {
    
    [self addToTableViewController:tableViewController];
    self.refreshTarget = target;
    self.refreshSelector = selector;
}

- (void)addToTableViewController:(UITableViewController *)tableViewController {
    
    [self removeFromPartnerObject];
    
    self.tableViewController = tableViewController;
    self.scrollView = self.tableViewController.tableView;
    
    self.tableViewController.refreshControl = self.refreshControl;
    [self.refreshControl.subviews.firstObject removeFromSuperview];
    
    self.originalDelegate = self.scrollView.delegate;
    self.scrollView.delegate = self;
}

- (void)addToScrollView:(UIScrollView *)scrollView refreshBlock:(void (^)(void))refreshBlock {
    
    [self addToScrollView:scrollView];
    self.refreshBlock = refreshBlock;
}

- (void)addToScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector {
    
    [self addToScrollView:scrollView];
    self.refreshTarget = target;
    self.refreshSelector = selector;
}

- (void)addToScrollView:(UIScrollView *)scrollView {
    
    [self removeFromPartnerObject];
    self.scrollView = scrollView;
    if (@available(iOS 10.0, *)) {
        self.scrollView.refreshControl = self.refreshControl;
    }
    [self.refreshControl.subviews.firstObject removeFromSuperview];
    
    self.originalDelegate = self.scrollView.delegate;
    self.scrollView.delegate = self;
}

- (void)removeFromPartnerObject {
    
    if (self.tableViewController) {
        self.tableViewController.refreshControl = nil;
        self.tableViewController = nil;
    }
    
    self.refreshTarget = nil;
    self.refreshSelector = NULL;
    
    self.scrollView.delegate = self.originalDelegate;
    self.scrollView = nil;
}

- (void)beginRefreshing {
    
    BOOL adjustScrollOffset = (self.scrollView.contentInset.top == -self.scrollView.contentOffset.y);
    
    self.loadingSpinner.hidden = NO;
    [self.refreshControl beginRefreshing];
    [self refreshControlTriggered:self.refreshControl];
    
    if (adjustScrollOffset) {
        [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    }
}

- (void)endRefreshing {
    
    __weak ZZWidgetSpinnerRefreshControl *weakSelf = self;
    
    if (self.scrollView.isDragging) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    self.awaitingRefreshEnd = YES;
    NSString * const animationGroupKey = @"animationGroupKey";
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [weakSelf.loadingSpinner stopAnimating];
        [weakSelf.loadingSpinner.layer removeAnimationForKey:animationGroupKey];
        if (!weakSelf.scrollView.isDecelerating) {
            weakSelf.awaitingRefreshEnd = NO;
        }
    }];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D scaleTransform = CATransform3DScale(CATransform3DIdentity, 0.25, 0.25, 1);
    scale.toValue = [NSValue valueWithCATransform3D:scaleTransform];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.toValue = @(0);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[ scale, opacity ];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self.loadingSpinner.layer addAnimation:group forKey:animationGroupKey];
    [CATransaction commit];
    
    [self.refreshControl endRefreshing];
}

- (void)refreshControlTriggered:(UIRefreshControl *)refreshControl {
    
    [self.loadingSpinner startAnimating];
    
    if (self.refreshBlock) {
        self.refreshBlock();
    } else if (self.refreshTarget && self.refreshSelector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.refreshTarget performSelector:self.refreshSelector withObject:self];
#pragma clang diagnostic pop
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.originalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if (self.loadingSpinner.isAnimating && !self.refreshControl.isRefreshing) {
        [self endRefreshing];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.originalDelegate scrollViewDidEndDecelerating:scrollView];
    }
    
    if (!self.refreshControl.isRefreshing) {
        
        self.awaitingRefreshEnd = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.originalDelegate scrollViewDidScroll:scrollView];
    }
    
    if (!self.refreshControl.hidden) {
        self.loadingSpinner.frame = CGRectMake(
                                               (self.refreshControl.frame.size.width - self.loadingSpinner.frame.size.width) / 2,
                                               (self.refreshControl.frame.size.height - self.loadingSpinner.frame.size.height) / 2,
                                               self.loadingSpinner.frame.size.width,
                                               self.loadingSpinner.frame.size.height
                                               );
    }
    
    if (!self.awaitingRefreshEnd) {
        self.loadingSpinner.hidden = NO;
        
        const CGFloat stretchLength = M_PI_2 + M_PI_4;
        CGFloat draggedOffset = scrollView.contentInset.top + scrollView.contentOffset.y;
        CGFloat percentToThreshold = draggedOffset / [self appleMagicOffset];
        
        self.loadingSpinner.staticArcLength = MIN(percentToThreshold * stretchLength, stretchLength);
    }
}

- (CGFloat)appleMagicOffset {
    
    __block NSInteger majorOSVersion;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        majorOSVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] firstObject] integerValue];
    });
    
    if (majorOSVersion <= 9) {
        return -109.0;
    } else {
        return -129.0;
    }
}

#pragma mark - UIScrollViewDelegate method forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return [super respondsToSelector:aSelector] || [self.originalDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    return self.originalDelegate;
}

@end
