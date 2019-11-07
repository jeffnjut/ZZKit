//
//  FJPhotoEditFilterGenreView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/8.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"

@interface FJPhotoEditFilterGenreView : UIView

@property (nonatomic, strong, readonly) UIButton *button;

+ (FJPhotoEditFilterGenreView *)create:(CGRect)frame image:(UIImage *)image title:(NSString *)title selected:(BOOL)selected;

- (void)updateSelected:(BOOL)selected;

- (void)updateFilterImage:(UIImage *)filterImage;

@end
