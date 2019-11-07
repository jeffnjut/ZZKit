//
//  FJPhotoEditCropperView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"

@interface FJPhotoEditCropperView : UIView

@property (nonatomic, copy) void(^editingBlock)(BOOL inEditing);
@property (nonatomic, copy) void(^okBlock)(NSString *ratio);

+ (FJPhotoEditCropperView *)create:(CGRect)frame editingBlock:(void(^)(BOOL inEditing))editingBlock crop1to1:(void(^)(void))crop1to1 crop3to4:(void(^)(void))crop3to4 crop4to3:(void(^)(void))crop4to3 crop4to5:(void(^)(void))crop4to5 crop5to4:(void(^)(void))crop5to4 okBlock:(void(^)(NSString *ratio))okBlock;

@end
