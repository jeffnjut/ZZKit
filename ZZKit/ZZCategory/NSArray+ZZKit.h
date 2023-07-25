//
//  NSArray+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZZKit)

#pragma mark - NSArray数组安全操作

/**
 *  NSArray获取对象
 */
- (id)zz_arrayObjectAtIndex:(NSUInteger)index;

/**
 *  NSArray增加对象
 */
- (NSMutableArray *)zz_arrayAddObject:(nonnull id)anObject;

/**
 *  NSArray插入对象
 */
- (NSMutableArray *)zz_arrayInsertObject:(nonnull id)anObject atIndex:(NSUInteger)index;

/**
 *  NSArray删除对象（按对象）
 */
- (NSMutableArray *)zz_arrayRemoveObject:(nonnull id)object;

/**
 *  NSArray删除对象（按序列）
 */
- (NSMutableArray *)zz_arrayRemoveObjectAtIndex:(NSUInteger)index;

/**
 *  NSArray替换对象
 */
- (NSMutableArray *)zz_arrayReplaceObjectAtIndex:(NSUInteger)index withObject:(nonnull id)object;

/**
 *  NSArray交换两个对象
 */
- (NSMutableArray *)zz_arrayExchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;

/**
 *  NSArray删除第一个对象
 */
- (NSMutableArray *)zz_arrayRemoveFirstObject;

/**
 *  NSArray删除最后一个对象
 */
- (NSMutableArray *)zz_arrayRemoveLastObject;

/**
 *  NSArray随机乱序
 */
- (NSMutableArray *)zz_arrayShuffle;

/**
 *  NSArray倒序排列
 */
- (NSMutableArray *)zz_arrayReverse;

/**
 *  添加的NSArray数组以去重的方式被添加的NSArray(Self)数据
 */
- (NSMutableArray *)zz_arrayMergeAndRemoveDuplicateObjects:(nonnull NSArray *)array;

/**
 *  NSArray删除重复的对象
 */
- (NSMutableArray *)zz_arrayRemoveDuplicateObjects;

/**
 *  取两个数组的交集
 */
- (NSMutableArray *)zz_arrayInterSectionWithArray:(nonnull NSArray *)array;

/**
 *  NSArray转NSMutableArray
 */
- (NSMutableArray *)zz_arrayToMutableArray;

/**
 *  按Mapping Block规则生成NSArray
 */
- (NSMutableArray *)zz_arrayMappedUsingBlock:(nonnull  id(^)(id object))block;

/**
 *  NSArray是否为空
 */
- (BOOL)zz_arrayIsEmpty;

/**
 *  NSArray是否为非空
 */
- (BOOL)zz_arrayIsNotEmpty;

/**
 *  NSArray是否含有Class类型的对象
 */
- (BOOL)zz_arrayContainsClassType:(nonnull Class)cls;

/**
 *  NSArray按首字母ASCII排序
 */
- (NSArray *)zz_arraySort:(BOOL)asc;

#pragma mark - NSArray转JSON

/**
 *  NSArray转JSON
 */
- (NSString *)zz_toJSONString;

@end

NS_ASSUME_NONNULL_END
