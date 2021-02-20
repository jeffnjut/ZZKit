//
//  ZZPerformance.h
//  ZZKit
//
//  Created by Fu Jie on 2021/2/19.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZPerformance : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (id)copy NS_UNAVAILABLE;

- (id)mutableCopy NS_UNAVAILABLE;

+ (void)zz_enbaleFps:(BOOL)enable onView:(nullable UIView *)onView;

@end

NS_ASSUME_NONNULL_END
