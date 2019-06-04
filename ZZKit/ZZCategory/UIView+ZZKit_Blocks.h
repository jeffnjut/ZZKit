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
- (void)zz_tapBlock:(void(^)(__kindof UIView * _Nonnull sender))block;

@end

NS_ASSUME_NONNULL_END
