//
//  ZZWidgetSwitch.h
//  ZZKit
//
//  Created by Fu Jie on 2020/3/17.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZWidgetSwitch : UIView

@property (nonatomic, assign) BOOL animation;

@property (nonatomic, strong) UIColor *offBackgroundColor;

@property (nonatomic, strong) UIColor *onBackgroundColor;

@property (nonatomic, strong) UIColor *roundColor;

@property (nonatomic, assign) CGFloat roundToBackgroundMargin;

@property (nonatomic, copy) BOOL(^beforeSwitchBlock)(BOOL isOn);

@property (nonatomic, copy) void(^switchBlock)(BOOL isOn);

@property (nonatomic, assign) BOOL isOn;

+ (ZZWidgetSwitch *)create:(CGRect)frame isOn:(BOOL)isOn offBackgroundColor:(nonnull UIColor *)offBackgroundColor onBackgroundColor:(nonnull UIColor *)onBackgroundColor roundColor:(nonnull UIColor *)roundColor roundToBackgroundMargin:(CGFloat)roundToBackgroundMargin animation:(BOOL)animation beforeSwitchBlock:(nullable BOOL(^)(BOOL isOn))beforeSwitchBlock switchBlock:(nullable void(^)(BOOL isOn))switchBlock;

- (void)enforceUpdateIsOn:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_END
