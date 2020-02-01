//
//  ZZPhotoEditFilterView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/8.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPhotoEditFilterView : UIView

+ (ZZPhotoEditFilterView *)create:(CGRect)frame filterImages:(NSArray *)filterImages filterTypes:(NSArray *)filterTypes selectedIndex:(NSUInteger)selectedIndex selectedBlock:(void(^)(NSUInteger index))selectedBlock;

- (void)updateFilterImages:(NSArray *)filterImages;

- (void)setSelectedIndex:(NSUInteger)index scrollable:(BOOL)scrollable;

@end
