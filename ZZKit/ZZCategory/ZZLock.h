//
//  ZZLock.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZLock : NSObject

/**
 *  加锁
 */
- (void)lock;

/**
 *  解锁
 */
- (void)unlock;

@end

NS_ASSUME_NONNULL_END
