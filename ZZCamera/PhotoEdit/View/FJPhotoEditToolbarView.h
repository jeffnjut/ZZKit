//
//  FJPhotoEditToolbarView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoEditViewController.h"

@interface FJPhotoEditToolbarView : UIView

@property (nonatomic, copy) void(^tagBlock)(void);
@property (nonatomic, copy) void(^editingBlock)(BOOL inEditing);
@property (nonatomic, copy) void(^filterBlock)(FJFilterType filterType);
@property (nonatomic, copy) void(^cropBlock)(NSString *ratio, BOOL confirm);
@property (nonatomic, copy) void(^tuneBlock)(FJTuningType type, float value, BOOL confirm);

+ (FJPhotoEditToolbarView *)create:(FJPhotoEditMode)mode editingBlock:(void (^)(BOOL inEditing))editingBlock filterBlock:(void(^)(FJFilterType filterType))filterBlock cropBlock:(void (^)(NSString *ratio, BOOL confirm))cropBlock tuneBlock:(void(^)(FJTuningType type, float value, BOOL confirm))tuneBlock;

- (NSUInteger)getIndex;

- (void)refreshFilterToolbar;

@end
