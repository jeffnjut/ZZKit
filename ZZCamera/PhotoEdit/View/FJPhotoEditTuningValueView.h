//
//  FJPhotoEditTuningValueView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"

@interface FJPhotoEditTuningValueView : UIView

@property (nonatomic, copy) void(^okBlock)(float value);
@property (nonatomic, copy) void(^valueChangedBlock)(float value);
@property (nonatomic, copy) void(^editingBlock)(BOOL inEditing);

- (void)updateTitle:(NSString *)title;

+ (FJPhotoEditTuningValueView *)create:(CGRect)frame title:(NSString *)title value:(float)value defaultValue:(float)defaultValue range:(NSArray *)range valueChangedBlock:(void(^)(float value))valueChangedBlock editingBlock:(void(^)(BOOL inEditing))editingBlock okBlock:(void(^)(float value))okBlock;

@end
