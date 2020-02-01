//
//  ZZPhotoEditTuningView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoEditTuningValueView.h"
#import "ZZPhotoManager.h"

@interface ZZPhotoEditTuningView : UIView

@property (nonatomic, copy) void(^editingBlock)(BOOL inEditing);
@property (nonatomic, copy) void(^tuneBlock)(ZZPhotoTuningType type, float value, BOOL confirm);

+ (ZZPhotoEditTuningView *)create:(CGRect)frame editingBlock:(void(^)(BOOL inEditing))editingBlock tuneBlock:(void(^)(ZZPhotoTuningType type, float value, BOOL confirm))tuneBlock;

@end
