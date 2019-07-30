//
//  ZZStorage.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/30.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZStorage : NSObject

#pragma mark - plist文件存储和删除

/**
 *  plist存储值（anyObject）
 */
+ (void)zz_plistSave:(nonnull id)anyObject;

/**
 *  plist存储值（anyObject、Key）
 */
+ (void)zz_plistSave:(nullable id)anyObject forKey:(nonnull NSString *)key;

/**
 *  plist存储值（anyObject、Key、UserDefault）
 */
+ (void)zz_plistSave:(nullable id)anyObject forKey:(nonnull NSString *)key userDefault:(nonnull NSUserDefaults *)userDefault;

/**
 *  plist取值（anyObject）
 */
+ (nullable id)zz_plistFetch:(nonnull NSString *)key;

/**
 *  plist取值（anyObject、Key）
 */
+ (nullable id)zz_plistFetch:(nullable Class)anyObjectClass forKey:(nonnull NSString *)key;

/**
 *  plist取值（anyObject、Key、UserDefault）
 */
+ (nullable id)zz_plistFetch:(nonnull Class)anyObjectClass forKey:(nonnull NSString *)key userDefault:(nonnull NSUserDefaults *)userDefault;

/**
 *  plist是否存在key（key）
 */
+ (BOOL)zz_plistExist:(nonnull NSString *)key;

/**
 *  plist是否存在key（key）
 */
+ (BOOL)zz_plistExist:(nonnull NSString *)key userDefault:(nonnull NSUserDefaults *)userDefault;

#pragma mark - Sandbox文件存储和删除

/**
 * 获取沙盒Document的文件目录。[Sandbox/Documents]
 * 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据。
 */
+ (nonnull NSString *)zz_documentDirectory;

/**
 *  获取沙盒Library的文件目录。[Sandbox/Library]
 */
+ (nonnull NSString *)zz_libraryDirectory;

/**
 * 获取沙盒Caches的文件目录。[Sandbox/Library/Preferences]
 * iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据。
 */
+ (nonnull NSString *)zz_cachesDirectory;

/**
 * 获取沙盒Preference的文件目录。[Sandbox/Library/Caches]
 * iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息。
 */
+ (nonnull NSString *)zz_preferencePanesDirectory;

/**
 * NSTemporaryDirectory。[Bundle/tmp]
 * iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除。
 */
+ (nonnull NSString *)zz_temporaryDirectory;

/**
 *  获取文件的路径
 */
+ (nonnull NSString *)zz_sandboxPath:(nonnull NSString *)directory name:(nonnull NSString *)name;

/**
 *  判断文件或目录是否存在
 */
+ (BOOL)zz_sandboxExistPath:(nonnull NSString *)path;

/**
 *  判断文件是否存在
 */
+ (BOOL)zz_sandboxExistFile:(nonnull NSString *)path;

/**
 *  判断目录是否存在
 */
+ (BOOL)zz_sandboxExistDirectory:(nonnull NSString *)path;

/**
 *  存储NSData对象到Sandbox Document（默认Document目录）
 */
+ (void)zz_sandboxSaveData:(nonnull NSData *)data name:(nonnull NSString *)name;

/**
 *  Sandbox Document获取NSData对象（默认Document目录）
 */
+ (nullable id)zz_sandboxFetchData:(nonnull NSString *)name;

/**
 *  存储NSData对象到Sandbox
 */
+ (void)zz_sandboxSaveData:(nonnull NSData *)data name:(nonnull NSString *)name directory:(nonnull NSString *)directory;

/**
 *  Sandbox获取NSData对象
 */
+ (nullable id)zz_sandboxFetchData:(nonnull NSString *)name directory:(nonnull NSString *)directory;

/**
 *  Sandbox中删除文件（默认Document目录）
 */
+ (void)zz_sandboxRemove:(nonnull NSString *)name;

/**
 *  Sandbox中删除文件
 */
+ (void)zz_sandboxRemove:(nonnull NSString *)name directory:(nonnull NSString *)directory;

/**
 *  Sandbox中删除文件或目录
 */
+ (void)zz_sandboxRemovePath:(nonnull NSString *)path;

/**
 *  Sandbox中文件或目录的大小
 */
+ (double)zz_sandboxSize:(nonnull NSString *)path;

@end

NS_ASSUME_NONNULL_END
