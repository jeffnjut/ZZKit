//
//  NSArray+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSArray+ZZKit.h"
#import "NSMutableArray+ZZKit.h"
#import "NSDictionary+ZZKit.h"
#import <YYModel/YYModel.h>

@implementation NSArray (ZZKit)

#pragma mark - NSArray数组安全操作

/**
 *  NSArray获取对象
 */
- (id)zz_arrayObjectAtIndex:(NSUInteger)index {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)self) zz_mutableArrayObjectAtIndex:index];
    }
    if (index >= 0 && index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

/**
 *  NSArray增加对象
 */
- (NSMutableArray *)zz_arrayAddObject:(nonnull id)anObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayAddObject:anObject];
        return (NSMutableArray *)self;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
    [mutableArray zz_mutableArrayAddObject:anObject];
    return mutableArray;
}

/**
 *  NSArray插入对象
 */
- (NSMutableArray *)zz_arrayInsertObject:(nonnull id)anObject atIndex:(NSUInteger)index {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayInsertObject:anObject atIndex:index];
        return (NSMutableArray *)self;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
    [mutableArray zz_mutableArrayInsertObject:anObject atIndex:index];
    return mutableArray;
}

/**
 *  NSArray删除对象（按对象）
 */
- (NSMutableArray *)zz_arrayRemoveObject:(nonnull id)object {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayRemoveObject:object];
        return (NSMutableArray *)self;
    }
    if ([self count] == 0) {
        return [NSMutableArray new];
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray removeObject:object];
        return mutableArray;
    }
}

/**
 *  NSArray删除对象（按序列）
 */
- (NSMutableArray *)zz_arrayRemoveObjectAtIndex:(NSUInteger)index {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayRemoveObjectAtIndex:index];
        return (NSMutableArray *)self;
    }
    if ([self count] == 0) {
        return [NSMutableArray new];
    } else if (index < 0 || index >= [self count]) {
        // 越界
        return [NSMutableArray arrayWithArray:self];
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray removeObjectAtIndex:index];
        return mutableArray;
    }
}

/**
 *  NSArray替换对象
 */
- (NSMutableArray *)zz_arrayReplaceObjectAtIndex:(NSUInteger)index withObject:(nonnull id)object {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayReplaceObjectAtIndex:index withObject:object];
        return (NSMutableArray *)self;
    }
    if ([self count] == 0) {
        // 数据为空
        return [NSMutableArray new];
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray replaceObjectAtIndex:index withObject:object];
        return mutableArray;
    }
}

/**
 *  NSArray交换两个对象
 */
- (NSMutableArray *)zz_arrayExchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2 {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayExchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        return (NSMutableArray *)self;
    }
    if ([self count] == 0) {
        // 数据为空
        return [NSMutableArray arrayWithArray:self];
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        return mutableArray;
    }
}

/**
 *  NSArray删除第一个对象
 */
- (NSMutableArray *)zz_arrayRemoveFirstObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayRemoveFirstObject];
        return (NSMutableArray *)self;
    }
    if ([self count] == 0) {
        // 数据为空
        return [NSMutableArray new];
    }else if ([self count] == 1) {
        return [NSMutableArray new];
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray removeObjectAtIndex:0];
        return mutableArray;
    }
}

/**
 *  NSArray删除最后一个对象
 */
- (NSMutableArray *)zz_arrayRemoveLastObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayRemoveLastObject];
        return (NSMutableArray *)self;
    }
    if ([self count] == 0) {
        // 数据为空
        return [NSMutableArray new];
    }else if ([self count] == 1) {
        return [NSMutableArray new];
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray removeLastObject];
        return mutableArray;
    }
}

/**
 *  NSArray随机乱序
 */
- (NSMutableArray *)zz_arrayShuffle {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayShuffle];
        return (NSMutableArray *)self;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
    [mutableArray zz_mutableArrayShuffle];
    return mutableArray;
}

/**
 *  NSArray倒序排列
 */
- (NSMutableArray *)zz_arrayReverse {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayReverse];
        return (NSMutableArray *)self;
    }
    return [NSMutableArray arrayWithArray:[[self reverseObjectEnumerator] allObjects]];
}

