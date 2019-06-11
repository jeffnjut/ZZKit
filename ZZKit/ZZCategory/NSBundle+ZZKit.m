//
//  NSBundle+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSBundle+ZZKit.h"
#import <pthread.h>
#import <objc/runtime.h>

#pragma mark - _ZZImageBundle

@interface _ZZImageBundle : NSObject

@property (nonatomic, assign) pthread_mutex_t lock;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSMutableArray *keysArray;
@property (nonatomic, strong) NSMutableArray *valuesArray;

- (nullable UIImage *)objectForKey:(nonnull NSString *)key;

- (void)addObject:(nonnull UIImage *)value forKey:(nonnull NSString *)key;

- (void)removeObjectForKey:(nonnull NSString *)key;

@end

@implementation _ZZImageBundle

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        self.maxCount = 50;
        self.keysArray = [[NSMutableArray alloc] init];
        self.valuesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (nullable UIImage *)objectForKey:(nonnull NSString *)key {
    
    __block UIImage *object = nil;
    pthread_mutex_lock(&_lock);
    __weak typeof(self) weakSelf = self;
    [self.keysArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:key]) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            object = [strongSelf.valuesArray objectAtIndex:idx];
            *stop = YES;
        }
    }];
    pthread_mutex_unlock(&_lock);
    return object;
}

- (void)addObject:(nonnull UIImage *)value forKey:(nonnull NSString *)key {
    
    if (value == nil || key == nil) {
        return;
    }
    
    if (self.keysArray.count != self.valuesArray.count) {
        return;
    }
    
    pthread_mutex_lock(&_lock);
    
    if (self.keysArray.count > 0 && [self.keysArray count] >= self.maxCount) {
        // 删除时间最久的对象
        [self.keysArray removeObjectAtIndex:0];
        [self.valuesArray removeObjectAtIndex:0];
    }
    [self.keysArray addObject:key];
    [self.valuesArray addObject:value];
    pthread_mutex_unlock(&_lock);
}

- (void)removeObjectForKey:(nonnull NSString *)key {
    
    if (key == nil) {
        return;
    }
    
    if ((self.keysArray.count != self.valuesArray.count) || self.keysArray.count == 0) {
        return;
    }
    
    pthread_mutex_lock(&_lock);
    __block NSUInteger index = NSUIntegerMax;
    [self.keysArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:key]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index != NSUIntegerMax) {
        [self.keysArray removeObjectAtIndex:index];
        [self.valuesArray removeObjectAtIndex:index];
    }
    pthread_mutex_unlock(&_lock);
}

@end

@implementation NSBundle (ZZKit)

#pragma mark - 获取Bundle对象

/**
 *  获取Resource Bundle对象（类方法）
 *  bundleName可以为空，当空时返回的是Class Package Bundle，
 *  否则返回Class Package Bundle中的名称为$bundleName.bundle的Bundle
 */
+ (NSBundle *)zz_resourceClass:(nonnull Class)cls bundleName:(nullable NSString *)bundleName {
    
    if (cls == nil) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleForClass:cls];
    // 适配CocoaPods
    if (bundle && bundleName.length > 0) {
        NSString *bundlePath = [bundle pathForResource:bundleName ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bundle;
}

#pragma mark - 从Bundle中获取UIImage图片对象

/**
 *  获取Resource Bundle的图片（类方法）
 */
+ (UIImage *)zz_image:(nonnull NSString *)imageName extension:(nullable NSString *)extension class:(nonnull Class)cls bunldeName:(nullable NSString *)bundleName {
    
    return [NSBundle zz_image:imageName extension:extension class:cls bunldeName:bundleName memCache:NO];
}

/**
 *  获取Resource Bundle的图片，Memory Cache（类方法）
 */
+ (UIImage *)zz_image:(nonnull NSString *)imageName extension:(nullable NSString *)extension class:(nonnull Class)cls bunldeName:(nullable NSString *)bundleName memCache:(BOOL)memCache {
    
    // 从Bundle中加载
    NSBundle *bundle = [self zz_resourceClass:cls bundleName:bundleName];
    UIImage *image = [bundle zz_image:imageName extension:extension memCache:memCache];
    if (image) {
        return image;
    }
    // 防止误用zz_image或者使用封装zz_image后的API
    return [UIImage imageNamed:imageName];
}

/**
 *  获取Resource Bundle的图片（实例方法）
 */
- (UIImage *)zz_image:(nonnull NSString *)imageName extension:(nullable NSString *)extension {
    
    return [self zz_image:imageName extension:extension memCache:NO];
}

/**
 *  获取Resource Bundle的图片，Memory Cache（实例方法）
 */
- (UIImage *)zz_image:(nonnull NSString *)imageName extension:(nullable NSString *)extension memCache:(BOOL)memCache {
    
    NSString *key = [NSString stringWithFormat:@"%@/%@", self.bundlePath, imageName];
    UIImage *image = [self.imageBundle objectForKey:imageName];
    if (image == nil) {
        NSBundle *bundle = self;
        int scale  = (int)[UIScreen mainScreen].scale;
        NSArray *scales = nil;
        if (scale == 3) {
            scales = @[@(3), @(2), @(1)];
        }else if (scale == 2) {
            scales = @[@(2), @(3), @(1)];
        }else {
            scales = @[@(1), @(2), @(3)];
        }
        for (NSNumber *number in scales) {
            if (extension.length > 0) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@%@x", imageName, number] ofType:extension]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }else {
                for (NSString *ext in @[EXTENSION_PNG, EXTENSION_JPG, EXTENSION_JPEG]) {
                    image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@%@x", imageName, number] ofType:ext]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    if (image) {
                        break;
                    }
                }
            }
            if(image == nil) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@%@x", imageName, number] ofType:nil]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            if (image) {
                break;
            }
        }
        if (image == nil) {
            for (NSString *ext in @[EXTENSION_PNG, EXTENSION_JPG, EXTENSION_JPEG]) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:ext]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                if (image) {
                    break;
                }
            }
            if(image == nil) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:extension]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }
        if (image != nil && memCache) {
            [self.imageBundle addObject:image forKey:key];
        }
    }
    if (!memCache) {
        [self.imageBundle removeObjectForKey:key];
    }
    return image;
}

#pragma mark - Private

- (_ZZImageBundle*)imageBundle {
    
    _ZZImageBundle *_imageBundle = objc_getAssociatedObject(self, "_ZZImageBundle");
    if (!_imageBundle) {
        _imageBundle = [[_ZZImageBundle alloc] init];
        objc_setAssociatedObject(self, "_ZZImageBundle", _imageBundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _imageBundle;
}

@end
