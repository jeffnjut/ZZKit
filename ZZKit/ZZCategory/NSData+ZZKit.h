//
//  NSData+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ZZKit)

/**
 *  NSData转NSString
 */
- (NSString *)zz_string;

/**
 *  NSData取得第一帧图片
 */
- (UIImage *)zz_imageFirstGifFrame;

/**
 *  NSData转成PNG或JPEG格式的base64码
 */
- (NSString *)zz_stringBase64;

@end

NS_ASSUME_NONNULL_END
