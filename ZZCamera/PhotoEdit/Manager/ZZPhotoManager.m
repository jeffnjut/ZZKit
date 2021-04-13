//
//  ZZPhotoManager.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoManager.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "NSDate+ZZKit.h"
#import "NSString+ZZKit.h"
#import "ZZNavigationController.h"
#import "ZZPhotoDraftHistoryViewController.h"
#import "PHAsset+QuickEdit.h"
#import "ZZPhotoFilterManager.h"
#import "ZZStorage.h"
#import "ZZPhotoLibraryViewController.h"
#import "ZZPhotoEditViewController.h"

@interface ZZPhotoManager ()

// 当前相册配置参数
@property (nonatomic, strong) ZZPhotoLibraryConfig *config;

// 相片队列
@property (nonatomic, strong) NSMutableArray<ZZPhotoAsset *> *photoQueue;

@end

@implementation ZZPhotoManager

static ZZPhotoManager *SINGLETON = nil;
static bool isFirstAccess = YES;

+ (nonnull ZZPhotoManager *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle
+ (id)allocWithZone:(NSZone *)zone {
    return [self shared];
}

- (id)copy {
    return [[ZZPhotoManager alloc] init];
}

- (id)mutableCopy {
    return [[ZZPhotoManager alloc] init];
}

- (id)init {
    
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

- (NSMutableArray<ZZPhotoAsset *> *)photoQueue {
    
    if (_photoQueue == nil) {
        _photoQueue = (NSMutableArray<ZZPhotoAsset *> *)[[NSMutableArray alloc] init];
    }
    return _photoQueue;
}

#pragma mark - Photo

/**
 * 根据PHAsset查找，从队列获取ZZPhotoAsset，若不存在则返回PHAsset生成ZZPhotoAsset的对象
 */
- (nonnull ZZPhotoAsset *)fetchPhoto:(nonnull PHAsset *)asset {
    
    for (ZZPhotoAsset *model in self.photoQueue) {
        if ([model.asset isEqual:asset]) {
            return model;
        }
    }
    return [[ZZPhotoAsset alloc] initWithAsset:asset];
}

/**
 * 根据PHAsset生成ZZPhotoAsset，并新增到队列
 */
- (nonnull ZZPhotoAsset *)addPhoto:(nonnull PHAsset *)asset {
    
    ZZPhotoAsset *model = [[ZZPhotoAsset alloc] initWithAsset:asset];
    [self.photoQueue addObject:model];
    return model;
}

/**
 * 根据PHAsset或者ZZPhotoAsset查找是否存在，不存在则新增到队列
 */
- (nullable ZZPhotoAsset *)addPhotoDistinct:(nonnull id)object {
    
    if (object != nil) {
        if ([object isKindOfClass:[PHAsset class]]) {
            
            PHAsset *asset = object;
            for (ZZPhotoAsset *model in self.photoQueue) {
                if ([model.asset isEqual:asset]) {
                    return model;
                }
            }
            ZZPhotoAsset *model = [[ZZPhotoAsset alloc] initWithAsset:asset];
            [self.photoQueue addObject:model];
            return model;
        }else if ([object isKindOfClass:[ZZPhotoAsset class]]) {
            
            ZZPhotoAsset *photoModel = object;
            for (int i = 0; i < self.photoQueue.count; i++) {
                ZZPhotoAsset *model = [self.photoQueue objectAtIndex:i];
                if ([model.asset isEqual:photoModel.asset] && [model.sessionId isEqualToString:photoModel.sessionId]) {
                    [self.photoQueue zz_arrayReplaceObjectAtIndex:i withObject:photoModel];
                    return photoModel;
                }
            }
            [self.photoQueue addObject:photoModel];
            return photoModel;
        }
    }
    return nil;
}

/**
 * 根据PHAsset删除队列中相应的ZZPhotoAsset
 */
- (void)removePhoto:(nonnull PHAsset *)asset {
    
    if (asset != nil) {
        for (int i = (int)self.photoQueue.count - 1; i >= 0; i-- ) {
            ZZPhotoAsset *model = [self.photoQueue objectAtIndex:i];
            if ([model.asset isEqual:asset]) {
                [self.photoQueue removeObjectAtIndex:i];
                break;
            }
        }
    }
}

/**
 * 根据index删除队列中相应的ZZPhotoAsset
 */
- (void)removePhotoAtIndex:(NSUInteger)index {
    
    [self.photoQueue removeObjectAtIndex:index];
}

/**
 * 交换ZZPhotoAsset对象
 */
- (void)exchangePhotoObjectAtIndex:(NSUInteger)one withObjectAtIndex:(NSUInteger)another {
    
    [self.photoQueue exchangeObjectAtIndex:one withObjectAtIndex:another];
}

/**
 * 将index的ZZPhotoAsset对象置顶
 */
- (void)sendPhotoObjectToTop:(NSUInteger)index {
    
    if (index == 0) {
        return;
    }
    [self.photoQueue insertObject:[self.photoQueue objectAtIndex:index] atIndex:0];
    [self.photoQueue removeObjectAtIndex:(index+1)];
}

/**
 * 清空队列
 */
- (void)cleanPhotos {
    
    [self.photoQueue removeAllObjects];
}

#pragma mark - Draft

// 判断存在（用于退出保存）
- (BOOL)isDraftExist:(nonnull NSString *)uid {
    
    ZZDraftList *objectListModel = [ZZStorage zz_plistFetch:[ZZDraftList class] forKey:@"ZZDraftList"];
    if (objectListModel != nil && objectListModel.drafts != nil && objectListModel.drafts.count > 0 && uid.length > 0) {
        for (ZZDraft *model in objectListModel.drafts) {
            if ([model.uid isEqualToString:uid]) {
                return YES;
            }
        }
    }
    return NO;
}

// 保存（用于退出保存）
- (nullable NSString *)saveDraftCache:(BOOL)overwrite extraType:(int)extraType extras:(nullable NSDictionary *)extras identifier:(nullable NSString *)identifier uid:(nonnull NSString *)uid {
    
    long long now = (long long)[NSDate zz_dateTimeStampSince1970];
    // 判断是否是已经存在已保存的draft中
    // 如果存在，先删除老的draft，再保存新的draft
    ZZDraftList *objectListModel = [ZZStorage zz_plistFetch:[ZZDraftList class] forKey:@"ZZDraftList"];
    if (objectListModel.drafts.count > 0) {
        for (int i = (int)objectListModel.drafts.count - 1; i >= 0; i--) {
            ZZDraft *draft = [objectListModel.drafts zz_arrayObjectAtIndex:i];
            if (identifier.length > 0 && [draft.identifier isEqualToString:identifier]) {
                if (overwrite) {
                    // 覆盖
                    [objectListModel.drafts removeObjectAtIndex:i];
                }else {
                    break;
                }
            }
        }
    }
    
    if (objectListModel == nil) {
        objectListModel = [[ZZDraftList alloc] init];
    }
    
    ZZDraft *objectModel = [[ZZDraft alloc] init];
    objectModel.extraType = extraType;
    objectModel.extra0 = [extras objectForKey:@"extra0"];
    objectModel.extra1 = [extras objectForKey:@"extra1"];
    objectModel.extra2 = [extras objectForKey:@"extra2"];
    objectModel.extra3 = [extras objectForKey:@"extra3"];
    objectModel.extra4 = [extras objectForKey:@"extra4"];
    objectModel.extra5 = [extras objectForKey:@"extra5"];
    for (ZZPhotoAsset *model in self.photoQueue) {
        ZZDraftPhoto *postPhotoModel = [[ZZDraftPhoto alloc] init];
        postPhotoModel.sessionId = model.sessionId;
        postPhotoModel.assetIdentifier = [model.asset localIdentifier];
        postPhotoModel.photoUrl = model.photoUrl;
        postPhotoModel.tuningObject = model.tuningObject;
        postPhotoModel.imageTags = model.imageTags;
        postPhotoModel.compressed = model.compressed;
        postPhotoModel.beginCropPointX = model.beginCropPoint.x;
        postPhotoModel.beginCropPointY = model.beginCropPoint.y;
        postPhotoModel.endCropPointX = model.endCropPoint.x;
        postPhotoModel.endCropPointY = model.endCropPoint.y;
        [objectModel.photos addObject:postPhotoModel];
    }
    if (identifier.length > 0) {
        objectModel.identifier = identifier;
    }else {
        objectModel.identifier = [NSString stringWithFormat:@"%@%lld", @"LOCAL#", now];
    }
    objectModel.uid = uid;
    objectModel.updateTimeStamp = now;
    [objectListModel.drafts addObject:objectModel];
    [ZZStorage zz_plistSave:objectListModel];
    return objectModel.identifier;
}

// 加载（用于退出保存）
- (nullable ZZDraftList *)loadDraftCache:(nullable NSString *)uid {
    
    ZZDraftList *objectListModel = [ZZStorage zz_plistFetch:[ZZDraftList class] forKey:@"ZZDraftList"];
    if (uid != nil) {
        for (int i = (int)objectListModel.drafts.count - 1; i >= 0; i--) {
            ZZDraft *draft = [objectListModel.drafts zz_arrayObjectAtIndex:i];
            if (![draft.uid isEqualToString:uid]) {
                [objectListModel.drafts zz_arrayRemoveObjectAtIndex:i];
            }
        }
    }
    return objectListModel;
}

// 加载到allPhoto（用于退出保存）
- (void)loadDraftPhotosToAllPhotos:(nonnull ZZDraft *)draft completion:(nullable void(^)(void))completion {
    
    ZZ_WEAK_SELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf cleanPhotos];
        if (draft.photos.count > 0) {
            for (int i = 0; i < draft.photos.count; i++) {
                ZZDraftPhoto *savingPhotoModel = [draft.photos zz_arrayObjectAtIndex:i];
                // 查找相册并赋值PHAsset（本地）
                if (savingPhotoModel.assetIdentifier.length > 0) {
                    PHAsset *findedAsset = [weakSelf findByIdentifier:savingPhotoModel.assetIdentifier];
                    UIImage *originalImage = [findedAsset getGeneralTargetImage];
                    [weakSelf _addToAllPhotos:draft assetIdentifier:savingPhotoModel.assetIdentifier photoUrl:savingPhotoModel.photoUrl image:originalImage asset:findedAsset completion:completion];
                }
                // 查找SD库(网络图片,异步加载)
                else if (savingPhotoModel.photoUrl.length > 0) {
                    [weakSelf findByPhotoUrl:savingPhotoModel.photoUrl completion:^(NSData *imageData, UIImage *image, NSString *url) {
                        if (image != nil) {
                            // 成功
                            [weakSelf _addToAllPhotos:draft assetIdentifier:nil photoUrl:url image:image asset:nil completion:completion];
                        }else {
                            // 失败
                            [weakSelf _addToAllPhotos:draft assetIdentifier:nil photoUrl:url image:nil asset:nil completion:completion];
                        }
                    }];
                }
                // 失败
                else {
                    [weakSelf _addToAllPhotos:draft assetIdentifier:nil photoUrl:nil image:nil asset:nil completion:completion];
                }
            }
        }else {
            [weakSelf cleanPhotos];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion == nil ? : completion();
            });
        }
    });
}

