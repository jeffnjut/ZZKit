//
//  CALayer+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "CALayer+ZZKit.h"

@implementation CALayer (ZZKit)

#pragma mark - 动画

/**
 *  Rotate动画
 */
- (void)zz_rotate:(CFTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue times:(CGFloat)times removedOnCompletion:(BOOL)removedOnCompletion {
    
    CABasicAnimation *anim;
    anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.repeatCount = times;
    anim.fromValue = [NSNumber numberWithFloat:fromValue];
    anim.toValue = [NSNumber numberWithFloat:toValue];
    if (removedOnCompletion == NO) {
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
    }
    [self addAnimation:anim forKey:@"animateTransform"];
}

@end
