//
//  UIView+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZZKit)

#pragma mark - Geometry

// UIView属性：Origin
@property CGPoint zzOrigin;

// UIView属性：Size
@property CGSize  zzSize;

// UIView属性：Height
@property CGFloat zzHeight;

// UIView属性：Width
@property CGFloat zzWidth;

// UIView属性：Top
@property CGFloat zzTop;

// UIView属性：Left
@property CGFloat zzLeft;

// UIView属性：Bottom
@property CGFloat zzBottom;

// UIView属性：Right
@property CGFloat zzRight;

// UIView属性：Center
@property CGPoint zzCenter;

// UIView属性：Bottom Left
@property (readonly) CGPoint zzBottomLeft;

// UIView属性：Bottom Right
@property (readonly) CGPoint zzBottomRight;

// UIView属性：Top Left
@property (readonly) CGPoint zzTopLeft;

// UIView属性：Top Right
@property (readonly) CGPoint zzTopRight;

/**
 *  移动Offset单位
 */
- (void)zz_moveBy:(CGPoint)delta;

/**
 *  比例扩大缩小
 */
- (void)zz_scaleBy:(CGFloat)scaleFactor;

/**
 *  保证适合Size
 */
- (void)zz_fitInSize:(CGSize)aSize;

/**
 *  判断自身是否在其它视图中
 */
- (BOOL)zz_isInAnotherView:(nonnull UIView *)anotherView;

#pragma mark - Find View

/**
 *  根据Class查找UIView
 */
- (nullable __kindof UIView *)zz_findView:(nonnull Class)cls;

/**
 *  根据Class查找UIViewController
 */
- (nullable __kindof UIViewController *)zz_findViewController:(nonnull Class)cls;

#pragma mark - Layer

/**
 *  设置圆形
 */
- (void)zz_round;

/**
 *  设置圆形（边宽、颜色）
 */
- (void)zz_roundWithBorderWidth:(CGFloat)width borderColor:(nullable UIColor *)color;

/**
 *  设置圆角（角度）
 */
- (void)zz_cornerRadius:(CGFloat)radius;

/**
 *  设置圆角（角度，边宽，颜色）
 */
- (void)zz_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width boderColor:(nullable UIColor *)color;

/**
 *  设置边框（边宽，颜色）
 */
- (void)zz_borderWidth:(CGFloat)width boderColor:(nullable UIColor *)color;

/**
 *  Shadow方法（radius和skecth中的blur是对应的）
 *  微调：降低opacity,提高radius；或者提高opacity，降低radius
 */
- (void)zz_shadowOffset:(CGSize)offset color:(nullable UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius;


#pragma mark - Quick UI

/**
 *  快速创建Button（常规）
 */
- (nonnull UIButton *)zz_quickAddButton:(nullable NSString *)buttonTitle
                             titleColor:(nullable UIColor *)titleColor
                                   font:(nullable UIFont *)font
                        backgroundColor:(nullable UIColor *)backgroundColor
                                  frame:(CGRect)frame
                        constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock
                     touchupInsideBlock:(nullable void(^)(UIButton *sender))touchupInsideBlock;

/**
 *  快速创建Button（完整）
 */
- (nonnull UIButton *)zz_quickAddButton:(nullable NSString *)buttonTitle
                             titleColor:(nullable UIColor *)titleColor
                                   font:(nullable UIFont *)font
                        backgroundColor:(nullable UIColor *)backgroundColor
                            borderColor:(nullable UIColor *)borderColor
                            borderWidth:(CGFloat)borderWidth
                           cornerRadius:(CGFloat)cornerRadius
                                  frame:(CGRect)frame
                        constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock touchupInsideBlock:(nullable void(^)(UIButton *sender))touchupInsideBlock;

/**
 *  快速创建Line
 */
- (nonnull UIView *)zz_quickAddLine:(nullable UIColor *)color
                              frame:(CGRect)frame
                    constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock;

/**
 *  快速创建Label
 */
- (nonnull UILabel *)zz_quickAddLabel:(nullable NSString *)text
                                 font:(nullable UIFont *)font
                            textColor:(nullable UIColor *)textColor
                        numberOfLines:(NSInteger)numberOfLines
                        textAlignment:(NSTextAlignment)textAlignment
                        perLineHeight:(CGFloat)perLineHeight
                                 kern:(CGFloat)kern
                                space:(CGFloat)space
                        lineBreakmode:(NSLineBreakMode)lineBreakmode
                       attributedText:(nullable NSAttributedString *)attributedText
               needCalculateTextFrame:(BOOL)needCalculateTextFrame
                      backgroundColor:(nullable UIColor *)backgroundColor
                                frame:(CGRect)frame
                      constraintBlock:(nullable BOOL(^)(UIView * _Nonnull superView, CGSize renderedSize, MASConstraintMaker * _Nonnull make))constraintBlock;

@end

NS_ASSUME_NONNULL_END
