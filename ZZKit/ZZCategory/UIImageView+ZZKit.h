//
//  UIImageView+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void ____ZZKitVoid____;

@interface UIImageView (ZZKit)

/**
 * 加载图片
 * URL                        imageURL : NSString / NSURL
 * placeholderImage           占位图
 * backgroundColor 占位图的背景色
 * contentMode     占位图的填充方式
 * completion                 加载完图片的回调Block
 */
- (____ZZKitVoid____)zz_load:(nonnull id)URL
            placeholderImage:(nullable UIImage *)placeholderImage
             backgroundColor:(nullable UIColor *)backgroundColor
                 contentMode:(UIViewContentMode)contentMode
                  completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion;

/**
 * 加载图片
 * URL                        imageURL : NSString / NSURL
 * placeholderImage           占位图
 * placeholderBackgroundColor 占位图的背景色
 * placeholderContentMode     占位图的填充方式
 * finishedBackgroundColor    加载完图片的背景色
 * finishedContentMode        显示图片的填充方式
 * fadeIn                     是否淡入显示
 * completion                 加载完图片的回调Block
 */
- (____ZZKitVoid____)zz_load:(nonnull id)URL
            placeholderImage:(nullable UIImage *)placeholderImage
  placeholderBackgroundColor:(nullable UIColor *)placeholderBackgroundColor
     finishedBackgroundColor:(nullable UIColor *)finishedBackgroundColor
      placeholderContentMode:(UIViewContentMode)placeholderContentMode
         finishedContentMode:(UIViewContentMode)finishedContentMode
                      fadeIn:(BOOL)fadeIn
                  completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion;

@end

NS_ASSUME_NONNULL_END
