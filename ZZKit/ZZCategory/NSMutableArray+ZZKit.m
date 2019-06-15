//
//  NSMutableArray+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSMutableArray+ZZKit.h"

@implementation NSMutableArray (ZZKit)

#pragma mark - NSArray数组安全操作

/**
 *  NSMutableArray获取对象
 */
- (id)zz_mutableArrayObjectAtIndex:(NSUInteger)index {
    
    if (index >= 0 && index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

/**
 *  NSMutableArray增加对象
 */
- (void)zz_mutableArrayAddObject:(nonnull id)anObject {
    
    if (anObject != nil && ![anObject isKindOfClass:[NSNull class]]) {
        [self addObject:anObject];
    }
}

/**
 *  NSMutableArray插入对象
 */
- (void)zz_mutableArrayInsertObject:(nonnull id)anObject atIndex:(NSUInteger)index {
    
    if (index >= 0 && index <= self.count && anObject != nil && ![anObject isKindOfClass:[NSNull class]]) {
        [self insertObject:anObject atIndex:index];
    }
}

/**
 *  NSMutableArray删除对象（按对象）
 */
- (void)zz_mutableArrayRemoveObject:(nonnull id)object {
    
    if ([self count] >= 0) {
        [self removeObject:object];
    }
}

/**
 *  NSMutableArray删除对象（按序列）
 */
- (void)zz_mutableArrayRemoveObjectAtIndex:(NSUInteger)index {
    
    if (index >= 0 && index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

/**
 *  NSMutableArray替换对象
 */
- (void)zz_mutableArrayReplaceObjectAtIndex:(NSUInteger)index withObject:(nonnull id)anObject {
    
    if (index >= 0 && index < self.count && anObject != nil && ![anObject isKindOfClass:[NSNull class]]) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

/**
 *  NSMutableArray删除第一个对象
 */
- (void)zz_mutableArrayRemoveFirstObject {
    
    if ([self count] > 0) {
        [self removeObjectAtIndex:0];
    }
}

/**
 *  NSMutableArray删除最后一个对象
 */
- (void)zz_mutableArrayRemoveLastObject {
    
    if ([self count] > 0) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

/**
 *  NSMutableArray随机乱序
 */
- (void)zz_mutableArrayShuffle {
    
    for (NSInteger i = (NSInteger)[self count] - 1; i > 0; i--) {
        NSUInteger j = (NSUInteger)arc4random_uniform((uint32_t)i + 1);
        [(NSMutableArray *)self exchangeObjectAtIndex:j withObjectAtIndex:(NSUInteger)i];
    }
}

/**
 *  NSMutableArray倒序排列
 */
- (void)zz_mutableArrayReverse {
    
    if ([self count] >= 2) {
        for (int i = 0; i < self.count / 2; i++) {
            [self exchangeObjectAtIndex:i withObjectAtIndex:(self.count - 1 - i)];
        }
    }
}

/**
 *  添加的NSArray数组以去重的方式被添加的NSMutableArray(Self)数据
 */
- (void)zz_mutableArrayMergeAndRemoveDuplicateObjects:(nonnull NSArray *)array {
    
    NSSet *set = [NSSet setWithArray:self];
    for (id object in array) {
        if (![set containsObject:object]) {
            [(NSMutableArray *)self addObject:object];
        }
    }
}

/**
 *  NSMutableArray删除重复的对象
 */
- (void)zz_mutableArrayRemoveDuplicateObjects {
    
    [self setArray:[[NSOrderedSet orderedSetWithArray:self] array]];
}

/**
 *  取两个数组的交集
 */
- (void)zz_mutableArrayInterSectionWithArray:(nonnull NSArray *)array {
    
    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithArray:self];
    [mutableSet intersectSet:[NSSet setWithArray:array]];
    [self removeAllObjects];
    [self addObjectsFromArray:[mutableSet array]];
}

/**
 *  NSMutableArray转NSArray
 */
- (NSArray *)zz_mutableArrayToArray {
    
    return [NSArray arrayWithArray:self];
}

/**
 *  按Mapping Block规则处理NSMutableArray
 */
- (void)zz_mutableArrayMappedUsingBlock:(nonnull id (^)(id object))block {
    
    if (block) {
        for (id object in self) {
            id replacement = block(object);
            if (replacement) {
                [self addObject:replacement];
            }
        }
    }
}

/**
 *  NSMutableArray是否为空
 */
- (BOOL)zz_mutableArrayIsEmpty {
    
    if ([self count] > 0) {
        return NO;
    }
    return YES;
}

/**
 *  NSArray是否含有Class类型的对象
 */
- (BOOL)zz_mutableArrayContainsClassType:(nonnull Class)cls {
    
    if (self.count > 0) {
        return [[self objectAtIndex:0] isKindOfClass:cls];
    }
    return NO;
}

@end
