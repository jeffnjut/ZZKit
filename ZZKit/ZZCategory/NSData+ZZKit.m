//
//  NSData+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSData+ZZKit.h"

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

@end
