//
//  DemoBannerCell.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "DemoBannerCell.h"

@interface DemoBannerCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DemoBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setZzData:(__kindof ZZTableViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    __block DemoBannerCellDataSource *ds = zzData;
    
    if (_scrollView == nil) {
        ZZ_WEAK_SELF
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ZZDevice.zz_screenWidth, ds.zzHeight)];
        [self.contentView addSubview:_scrollView];
        for (int i = 0; i < 3; i++) {
            NSString *name = [NSString stringWithFormat:@"ic_bg_%d", i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            imageView.image = name.zz_image;
            imageView.tag = i;
            [_scrollView addSubview:imageView];
            [imageView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
                NSLog(@"%d", (int)sender.tag);
                ds.selectedIndex = sender.tag;
                weakSelf.zzTapBlock == nil ? : weakSelf.zzTapBlock(weakSelf);
            }];
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    }
}

@end

@implementation DemoBannerCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 200.0;
    }
    return self;
}

@end
