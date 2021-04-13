//
//  ZZPhotoAsset.h
//  ZZKit
//
//  Created by Fu Jie on 2020/1/21.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "ZZPhotoTuning.h"
#import "ZZPhotoTag.h"
#import "NSArray+FetchImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZPhotoAsset : NSObject

// SessionId 每次新打开相册随机生成
@property (nullable, nonatomic, copy) NSString *sessionId;

// PHAsset 对象
@property (nullable, nonatomic, strong) PHAsset *asset;

// 照片 URL（下载照片存放在文件系统中，以photoUrl的hash值为文件名）
@property (nullable, nonatomic, copy) NSString *photoUrl;

// 原始图片
@property (nullable, nonatomic, strong) UIImage *originalImage;

// 缩略图片
@property (nullable, nonatomic, strong) UIImage *originalThumbImage;

// 压缩图片
@property (nullable, nonatomic, strong) UIImage *croppedImage;

// 当前图片（裁切或原图）
@property (nullable, nonatomic, strong) UIImage *currentImage;

// 当前图片（滤镜或Tuning的效果后，包括裁切）
@property (nullable, nonatomic, strong) UIImage *currentFilteredImage;

// 图片参数
@property (nullable, nonatomic, strong) ZZPhotoTuning *tuningObject;

// 滤镜参数
@property (nonnull, nonatomic, strong) NSMutableArray<UIImage *> *filterThumbImages;

// 图上标签
@property (nullable, nonatomic, strong) NSMutableArray<ZZPhotoTag *> *imageTags;

// 是否需要裁切
@property (nonatomic, assign) BOOL needCrop;

// 留白和充满标记 (YES:留白,NO:充满)
@property (nonatomic, assign) BOOL compressed;

// 裁切的起始（左上角）的参数
@property (nonatomic, assign) CGPoint beginCropPoint;

// 裁切的起始（右下角）的参数
@property (nonatomic, assign) CGPoint endCropPoint;

/**
 * 初始化ZZPhotoAsset
 */
- (nonnull id)initWithAsset:(nonnull PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
