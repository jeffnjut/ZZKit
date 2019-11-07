//
//  FJTakePhotoView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/21.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJTakePhotoView : UIView

+ (FJTakePhotoView *)create:(CGRect)frame takeButtonSize:(CGSize)takeButtonSize strokeColor:(UIColor *)strokeColor strokeWidth:(CGFloat)strokeWidth longTapPressDuration:(CGFloat)longTapPressDuration circleDuration:(CGFloat)circleDuration type:(int)type tapBlock:(void(^)(void))tapBlock longPressBlock:(void(^)(BOOL begin))longPressBlock;

@end
