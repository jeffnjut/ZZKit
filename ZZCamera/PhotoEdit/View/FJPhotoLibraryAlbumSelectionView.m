//
//  FJPhotoLibraryAlbumSelectionView.m
//  FJCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import "FJPhotoLibraryAlbumSelectionView.h"
#import "FJPhotoLibraryAlbumCell.h"

@interface FJPhotoLibraryAlbumSelectionView()

@property (nonatomic, strong) ZZTableView *tableView;
@property (nonatomic, strong) NSArray<PHAssetCollection *> *photoAssetCollections;
@property (nonatomic, strong) PHAssetCollection *selectedPhotoAssetCollection;
@property (nonatomic, copy) void(^assetCollectionChangedBlock)(PHAssetCollection *currentCollection);

@end

@implementation FJPhotoLibraryAlbumSelectionView

- (void)setAssetCollectionChangedBlock:(void(^)(PHAssetCollection *currentCollection))block {
    
    _assetCollectionChangedBlock = block;
}

+ (FJPhotoLibraryAlbumSelectionView *)create:(CGPoint)point maxColumn:(NSUInteger)maxColumn photoAssetCollections:(NSArray<PHAssetCollection *> *)photoAssetCollections selectedPhotoAssetCollection:(PHAssetCollection *)selectedPhotoAssetCollection assetCollectionChangedBlock:(void(^)(PHAssetCollection *currentCollection))block {
    
    CGFloat h = 0;
    if (maxColumn == 0) {
        // 撑满全屏
        h = ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT;
    }else {
        h = photoAssetCollections.count > maxColumn ? maxColumn * 80.0 : photoAssetCollections.count * 80.0;
    }
    FJPhotoLibraryAlbumSelectionView *view = [[FJPhotoLibraryAlbumSelectionView alloc] initWithFrame:CGRectMake(point.x, point.y, UIScreen.mainScreen.bounds.size.width, h)];
    view.photoAssetCollections = photoAssetCollections;
    view.selectedPhotoAssetCollection = selectedPhotoAssetCollection;
    [view setAssetCollectionChangedBlock:block];
    [view _render];
    return view;
}

- (ZZTableView *)tableView {
    
    if (_tableView == nil) {
        ZZ_WEAK_SELF
        _tableView = [ZZTableView zz_quickAdd:ZZTableViewCellEditingStyleNone backgroundColor:[UIColor whiteColor] onView:self frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
            make.left.right.top.equalTo(weakSelf);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(weakSelf.mas_safeAreaLayoutGuideBottom);
            }else {
                make.bottom.equalTo(weakSelf);
            }
        } actionBlock:^(ZZTableView *__weak  _Nonnull tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
            
            if (action == ZZTableViewCellActionTapped) {
                if ([cellData isKindOfClass:[FJPhotoLibraryAlbumCellDataSource class]]) {
                    FJPhotoLibraryAlbumCellDataSource *ds = cellData;
                    for (FJPhotoLibraryAlbumCellDataSource *data in weakSelf.tableView.zzDataSource) {
                        data.isSelected = NO;
                        if ([data isEqual:ds]) {
                            data.isSelected = YES;
                            weakSelf.assetCollectionChangedBlock == nil ? : weakSelf.assetCollectionChangedBlock(data.assetCollection);
                        }
                    }
                    [weakSelf.tableView zz_refresh];
                }
            }
        }];
    }
    return _tableView;
}

- (void)_render {
    
    [self.tableView.zzDataSource removeAllObjects];
    // 获取当前相册 所有照片对象
    for (PHAssetCollection *collection in self.photoAssetCollections) {
        FJPhotoLibraryAlbumCellDataSource *ds = [[FJPhotoLibraryAlbumCellDataSource alloc] init];
        ds.assetCollection = collection;
        if ([collection isEqual:self.selectedPhotoAssetCollection]) {
            ds.isSelected = YES;
        }else {
            ds.isSelected = NO;
        }
        [self.tableView zz_addDataSource:ds];
    }
    [self.tableView zz_refresh];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