- (void)_addToAllPhotos:(nullable ZZDraft *)draft assetIdentifier:(nullable NSString *)assetIdentifier photoUrl:(nullable NSString *)photoUrl image:(nullable UIImage *)image asset:(nullable PHAsset *)asset completion:(nullable void(^)(void))completion {
    
    ZZDraftPhoto *savingPhotoModel = nil;
    for (int i = 0; i < draft.photos.count; i++) {
        ZZDraftPhoto *findPhotoModel = [draft.photos zz_arrayObjectAtIndex:i];
        if (assetIdentifier.length > 0) {
            if ([findPhotoModel.assetIdentifier isEqualToString:assetIdentifier]) {
                savingPhotoModel = findPhotoModel;
                break;
            }
        }else if (photoUrl.length > 0) {
            if ([findPhotoModel.photoUrl isEqualToString:photoUrl]) {
                savingPhotoModel = findPhotoModel;
                break;
            }
        }
    }
    
    ZZPhotoAsset *photoModel = [[ZZPhotoAsset alloc] init];
    BOOL loadImageFailed = NO;
    if (savingPhotoModel && assetIdentifier) {
        if (asset == nil && image == nil) {
            // 加载照片失败
            loadImageFailed = YES;
        }else if (image == nil) {
            // 加载asset（不需要加载，外部传入）
        }
    }else if (savingPhotoModel && photoUrl) {
        if (image == nil) {
            // 加载照片失败
            loadImageFailed = YES;
        }
    }else {
        // 加载照片失败
        loadImageFailed = YES;
    }
    
    // 赋值照片属性
    photoModel.sessionId = savingPhotoModel.sessionId;
    photoModel.asset = asset;
    photoModel.photoUrl = savingPhotoModel.photoUrl;
    photoModel.tuningObject = savingPhotoModel.tuningObject;
    photoModel.imageTags = savingPhotoModel.imageTags;
    photoModel.compressed = savingPhotoModel.compressed;
    photoModel.beginCropPoint = CGPointMake(savingPhotoModel.beginCropPointX, savingPhotoModel.beginCropPointY);
    photoModel.endCropPoint = CGPointMake(savingPhotoModel.endCropPointX, savingPhotoModel.endCropPointY);
    if (loadImageFailed) {
        photoModel.croppedImage = @"ZZPhotoManager.ic_photo_no_found".zz_image;
    }else {
        UIImage *croppedImage = [image zz_imageCropBeginPointRatio:photoModel.beginCropPoint endPointRatio:CGPointMake(savingPhotoModel.endCropPointX, savingPhotoModel.endCropPointY)];
        photoModel.croppedImage = croppedImage;
    }
    [self.photoQueue addObject:photoModel];
    
    if (self.photoQueue.count == draft.photos.count) {
        // 调整顺序
        for (int i = 0; i < draft.photos.count; i++) {
            savingPhotoModel = [draft.photos zz_arrayObjectAtIndex:i];
            ZZPhotoAsset *photoModel = [self.photoQueue zz_arrayObjectAtIndex:i];
            if (savingPhotoModel.assetIdentifier.length > 0) {
                if (![savingPhotoModel.assetIdentifier isEqualToString:[photoModel.asset localIdentifier]]) {
                    for (int j = i + 1; j < self.photoQueue.count; j++) {
                        ZZPhotoAsset *pModel = [self.photoQueue zz_arrayObjectAtIndex:j];
                        if ([savingPhotoModel.assetIdentifier isEqualToString:[pModel.asset localIdentifier]]) {
                            [self.photoQueue exchangeObjectAtIndex:j withObjectAtIndex:i];
                            break;
                        }
                    }
                }
            }else if (savingPhotoModel.photoUrl.length > 0) {
                if (![savingPhotoModel.photoUrl isEqualToString:photoModel.photoUrl]) {
                    for (int j = i + 1; j < self.photoQueue.count; j++) {
                        ZZPhotoAsset *pModel = [self.photoQueue zz_arrayObjectAtIndex:j];
                        if ([savingPhotoModel.photoUrl isEqualToString:pModel.photoUrl]) {
                            [self.photoQueue exchangeObjectAtIndex:j withObjectAtIndex:i];
                            break;
                        }
                    }
                }
            }
        }
        // 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            completion == nil ? : completion();
        });
    }
}

