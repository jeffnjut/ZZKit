//
//  UIView+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIView+ZZKit.h"
#import "UIView+ZZKit_Blocks.h"
#import "UIControl+ZZKit_Blocks.h"
#import "NSString+ZZKit.h"
#import "NSAttributedString+ZZKit.h"

#pragma mark - Geometry方法

// CGRect转换成CGPoint
CGPoint CGRectGetCenter(CGRect rect) {
    
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

// CGRect移动到CGPoint中心点
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) {
    
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ZZKit)

#pragma mark - Geometry

/**
 *  获取UIView属性 - 原点
 */
- (CGPoint)zzOrigin {
    
    return self.frame.origin;
}

/**
 *  设置UIView属性 - 原点
 */
- (void)setZzOrigin:(CGPoint)zzOrigin {
    
    CGRect newframe = self.frame;
    newframe.origin = zzOrigin;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 尺寸
 */
- (CGSize)zzSize {
    
    return self.frame.size;
}

/**
 *  设置UIView属性 - 尺寸
 */
- (void)setZzSize:(CGSize)zzSize {
    
    CGRect newframe = self.frame;
    newframe.size = zzSize;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 高度
 */
- (CGFloat)zzHeight {
    
    return self.frame.size.height;
}

/**
 *  设置UIView属性 - 高度
 */
- (void)setZzHeight:(CGFloat)zzHeight {
    
    CGRect newframe = self.frame;
    newframe.size.height = zzHeight;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 宽度
 */
- (CGFloat)zzWidth {
    
    return self.frame.size.width;
}

/**
 *  设置UIView属性 - 宽度
 */
- (void)setZzWidth:(CGFloat)zzWidth {
    
    CGRect newframe = self.frame;
    newframe.size.width = zzWidth;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 顶边
 */
- (CGFloat)zzTop {
    
    return self.frame.origin.y;
}

/**
 *  设置UIView属性 - 顶边
 */
- (void)setZzTop:(CGFloat)zzTop {
    
    CGRect newframe = self.frame;
    newframe.origin.y = zzTop;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 左边
 */
- (CGFloat)zzLeft {
    
    return self.frame.origin.x;
}

/**
 *  设置UIView属性 - 左边
 */
- (void)setZzLeft:(CGFloat)zzLeft {
    
    CGRect newframe = self.frame;
    newframe.origin.x = zzLeft;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 底边
 */
- (CGFloat)zzBottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

/**
 *  设置UIView属性 - 底边
 */
- (void)setZzBottom:(CGFloat)zzBottom {
    
    CGRect newframe = self.frame;
    newframe.origin.y = zzBottom - self.frame.size.height;
    self.frame = newframe;
}

/**
 *  获取UIView属性 - 右边
 */
- (CGFloat)zzRight {
    
    return self.frame.origin.x + self.frame.size.width;
}

/**
 *  设置UIView属性 - 右边
 */
- (void)setZzRight:(CGFloat)zzRight {
    
    CGFloat delta = zzRight - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

/**
 *  获取UIView属性：Center
 */
- (CGPoint)zzCenter {
    
    return self.center;
}

/**
 *  设置UIView属性：Center
 */
- (void)setZzCenter:(CGPoint)zzCenter {
    
    self.center = zzCenter;
}

/**
 *  获取UIView属性 - 底左边
 */
- (CGPoint)zzBottomLeft {
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

/**
 *  获取UIView属性 - 底右边
 */
- (CGPoint)zzBottomRight {
    
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

/**
 *  获取UIView属性 - 上左边
 */
- (CGPoint)zzTopLeft {
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

/**
 *  获取UIView属性 - 上右边
 */
- (CGPoint)zzTopRight {
    
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

/**
 *  移动Offset单位
 */
- (void)zz_moveBy:(CGPoint)delta {
    
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

/**
 *  比例扩大缩小
 */
- (void)zz_scaleBy:(CGFloat)scaleFactor {
    
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

/**
 *  保证适合Size
 */
- (void)zz_fitInSize:(CGSize)aSize {
    
    CGFloat scale;
    CGRect newframe = self.frame;
    if (newframe.size.height && (newframe.size.height > aSize.height)) {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width)) {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    self.frame = newframe;
}

/**
 *  判断自身是否在其它视图中
 */
- (BOOL)zz_isInAnotherView:(nonnull UIView *)anotherView {
    
    CGRect rect = [self convertRect:self.frame toView:anotherView];
    if (CGRectIntersectsRect(anotherView.frame, rect)) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - Find View

/**
 *  根据Class查找UIView
 */
- (nullable __kindof UIView*)zz_findView:(nonnull Class)cls {
    
    if (cls == nil) {
        return nil;
    }
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        if ([next isKindOfClass:cls]) {
            return next;
        }else {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:cls]) {
                return (UIView *)nextResponder;
            }
        }
    }
    return nil;
}

#pragma mark - Layer

/**
 *  设置圆形
 */
- (void)zz_round {
    
    [self zz_roundWithBorderWidth:0 borderColor:nil];
}

/**
 *  设置圆形（边宽、颜色）
 */
- (void)zz_roundWithBorderWidth:(CGFloat)width borderColor:(nullable UIColor *)color {
    
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat r = 0.0f;
    if (w >= h) {
        r = w / 2.0f;
    }else {
        r = h / 2.0f;
    }
    [self zz_cornerRadius:r borderWidth:width boderColor:color];
}

/**
 *  设置圆角（角度）
 */
- (void)zz_cornerRadius:(CGFloat)radius {
    
    [self zz_cornerRadius:radius borderWidth:0.0 boderColor:nil];
}

/**
 *  设置圆角（角度，边宽，颜色）
 */
- (void)zz_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width boderColor:(nullable UIColor *)color {
    
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

/**
 *  设置边框（边宽，颜色）
 */
- (void)zz_borderWidth:(CGFloat)width boderColor:(nullable UIColor *)color {
    
    [self zz_cornerRadius:0.0 borderWidth:width boderColor:color];
}

/**
 *  Shadow方法（radius和skecth中的blur是对应的）
 *  微调：降低opacity,提高radius；或者提高opacity，降低radius
 */
- (void)zz_shadowOffset:(CGSize)offset color:(nullable UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius {
    
    // add shadow (use shadowPath to improve rendering performance)
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

#pragma mark - Quick UI

/**
 *  快速创建Button（常规）
 */
- (nonnull UIButton *)zz_quickAddButton:(nullable NSString *)buttonTitle titleColor:(nullable UIColor *)titleColor font:(nullable UIFont *)font backgroundColor:(nullable UIColor *)backgroundColor frame:(CGRect)frame makeConstraint:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock touchupInsideBlock:(nullable void(^)(UIButton *sender))touchupInsideBlock {
    
    return [self zz_quickAddButton:buttonTitle titleColor:titleColor font:font backgroundColor:backgroundColor borderColor:nil borderWidth:0 cornerRadius:0 frame:frame makeConstraint:constraintBlock touchupInsideBlock:touchupInsideBlock];
}

/**
 *  快速创建Button（完整）
 */
- (nonnull UIButton *)zz_quickAddButton:(nullable NSString *)buttonTitle titleColor:(nullable UIColor *)titleColor font:(nullable UIFont *)font backgroundColor:(nullable UIColor *)backgroundColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius frame:(CGRect)frame makeConstraint:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock touchupInsideBlock:(nullable void(^)(UIButton *sender))touchupInsideBlock {
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [self addSubview:button];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.backgroundColor = backgroundColor;
    [button zz_cornerRadius:cornerRadius borderWidth:borderWidth boderColor:borderColor];
    if (touchupInsideBlock) {
        [button zz_tapBlock:UIControlEventTouchUpInside block:touchupInsideBlock];
    }
    return button;
}

/**
 *  快速创建Line
 */
- (nonnull UIView *)zz_quickAddLine:(nullable UIColor *)color frame:(CGRect)frame makeConstraint:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock {
    
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:lineView];
    if (color == nil) {
        // 默认颜色
        lineView.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:230.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
    }else {
        lineView.backgroundColor = color;
    }
    if (constraintBlock != nil) {
        __weak typeof(self) weakSelf = self;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            constraintBlock(weakSelf, make);
        }];
    }
    return lineView;
}

/**
 *  快速创建Label
 */
- (nonnull UILabel *)zz_quickAddLabel:(nullable NSString *)text font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment perLineHeight:(CGFloat)perLineHeight kern:(CGFloat)kern space:(CGFloat)space lineBreakmode:(NSLineBreakMode)lineBreakmode attributedText:(nullable NSAttributedString *)attributedText needCalculateTextFrame:(BOOL)needCalculateTextFrame backgroundColor:(nullable UIColor *)backgroundColor frame:(CGRect)frame makeConstraint:(nullable BOOL(^)(UIView * _Nonnull superView, CGSize renderedSize, MASConstraintMaker * _Nonnull make))constraintBlock {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [self addSubview:label];
    label.numberOfLines = numberOfLines;
    label.backgroundColor = backgroundColor;
    __block CGSize renderSize = frame.size;
    NSAttributedString *_attributedText = nil;
    if (attributedText != nil) {
        _attributedText = attributedText;
    }else if (text != nil) {
        NSMutableDictionary *attributedDict = [[NSMutableDictionary alloc] init];
        if (font) {
            [attributedDict setObject:font forKey:NSFontAttributeName];
        }
        if (textColor) {
            [attributedDict setObject:textColor forKey:NSForegroundColorAttributeName];
        }
        [attributedDict setObject:@(kern) forKey:NSKernAttributeName];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = lineBreakmode;
        style.lineSpacing = space;
        if (perLineHeight > 0) {
            style.minimumLineHeight = perLineHeight;
            style.maximumLineHeight = perLineHeight;
        }
        style.alignment = textAlignment;
        [attributedDict setObject:style forKey:NSParagraphStyleAttributeName];
        _attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributedDict];
    }
    label.attributedText = _attributedText;
    if (needCalculateTextFrame) {
        renderSize = [_attributedText zz_size:renderSize enableCeil:YES];
    }
    if (constraintBlock != nil) {
        __weak typeof(self) weakSelf = self;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (constraintBlock(weakSelf, renderSize, make) == NO) {
                make.left.equalTo(weakSelf.mas_left).offset(frame.origin.x);
                make.top.equalTo(weakSelf.mas_top).offset(frame.origin.y);
                make.width.mas_equalTo(frame.size.width);
                make.height.mas_equalTo(frame.size.height);
            }
        }];
    }
    return label;
}

@end
