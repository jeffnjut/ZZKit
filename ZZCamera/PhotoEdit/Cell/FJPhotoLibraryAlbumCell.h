//
//  FJPhotoLibraryAlbumCell.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"

@interface FJPhotoLibraryAlbumCell : ZZTableViewCell

@end

@interface FJPhotoLibraryAlbumCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, assign) BOOL isSelected;

@end
