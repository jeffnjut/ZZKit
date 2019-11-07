//
//  FJPhotoLibrarySelectionView.m
//  FJCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import "FJPhotoLibrarySelectionView.h"
#import "FJPhotoEditCommonHeader.h"

@interface FJPhotoLibrarySelectionView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImage;
@property (nonatomic, weak) IBOutlet UIButton *tapBtn;
@property (nonatomic, assign) BOOL extended;
@property (nonatomic, copy) void(^extendBlock)(void);
@property (nonatomic, copy) void(^collapseBlock)(void);

@end

@implementation FJPhotoLibrarySelectionView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.arrowImage.image = @"FJPhotoLibrarySelectionView.ic_arrow_down".zz_image;
}

+ (FJPhotoLibrarySelectionView *)create:(NSString *)title {
    
    FJPhotoLibrarySelectionView *view = ZZ_LOAD_NIB(@"FJPhotoLibrarySelectionView");
    [view updateAlbumTitle:title];
    return view;
}

- (void)updateAlbumTitle:(NSString *)album {
    
    self.titleLabel.text = album;
}

- (void)setExtendBlock:(void(^)(void))block {
    
    _extendBlock = block;
}

- (void)setCollapseBlock:(void(^)(void))block {
    
    _collapseBlock = block;
}

- (IBAction)_tap:(UIButton *)sender {
    
    [self.tapBtn setUserInteractionEnabled:NO];
    if (self.extended) {
        self.arrowImage.image = @"FJPhotoLibrarySelectionView.ic_arrow_down".zz_image;
        self.collapseBlock == nil ? : self.collapseBlock();
        self.extended = NO;
    }else {
        self.arrowImage.image = @"FJPhotoLibrarySelectionView.ic_arrow_up".zz_image;
        self.extendBlock == nil ? : self.extendBlock();
        self.extended = YES;
    }
    ZZ_WEAK_SELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tapBtn setUserInteractionEnabled:YES];
    });
}

- (void)collapse {
    
    self.arrowImage.image = @"FJPhotoLibrarySelectionView.ic_arrow_down".zz_image;
    self.extended = NO;
}

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(240, 48);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
