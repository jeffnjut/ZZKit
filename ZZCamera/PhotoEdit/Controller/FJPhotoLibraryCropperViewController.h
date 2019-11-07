//
//  FJPhotoLibraryCropperViewController.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/13.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoEditViewController.h"
#import "FJImageTagModel.h"
#import "FJPhotoUserTagBaseViewController.h"
#import "FJPhotoManager.h"

typedef NS_ENUM(NSInteger, FJTakePhotoButtonPosition) {
    
    FJTakePhotoButtonPositionNone,
    FJTakePhotoButtonPositionCell,
    FJTakePhotoButtonPositionBottom,
    FJTakePhotoButtonPositionBottomWithDraft
};

typedef NS_ENUM(NSInteger, FJPhotoSortType) {
    
    FJPhotoSortTypeModificationDateDesc,
    FJPhotoSortTypeModificationDateAsc,
    FJPhotoSortTypeCreationDateDesc,
    FJPhotoSortTypeCreationDateAsc
};

@interface FJPhotoLibraryCropperViewController : UIViewController

// 拍照按钮的位置
@property (nonatomic, assign) FJTakePhotoButtonPosition takeButtonPosition;

// 排序方式
@property (nonatomic, assign) FJPhotoSortType sortType;

// 多张照片选择最多选择张数（默认为9）
@property (nonatomic, assign) NSUInteger maxSelectionCount;

// 照片瀑布流的列数（默认为4）
@property (nonatomic, assign) NSUInteger photoListColumn;

// 过滤尺寸（小于尺寸的照片不在相册选择中显示）
@property (nonatomic, assign) CGSize filterMinPhotoPixelSize;

// 宽长图片的极限比例(比例极限是不小于：高度/宽度值)
@property (nonatomic, assign) CGFloat horizontalExtemeRatio;

// 窄长图片的极限比例(比例极限是不小于：宽度/高度值)
@property (nonatomic, assign) CGFloat verticalExtemeRatio;

// 是否显示裁切视图CropperView
@property (nonatomic, assign) BOOL cropperViewVisible;

// 启动时的Block
@property (nonatomic, copy) void(^userInitBlock)(void);

// 超出最多选择张数后的Block
@property (nonatomic, copy) void(^userOverLimitationBlock)(void);

// Next Block
@property (nonatomic, copy) void(^userNextBlock)(NSMutableArray<FJPhotoModel *> *selectedPhotos);

// 用户设置的未获得访问相册权限的Block
@property (nonatomic, copy) void(^userNoPhotoLibraryPermissionBlock)(void);

// 用户设置的未获得访问相机权限的Block
@property (nonatomic, copy) void(^userNoCameraPermissionBlock)(void);

// 用户选择未发布的草稿的Block
@property (nonatomic, copy) void(^userSelectDraftBlock)(FJPhotoPostDraftSavingModel *draft, BOOL pictureRemoved);

// Mode (Edit Controller)
@property (nonatomic, assign) FJPhotoEditMode mode;

// 编辑 Next Block (Edit Controller)
@property (nonatomic, copy) void(^userEditNextBlock)(void);

// User ID
@property (nonatomic, copy) NSString *uid;

// 限制添加Tag的个数，0为不限制
@property (nonatomic, assign) NSUInteger limitedTagCnt;

// 初始化
- (instancetype)initWithMode:(FJPhotoEditMode)mode editController:(__kindof FJPhotoUserTagBaseViewController * (^)(FJPhotoEditViewController *controller))editController;

@end
