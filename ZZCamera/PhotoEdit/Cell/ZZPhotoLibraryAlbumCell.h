//
//  ZZPhotoLibraryAlbumCell.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZZTableView.h"

@interface ZZPhotoLibraryAlbumCell : ZZTableViewCell

@end

@interface ZZPhotoLibraryAlbumCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, assign) BOOL isSelected;

@end
