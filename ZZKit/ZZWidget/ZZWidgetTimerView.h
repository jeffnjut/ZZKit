//
//  ZZWidgetTimerView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZWidgetTimerView : UIView

// "跳过"的富文本文案
@property (nonatomic, strong) NSAttributedString *zzSkipText;

// “跳过”文案的偏移属性
@property (nonatomic, assign) UIOffset zzSkipTextOffset;

// 倒计时的格式化文案，例如 @"还剩%d秒"
@property (nonatomic, strong) NSString *zzFormattedTimeText;

// 倒计时时间的富文本属性
@property (nonatomic, strong) NSDictionary *zzTimeTextAttibutes;

// 倒计时时间的偏移属性
@property (nonatomic, assign) UIOffset zzTimeTextOffset;

@property (nonatomic, strong, readonly) UILabel *labelSkip;
@property (nonatomic, strong, readonly) UILabel *labelTime;

/**
 *  创建倒计时View
 */
+ (ZZWidgetTimerView *)zz_quickAdd:(BOOL)reverse time:(CGFloat)time onView:(nullable UIView *)onView backgroundColor:(nullable UIColor *)backgroundColor borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor circleLineWidth:(CGFloat)circleLineWidth circleLineColor:(nullable UIColor *)circleLineColor circleLineFillColor:(nullable UIColor *)circleLineFillColor circleLineMargin:(CGFloat)circleLineMargin frame:(CGRect)frame tapBlock:(nullable void(^)(ZZWidgetTimerView *zzWidgetTimerView))tapBlock completionBlock:(nullable void(^)(ZZWidgetTimerView *zzWidgetTimerView))completionBlock;

/**
 *  开始计时
 */
- (void)zz_start;

/**
 *  开始计时
 */
- (void)zz_start:(void(^)(ZZWidgetTimerView *zzWidgetTimerView))completion;

@end

NS_ASSUME_NONNULL_END
