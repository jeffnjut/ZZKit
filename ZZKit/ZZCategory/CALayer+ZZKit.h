//
//  CALayer+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZZKit)

#pragma mark - 动画

/**
 *  Rotate动画
 */
- (void)zz_rotate:(CFTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue times:(CGFloat)times removedOnCompletion:(BOOL)removedOnCompletion;

@end

NS_ASSUME_NONNULL_END
