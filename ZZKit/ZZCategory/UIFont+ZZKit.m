//
//  UIFont+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIFont+ZZKit.h"
#import <CoreText/CoreText.h>

@implementation UIFont (ZZKit)

/**
 *  存放在Document文件夹里以name名称加载字体
 */
+ (UIFont *)zz_fontFromDocumentFileName:(NSString *)name fontSize:(CGFloat)fontSize {
    
    if ([[self class] _isExistFile:[[self class] _getDocumentFilePath:name]]) {
        return [UIFont zz_fontTTFandOTFFromDocumentPath:[[self class] _getDocumentFilePath:name] fontSize:fontSize];
    }
    return nil;
}

/**
 *  下载url的字体文件，以name名称存放在Document文件夹
 */
+ (void)zz_fontDownloadToDocument:(NSString *)url name:(NSString *)name completion:(void(^)(BOOL success, NSString *filePath))completion {
    
    if ([url length] == 0 || [name length] == 0) {
        completion(NO, nil);
        return;
    }
    if ([[self class] _isExistFile:[[self class] _getDocumentFilePath:name]]) {
        completion(YES, [[self class] _getDocumentFilePath:name]);
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && [data length] > 0) {
            // 下载成功
            [[self class] _writeDocumentData:data name:name];
            completion == nil ? : completion(YES, [[self class] _getDocumentFilePath:name]);
        }else{
            // 下载失败
            completion == nil ? : completion(NO, nil);
        }
    }];
    [task resume];
}

/**
 *  加载path的TTF、OTF文件，输出size大小的字体
 */
+ (UIFont *)zz_fontTTFandOTFFromDocumentPath:(NSString *)path fontSize:(CGFloat)fontSize {
    
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGFontRelease(fontRef);
    return font;
}

/**
 *  加载path的TTC文件，输出size大小的字体集
 */
+ (NSArray *)zz_fontTTCArrayFromDocumentPath:(NSString *)path fontSize:(CGFloat)fontSize {
    
    CFStringRef fontPath = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
    CFURLRef fontUrl = CFURLCreateWithFileSystemPath(NULL, fontPath, kCFURLPOSIXPathStyle, 0);
    CFArrayRef fontArray = CTFontManagerCreateFontDescriptorsFromURL(fontUrl);
    CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeNone, NULL);
    NSMutableArray *customFontArray = [NSMutableArray array];
    for (CFIndex i = 0 ; i < CFArrayGetCount(fontArray); i++) {
        CTFontDescriptorRef  descriptor = CFArrayGetValueAtIndex(fontArray, i);
        CTFontRef fontRef = CTFontCreateWithFontDescriptor(descriptor, fontSize, NULL);
        NSString *fontName = CFBridgingRelease(CTFontCopyName(fontRef, kCTFontPostScriptNameKey));
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        [customFontArray addObject:font];
        CFRelease(fontRef);
    }
    CFRelease(fontPath);
    CFRelease(fontUrl);
    CFRelease(fontArray);
    return customFontArray;
}

#pragma mark - Private

+ (BOOL)_isExistFile:(NSString *)filePath {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSString *)_getDocumentFilePath:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    return fileName;
}

+ (void)_writeDocumentData:(NSData *)data name:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    [data writeToFile:fileName atomically:YES];
}

@end