// 删除（用于退出保存）
- (void)cleanDraftCache:(nullable NSString *)uid {
    
    if (uid == nil) {
        [ZZStorage zz_plistSave:nil forKey:@"ZZDraftList"];
    }else {
        ZZDraftList *objectListModel = [ZZStorage zz_plistFetch:[ZZDraftList class] forKey:@"ZZDraftList"];
        for (int i = (int)objectListModel.drafts.count - 1; i >= 0; i--) {
            ZZDraft *draft = [objectListModel.drafts zz_arrayObjectAtIndex:i];
            if ([draft.uid isEqualToString:uid]) {
                [objectListModel.drafts zz_arrayRemoveObjectAtIndex:i];
            }
        }
        if (objectListModel.drafts.count == 0) {
            [ZZStorage zz_plistSave:nil forKey:@"ZZDraftList"];
        }else {
            [ZZStorage zz_plistSave:objectListModel];
        }
    }
}

// 删除某个Draft（用于退出保存）
- (void)removeDraft:(nonnull ZZDraft *)draft {
    
    [self removeDraftByIdentifier:draft.identifier];
}

// 删除某个Draft（用于退出保存）
- (void)removeDraftByIdentifier:(nonnull NSString *)identifier {
    
    ZZDraftList *draftList = [self loadDraftCache:nil];
    for (int i = (int)draftList.drafts.count - 1; i >= 0; i--) {
        ZZDraft *d = [draftList.drafts zz_arrayObjectAtIndex:i];
        if ([d.identifier isEqualToString:identifier]) {
            [draftList.drafts zz_arrayRemoveObjectAtIndex:i];
            break;
        }
    }
    if (draftList.drafts.count == 0) {
        [self cleanDraftCache:nil];
    }else {
        [ZZStorage zz_plistSave:draftList];
    }
}

