//
//  ZZPerformance.m
//  ZZKit
//
//  Created by Fu Jie on 2021/2/19.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ZZPerformance.h"

@interface ZZPerformance()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UILabel *displayFpsLb;
@property (nonatomic, weak) UIView *displayOnView;


@end

@implementation ZZPerformance

+ (ZZPerformance *)shared {
    
    static ZZPerformance *SINGLETON = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SINGLETON = [[super alloc] init];
    });
    return SINGLETON;
}

- (UILabel *)displayFpsLb {
    
    if (_displayFpsLb == nil) {
        _displayFpsLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
        _displayFpsLb.textColor = UIColor.whiteColor;
        _displayFpsLb.font = [UIFont systemFontOfSize:12.0];
        _displayFpsLb.textAlignment = NSTextAlignmentCenter;
        _displayFpsLb.layer.masksToBounds = YES;
        _displayFpsLb.layer.cornerRadius = 4.0;
        _displayFpsLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        _displayFpsLb.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
        pan.maximumNumberOfTouches = 1;
        [_displayFpsLb addGestureRecognizer:pan];
    }
    return _displayFpsLb;
}

- (void)_panAction:(UIPanGestureRecognizer *)panGesture {
    
    static CGPoint lastPoint;
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [panGesture translationInView:self.displayOnView];
            self.displayFpsLb.center = CGPointMake(self.displayFpsLb.center.x + p.x - lastPoint.x, self.displayFpsLb.center.y + p.y - lastPoint.y);
            lastPoint = p;
            break;
        }
        default:
        {
            lastPoint = CGPointZero;
        }
            break;
    }
}

+ (void)zz_enbaleFps:(BOOL)enable onView:(nullable UIView *)onView {
    
    ZZPerformance *performance = [ZZPerformance shared];
    performance.displayOnView = onView;
    if (enable) {
        if (!performance.displayLink) {
            performance.displayLink = [CADisplayLink displayLinkWithTarget:[[self class] shared] selector:@selector(_printFps)];
            [performance.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
    }else {
        [performance.displayFpsLb removeFromSuperview];
        [performance.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        performance.displayLink = nil;
    }
}

- (void)_printFps {
    
    static NSTimeInterval lastTimeStamp = 0.1;
    static short frames = 0;
    if (lastTimeStamp == 0.1) {
        lastTimeStamp = self.displayLink.timestamp;
    }
    
    if (self.displayLink.timestamp - lastTimeStamp >= 1.0) {
        
        if (self.displayOnView) {
            
            if (self.displayFpsLb.superview == nil) {
                [self.displayOnView addSubview:self.displayFpsLb];
            }
            [self.displayFpsLb.superview bringSubviewToFront:self.displayFpsLb];
            self.displayFpsLb.text = [NSString stringWithFormat:@"Fps:%d", frames];
        
        }else {
            NSLog(@"Fps:%d", frames);
        }
        frames = 0;
        lastTimeStamp = self.displayLink.timestamp;
    }
    frames++;
}

@end
