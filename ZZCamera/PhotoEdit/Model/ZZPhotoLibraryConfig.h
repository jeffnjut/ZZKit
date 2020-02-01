//
//  ZZPhotoLibraryConfig.h
//  ZZKit
//
//  Created by Fu Jie on 2020/1/22.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZPhotoLibraryConfig.h"
#import "ZZDraft.h"
#import "ZZPhotoAsset.h"

@class ZZPhotoSelectTagBaseViewController;
@class ZZPhotoEditViewController;
@class ZZPhotoLibraryViewController;

typedef NS_ENUM(NSInteger, ZZPhotoLibraryConfigCameraButtonType) {
    
    // 没有拍照按钮
    ZZPhotoLibraryCameraButtonTypeNone,
    
    // 拍照按钮在Cell上
    ZZPhotoLibraryCameraButtonTypeCell,
    
    // 拍照按钮在底部工具条上
    ZZPhotoLibraryCameraButtonTypeBottom
};

typedef NS_ENUM(NSInteger, ZZPhotoLibrarySortType) {
    
    // 照片按照修改时间降序
    ZZPhotoLibrarySortTypeModificationDateDesc,
    
    // 照片按照修改时间升序
    ZZPhotoLibrarySortTypeModificationDateAsc,
    
    // 照片按照创建时间降序
    ZZPhotoLibrarySortTypeCreationDateDesc,
    
    // 照片按照创建时间升序
    ZZPhotoLibrarySortTypeCreationDateAsc
};

typedef NS_ENUM(NSInteger, ZZPhotoLibraryCropperType) {
    
    // 隐藏裁切视图，图片不受尺寸限制(原图尺寸)
    ZZPhotoLibraryCropperTypeHiddenUnlimited,
    
    // 隐藏裁切视图，图片受尺寸限制自动裁切（超出最大裁切尺寸居中自动裁切，否则原图尺寸）
    ZZPhotoLibraryCropperTypeHiddenLimited,
    
    // 显示裁切视图，裁切图片尺寸受最大裁切尺寸的限制
    ZZPhotoLibraryCropperTypeShow
};

typedef NS_ENUM(NSInteger, ZZPhotoEditMode) {
    
    // 不支持图片编辑
    ZZPhotoEditModeNone       = 0x0000,
    
    // 支持滤镜
    ZZPhotoEditModeFilter     = 0x0001,
    
    // 支持裁切
    ZZPhotoEditModeCropprer   = 0x0002,
    
    // 支持图片调整
    ZZPhotoEditModeTuning     = 0x0004,
    
    // 支持添加图上标签
    ZZPhotoEditModeTag        = 0x0008,
    
    // 全部支持
    ZZPhotoEditModeAll        = ZZPhotoEditModeFilter | ZZPhotoEditModeCropprer | ZZPhotoEditModeTuning | ZZPhotoEditModeTag
};

NS_ASSUME_NONNULL_BEGIN

@interface ZZPhotoLibraryConfig : NSObject

// 编辑模式
@property (nonatomic, assign) ZZPhotoEditMode mode;

// 拍照按钮的位置
@property (nonatomic, assign) ZZPhotoLibraryConfigCameraButtonType cameraButtonType;

// 是否显示草稿箱
@property (nonatomic, assign) BOOL showDraft;

// 照片排序
@property (nonatomic, assign) ZZPhotoLibrarySortType sortType;

// 多张照片选择最多选择张数（默认为9）
@property (nonatomic, assign) NSUInteger maxSelectionCount;

// 显示照片列表的列数
@property (nonatomic, assign) NSUInteger column;

// 过滤尺寸（小于尺寸的照片不在相册选择中显示）
@property (nonatomic, assign) CGSize filterMinPhotoPixelSize;

// 是否显示裁切视图CropperView
@property (nonatomic, assign) ZZPhotoLibraryCropperType cropperType;

// 宽长图片的极限比例(比例极限是不小于：高度/宽度值)
@property (nonatomic, assign) CGFloat cropperHorizontalExtemeRatio;

// 窄长图片的极限比例(比例极限是不小于：宽度/高度值)
@property (nonatomic, assign) CGFloat cropperVerticalExtemeRatio;

// 限制添加Tag的个数，0为不限制
@property (nonatomic, assign) NSUInteger limitedTagCnt;

// 当前编辑的索引，重新编辑的相片序列（并不是从相册进入，去掉返回按钮）
@property (nonatomic, strong, nullable) NSNumber *editPhotoIndex;

// 启动时的Block
@property (nonatomic, copy) void(^userInitBlock)(void);

// 超出最多选择张数后的Block
@property (nonatomic, copy) void(^userOverLimitationBlock)(ZZPhotoLibraryViewController *photoLibraryController);

// 用户设置的未获得访问相册权限的Block
@property (nonatomic, copy) void(^userNoPhotoLibraryPermissionBlock)(void);

// 用户设置的未获得访问相机权限的Block
@property (nonatomic, copy) void(^userNoCameraPermissionBlock)(void);

// 用户选择未发布的草稿的Block
@property (nonatomic, copy) void(^userSelectDraftBlock)(UINavigationController *navigationController, ZZDraft *draft, BOOL pictureRemoved);

// 用户相册浏览 Next Block (PohotoLibrary Controller)
@property (nonatomic, copy) void(^userNextBlock)(void);

// 用户编辑图片 Next Block (Edit Controller)
@property (nonatomic, copy) void(^userEditNextBlock)(UINavigationController *navigationController, NSArray<ZZPhotoAsset *> *photoQueue);

// 用户编辑图片 选择标签 Block (Edit Controller)
@property (nonatomic, copy) __kindof ZZPhotoSelectTagBaseViewController *(^userEditSelectTagBlock)(ZZPhotoEditViewController *controller);

@end

NS_ASSUME_NONNULL_END
