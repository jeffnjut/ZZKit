//
//  ZZWidgetSwitch.m
//  ZZKit
//
//  Created by Fu Jie on 2020/3/17.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "ZZWidgetSwitch.h"
#import "UIView+ZZKit.h"

@interface ZZWidgetSwitch ()

@property (nonatomic, strong) UILabel *roundView;

@property (nonatomic, strong) UILabel *leftView;

@property (nonatomic, strong) UILabel *rightView;

@end

@implementation ZZWidgetSwitch

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self _buildUI:NO offBackgroundColor:[UIColor whiteColor] onBackgroundColor:[UIColor whiteColor] roundColor:[UIColor whiteColor] roundToBackgroundMargin:0 animation:NO beforeSwitchBlock:nil switchBlock:nil];
}

+ (ZZWidgetSwitch *)create:(CGRect)frame isOn:(BOOL)isOn offBackgroundColor:(nonnull UIColor *)offBackgroundColor onBackgroundColor:(nonnull UIColor *)onBackgroundColor roundColor:(nonnull UIColor *)roundColor roundToBackgroundMargin:(CGFloat)roundToBackgroundMargin animation:(BOOL)animation beforeSwitchBlock:(nullable BOOL(^)(BOOL isOn))beforeSwitchBlock switchBlock:(nullable void(^)(BOOL isOn))switchBlock {
    
    ZZWidgetSwitch *view = [[ZZWidgetSwitch alloc] initWithFrame:frame];
    [view _buildUI:isOn offBackgroundColor:offBackgroundColor onBackgroundColor:onBackgroundColor roundColor:roundColor roundToBackgroundMargin:roundToBackgroundMargin animation:animation beforeSwitchBlock:beforeSwitchBlock switchBlock:switchBlock];
    return view;
}

- (void)_buildUI:(BOOL)isOn offBackgroundColor:(nonnull UIColor *)offBackgroundColor onBackgroundColor:(nonnull UIColor *)onBackgroundColor roundColor:(nonnull UIColor *)roundColor roundToBackgroundMargin:(CGFloat)roundToBackgroundMargin animation:(BOOL)animation beforeSwitchBlock:(nullable BOOL(^)(BOOL isOn))beforeSwitchBlock switchBlock:(nullable void(^)(BOOL isOn))switchBlock {
    
    if (self.zzWidth < self.zzHeight) {
        NSAssert(NO, @"ZZWidgetSwitch 宽不能小于高");
        return;
    }
    
    // self.leftView = [[UILabel alloc] initWithFrame:self.bounds];
    self.rightView = [[UILabel alloc] initWithFrame:self.bounds];
    self.roundView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height - roundToBackgroundMargin * 2.0, self.bounds.size.height - roundToBackgroundMargin * 2.0)];
    self.roundView.backgroundColor = roundColor;
    // [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [self addSubview:self.roundView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(_tap) forControlEvents:UIControlEventTouchUpInside];
    
    self.beforeSwitchBlock = beforeSwitchBlock;
    
    self.switchBlock = switchBlock;
    
    self.animation = animation;
    
    self.offBackgroundColor = offBackgroundColor;
    
    self.onBackgroundColor = onBackgroundColor;
    
    self.roundToBackgroundMargin = roundToBackgroundMargin;
    
    [self zz_cornerRadius:self.zzHeight / 2.0];
    [self.roundView zz_round];
    
    self.isOn = isOn;
}

- (void)setRoundColor:(UIColor *)roundColor {
    
    _roundColor = roundColor;
    self.roundView.backgroundColor = roundColor;
}

- (void)setRoundToBackgroundMargin:(CGFloat)roundToBackgroundMargin {
    
    _roundToBackgroundMargin = roundToBackgroundMargin;
    self.roundView.zzWidth = self.zzHeight - roundToBackgroundMargin * 2.0;
    self.roundView.zzHeight = self.roundView.zzWidth;
    [self.roundView zz_round];
}

- (void)setIsOn:(BOOL)isOn {
    
    _isOn = isOn;
    if (_animation) {
        
    }else {
        
        BOOL can = YES;
        if (self.beforeSwitchBlock) {
            can = self.beforeSwitchBlock(isOn);
        }
        if (can) {
            
            [self enforceUpdateIsOn:isOn];
            
            self.switchBlock == nil ? : self.switchBlock(self.isOn);
            
        }else {
            _isOn = !isOn;
        }
    }
}

- (void)enforceUpdateIsOn:(BOOL)isOn {
    
    _isOn = isOn;
    if (_animation) {
        
    }else {
        
        if (isOn) {
            
            self.roundView.zzRight = self.zzWidth - self.roundToBackgroundMargin;
            self.roundView.zzTop = self.roundToBackgroundMargin;
            self.rightView.backgroundColor = self.onBackgroundColor;
        }else {
            
            self.roundView.zzLeft = self.roundToBackgroundMargin;
            self.roundView.zzTop = self.roundToBackgroundMargin;
            self.rightView.backgroundColor = self.offBackgroundColor;
        }
    }
    
}

- (void)_tap {
    
    self.isOn = !self.isOn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