/**
 *  添加的NSArray数组以去重的方式被添加的NSArray(Self)数据
 */
- (NSMutableArray *)zz_arrayMergeAndRemoveDuplicateObjects:(nonnull NSArray *)array {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayMergeAndRemoveDuplicateObjects:array];
        return (NSMutableArray *)self;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
    [mutableArray zz_mutableArrayMergeAndRemoveDuplicateObjects:array];
    return mutableArray;
}

/**
 *  NSArray删除重复的对象
 */
- (NSMutableArray *)zz_arrayRemoveDuplicateObjects {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayRemoveDuplicateObjects];
        return (NSMutableArray *)self;
    }
    return [NSMutableArray arrayWithArray:[[NSOrderedSet orderedSetWithArray:self] array]];
}

/**
 *  取两个数组的交集
 */
- (NSMutableArray *)zz_arrayInterSectionWithArray:(nonnull NSArray *)array {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayInterSectionWithArray:array];
        return (NSMutableArray *)self;
    }
    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithArray:self];
    [mutableSet intersectSet:[NSSet setWithArray:array]];
    return [NSMutableArray arrayWithArray:[mutableSet array]];
}

/**
 *  NSArray转NSMutableArray
 */
- (NSMutableArray *)zz_arrayToMutableArray {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return (NSMutableArray *)self;
    }
    return [NSMutableArray arrayWithArray:self];
}

/**
 *  按Mapping Block规则生成NSArray
 */
- (NSMutableArray *)zz_arrayMappedUsingBlock:(nonnull  id(^)(id object))block {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) zz_mutableArrayMappedUsingBlock:block];
        return (NSMutableArray *)self;
    }
    if (block) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[self count]];
        for (id object in self) {
            id replacement = block(object);
            if (replacement) {
                [mutableArray addObject:replacement];
            }
        }
        return mutableArray;
    }else {
        return [NSMutableArray arrayWithArray:self];
    }
}

/**
 *  NSArray是否为空
 */
- (BOOL)zz_arrayIsEmpty {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)self) zz_mutableArrayIsEmpty];
    }
    if ([self count] > 0) {
        return NO;
    }
    return YES;
}

/**
 *  NSArray是否含有Class类型的对象
 */
- (BOOL)zz_arrayContainsClassType:(nonnull Class)cls {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)self) zz_mutableArrayContainsClassType:cls];
    }
    if (self.count > 0) {
        return [[self objectAtIndex:0] isKindOfClass:cls];
    }
    return NO;
}

/**
 *  NSArray按首字母ASCII排序
 */
- (NSArray *)zz_arraySort:(BOOL)asc {
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortedArray = [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult result = NSOrderedSame;
        if (asc) {
            result = [obj1 compare:obj2];
        }else {
            result = [obj2 compare:obj1];
        }
        return result;
    }];
    return afterSortedArray;
}

#pragma mark - NSArray转JSON

/**
 *  NSArray转JSON
 */
- (NSString *)zz_toJSONString {
    
    if ([self count] == 0) {
        return nil;
    }
    NSMutableString *ret = [[NSMutableString alloc] initWithString:@"["];
    for (int i = 0; i < self.count; i++) {
        NSObject *object = [self objectAtIndex:i];
        id appendData = nil;
        if ([object isKindOfClass:[NSString class]]) {
            appendData = [NSString stringWithFormat:@"\"%@\"",object];
        }else if ([object isKindOfClass:[NSNumber class]]) {
            appendData = object;
        }else if ([object isKindOfClass:[NSArray class]]) {
            appendData = [(NSArray *)object zz_toJSONString];
        }else if ([object isKindOfClass:[NSDictionary class]]) {
            appendData = [(NSDictionary *)object zz_toJSONString];
        }else {
            appendData = [object yy_modelToJSONString];
        }
        if (i == self.count - 1) {
            [ret appendFormat:@"%@]", appendData];
        }else {
            [ret appendFormat:@"%@,", appendData];
        }
    }
    return ret;
}

@end
