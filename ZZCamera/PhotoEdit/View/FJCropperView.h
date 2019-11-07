//
//  FJCropperView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/13.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoManager.h"

@interface FJCropperView : UIView

@property (nonatomic, weak) IBOutlet UILabel *blurLabel;

+ (FJCropperView *)create:(BOOL)debug grid:(BOOL)grid horizontalExtemeRatio:(CGFloat)horizontalExtemeRatio verticalExtemeRatio:(CGFloat)verticalExtemeRatio croppedBlock:(void(^)(FJPhotoModel *photoModel, CGRect frame))croppedBlock updownBlock:(void(^)(BOOL up))updownBlock;

// 更新图片(返回NO表示iCoud图片下载中)
- (BOOL)updateModel:(FJPhotoModel *)model;

// 更新向上和向下的状态
- (void)updateUp:(BOOL)up;

// 获取向上和向下的状态
- (BOOL)getUp;

// 是否在裁切图片
// - (BOOL)inCroppingImage;

@end