// 根据Asset Identifier查找PHAsset
- (nullable PHAsset *)findByIdentifier:(nonnull NSString *)assetIdentifier {
    
    // 系统相机查找
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in collections) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumMyPhotoStream || collection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumCloudShared) {
            // 屏蔽 iCloud 照片流
        }else {
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            for (PHAsset *asset in assets) {
                if ([[asset localIdentifier] isEqualToString:assetIdentifier]) {
                    return asset;
                }
            }
        }
    }
    // 自定义相册查找
    PHFetchResult<PHAssetCollection *> *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *asset in assets) {
            if ([[asset localIdentifier] isEqualToString:assetIdentifier]) {
                return asset;
            }
        }
    }
    return nil;
}

// 根据PhotoUrl查找NSData、UIImage
- (void)findByPhotoUrl:(nonnull NSString *)photoUrl completion:(nullable void(^)(NSData * _Nullable imageData, UIImage * _Nullable image, NSString * _Nullable url))completion {
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[photoUrl zz_URL] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        completion == nil ? : completion(data, image, photoUrl);
    }];
}

// 更新UID信息
- (void)update:(nullable NSString *)identifier uid:(nullable NSString *)uid {
    
    ZZDraftList *objectListModel = [ZZStorage zz_plistFetch:[ZZDraftList class] forKey:@"ZZDraftList"];
    if (objectListModel != nil && objectListModel.drafts != nil && objectListModel.drafts.count > 0 && uid.length > 0) {
        for (ZZDraft *model in objectListModel.drafts) {
            if ([model.identifier isEqualToString:identifier]) {
                model.uid = uid;
                [ZZStorage zz_plistSave:objectListModel];
                break;
            }
        }
    }
}

