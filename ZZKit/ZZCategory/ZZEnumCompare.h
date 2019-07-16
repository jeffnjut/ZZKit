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
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType全部包含在status中返回true；否则为false
 */
- (BOOL)zz_hasType:(NSInteger)type;

/**
 *  type类型是否在status中存在某个子subType或全部
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType任意一个包含在status中返回true；否则为false
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

/**
 *  type类型是否在status中存在
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType全部包含在status中返回true；否则为false
 */
+ (BOOL)zz_has:(NSInteger)type aType:(NSInteger)aType;
    
/**
 *  type类型是否在status中存在某个子subType或全部
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType任意一个包含在status中返回true；否则为false
 */
+ (BOOL)zz_has:(NSInteger)type anySubType:(NSInteger)anySubType;

@end

NS_ASSUME_NONNULL_END
