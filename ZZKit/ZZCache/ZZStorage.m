//
//  ZZStorage.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/30.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZStorage.h"
#import <YYModel/YYModel.h>
#import "NSArray+ZZKit.h"
#import "NSDictionary+ZZKit.h"
#import "NSString+ZZKit.h"

@implementation ZZStorage

#pragma mark - plist文件存储和删除

/**
 *  plist存储值（anyObject）
 */
+ (void)zz_plistSave:(nonnull id)anyObject {
    
    [self zz_plistSave:anyObject forKey:NSStringFromClass([anyObject class])];
}

/**
 *  plist存储值（anyObject、Key）
 */
+ (void)zz_plistSave:(nullable id)anyObject forKey:(nonnull NSString *)key {
    
    [self zz_plistSave:anyObject forKey:key userDefault:[NSUserDefaults standardUserDefaults]];
}

/**
 *  plist存储值（anyObject、Key、UserDefault）
 */
+ (void)zz_plistSave:(nullable id)anyObject forKey:(nonnull NSString *)key userDefault:(nonnull NSUserDefaults *)userDefault {
    
    if (key == nil || userDefault == nil) {
        return;
    }
    
    if (anyObject == nil) {
        [userDefault removeObjectForKey:key];
    }else {
        if ([anyObject isKindOfClass:[NSString class]] || [anyObject isKindOfClass:[NSNumber class]]) {
            [userDefault setObject:anyObject forKey:key];
        }else if ([anyObject isKindOfClass:[NSArray class]]) {
            [userDefault setObject:[(NSArray *)anyObject zz_toJSONString] forKey:key];
        }else if ([anyObject isKindOfClass:[NSDictionary class]]) {
            [userDefault setObject:[(NSDictionary *)anyObject zz_toJSONString] forKey:key];
        }else {
            [userDefault setObject:[anyObject yy_modelToJSONString] forKey:key];
        }
    }
}

/**
 *  plist取值（anyObject）
 */
+ (nullable id)zz_plistFetch:(nonnull NSString *)key {
    
    return [self zz_plistFetch:nil forKey:key];
}

/**
 *  plist取值（anyObject、Key）
 */
+ (nullable id)zz_plistFetch:(nullable Class)anyObjectClass forKey:(nonnull NSString *)key {
    
    return [self zz_plistFetch:anyObjectClass forKey:key userDefault:[NSUserDefaults standardUserDefaults]];
}

/**
 *  plist取值（anyObject、Key、UserDefault）
 */
+ (nullable id)zz_plistFetch:(nonnull Class)anyObjectClass forKey:(nonnull NSString *)key userDefault:(nonnull NSUserDefaults *)userDefault {
    
    if (key == nil || userDefault == nil) {
        return nil;
    }
    
    if (anyObjectClass == [NSString class] || anyObjectClass == [NSNumber class] || anyObjectClass == nil) {
        return [userDefault valueForKey:key];
    }
    
    NSString *_json = [userDefault valueForKey:key];
    if (anyObjectClass == [NSArray class] || anyObjectClass == [NSMutableArray class]) {
        return [_json zz_jsonToCocoaObject];
    }else if (anyObjectClass == [NSDictionary class] || anyObjectClass == [NSMutableDictionary class]) {
        return [_json zz_jsonToCocoaObject];
    }else {
        return [anyObjectClass yy_modelWithJSON:_json];
    }
    return _json;
}

/**
 *  plist是否存在key（key）
 */
+ (BOOL)zz_plistExist:(nonnull NSString *)key {
    
    return [self zz_plistExist:key userDefault:[NSUserDefaults standardUserDefaults]];
}

/**
 *  plist是否存在key（key）
 */
+ (BOOL)zz_plistExist:(nonnull NSString *)key userDefault:(nonnull NSUserDefaults *)userDefault {
    
    return ([userDefault valueForKey:key] != nil);
}

#pragma mark - Sandbox文件存储和删除

