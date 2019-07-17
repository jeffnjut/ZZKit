//
//  UIImageView+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ZZKit)

/**
 * 加载图片（所有网络图片格式）
 * url              url
 * placeholderImage 占位图
 * backgroundColor  加载完图片的背景色
 * contentMode      占位图或image url加载的填充方式
 * completion       完成加载的回调block
 */
- (void)zz_load:(nonnull NSString *)url placeholderImage:(nullable UIImage *)placeholderImage backgroundColor:(nullable UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion;

/**
 * 加载图片（除了Gif的网络图片格式）
 * url                       image url
 * round                     是否圆型
 * borderWidth               边框宽度
 * borderColor               边框颜色
 * placeholderImage          占位图
 * placeholderContentMode    占位图的填充方式
 * placeholderBackgroudColor 占位图的背景色
 * contentMode               显示图片的填充方式
 * backgroundColor           加载完图片的背景色
 * completion                加载完图片的回调block
 */
- (void)zz_load:(nonnull NSString *)url round:(BOOL)round borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor placeholderImage:(nullable UIImage *)placeholderImage placeholderContentMode:(UIViewContentMode)placeholderContentMode placeholderBackgroudColor:(nullable UIColor *)placeholderBackgroudColor contentMode:(UIViewContentMode)contentMode backgroundColor:(nullable UIColor *)backgroundColor completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion;

@end

NS_ASSUME_NONNULL_END
