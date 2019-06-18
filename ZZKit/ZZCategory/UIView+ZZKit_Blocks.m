//
//  UIView+ZZKit_Blocks.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/4.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIView+ZZKit_Blocks.h"
#import <objc/runtime.h>

@implementation UIView (ZZKit_Blocks)

/**
 *  设置通用的点击事件
 */
- (void)zz_tapBlock:(void(^)(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender))block {
    
    [self zz_removeTap];
    [self setUserInteractionEnabled:YES];
    objc_setAssociatedObject(self, "_zzTapBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_zz_tapAction:)];
    [self addGestureRecognizer:_tap];
}

/**
 *  删除通用的点击事件
 */
-(void)zz_removeTap {
    
    for (UITapGestureRecognizer *tapGesture in self.gestureRecognizers) {
        if ([tapGesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:tapGesture];
        }
    }
}

/**
 *  设置通用的长按事件
 */
- (void)zz_longPress:(NSTimeInterval)minimumPressDuration block:(void(^)(UILongPressGestureRecognizer * _Nonnull longPressGesture, __kindof UIView * _Nonnull sender))block {
    
    [self zz_removeLongPress];
    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_zz_longPress:)];
    longPressGesture.minimumPressDuration = minimumPressDuration;
    [self addGestureRecognizer:longPressGesture];
    objc_setAssociatedObject(self, "_zzLongPressBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  删除通用的长按事件
 */
- (void)zz_removeLongPress {
    
    for (UILongPressGestureRecognizer *longPressGesture in self.gestureRecognizers) {
        if ([longPressGesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [self removeGestureRecognizer:longPressGesture];
        }
    }
}

#pragma mark - Private

- (void)_zz_tapAction:(UITapGestureRecognizer *)tapGesture {
    
    void(^block)(UITapGestureRecognizer *gesture, id sender)  = objc_getAssociatedObject(self, "_zzTapBlock");
    block == nil ? : block(tapGesture, tapGesture.view);
}

- (void)_zz_longPress:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        void(^block)(UILongPressGestureRecognizer *gesture, id sender)  = objc_getAssociatedObject(self, "_zzLongPressBlock");
        block == nil ? : block(longPressGesture, longPressGesture.view);
    }
}

@end
