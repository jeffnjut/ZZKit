//
//  ZZWidgetPinCodeView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ZZWidgetNoPasteTextField

@interface ZZWidgetNoPasteTextField : UITextField

@end

#pragma mark - ZZWidgetPinCodeView

@interface ZZWidgetPinCodeView : UIView

@property (nonatomic, copy, readonly) NSString *text;

/**
 * 创建ZZWidgetPinCodeView
 */
+ (ZZWidgetPinCodeView *)zz_createPinCodeTextView:(CGRect)frame itemNumber:(NSInteger)itemNumber itemGap:(CGFloat)itemGap pinTextColor:(nullable UIColor *)pinTextColor pinTextFont:(nullable UIFont *)pinTextFont normalUnderLineColor:(nullable UIColor *)normalUnderLineColor normalUnderLineWidth:(CGFloat)normalUnderLineWidth highlightedUnderLineColor:(nullable UIColor *)highlightedUnderLineColor highlightedUnderLineWidth:(CGFloat)highlightedUnderLineWidth;

@end

NS_ASSUME_NONNULL_END
