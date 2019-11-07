//
//  FJPhotoEditViewController.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoManager.h"

@class FJPhotoUserTagBaseViewController;

@protocol FJPhotoEditTagDelegate <NSObject>

@optional

- (void)fj_photoEditAddTag:(FJImageTagModel *)model point:(CGPoint)point;

@end


typedef NS_ENUM(NSInteger, FJPhotoEditMode) {
    FJPhotoEditModeFilter     = 0x0001,
    FJPhotoEditModeCropprer   = 0x0002,
    FJPhotoEditModeTuning     = 0x0004,
    FJPhotoEditModeTag        = 0x0008,
    FJPhotoEditModeAll        = FJPhotoEditModeFilter | FJPhotoEditModeCropprer | FJPhotoEditModeTuning | FJPhotoEditModeTag
    
};

@interface FJPhotoEditViewController : UIViewController <FJPhotoEditTagDelegate>

// Mode
@property (nonatomic, assign) FJPhotoEditMode mode;

// 编辑 Next Block (Edit Controller)
@property (nonatomic, copy) void(^userEditNextBlock)(void);

// 已选相片
@property (nonatomic, strong) NSMutableArray<FJPhotoModel *> *selectedPhotos;

// 重新编辑的相片序列（指代并不是从相册进入，去掉返回按钮）
@property (nonatomic, strong) NSNumber *editPhotoIndex;

// 限制添加Tag的个数，0为不限制
@property (nonatomic, assign) NSUInteger limitedTagCnt;

// 初始化
- (instancetype)initWithMode:(FJPhotoEditMode)mode editController:(__kindof FJPhotoUserTagBaseViewController * (^)(FJPhotoEditViewController *controller))editController;

@end
