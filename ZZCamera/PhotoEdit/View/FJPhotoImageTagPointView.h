//
//  FJPhotoImageTagPointView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/12/11.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJPhotoImageTagPointView : UIView

- (void)startAnimation;
- (void)stopAnimation;

@end


// 脉冲 闪烁
@interface FJPulseLayer : CAReplicatorLayer

/**
 *  缩放动画开始的半径值
 *
 *	默认值 0.0
 */
@property (nonatomic, assign) CGFloat fromValueForRadius;

/**
 *  透明动画开始的透明度值
 *
 *	默认值 0.45
 */
@property (nonatomic, assign) CGFloat fromValueForAlpha;

/**
 *	关键帧动画中，透明度的中间值
 *
 *	默认值 0.2
 */
@property (nonatomic, assign) CGFloat keyTimeForHalfOpacity;

/**
 *  脉冲动画的重复次数
 *
 *	默认值 INFINITY.
 */
@property (nonatomic, assign) float repeatCount;

/**
 *  圆形脉冲的半径
 *
 *	默认值 15pt.
 */
@property (nonatomic, assign) CGFloat radius;

/**
 *	以秒为单位的动画时间.
 *
 *	默认值 1.0
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 *  圆形脉冲的个数
 *
 *	默认值 1
 */
@property (nonatomic, assign) NSInteger focusLayerNumber;

- (void)startAnimation;
- (void)stopAnimation;

@end
