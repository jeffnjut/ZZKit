//
//  UIViewController+ZZTrace.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZZTrace)

// 设置上一页的pref
- (void)zz_setPref:(NSString *)pref;

// 获取上一页的pref
- (NSString *)zz_getPref;

// 设置上一页的pageHash
- (void)zz_setPrefHash:(NSString *)prefHash;

// 获取上一页的pageHash
- (NSString *)zz_getPrefHash;

// 设置上一页的pageHash的全路径
- (void)zz_setPageHashFullPath:(NSString *)prefHash;

// 获取上一页的pageHash的全路径
- (NSString *)zz_getPageHashFullPath;

// Push
- (void)zz_trace_push:(UIViewController *)viewController animated:(BOOL)animated;

// Present
- (void)zz_trace_present:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
