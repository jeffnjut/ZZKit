//
//  ZZPhotoDraftCell.h
//  ZZCamera
//
//  Created by Fu Jie on 2019/1/16.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoManager.h"
#import "ZZPhotoFilterManager.h"
#import "ZZTableView.h"

@interface ZZPhotoDraftCell : ZZTableViewCell

- (void)updateSelected:(BOOL)selected;

@end

@interface ZZPhotoDraftCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, strong) ZZDraft *data;
@property (nonatomic, assign) BOOL pictureRemoved;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL selected;
// 0 是选择 1 长按
@property (nonatomic, assign) int action;

// 缓存Image
@property (nonatomic, strong) UIImage *cacheImage;

@end

