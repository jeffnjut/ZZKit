//
//  ZZPhotoLibrarySelectionView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/26.
//  Copyright © 2018年 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPhotoLibrarySelectionView : UIView

+ (ZZPhotoLibrarySelectionView *)create:(NSString *)title;

- (void)updateAlbumTitle:(NSString *)album;

- (void)setExtendBlock:(void(^)(void))block;

- (void)setCollapseBlock:(void(^)(void))block;

- (void)collapse;

@end
