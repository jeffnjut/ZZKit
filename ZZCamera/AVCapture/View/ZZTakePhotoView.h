//
//  ZZTakePhotoView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/21.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTakePhotoView : UIView

+ (ZZTakePhotoView *)create:(CGRect)frame takeButtonSize:(CGSize)takeButtonSize strokeColor:(UIColor *)strokeColor strokeWidth:(CGFloat)strokeWidth longTapPressDuration:(CGFloat)longTapPressDuration circleDuration:(CGFloat)circleDuration type:(int)type tapBlock:(void(^)(void))tapBlock longPressBlock:(void(^)(BOOL begin))longPressBlock;

@end
