//
//  FJPhotoImageTagView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/5.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJImageTagModel.h"

@interface FJPhotoImageTagView : UIView

@property (nonatomic, weak, readwrite) IBOutlet NSLayoutConstraint *textLabelConstraint;

// 创建FJPhotoImageTagView
+ (FJPhotoImageTagView *)create:(CGPoint)point containerSize:(CGSize)containerSize model:(FJImageTagModel *)model fixEdge:(BOOL)fixEdge autoChangeDirection:(BOOL)autoChangeDirection tapBlock:(void(^)(__weak FJPhotoImageTagView *photoImageTagView))tapBlock movingBlock:(void(^)(UIGestureRecognizerState state, CGPoint point, FJPhotoImageTagView *imageTagView))movingBlock;

// 创建FJPhotoImageTagView（Scale）
+ (FJPhotoImageTagView *)create:(CGPoint)point containerSize:(CGSize)containerSize model:(FJImageTagModel *)model scale:(CGFloat)scale fixEdge:(BOOL)fixEdge autoChangeDirection:(BOOL)autoChangeDirection tapBlock:(void(^)(__weak FJPhotoImageTagView *photoImageTagView))tapBlock movingBlock:(void(^)(UIGestureRecognizerState state, CGPoint point, FJPhotoImageTagView *imageTagView))movingBlock;

- (void)reverseDirection;

- (FJImageTagModel *)getTagModel;

// 根据文件计算ImageTagView的宽度
+ (CGFloat)getPhotoImageTagViewWidth:(NSString *)text;

@end
