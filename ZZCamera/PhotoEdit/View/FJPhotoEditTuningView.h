//
//  FJPhotoEditTuningView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditTuningValueView.h"
#import "FJPhotoManager.h"

@interface FJPhotoEditTuningView : UIView

@property (nonatomic, copy) void(^editingBlock)(BOOL inEditing);
@property (nonatomic, copy) void(^tuneBlock)(FJTuningType type, float value, BOOL confirm);

+ (FJPhotoEditTuningView *)create:(CGRect)frame editingBlock:(void(^)(BOOL inEditing))editingBlock tuneBlock:(void(^)(FJTuningType type, float value, BOOL confirm))tuneBlock;

@end
