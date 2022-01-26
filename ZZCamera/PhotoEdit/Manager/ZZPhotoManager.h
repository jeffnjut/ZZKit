//
//  ZZPhotoManager.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZPhotoTuning.h"
#import "ZZPhotoTag.h"
#import "ZZDraft.h"
#import "ZZPhotoAsset.h"
#import "ZZPhotoLibraryConfig.h"
#import "NSArray+FetchImage.h"

@interface ZZPhotoManager : NSObject

// 当前相册配置参数
@property (nonatomic, strong, readonly, nullable) ZZPhotoLibraryConfig *config;

// 相片队列
@property (nullable, nonatomic, strong, readonly) NSMutableArray<ZZPhotoAsset *> *photoQueue;

// 当前正在编辑对象
@property (nullable, nonatomic, strong) ZZPhotoAsset *currentPhoto;

+ (nonnull ZZPhotoManager *)shared;

#pragma mark - Photo

/**
 * 根据PHAsset查找，从队列获取ZZPhotoAsset，若不存在则返回PHAsset生成ZZPhotoAsset的对象
 */
- (nonnull ZZPhotoAsset *)fetchPhoto:(nonnull PHAsset *)asset;

/**
 * 根据PHAsset生成ZZPhotoAsset，并新增到队列
 */
- (nonnull ZZPhotoAsset *)addPhoto:(nonnull PHAsset *)asset;

/**
 * 根据PHAsset或者ZZPhotoAsset查找是否存在，不存在则新增到队列
 */
- (nullable ZZPhotoAsset *)addPhotoDistinct:(nonnull id)object;

/**
 * 根据PHAsset删除队列中相应的ZZPhotoAsset
 */
- (void)removePhoto:(nonnull PHAsset *)asset;

/**
 * 根据index删除队列中相应的ZZPhotoAsset
 */
- (void)removePhotoAtIndex:(NSUInteger)index;

/**
 * 交换ZZPhotoAsset对象
 */
- (void)exchangePhotoObjectAtIndex:(NSUInteger)one withObjectAtIndex:(NSUInteger)another;

/**
 * 将index的ZZPhotoAsset对象置顶
 */
- (void)sendPhotoObjectToTop:(NSUInteger)index;

/**
 * 清空队列
 */
- (void)cleanPhotos;

#pragma mark - Draft

// 判断存在（用于退出保存）
- (BOOL)isDraftExist:(nonnull NSString *)uid;

// 保存（用于退出保存）
- (nullable NSString *)saveDraftCache:(BOOL)overwrite extraType:(int)extraType extras:(nullable NSDictionary *)extras identifier:(nullable NSString *)identifier uid:(nonnull NSString *)uid;

// 加载（用于退出保存）
- (nullable ZZDraftList *)loadDraftCache:(nullable NSString *)uid;

// 加载到allPhoto（用于退出保存）
- (void)loadDraftPhotosToAllPhotos:(nonnull ZZDraft *)draft completion:(nullable void(^)(void))completion;

// 删除（用于退出保存）
- (void)cleanDraftCache:(nullable NSString *)uid;

// 删除某个Draft（用于退出保存）
- (void)removeDraft:(nonnull ZZDraft *)draft;

// 删除某个Draft（用于退出保存）
- (void)removeDraftByIdentifier:(nonnull NSString *)identifier;

// 根据Asset Identifier查找PHAsset
- (nullable PHAsset *)findByIdentifier:(nonnull NSString *)assetIdentifier;

// 根据PhotoUrl查找NSData、UIImage
- (void)findByPhotoUrl:(nonnull NSString *)photoUrl completion:(nullable void(^)(NSData * _Nullable imageData, UIImage * _Nullable image, NSString * _Nullable url))completion;

// 更新UID信息
- (void)update:(nullable NSString *)identifier uid:(nullable NSString *)uid;

// 打开相册
+ (void)presentPhotoLibraryController:(nonnull UIViewController *)controller configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock;

// 打开相册(keepPrevious)
+ (void)presentPhotoLibraryController:(nonnull UIViewController *)controller keepPrevious:(BOOL)keepPreviois configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock;

// 打开编辑
+ (void)presentPhotoEditController:(nonnull UIViewController *)controller configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock;

// 打开编辑(keepPrevious)
+ (void)presentPhotoEditController:(nonnull UIViewController *)controller keepPrevious:(BOOL)keepPreviois configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock;

// 打开草稿箱
+ (void)presentDraftController:(nonnull UIViewController *)controller uid:(nonnull NSString *)uid configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock;

// 加载图片
- (void)loadNetworkPhotosToAllPhotos:(NSArray<NSString *> *)imageUrls completion:(nullable void(^)(void))completion;

@end
