//
//  ZZDraft.h
//  ZZKit
//
//  Created by Fu Jie on 2020/1/21.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZPhotoTuning.h"
#import "ZZPhotoTag.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 草稿的照片信息

@interface ZZDraftPhoto : NSObject

// SessionId 每次新打开相册随机生成
@property (nullable, nonatomic, copy) NSString *sessionId;

// localIdentifier（系统的）
@property (nullable, nonatomic, copy) NSString *assetIdentifier;

// 照片 URL（下载照片存放在文件系统中，以photoUrl的hash值为文件名）
@property (nullable, nonatomic, copy) NSString *photoUrl;

// 图片参数
@property (nullable, nonatomic, strong) ZZPhotoTuning *tuningObject;

// 图上标签
@property (nullable, nonatomic, strong) NSMutableArray<ZZPhotoTag *> *imageTags;

// 留白和充满标记 (YES:留白,NO:充满)
@property (nonatomic, assign) BOOL compressed;

// 裁切的起始（左上角X）的参数
@property (nonatomic, assign) CGFloat beginCropPointX;

// 裁切的起始（左上角Y）的参数
@property (nonatomic, assign) CGFloat beginCropPointY;

// 裁切的起始（右下角X）的参数
@property (nonatomic, assign) CGFloat endCropPointX;

// 裁切的起始（右下角Y）的参数
@property (nonatomic, assign) CGFloat endCropPointY;

@end

#pragma mark - 草稿的信息

@interface ZZDraft : NSObject

// Photo 列表

@property (nonnull, nonatomic, strong) NSMutableArray<ZZDraftPhoto *> *photos;

// Extra 参数类型，比如0表示A功能扩展参数，1表示B模块的扩展参数
@property (nonatomic, assign) int extraType;

// 预留参数
@property (nullable, nonatomic, copy) NSString *extra0;
@property (nullable, nonatomic, copy) NSString *extra1;
@property (nullable, nonatomic, copy) NSString *extra2;
@property (nullable, nonatomic, copy) NSString *extra3;
@property (nullable, nonatomic, copy) NSString *extra4;
@property (nullable, nonatomic, copy) NSString *extra5;

// 唯一码(可以去晒单ID，可以取创建时间)
@property (nullable, nonatomic, copy) NSString *identifier;

// 最后保存时间
@property (nonatomic, assign) long long updateTimeStamp;

// 用户ID
@property (nullable, nonatomic, copy) NSString *uid;

@end


#pragma mark - 草稿的信息列表

@interface ZZDraftList : NSObject

@property (nullable, nonatomic, strong) NSMutableArray<ZZDraft *> *drafts;

@end

NS_ASSUME_NONNULL_END
