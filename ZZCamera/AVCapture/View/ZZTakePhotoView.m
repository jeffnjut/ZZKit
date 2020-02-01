//
//  ZZTakePhotoView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/21.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZTakePhotoView.h"
#import "ZZMacro.h"
#import "NSString+ZZKit.h"

@interface ZZTakePhotoView () <CAAnimationDelegate>
{
    BOOL _inTakingVideo;
}

@property (nonatomic, weak) IBOutlet UIView *takeView;

@property (nonatomic, assign) CGFloat longTapPressDuration;
@property (nonatomic, assign) CGFloat circleDuration;
@property (nonatomic, assign) CGSize takeButtonSize;
@property (nonatomic, copy) void(^tapBlock)(void);
@property (nonatomic, copy) void(^longPressBlock)(BOOL begin);
// 1: 拍照  2：摄像 3：兼容
@property (nonatomic, assign) int type;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) CAShapeLayer *buttonLayer;

@end

@implementation ZZTakePhotoView

+ (ZZTakePhotoView *)create:(CGRect)frame takeButtonSize:(CGSize)takeButtonSize strokeColor:(UIColor *)strokeColor strokeWidth:(CGFloat)strokeWidth longTapPressDuration:(CGFloat)longTapPressDuration circleDuration:(CGFloat)circleDuration type:(int)type tapBlock:(void(^)(void))tapBlock longPressBlock:(void(^)(BOOL begin))longPressBlock {
    
    NSAssert(frame.size.width == frame.size.height, @"ZZTakePhotoView Size != Height");
    NSAssert(takeButtonSize.width == takeButtonSize.height, @"TakeButton Size != Height");
    
    ZZTakePhotoView *view = ZZ_LOAD_NIB(@"ZZTakePhotoView");
    view.frame = frame;
    view.strokeColor = strokeColor;
    view.strokeWidth = strokeWidth;
    view.takeButtonSize = takeButtonSize;
    view.longTapPressDuration = longTapPressDuration;
    view.circleDuration = circleDuration;
    view.tapBlock = tapBlock;
    view.longPressBlock = longPressBlock;
    view.type = type;
    [view _buildUI];
    return view;
}

- (void)_buildUI {
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.masksToBounds = YES;
    self.takeView.frame = CGRectMake((self.bounds.size.width - self.takeButtonSize.width) / 2.0, (self.bounds.size.height - self.takeButtonSize.height) / 2.0, self.takeButtonSize.width, self.takeButtonSize.height);
    self.takeView.layer.cornerRadius = self.takeButtonSize.width / 2.0;
    self.takeView.layer.masksToBounds = YES;
    
    // 增加手势
    if (self.type == 1 || self.type == 3) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
        [self.takeView addGestureRecognizer:tapGesture];
    }
    if (self.type == 2 || self.type == 3) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPress:)];
        longPressGesture.minimumPressDuration = self.longTapPressDuration;
        [self.takeView addGestureRecognizer:longPressGesture];
    }
}

- (void)_tap:(UITapGestureRecognizer *)tapGesture {
    
    if (_inTakingVideo) {
        return;
    }
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        // 拍照动画
        [tapGesture.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            tapGesture.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                tapGesture.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                [tapGesture.view setUserInteractionEnabled:YES];
            }];
        }];
        self.tapBlock == nil ? : self.tapBlock();
    }
}

- (void)_longPress:(UILongPressGestureRecognizer *)longPressGesture {
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_inTakingVideo) {
                return;
            }
            [self _performEnlargerAnimation];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self _performRestoreAnimation:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            break;
        }
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

- (void)_performEnlargerAnimation {
    
    __weak typeof(self) weakSelf = self;
    __block CGRect frame = self.bounds;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.3, 1.3);
        weakSelf.takeView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    } completion:^(BOOL finished) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0) radius:frame.size.width / 2.0 startAngle:3 * M_PI / 2.0 endAngle: 3 * M_PI / 2.0 + 2 * M_PI clockwise:true];
        weakSelf.buttonLayer = [CAShapeLayer layer];
        weakSelf.buttonLayer.frame = frame;
        weakSelf.buttonLayer.strokeColor = self.strokeColor != nil ? self.strokeColor.CGColor : @"#00D76E".zz_color.CGColor;
        weakSelf.buttonLayer.lineWidth = self.strokeWidth > 0 ? self.strokeWidth  : frame.size.width / 10;
        weakSelf.buttonLayer.fillColor = [UIColor clearColor].CGColor;
        weakSelf.buttonLayer.path = path.CGPath;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        strokeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        strokeAnimation.duration = weakSelf.circleDuration;
        strokeAnimation.delegate = weakSelf;
        [weakSelf.buttonLayer addAnimation:strokeAnimation forKey:nil];
        [weakSelf.layer addSublayer:weakSelf.buttonLayer];
    }];
}

- (void)_performRestoreAnimation:(BOOL)animation {
    
    if (_inTakingVideo == NO) {
        return;
    }
    _inTakingVideo = NO;
    if (animation) {
        __weak typeof(self) weakSelf = self;
        [self.buttonLayer removeFromSuperlayer];
        self.buttonLayer = nil;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
            weakSelf.takeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [self.buttonLayer removeFromSuperlayer];
        self.buttonLayer = nil;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.takeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
    self.longPressBlock == nil ? : self.longPressBlock(NO);
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
    _inTakingVideo = YES;
    self.longPressBlock == nil ? : self.longPressBlock(YES);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self _performRestoreAnimation:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
