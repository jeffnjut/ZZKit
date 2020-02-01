//
//  ZZPhotoCollectionViewCell.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import "ZZPhotoCollectionViewCell.h"
#import "PHAsset+QuickEdit.h"
#import "ZZDevice.h"
#import "NSString+ZZKit.h"
#import "UIView+ZZKit.h"

@interface ZZPhotoCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iv_camera;
@property (nonatomic, weak) IBOutlet UIView *v_content;
@property (nonatomic, weak) IBOutlet UIImageView *iv_cover;
@property (nonatomic, weak) IBOutlet UIImageView *iv_tick;

@end

@implementation ZZPhotoCollectionViewCell

- (void)dealloc {
    self.iv_camera = nil;
    self.v_content = nil;
    self.iv_cover = nil;
    self.iv_tick = nil;
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
    ZZPhotoCollectionViewCellDataSource *ds = zzData;
    self.iv_camera.hidden = !ds.isCameraPlaceholer;
    self.v_content.hidden = ds.isCameraPlaceholer;
    if (ds.isCameraPlaceholer) {
        return;
    }
    self.iv_tick.hidden = !ds.isMultiSelection;
    [self.iv_cover setImage:nil];
    
    // PHAsset
    ZZ_WEAK_SELF
    CGFloat w = ZZDevice.zz_screenWidth * 2.0 / (CGFloat)ds.column;
    CGFloat h = w;
    if (ds.photoAsset && ds.photoAsset.pixelWidth > 0 && ds.photoAsset.pixelHeight > 0) {
        h = w * ((CGFloat)ds.photoAsset.pixelHeight / (CGFloat)ds.photoAsset.pixelWidth);
    }
    if (@available(iOS 13.0, *)) {
        [ds.photoAsset zz_imageAsyncTargetSize:CGSizeMake(w, h) fast:NO iCloud:YES progress:nil result:^(UIImage *image) {
            [weakSelf.iv_cover setImage:image];
        }];
    }else {
        [ds.photoAsset zz_imageAsyncTargetSize:CGSizeMake(w, h) fast:YES iCloud:YES progress:nil result:^(UIImage *image) {
            [weakSelf.iv_cover setImage:image];
        }];
    }
    
    if (ds.isTicked) {
        [self.iv_tick setImage:@"ZZPhotoCollectionViewCell.ic_photo_selected".zz_image];
    }else {
        [self.iv_tick setImage:@"ZZPhotoCollectionViewCell.ic_photo_unselected".zz_image];
    }
    
    [self updateHighlighted:ds.isHighlighted];
}

- (void)updateHighlighted:(BOOL)isHighlighted {
    
    ZZPhotoCollectionViewCellDataSource *ds = self.zzData;
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

@implementation ZZPhotoCollectionViewCellDataSource

- (void)setIsTicked:(BOOL)isTicked {
    _isTicked = isTicked;
    if (isTicked) {
        self.isHighlighted = YES;
    }
}

- (void)setColumn:(NSUInteger)column {
    
    _column = column;
    self.zzSize = CGSizeMake((ZZDevice.zz_screenWidth - 5.0 * (CGFloat)column) / (CGFloat)column, (ZZDevice.zz_screenWidth - 5.0 * (CGFloat)column) / (CGFloat)column);
}

@end
