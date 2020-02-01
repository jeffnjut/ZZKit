//
//  ZZPhotoLibraryAlbumSelectionView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ZZPhotoLibraryAlbumSelectionView : UIView

- (void)setAssetCollectionChangedBlock:(void(^)(PHAssetCollection *currentCollection))block;

+ (ZZPhotoLibraryAlbumSelectionView *)create:(CGPoint)point maxColumn:(NSUInteger)maxColumn photoAssetCollections:(NSArray<PHAssetCollection *> *)photoAssetCollections selectedPhotoAssetCollection:(PHAssetCollection *)selectedPhotoAssetCollection assetCollectionChangedBlock:(void(^)(PHAssetCollection *currentCollection))block;

@end
