//
//  NSBundle+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EXTENSION_PNG  @"png"
#define EXTENSION_JPG  @"jpg"
#define EXTENSION_JPEG @"jpeg"

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ZZKit)

#pragma mark - 获取Bundle对象

/**
 *  获取Resource Bundle对象（类方法）
 *  bundleName可以为空，当空时返回的是Class Package Bundle，
 *  否则返回Class Package Bundle中的名称为$bundleName.bundle的Bundle
 */
+ (NSBundle *)zz_resourceClass:(nonnull Class)cls bundleName:(nullable NSString *)bundleName;

#pragma mark - 从Bundle中获取UIImage图片对象

/**
 *  获取Resource Bundle的图片（类方法）
 */
+ (UIImage *)zz_image:(nonnull NSString *)imageName extension:(nullable NSString *)extension class:(nonnull Class)cls bunldeName:(nullable NSString *)bundleName;

/**
 *  获取Resource Bundle的图片（实例方法）
 */
- (UIImage *)zz_image:(nonnull NSString *)imageName extension:(nullable NSString *)extension;

@end

NS_ASSUME_NONNULL_END
