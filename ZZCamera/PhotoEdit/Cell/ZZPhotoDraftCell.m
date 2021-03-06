//
//  ZZPhotoDraftCell.m
//  ZZCamera
//
//  Created by Fu Jie on 2019/1/16.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "ZZPhotoDraftCell.h"
#import <Typeset/Typeset.h>
#import "PHAsset+QuickEdit.h"
#import "UIImage+ZZKit.h"
#import "NSString+ZZKit.h"
#import "UIView+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "NSString+ZZKit.h"

@interface ZZPhotoDraftCell()

@property (nonatomic, weak) IBOutlet UIImageView *draftImageView;
@property (nonatomic, weak) IBOutlet UILabel *draftLabel;
@property (nonatomic, weak) IBOutlet UILabel *draftAssetsCntLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkboxImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *checkboxImageViewConst;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation ZZPhotoDraftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPress)];
    [self.contentView addGestureRecognizer:longPress];
    [self.draftImageView zz_cornerRadius:2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setZzData:(__kindof ZZTableViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    ZZPhotoDraftCellDataSource *ds = zzData;
    
    ZZ_WEAK_SELF
    if (ds.cacheImage != nil) {
        self.draftImageView.image = ds.cacheImage;
    }else {
        ZZDraftPhoto *pModel = [ds.data.photos zz_arrayObjectAtIndex:0];
        if (pModel.assetIdentifier.length > 0) {
            PHAsset *asset = [ZZPhotoManager.shared findByIdentifier:pModel.assetIdentifier];
            if (asset == nil) {
                [self _renderDefaultImage];
            }else {
                ds.pictureRemoved = NO;
                UIImage *image = [asset getSmallTargetImage];
                [self _renderImage:image photoModel:pModel];
            }
        }else if (pModel.photoUrl.length > 0) {
            self.draftImageView.image = @"ZZPhotoDraftCell.ic_photo_no_found".zz_image;
            [ZZPhotoManager.shared findByPhotoUrl:pModel.photoUrl completion:^(NSData *imageData, UIImage *image, NSString *url) {
                if (image == nil) {
                    [weakSelf _renderDefaultImage];
                }else {
                    [weakSelf _renderImage:image photoModel:pModel];
                }
            }];
        }else {
            [weakSelf _renderDefaultImage];
        }
    }
    
    if (ds.data.extra2 != nil && [ds.data.extra2 isKindOfClass:[NSString class]]) {
        NSString *txt = ds.data.extra2;
        self.draftLabel.attributedText = txt.typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).minimumLineHeight(22.0).color(@"#3C3C3C".zz_color).lineBreakMode(NSLineBreakByTruncatingTail).string;
    }else {
        self.draftLabel.attributedText = @"暂无标题".typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).minimumLineHeight(22.0).color(@"#3C3C3C".zz_color).string;
    }
    self.draftAssetsCntLabel.text = [NSString stringWithFormat:@"%d张照片", (int)ds.data.photos.count];
    
    if (ds.editable) {
        self.checkboxImageViewConst.constant = 60.0;
        self.checkboxImageView.hidden = NO;
        [self.checkboxImageView setHighlighted:ds.selected];
        self.button.hidden = NO;
    }else {
        self.checkboxImageViewConst.constant = 16.0;
        self.checkboxImageView.hidden = YES;
        self.button.hidden = YES;
    }
}

- (void)_renderImage:(UIImage *)image photoModel:(ZZDraftPhoto *)photoModel {
    
    image = [image zz_imageCropBeginPointRatio:CGPointMake(photoModel.beginCropPointX, photoModel.beginCropPointY) endPointRatio:CGPointMake(photoModel.endCropPointX, photoModel.endCropPointY)];
    image = [[ZZPhotoFilterManager shared] image:image tuningObject:photoModel.tuningObject appendFilterType:photoModel.tuningObject.filterType];
    if (image == nil) {
        [self _renderDefaultImage];
    }else {
        self.draftImageView.image = image;
    }
    
    ZZPhotoDraftCellDataSource *ds = self.zzData;
    ds.cacheImage = self.draftImageView.image;
}

- (void)_renderDefaultImage {
    
    ZZPhotoDraftCellDataSource *ds = self.zzData;
    self.draftImageView.image = @"ZZPhotoDraftCell.ic_photo_no_found".zz_image;
    if (ds.data.photos.count == 1) {
        ds.pictureRemoved = YES;
    }else {
        ds.pictureRemoved = NO;
    }
    
    ds.cacheImage = self.draftImageView.image;
}

- (void)updateSelected:(BOOL)selected {
    
    ZZPhotoDraftCellDataSource *ds = self.zzData;
    ds.selected = selected;
    [self.checkboxImageView setHighlighted:selected];
}

- (IBAction)_tapCheckbox:(id)sender {
    
    BOOL checked = self.checkboxImageView.isHighlighted;
    [self updateSelected:!checked];
    ZZPhotoDraftCellDataSource *ds = self.zzData;
    ds.action = 0;
    self.zzTapBlock == nil ? : self.zzTapBlock(self);
}

- (void)_longPress {
    
    ZZPhotoDraftCellDataSource *ds = self.zzData;
    ds.action = 1;
    self.zzTapBlock == nil ? : self.zzTapBlock(self);
}

@end

@implementation ZZPhotoDraftCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 98.0;
    }
    return self;
}

@end
