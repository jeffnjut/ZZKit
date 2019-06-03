//
//  UIFont+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZZKit)

/**
 *  存放在Document文件夹里以name名称加载字体
 */
+ (UIFont *)zz_fontFromDocumentFileName:(NSString *)name fontSize:(CGFloat)fontSize;

/**
 *  下载url的字体文件，以name名称存放在Document文件夹
 */
+ (void)zz_fontDownloadToDocument:(NSString *)url name:(NSString *)name completion:(void(^)(BOOL success, NSString *filePath))completion;

/**
 *  加载path的TTF、OTF文件，输出size大小的字体
 */
+ (UIFont *)zz_fontTTFandOTFFromDocumentPath:(NSString *)path fontSize:(CGFloat)fontSize;

/**
 *  加载path的TTC文件，输出size大小的字体集
 */
+ (NSArray *)zz_fontTTCArrayFromDocumentPath:(NSString *)path fontSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
