//
//  ZZPhotoImageTagView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/5.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoTag.h"

@interface ZZPhotoImageTagView : UIView

@property (nonatomic, weak, readwrite) IBOutlet NSLayoutConstraint *textLabelConstraint;

// 创建ZZPhotoImageTagView
+ (ZZPhotoImageTagView *)create:(CGPoint)point containerSize:(CGSize)containerSize model:(ZZPhotoTag *)model fixEdge:(BOOL)fixEdge autoChangeDirection:(BOOL)autoChangeDirection tapBlock:(void(^)(__weak ZZPhotoImageTagView *photoImageTagView))tapBlock movingBlock:(void(^)(UIGestureRecognizerState state, CGPoint point, ZZPhotoImageTagView *imageTagView))movingBlock;

// 创建ZZPhotoImageTagView（Scale）
+ (ZZPhotoImageTagView *)create:(CGPoint)point containerSize:(CGSize)containerSize model:(ZZPhotoTag *)model scale:(CGFloat)scale fixEdge:(BOOL)fixEdge autoChangeDirection:(BOOL)autoChangeDirection tapBlock:(void(^)(__weak ZZPhotoImageTagView *photoImageTagView))tapBlock movingBlock:(void(^)(UIGestureRecognizerState state, CGPoint point, ZZPhotoImageTagView *imageTagView))movingBlock;

- (void)reverseDirection;

- (ZZPhotoTag *)getTagModel;

// 根据文件计算ImageTagView的宽度
+ (CGFloat)getPhotoImageTagViewWidth:(NSString *)text;

@end
