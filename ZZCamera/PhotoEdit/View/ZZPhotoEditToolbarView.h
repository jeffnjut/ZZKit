//
//  ZZPhotoEditToolbarView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoEditViewController.h"

@interface ZZPhotoEditToolbarView : UIView

@property (nonatomic, copy) void(^tagBlock)(void);
@property (nonatomic, copy) void(^editingBlock)(BOOL inEditing);
@property (nonatomic, copy) void(^filterBlock)(ZZPhotoFilterType filterType);
@property (nonatomic, copy) void(^cropBlock)(NSString *ratio, BOOL confirm);
@property (nonatomic, copy) void(^tuneBlock)(ZZPhotoTuningType type, float value, BOOL confirm);

+ (ZZPhotoEditToolbarView *)create:(ZZPhotoEditMode)mode editingBlock:(void (^)(BOOL inEditing))editingBlock filterBlock:(void(^)(ZZPhotoFilterType filterType))filterBlock cropBlock:(void (^)(NSString *ratio, BOOL confirm))cropBlock tuneBlock:(void(^)(ZZPhotoTuningType type, float value, BOOL confirm))tuneBlock;

- (NSUInteger)getIndex;

- (void)refreshFilterToolbar;

@end
