//
//  FJPhotoCollectionViewCell.m
//  FJCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import "FJPhotoCollectionViewCell.h"
#import "PHAsset+QuickEdit.h"

@interface FJPhotoCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iv_camera;
@property (nonatomic, weak) IBOutlet UIView *v_content;
@property (nonatomic, weak) IBOutlet UIImageView *iv_cover;
@property (nonatomic, weak) IBOutlet UIImageView *iv_select;

@end

@implementation FJPhotoCollectionViewCell

- (void)dealloc {
    self.iv_camera = nil;
    self.v_content = nil;
    self.iv_cover = nil;
    self.iv_select = nil;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.iv_cover.contentMode = UIViewContentModeScaleAspectFill;
    self.iv_cover.clipsToBounds = YES;
    self.iv_cover.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setZzData:(__kindof ZZCollectionViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    FJPhotoCollectionViewCellDataSource *ds = zzData;
    self.iv_camera.hidden = !ds.isCameraPlaceholer;
    self.v_content.hidden = ds.isCameraPlaceholer;
    if (ds.isCameraPlaceholer) {
        return;
    }
    self.iv_select.hidden = !ds.isMultiSelection;
    [self.iv_cover setImage:nil];
    
    // PHAsset
    ZZ_WEAK_SELF
    CGFloat w = ZZDevice.zz_screenWidth * 2.0 / (CGFloat)ds.photoListColumn;
    CGFloat h = w;
    if (ds.photoAsset && ds.photoAsset.pixelWidth > 0 && ds.photoAsset.pixelHeight > 0) {
        h = w * ((CGFloat)ds.photoAsset.pixelHeight / (CGFloat)ds.photoAsset.pixelWidth);
    }
    if (@available(iOS 13.0, *)) {
        [ds.photoAsset fj_imageAsyncTargetSize:CGSizeMake(w, h) fast:NO iCloud:YES progress:nil result:^(UIImage *image) {
            [weakSelf.iv_cover setImage:image];
        }];
    }else {
        [ds.photoAsset fj_imageAsyncTargetSize:CGSizeMake(w, h) fast:YES iCloud:YES progress:nil result:^(UIImage *image) {
            [weakSelf.iv_cover setImage:image];
        }];
    }
    
    if (ds.isSelected) {
        [self.iv_select setImage:@"FJPhotoCollectionViewCell.ic_photo_selected".zz_image];
    }else {
        [self.iv_select setImage:@"FJPhotoCollectionViewCell.ic_photo_unselected".zz_image];
    }
    
    [self updateHighlighted:ds.isHighlighted];
}

- (void)updateHighlighted:(BOOL)isHighlighted {
    
    FJPhotoCollectionViewCellDataSource *ds = self.zzData;
    ds.isHighlighted = isHighlighted;
    if (isHighlighted) {
        [self zz_cornerRadius:2.0 borderWidth:2.0 boderColor:@"#FF7725".zz_color];
    }else {
        [self zz_cornerRadius:0 borderWidth:0 boderColor:[UIColor clearColor]];
    }
}

- (IBAction)_tapSelect:(id)sender {
    
    self.zzTapBlock == nil ? : self.zzTapBlock(self.zzData, self);
}

@end

@implementation FJPhotoCollectionViewCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.photoListColumn = 4.0;
        self.zzSize = CGSizeMake((ZZDevice.zz_screenWidth - 5.0 * (CGFloat)self.photoListColumn) / (CGFloat)self.photoListColumn, (ZZDevice.zz_screenWidth - 5.0 * (CGFloat)self.photoListColumn) / (CGFloat)self.photoListColumn);
    }
    return self;
}

- (void)setPhotoListColumn:(NSUInteger)photoListColumn {
    
    _photoListColumn = photoListColumn;
    self.zzSize = CGSizeMake((ZZDevice.zz_screenWidth - 5.0 * (CGFloat)photoListColumn) / (CGFloat)photoListColumn, (ZZDevice.zz_screenWidth - 5.0 * (CGFloat)photoListColumn) / (CGFloat)photoListColumn);
}

@end
