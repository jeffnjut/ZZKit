//
//  NSMutableArray+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (ZZKit)

#pragma mark - NSArray数组安全操作

/**
 *  NSMutableArray获取对象
 */
- (id)zz_mutableArrayObjectAtIndex:(NSUInteger)index;

/**
 *  NSMutableArray增加对象
 */
- (void)zz_mutableArrayAddObject:(nonnull id)anObject;

/**
 *  NSMutableArray插入对象
 */
- (void)zz_mutableArrayInsertObject:(nonnull id)anObject atIndex:(NSUInteger)index;

/**
 *  NSMutableArray删除对象（按对象）
 */
- (void)zz_mutableArrayRemoveObject:(nonnull id)object;

/**
 *  NSMutableArray删除对象（按序列）
 */
- (void)zz_mutableArrayRemoveObjectAtIndex:(NSUInteger)index;

/**
 *  NSMutableArray替换对象
 */
- (void)zz_mutableArrayReplaceObjectAtIndex:(NSUInteger)index withObject:(nonnull id)anObject;

/**
 *  NSMutableArray删除第一个对象
 */
- (void)zz_mutableArrayRemoveFirstObject;

/**
 *  NSMutableArray删除最后一个对象
 */
- (void)zz_mutableArrayRemoveLastObject;

/**
 *  NSMutableArray随机乱序
 */
- (void)zz_mutableArrayShuffle;

/**
 *  NSMutableArray倒序排列
 */
- (void)zz_mutableArrayReverse;

/**
 *  添加的NSArray数组以去重的方式被添加的NSMutableArray(Self)数据
 */
- (void)zz_mutableArrayMergeAndRemoveDuplicateObjects:(nonnull NSArray *)array;

/**
 *  NSMutableArray删除重复的对象
 */
- (void)zz_mutableArrayRemoveDuplicateObjects;

/**
 *  取两个数组的交集
 */
- (void)zz_mutableArrayInterSectionWithArray:(nonnull NSArray *)array;

/**
 *  NSMutableArray转NSArray
 */
- (NSArray *)zz_mutableArrayToArray;

/**
 *  按Mapping Block规则处理NSMutableArray
 */
- (void)zz_mutableArrayMappedUsingBlock:(nonnull id (^)(id object))block;

/**
 *  NSMutableArray是否为非空
 */
- (BOOL)zz_mutableArrayHasObject;

/**
 *  NSMutableArray是否为空
 */
- (BOOL)zz_mutableArrayIsEmpty;

@end

NS_ASSUME_NONNULL_END
