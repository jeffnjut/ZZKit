//
//  ZZLinkedMap.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/23.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZLinkedMapNode, ZZLinkedMap;

typedef ZZLinkedMapNode* ZZLinkedMapNodePtr;

#pragma mark - 双向链表指针Node节点对象
@interface ZZLinkedMapNode : NSObject
{
    @package
    __unsafe_unretained ZZLinkedMapNode *_next;
    __unsafe_unretained ZZLinkedMapNode *_prev;
    id _key;
    id _value;
    NSUInteger _cost;
    NSTimeInterval _time;
}

@end

#pragma mark - 双向链表Map对象

@interface ZZLinkedMap : NSObject
{
    @package
    ZZLinkedMapNode *_head;
    ZZLinkedMapNode *_tail;
    CFMutableDictionaryRef _dic;
    NSUInteger _cost;
    NSUInteger _count;
    BOOL _releaseOnMainThread;
    BOOL _releaseAsync;
}

#pragma mark - Public

/**
 * 插入Node到Head节点
 */
- (nonnull ZZLinkedMapNode *)insertHead:(nonnull ZZLinkedMapNode *)node;

/**
 *  将Node移位到Head
 */
- (nonnull ZZLinkedMapNode *)bringHead:(nonnull ZZLinkedMapNode *)node;

/**
 * 插入Node到Tail节点
 */
- (nonnull ZZLinkedMapNode *)insertTail:(nonnull ZZLinkedMapNode *)node;

/**
 * 将Node移位到Tail
 */
- (nonnull ZZLinkedMapNode *)sendTail:(nonnull ZZLinkedMapNode *)node;

/**
 * 删除Node
 */
- (nullable ZZLinkedMapNode *)removeNode:(nonnull ZZLinkedMapNode *)node;

/**
 * 删除Head Node
 */
- (nullable ZZLinkedMapNode *)removeHead;

/**
 * 删除Tail Node
 */
- (nullable ZZLinkedMapNode *)removeTail;

/**
 * 删除非首非尾Node
 */
- (nonnull ZZLinkedMapNode *)removeNonLeafNode:(nonnull ZZLinkedMapNode *)node;

/**
 * 删除全部
 */
- (void)removeAll;

/**
 * 根据Key获得Node对象
 */
- (nullable ZZLinkedMapNode *)objectForKey:(id)key;

/**
 * 是否存在Key对应的Value
 */
- (BOOL)containKey:(id)key;

@end

NS_ASSUME_NONNULL_END
