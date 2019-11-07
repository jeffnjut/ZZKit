//
//  FJPhotoLibraryAlbumCell.m
//  FJCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import "FJPhotoLibraryAlbumCell.h"
#import "PHAsset+QuickEdit.h"

@interface FJPhotoLibraryAlbumCell()

@property (nonatomic, weak) IBOutlet UIImageView *albumImage;
@property (nonatomic, weak) IBOutlet UILabel *albumLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIImageView *selectImage;

@end

@implementation FJPhotoLibraryAlbumCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setZzData:(__kindof ZZTableViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    FJPhotoLibraryAlbumCellDataSource *ds = zzData;
    // 获取当前相册 所有照片对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:ds.assetCollection options:nil];
    PHAsset *firstAsset = assets.lastObject;
    
    ZZ_WEAK_SELF
    if (@available(iOS 13.0, *)) {
        [firstAsset fj_imageAsyncTargetSize:CGSizeMake(150.0, 150.0) fast:NO iCloud:YES progress:nil result:^(UIImage *image) {
            [weakSelf.albumImage setImage:image];
        }];
    }else {
        [firstAsset fj_imageAsyncTargetSize:CGSizeMake(150.0, 150.0) fast:YES iCloud:YES progress:nil result:^(UIImage *image) {
            [weakSelf.albumImage setImage:image];
        }];
    }
    self.albumLabel.text = ds.assetCollection.localizedTitle;
    self.countLabel.text = ZZ_STR_FORMAT_INTEGER(assets.count);
    [self.selectImage setHighlighted:ds.isSelected];
}

@end

@implementation FJPhotoLibraryAlbumCellDataSource

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.zzHeight = 80.0;
    }
    return self;
}

@end