/**
 * 获取沙盒Document的文件目录。[Sandbox/Documents]
 * 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据。
 */
+ (nonnull NSString *)zz_documentDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取沙盒Library的文件目录。[Sandbox/Library]
 */
+ (nonnull NSString *)zz_libraryDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * 获取沙盒Caches的文件目录。[Sandbox/Library/Preferences]
 * iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据。
 */
+ (nonnull NSString *)zz_cachesDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * 获取沙盒Preference的文件目录。[Sandbox/Library/Caches]
 * iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息。
 */
+ (nonnull NSString *)zz_preferencePanesDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * NSTemporaryDirectory。[Bundle/tmp]
 * iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除。
 */
+ (nonnull NSString *)zz_temporaryDirectory {
    
    return NSTemporaryDirectory();
}

/**
 *  获取文件的路径
 */
+ (nonnull NSString *)zz_sandboxPath:(nonnull NSString *)directory name:(nonnull NSString *)name {
    
    return [directory stringByAppendingPathComponent:name];
}

/**
 *  判断文件或目录是否存在
 */
+ (BOOL)zz_sandboxExistPath:(nonnull NSString *)path {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/**
 *  判断文件是否存在
 */
+ (BOOL)zz_sandboxExistFile:(nonnull NSString *)path {
    
    BOOL isDirectory;
    BOOL  exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return exist && !isDirectory;
}

/**
 *  判断目录是否存在
 */
+ (BOOL)zz_sandboxExistDirectory:(nonnull NSString *)path {
    
    BOOL isDirectory;
    BOOL  exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return exist && isDirectory;
}

/**
 *  存储NSData对象到Sandbox Document（默认Document目录）
 */
+ (void)zz_sandboxSaveData:(nonnull NSData *)data name:(nonnull NSString *)name {
    
    [self zz_sandboxSaveData:data name:name directory:[self zz_documentDirectory]];
}

/**
 *  Sandbox Document获取NSData对象（默认Document目录）
 */
+ (nullable id)zz_sandboxFetchData:(nonnull NSString *)name {
    
    return [self zz_sandboxFetchData:name directory:[self zz_documentDirectory]];
}

/**
 *  存储NSData对象到Sandbox
 */
+ (void)zz_sandboxSaveData:(nonnull NSData *)data name:(nonnull NSString *)name directory:(nonnull NSString *)directory {
    
    NSString *fileName = [self zz_sandboxPath:directory name:name];
    [data writeToFile:fileName atomically:YES];
}

/**
 *  Sandbox获取NSData对象
 */
+ (nullable id)zz_sandboxFetchData:(nonnull NSString *)name directory:(nonnull NSString *)directory {
    
    NSString *fileName = [self zz_sandboxPath:directory name:name];
    NSData *data = [NSData dataWithContentsOfFile:fileName options:0 error:NULL];
    return data;
}

/**
 *  Sandbox中删除文件（默认Document目录）
 */
+ (void)zz_sandboxRemove:(nonnull NSString *)name {
    
    [self zz_sandboxRemove:name directory:[self zz_documentDirectory]];
}

/**
 *  Sandbox中删除文件
 */
+ (void)zz_sandboxRemove:(nonnull NSString *)name directory:(nonnull NSString *)directory {
    
    [self zz_sandboxRemovePath:[self zz_sandboxPath:directory name:name]];
}

/**
 *  Sandbox中删除文件或目录
 */
+ (void)zz_sandboxRemovePath:(nonnull NSString *)path {
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**
 *  Sandbox中文件或目录的大小
 */
+ (double)zz_sandboxSize:(nonnull NSString *)path {
    
    // 获得文件夹管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [fileManager fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 判断是否为文件夹
    if (dir) {
        // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [fileManager subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [fileManager fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) {
                // 子路径是个文件
                NSDictionary *attrs = [fileManager attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1000 * 1000.0);
    } else {
        // 文件
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1000 * 1000.0);
    }
}

@end
