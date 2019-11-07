//
//  FJPhotoDraftCell.h
//  FJCamera
//
//  Created by Fu Jie on 2019/1/16.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoManager.h"
#import "FJFilterManager.h"

@interface FJPhotoDraftCell : ZZTableViewCell

- (void)updateSelected:(BOOL)selected;

@end

@interface FJPhotoDraftCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, strong) FJPhotoPostDraftSavingModel *data;
@property (nonatomic, assign) BOOL pictureRemoved;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL selected;
// 0 是选择 1 长按
@property (nonatomic, assign) int action;

// 缓存Image
@property (nonatomic, strong) UIImage *cacheImage;

@end

