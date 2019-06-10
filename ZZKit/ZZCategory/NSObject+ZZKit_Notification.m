//
//  NSObject+ZZKit_Notification.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSObject+ZZKit_Notification.h"
#import <pthread.h>
#import <objc/runtime.h>
#import <objc/message.h>

static void *const kZZObserver = "kZZObserver";
static void *const kZZNotification = "kZZNotification";
static void *const kSwizzledDealloc = "kSwizzledDealloc";

#pragma mark - ZZNotification

@interface _ZZNotification : NSObject
{
    @private
    pthread_mutex_t _lock;
    CFMutableDictionaryRef _dict;
}

- (nullable id)zz_objectForKey:(nonnull NSString *)key;

- (void)zz_setValue:(nullable id)value forKey:(nonnull NSString *)key;

- (void)zz_removeAll;

- (void)zz_remove:(nonnull NSString *)key;

- (BOOL)zz_hasObjects;

- (void)zz_notificationAction:(NSNotification *)notification;

- (void)zz_execute:(nonnull void(^)(void const *key, void const *value))block;

@end

@implementation _ZZNotification

#pragma mark - _ZZNotification init

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _dict = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (nullable id)zz_objectForKey:(nonnull NSString *)key {
    
    id value = nil;
    pthread_mutex_lock(&_lock);
    value = CFDictionaryGetValue(_dict, (__bridge const void *)(key));
    pthread_mutex_unlock(&_lock);
    return value;
}

- (void)zz_setValue:(nullable id)value forKey:(nonnull NSString *)key {
    
    pthread_mutex_lock(&_lock);
    if (!value) {
        CFDictionaryRemoveValue(_dict, (__bridge const void *)(key));
    }else {
        CFDictionarySetValue(_dict, (__bridge const void *)(key), (__bridge const void *)(value));
    }
    pthread_mutex_unlock(&_lock);
}

- (void)zz_replace:(nullable id)value forKey:(nonnull NSString *)key {
    
    pthread_mutex_lock(&_lock);
    CFDictionaryReplaceValue(_dict, (__bridge const void *)(key), (__bridge const void *)(value));
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeAll {
    
    pthread_mutex_lock(&_lock);
    CFDictionaryRemoveAllValues(_dict);
    pthread_mutex_unlock(&_lock);
}

- (void)zz_remove:(nonnull NSString *)key {
    
    pthread_mutex_lock(&_lock);
    CFDictionaryRemoveValue(_dict, (__bridge const void *)(key));
    pthread_mutex_unlock(&_lock);
}

- (BOOL)zz_hasObjects {
    
    CFIndex count = 0;
    pthread_mutex_lock(&_lock);
    count = CFDictionaryGetCount(_dict);
    pthread_mutex_unlock(&_lock);
    return count > 0;
}

- (void)zz_execute:(nonnull void(^)(void const *key, void const *value))block {
    
    CFIndex count = CFDictionaryGetCount(_dict);
    if (count == 0) {
        return;
    }
    CFTypeRef _keys[] = {NULL};
    CFDictionaryGetKeysAndValues(_dict, (const void**)_keys, (const void**)NULL);
    for(CFIndex i = 0; i < count; i++){
        block(_keys[i], CFDictionaryGetValue(_dict, (void const *)_keys[i]));
    }
}

#pragma mark - Notification Responder

- (void)zz_notificationAction:(NSNotification *)notification {
    
    void(^block)(NSNotification *notification) = [self zz_objectForKey:notification.name];
    if (block != nil) {
        block(notification);
    }
}

#pragma mark - observeValueForKeyPath:ofObject:change:context:

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    // NSKeyValueObservingOptionNew：当options中包括了这个参数的时候，观察者收到的change参数中就会包含NSKeyValueChangeNewKey和它对应的值，
    // 也就是说，观察者可以得知这个property在被改变之后的新值。
    // NSKeyValueObservingOptionOld：和NSKeyValueObservingOptionNew的意思类似，当包含了这个参数的时候，观察者收到的change参数中就会包含NSKeyValueChangeOldKey和它对应的值。
    // NSKeyValueObservingOptionInitial：当包含这个参数的时候，在addObserver的这个过程中，就会有一个notification被发送到观察者那里，反之则没有。
    // NSKeyValueObservingOptionPrior：当包含这个参数的时候，在被观察的property的值改变前和改变后，系统各会给观察者发送一个change notification；
    // 在property的值改变之前发送的change notification中，change参数会包含NSKeyValueChangeNotificationIsPriorKey并且值为@YES，但不会包含NSKeyValueChangeNewKey和它对应的值。
    
    void(^block)(id object, id oldValue, id newValue) = [self zz_objectForKey:keyPath];
    if (block != nil) {
        
        BOOL prior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
        if (prior) {
            // 改变前的信息
            return;
        }
        
        NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
        if (kind != NSKeyValueChangeSetting) {
            // 非设置的，其它还有NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, NSKeyValueChangeReplacement
            return;
        }
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (oldValue == [NSNull null]) {
            oldValue = nil;
        }
        if (newValue == [NSNull null]) {
            newValue = nil;
        }
        block(object, oldValue, newValue);
    }
}

@end

@implementation NSObject (ZZKit_Notification)

#pragma mark - KVO监听

/**
 *  添加KVO监听
 */
