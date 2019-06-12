//
//  ZZNavigationController.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZNavigationController : UINavigationController

@property (nonatomic, assign) BOOL zzDisablePopGesture;

@property (nonatomic, copy) BOOL(^zzPopGestureBlock)(__weak ZZNavigationController *zzNavigationController);

@end

NS_ASSUME_NONNULL_END
