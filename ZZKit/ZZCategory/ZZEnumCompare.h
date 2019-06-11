//
//  ZZEnumCompare.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZEnumCompare : NSObject

/**
 *  获取status
 */
- (NSInteger)zz_status;

/**
 *  type类型是否在status中存在
 */
- (BOOL)zz_hasType:(NSInteger)type;

/**
 *  status是否是包含type类型
 *  type类型由A|B|...|N等subType组成，包含任意一个subType返回true；否则为false
 */
- (BOOL)zz_hasAnySubType:(NSInteger)type;

/**
 *  添加type到status
 */
- (void)zz_addType:(NSInteger)type;

/**
 *  从status中移除type
 */
- (void)zz_removeType:(NSInteger)type;

/**
 *  设置status为type
 */
- (void)zz_setType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
