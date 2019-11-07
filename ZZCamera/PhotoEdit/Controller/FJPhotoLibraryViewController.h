//
//  FJPhotoLibraryViewController.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoEditViewController.h"
#import "FJImageTagModel.h"
#import "FJPhotoUserTagBaseViewController.h"
#import "FJPhotoManager.h"

@interface FJPhotoLibraryViewController : UIViewController

// 多张照片选择最多选择张数（默认为9）
@property (nonatomic, assign) NSUInteger maxSelectionCount;

// 照片瀑布流的列数（默认为4）
@property (nonatomic, assign) NSUInteger photoListColumn;

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

// Mode (Edit Controller)
@property (nonatomic, assign) FJPhotoEditMode mode;

// 编辑 Next Block (Edit Controller)
@property (nonatomic, copy) void(^userEditNextBlock)(void);

// 限制添加Tag的个数，0为不限制
@property (nonatomic, assign) NSUInteger limitedTagCnt;

// 初始化
- (instancetype)initWithMode:(FJPhotoEditMode)mode editController:(__kindof __weak FJPhotoUserTagBaseViewController * (^)(FJPhotoEditViewController *controller))editController;

@end