// 打开相册
+ (void)presentPhotoLibraryController:(nonnull UIViewController *)controller configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock {
    
    [ZZPhotoManager presentPhotoLibraryController:controller keepPrevious:NO configureBlock:configureBlock];
}

// 打开相册(keepPrevious)
+ (void)presentPhotoLibraryController:(nonnull UIViewController *)controller keepPrevious:(BOOL)keepPreviois configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock {
    
    if (ZZPhotoManager.shared.photoQueue == nil) {
        ZZPhotoManager.shared.photoQueue = (NSMutableArray<ZZPhotoAsset *> *)[NSMutableArray new];
    }
    if (keepPreviois) {
        if (ZZPhotoManager.shared.config == nil) {
            ZZPhotoManager.shared.config = [[ZZPhotoLibraryConfig alloc] init];
        }
    }else {
        ZZPhotoManager.shared.config = nil;
        ZZPhotoManager.shared.config = [[ZZPhotoLibraryConfig alloc] init];
        [ZZPhotoManager.shared cleanPhotos];
    }
    configureBlock == nil ? : configureBlock(ZZPhotoManager.shared.config);
    ZZPhotoLibraryViewController *photoLibraryViewController = [[ZZPhotoLibraryViewController alloc] initWithSessionId:[NSString zz_uuidRandomTimestamp]];
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:photoLibraryViewController];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [controller presentViewController:nav animated:YES completion:nil];
}

// 打开编辑
+ (void)presentPhotoEditController:(nonnull UIViewController *)controller configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock {
    
    [ZZPhotoManager presentPhotoEditController:controller keepPrevious:YES configureBlock:configureBlock];
}

// 打开编辑(keepPrevious)
+ (void)presentPhotoEditController:(nonnull UIViewController *)controller keepPrevious:(BOOL)keepPreviois configureBlock:(nullable void(^)(ZZPhotoLibraryConfig * _Nullable config))configureBlock {
    
    if (ZZPhotoManager.shared.photoQueue == nil) {
        ZZPhotoManager.shared.photoQueue = (NSMutableArray<ZZPhotoAsset *> *)[NSMutableArray new];
    }
    if (keepPreviois) {
        if (ZZPhotoManager.shared.config == nil) {
            ZZPhotoManager.shared.config = [[ZZPhotoLibraryConfig alloc] init];
        }
    }else {
        ZZPhotoManager.shared.config = nil;
        ZZPhotoManager.shared.config = [[ZZPhotoLibraryConfig alloc] init];
        [ZZPhotoManager.shared cleanPhotos];
    }
    configureBlock == nil ? : configureBlock(ZZPhotoManager.shared.config);
    ZZPhotoEditViewController *photoEditViewController = [[ZZPhotoEditViewController alloc] init];
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:photoEditViewController];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [controller presentViewController:nav animated:YES completion:nil];
}

// 打开草稿箱
+ (void)presentDraftController:(nonnull UIViewController *)controller uid:(nonnull NSString *)uid userSelectDraftBlock:(nullable void(^)(ZZDraft * _Nullable draft, BOOL pictureRemoved))userSelectDraftBlock {
    
    ZZPhotoDraftHistoryViewController *draftVC = [[ZZPhotoDraftHistoryViewController alloc] init];
    draftVC.uid = uid;
    draftVC.userSelectDraftBlock = userSelectDraftBlock;
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:draftVC];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [controller presentViewController:nav animated:YES completion:nil];
}


@end
