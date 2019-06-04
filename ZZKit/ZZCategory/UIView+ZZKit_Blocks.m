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
- (void)zz_tapBlock:(void(^)(__kindof UIView * _Nonnull sender))block {
    
    [self setUserInteractionEnabled:YES];
    objc_setAssociatedObject(self, "_zzTapBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_zz_tapAction:)];
    [self addGestureRecognizer:_tap];
}

#pragma mark - Private

- (void)_zz_tapAction:(UITapGestureRecognizer *)tapGesture {
    
    void(^block)(id sender)  = objc_getAssociatedObject(self, "_zzTapBlock");
    block == nil ? : block(tapGesture.view);
}

@end
