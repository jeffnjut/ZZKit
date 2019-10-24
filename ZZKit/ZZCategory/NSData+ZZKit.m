//
//  NSData+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSData+ZZKit.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+ZZKit.h"

@implementation NSData (ZZKit)

/**
 *  NSData转NSString
 */
- (nullable NSString *)zz_string {
    
    if ([self isKindOfClass:[NSData class]]) {
        const unsigned *bytes = [(NSData *)self bytes];
        return [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x", ntohl(bytes[0]), ntohl(bytes[1]), ntohl(bytes[2]), ntohl(bytes[3]), ntohl(bytes[4]), ntohl(bytes[5]), ntohl(bytes[6]), ntohl(bytes[7])];
    } else {
        return [[[[self description] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}

/**
 *  NSData转成UIImage
 */
- (nullable UIImage *)zz_image {
    
    return [UIImage imageWithData:self];
}

/**
 *  NSData取得第一帧图片
 */
- (nullable UIImage *)zz_imageFirstGifFrame {
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self, NULL);
    size_t count = CGImageSourceGetCount(source);
    if (count > 0) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CFRelease(source);
        return image;
    }
    CFRelease(source);
    return nil;
}

/**
 *  NSData转成PNG或JPEG格式的base64码
 */
- (nullable NSString *)zz_stringBase64 {
    
    NSString *base64 = [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

/**
 *  NSData转md5
 */
- (nullable NSString *)zz_md5 {
    
    /*
    //1: 创建一个MD5对象
    CC_MD5_CTX md5;
    //2: 初始化MD5
    CC_MD5_Init(&md5);
    //3: 准备MD5加密
    CC_MD5_Update(&md5, self.bytes, (CC_LONG)self.length);
    //4: 准备一个字符串数组, 存储MD5加密之后的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //5: 结束MD5加密
    CC_MD5_Final(result, &md5);
    NSMutableString *resultString = [NSMutableString string];
    //6:从result数组中获取最终结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", result[i]];
    }
    return resultString;
    */
    
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

@end
