//
//  FJPhotoEditFilterView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/8.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"

@interface FJPhotoEditFilterView : UIView

+ (FJPhotoEditFilterView *)create:(CGRect)frame filterImages:(NSArray *)filterImages filterNames:(NSArray *)filterNames selectedIndex:(NSUInteger)selectedIndex selectedBlock:(void(^)(NSUInteger index))selectedBlock;

- (void)updateFilterImages:(NSArray *)filterImages;

- (void)setSelectedIndex:(NSUInteger)index scrollable:(BOOL)scrollable;

@end
