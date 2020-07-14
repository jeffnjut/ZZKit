//
//  NSBundle+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSBundle+ZZKit.h"

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
    
    // 从Bundle中加载
    NSBundle *bundle = [self zz_resourceClass:cls bundleName:bundleName];
    UIImage *image = [bundle zz_image:imageName extension:extension];
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
    
    if (imageName == nil || imageName.length == 0) {
        return nil;
    }
    UIImage *image = nil;
    if (@available(iOS 13.0, *)) {
        image = [UIImage imageNamed:imageName inBundle:NSBundle.mainBundle withConfiguration:nil];
        if (image) {
            return image;
        }
    }
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
        if(image == nil) {
            image = [UIImage imageNamed:imageName];
        }
    }
    return image;
}

@end
