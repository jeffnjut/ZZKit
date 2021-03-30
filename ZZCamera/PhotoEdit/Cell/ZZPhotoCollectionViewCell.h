//
//  ZZPhotoCollectionViewCell.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import <Photos/Photos.h>
#import "ZZCollectionView.h"

@interface ZZPhotoCollectionViewCell : ZZCollectionViewCell

- (void)updateTicked:(BOOL)isTicked;

@end

@interface ZZPhotoCollectionViewCellDataSource : ZZCollectionViewCellDataSource

@property (nonatomic, assign) BOOL isCameraPlaceholer;
@property (nonatomic, assign) BOOL isMultiSelection;
@property (nonatomic, assign) BOOL isTicked;
@property (nonatomic, strong) PHAsset *photoAsset;
@property (nonatomic, assign) NSInteger index;

@end
