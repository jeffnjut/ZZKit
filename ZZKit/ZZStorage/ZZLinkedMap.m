//
//  ZZLinkedMap.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/23.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLinkedMap.h"
#import <pthread.h>

#pragma mark - 双向链表指针Node节点对象
@interface ZZLinkedMapNode()

@end

@implementation ZZLinkedMapNode

@end

#pragma mark - 双向链表Map对象
@interface ZZLinkedMap()

@end

@implementation ZZLinkedMap

#pragma mark - Private

- (instancetype)init {
    self = [super init];
    if (self) {
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _releaseOnMainThread = NO;
        _releaseAsync = YES;
    }
    return self;
}

- (void)dealloc {
    
    CFRelease(_dic);
}

#pragma mark - Public

/**
 * 插入Node到Head节点
 */
- (nonnull ZZLinkedMapNode *)insertHead:(nonnull ZZLinkedMapNode *)node {
    
    // node添加到_map
    CFIndex cnt = CFDictionaryGetCount(_dic);
    CFDictionarySetValue(_dic, (__bridge void const *)node->_key, (__bridge void const *)node);
    if (cnt == CFDictionaryGetCount(_dic)) {
        [self bringHead:node];
        return node;
    }
    // 增加_map的cost
    _cost += node->_cost;
    // 增加_map长度
    _count++;
    if (_head) {
        // 双向链表非空
        node->_prev = nil;
        node->_next = _head;
        _head->_prev = node;
        _head = node;
    }else {
        // 双向链表空
        _head = node;
        _tail = node;
    }
    return node;
}

/**
 *  将Node移位到Head
 */
- (nonnull ZZLinkedMapNode *)bringHead:(nonnull ZZLinkedMapNode *)node {
    
    if (node == _head) {
        // node在head节点
        return _head;
    }else if (node == _tail) {
        // node在tail节点
        _tail = _tail->_prev;
        _tail->_next = nil;
    }else {
        // node在其它节点
        node->_prev->_next = node->_next;
        node->_next->_prev = node->_prev;
    }
    node->_prev = nil;
    node->_next = _head;
    _head->_prev = node;
    _head = node;
    return node;
}

/**
 * 插入Node到Tail节点
 */
- (nonnull ZZLinkedMapNode *)insertTail:(nonnull ZZLinkedMapNode *)node {
    
    CFIndex cnt = CFDictionaryGetCount(_dic);
    CFDictionarySetValue(_dic, (__bridge const void *)node->_key, (__bridge  const void *)node);
    if (cnt == CFDictionaryGetCount(_dic)) {
        [self sendTail:node];
        return node;
    }
    _cost += node->_cost;
    _count++;
    if (_tail) {
        node->_next = nil;
        node->_prev = _tail;
        _tail->_next = node;
        _tail = node;
    }else {
        _head = node;
        _tail = node;
    }
    return node;
}

/**
 * 将Node移位到Tail
 */
- (nonnull ZZLinkedMapNode *)sendTail:(nonnull ZZLinkedMapNode *)node {
    
    if (node == _tail) {
        return _tail;
    }else if (node == _head) {
        _head = _head->_next;
        _head->_prev = nil;
    }else {
        node->_prev->_next = node->_next;
        node->_next->_prev = node->_prev;
    }
    node->_next = nil;
    node->_prev = _tail;
    _tail->_next = node;
    _tail = node;
    return node;
}

/**
 * 删除Node
 */
- (nullable ZZLinkedMapNode *)removeNode:(nonnull ZZLinkedMapNode *)node {
    
    if (node == _head) {
        return [self removeHead];
    }else if (node == _tail) {
        return [self removeTail];
    }else {
        return [self removeNonLeafNode:node];
    }
    return nil;
}

/**
 * 删除Head Node
 */
- (nullable ZZLinkedMapNode *)removeHead {
    
    if (_head) {
        _cost -= _head->_cost;
        _count--;
        ZZLinkedMapNode *tmpNode = _head;
        _head = _head->_next;
        if (_head && _head->_prev) _head->_prev = nil;
        CFDictionaryRemoveValue(_dic, (__bridge void const *)tmpNode->_key);
        return tmpNode;
    }
    return nil;
}

/**
 * 删除Tail Node
 */
- (nullable ZZLinkedMapNode *)removeTail {
    
    if (_tail) {
        _cost -= _tail->_cost;
        _count--;
        ZZLinkedMapNode *tmpNode = _tail;
        _tail = _tail->_prev;
        _tail->_next = nil;
        CFDictionaryRemoveValue(_dic, (__bridge void const *)tmpNode->_key);
        return tmpNode;
    }
    return nil;
}

/**
 * 删除非首非尾Node
 */
- (nonnull ZZLinkedMapNode *)removeNonLeafNode:(nonnull ZZLinkedMapNode *)node {
    
    if (_head != nil && node != _head && node != _tail) {
        _cost -= node->_cost;
        _count--;
        node->_prev->_next = node->_next;
        node->_next->_prev = node->_prev;
        CFDictionaryRemoveValue(_dic, (__bridge void const *)node->_key);
        return node;
    }
    return nil;
}

/**
 * 删除全部
 */
- (void)removeAll {
    
    _cost = 0;
    _count = 0;
    _head = nil;
    _tail = nil;
    if (CFDictionaryGetCount(_dic) > 0) {
        CFMutableDictionaryRef tmpMap = _dic;
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        if (_releaseAsync) {
            dispatch_queue_t queue = _releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(queue, ^{
                CFRelease(tmpMap);
            });
        }else if (_releaseOnMainThread && pthread_main_np() == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CFRelease(tmpMap);
            });
        }else {
            CFRelease(tmpMap);
        }
    }
}

/**
 * 根据Key获得Node对象
 */
- (nullable ZZLinkedMapNode *)objectForKey:(id)key {
    
    return CFDictionaryGetValue(_dic, (__bridge void const *)key);
}

/**
 * 是否存在Key对应的Value
 */
- (BOOL)containKey:(id)key {
    
    return CFDictionaryContainsKey(_dic, (__bridge void const *)key);
}

@end
