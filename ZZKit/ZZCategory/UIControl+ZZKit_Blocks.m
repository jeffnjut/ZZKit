//
//  UIControl+ZZKit_Blocks.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/4.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIControl+ZZKit_Blocks.h"
#import <objc/runtime.h>

@implementation UIControl (ZZKit_Blocks)

/**
 *  设置UIButton的点击事件
 */
- (void)zz_tapBlock:(UIControlEvents)event block:(void(^)(__kindof UIControl * _Nonnull sender))block {
    
    [self setUserInteractionEnabled:YES];
    objc_setAssociatedObject(self, "_zzTapBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(_zz_tapAction:) forControlEvents:event];
}

#pragma mark - Private

- (void)_zz_tapAction:(UIButton *)sender {
    
    void(^block)(id sender)  = objc_getAssociatedObject(self, "_zzTapBlock");
    block == nil ? : block(sender);
}

@end
