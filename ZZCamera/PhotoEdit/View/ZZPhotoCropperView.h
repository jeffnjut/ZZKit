//
//  ZZPhotoCropperView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/13.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoManager.h"

@interface ZZPhotoCropperView : UIView

@property (nonatomic, weak) IBOutlet UILabel *blurLabel;

/**
 * 创建相片裁切视图
 */
+ (ZZPhotoCropperView *)create:(BOOL)debug showGrid:(BOOL)showGrid cropperHorizontalExtemeRatio:(CGFloat)cropperHorizontalExtemeRatio cropperVerticalExtemeRatio:(CGFloat)cropperVerticalExtemeRatio croppedBlock:(void(^)(ZZPhotoAsset *photoModel, CGRect frame))croppedBlock updownBlock:(void(^)(BOOL up))updownBlock;

// 更新图片(返回NO表示iCoud图片下载中)
- (BOOL)updateModel:(ZZPhotoAsset *)model;

// 更新向上和向下的状态
- (void)updateUp:(BOOL)up;

// 获取向上和向下的状态
- (BOOL)getUp;

@end
