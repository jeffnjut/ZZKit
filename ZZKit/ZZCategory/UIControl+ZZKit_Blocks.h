//
//  UIControl+ZZKit_Blocks.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/4.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ZZKit_Blocks)

/**
 *  设置UIButton的点击事件
 */
- (void)zz_tapBlock:(UIControlEvents)event block:(void(^)(__kindof UIControl * _Nonnull sender))block;

@end

NS_ASSUME_NONNULL_END