- (void)zz_addObserverBlockForKeyPath:(nonnull NSString *)keyPath block:(nullable void(^)(id object, id oldValue, id newValue))block {

    if (!keyPath || !block) {
        return;
    }
    // 取出对应的Target(以keyPath存储)
    void(^target)(id object, id oldValue, id newValue) = [self.zzObserver zz_objectForKey:keyPath];
    if (!target) {
        // 注册监听
        [self addObserver:self.zzObserver forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        // 添加Block
        [self.zzObserver zz_setValue:block forKey:keyPath];
    }else {
        // 替换Block
        [self.zzObserver zz_replace:block forKey:keyPath];
    }
    
    [self _swizzleDealloc];
}

/**
 *  移除KVO监听
 */
- (void)zz_removeObserverBlockForKeyPath:(nonnull NSString *)keyPath {
    
    if (!keyPath) {
        return;
    }
    
    if ([self.zzObserver zz_hasObjects] == NO) {
        return;
    }
    
    void(^target)(id object, id oldValue, id newValue) = [self.zzObserver zz_objectForKey:keyPath];
    if (!target) {
        return;
    }
    
    [self.zzObserver zz_remove:keyPath];
}

/**
 *  移除全部KVO监听
 */
- (void)zz_removeAllObserverBlocks {
    
    if ([self.zzObserver zz_hasObjects] == NO) {
        return;
    }
    [self.zzObserver zz_removeAll];
}

#pragma mark - Notification监听

/**
 *  添加通知
 */
- (void)zz_addNotificationBlockForName:(nonnull NSString *)name block:(nullable void(^)(NSNotification *notification))block {
    
    if (!name || !block) {
        return;
    }
    
    // 取出保存KVOTarget字典
    void(^target)(NSNotification *notification) = [self.zzNotification zz_objectForKey:name];
    if (!target) {
        // 注册监听
        [[NSNotificationCenter defaultCenter] addObserver:self.zzNotification selector:@selector(zz_notificationAction:) name:name object:nil];
        // 添加Block
        [self.zzNotification zz_setValue:block forKey:name];
    }else {
        // 替换Block
        [self.zzNotification zz_setValue:block forKey:name];
    }
    [self _swizzleDealloc];
}

/**
 *  移除通知
 */
- (void)zz_removeNotificationBlockForName:(nonnull NSString *)name {
    
    if (!name) {
        return;
    }
    
    if ([self.zzNotification zz_hasObjects] == NO) {
        return;
    }
    
    void(^target)(NSNotification *notification) = [self.zzNotification zz_objectForKey:name];
    if (!target) {
        return;
    }
    
    [self.zzNotification zz_remove:name];
}

/**
 *  移除全部通知
 */
- (void)zz_removeAllNotificationBlocks {
    
    if ([self.zzNotification zz_hasObjects] == NO) {
        return;
    }
    
    [self.zzNotification zz_removeAllObserverBlocks];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.zzNotification];
}

/**
 *  发送通知
 */
- (void)zz_postNotificationWithName:(nonnull NSString *)name {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil];
}

/**
 *  发送通知
 */
- (void)zz_postNotificationWithName:(nonnull NSString *)name userInfo:(nonnull NSDictionary *)userInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

#pragma mark - Private

- (_ZZNotification *)zzObserver {
    
    _ZZNotification *_zzObserver = (_ZZNotification *)(objc_getAssociatedObject(self, kZZObserver));
    if (!_zzObserver) {
        _zzObserver = [[_ZZNotification alloc] init];
        objc_setAssociatedObject(self, kZZObserver, _zzObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _zzObserver;
}

- (_ZZNotification *)zzNotification {
    
    _ZZNotification *_zzNotification = (_ZZNotification *)(objc_getAssociatedObject(self, kZZNotification));
    if (!_zzNotification) {
        _zzNotification = [[_ZZNotification alloc] init];
        objc_setAssociatedObject(self, kZZNotification, _zzNotification, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _zzNotification;
}

- (void)_swizzleDealloc {
    
    BOOL swizzled = [objc_getAssociatedObject(self, kSwizzledDealloc) boolValue];
    if (swizzled) {
        return;
    }
    Class swizzleClass = [self class];
    @synchronized(swizzleClass) {
        
        swizzled = [objc_getAssociatedObject(self, kSwizzledDealloc) boolValue];
        if (swizzled) {
            return;
        }
        
        // 获取原有的dealloc方法
        SEL deallocSelector = sel_registerName("dealloc");
        // 初始化一个函数指针用于保存原有的dealloc方法
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        // 实现我们自己的dealloc方法，通过block的方式
        id newDealloc = ^(__unsafe_unretained id objSelf) {
            // 在这里我们移除所有的KVO
            [((_ZZNotification *)objSelf).zzObserver zz_removeAll];
            // 移除所有通知
            [((_ZZNotification *)objSelf).zzNotification zz_removeAll];
            // 根据原有的dealloc方法是否存在进行判断
            if (originalDealloc == NULL) {
                // 如果不存在，说明本类没有实现dealloc方法，则需要向父类发送dealloc消息(objc_msgSendSuper)
                // 构造objc_msgSendSuper所需要的参数，.receiver为方法的实际调用者，即为类本身，.super_class指向其父类
                struct objc_super superInfo = {
                    .receiver = objSelf,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                // 构建objc_msgSendSuper函数
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                //向super发送dealloc消息
                msgSend(&superInfo, deallocSelector);
            }else{
                // 如果存在，表明该类实现了dealloc方法，则直接调用即可
                // 调用原有的dealloc方法
                originalDealloc(objSelf, deallocSelector);
            }
        };
        // 根据block构建新的dealloc实现IMP
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        // 尝试添加新的dealloc方法，如果该类已经复写的dealloc方法则不能添加成功，反之则能够添加成功
        // "v@:"  这是一个void类型的方法，没有参数传入;
        // "i@:"  这是一个int类型的方法，没有参数传入;
        // "i@:@" 这是一个int类型的方法，有一个参数传入。
        if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
            // 如果没有添加成功则保存原有的dealloc方法，用于新的dealloc方法中
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        // 标记该类已经调剂过了
        objc_setAssociatedObject(self.class, kSwizzledDealloc, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
