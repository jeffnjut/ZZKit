//
//  ZZPhotoEditTitleScrollView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPhotoEditTitleScrollView : UIView

+ (ZZPhotoEditTitleScrollView *)create:(NSUInteger)count;

- (void)updateTitle:(NSString *)title;

- (void)updateCount:(NSUInteger)count;

- (void)updateIndex:(NSUInteger)index;

- (NSUInteger)currentIndex;

- (void)setPageControllHidden:(BOOL)hidden;

@end
