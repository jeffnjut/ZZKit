//
//  UIView+ZZKit_Blocks.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/4.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZZKit_Blocks)

/**
 *  设置通用的点击事件
 */
- (void)zz_tapBlock:(void(^)(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender))block;

/**
 *  删除通用的点击事件
 */
- (void)zz_removeTap;

/**
 *  设置通用的长按事件
 */
- (void)zz_longPress:(NSTimeInterval)minimumPressDuration block:(void(^)(UILongPressGestureRecognizer * _Nonnull longPressGesture, __kindof UIView * _Nonnull sender))block;

/**
 *  删除通用的长按事件
 */
- (void)zz_removeLongPress;

@end

NS_ASSUME_NONNULL_END
