//
//  ZZWidgetPinCodeView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetPinCodeView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Typeset/Typeset.h>
#import "NSString+ZZKit.h"
#import "NSAttributedString+ZZKit.h"

#pragma mark - Line

@interface NormalLine : UIView

@end

@implementation NormalLine

@end

@interface HighlightedLine : UIView

@end

@implementation HighlightedLine

@end

#pragma mark - ZZWidgetNoPasteTextField

@implementation ZZWidgetNoPasteTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    // 整体禁用
    /*
     UIMenuController *menuController = [UIMenuController sharedMenuController];
     if (menuController) {
     [UIMenuController sharedMenuController].menuVisible = NO;
     }
     return NO;
     */
    
    if (action == @selector(paste:))
        //禁止粘贴
        return NO;
    if (action == @selector(select:))
        // 禁止选择
        return NO;
    if (action == @selector(selectAll:))
        // 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end

#pragma mark - ZZWidgetPinCodeView

@interface ZZWidgetPinCodeView ()

@property (nonatomic, assign) NSInteger itemNumber;
@property (nonatomic, assign) NSInteger itemGap;
@property (nonatomic, strong) UIColor *normalUnderLineColor;
@property (nonatomic, strong) UIColor *highlightedUnderLineColor;
@property (nonatomic, assign) CGFloat normalUnderLineWidth;
@property (nonatomic, assign) CGFloat highlightedUnderLineWidth;
@property (nonatomic, strong) UIColor *pinTextColor;
@property (nonatomic, strong) UIFont  *pinTextFont;
@property (nonatomic, strong) ZZWidgetNoPasteTextField *textField;
@property (nonatomic, strong) UILabel *labelText;

@property (nonatomic, copy) NSString *text;

@end

@implementation ZZWidgetPinCodeView

/**
 * 创建ZZWidgetPinCodeView
 */
+ (ZZWidgetPinCodeView *)zz_createPinCodeTextView:(CGRect)frame itemNumber:(NSInteger)itemNumber itemGap:(CGFloat)itemGap pinTextColor:(nullable UIColor *)pinTextColor pinTextFont:(nullable UIFont *)pinTextFont normalUnderLineColor:(nullable UIColor *)normalUnderLineColor normalUnderLineWidth:(CGFloat)normalUnderLineWidth highlightedUnderLineColor:(nullable UIColor *)highlightedUnderLineColor highlightedUnderLineWidth:(CGFloat)highlightedUnderLineWidth {
    
    ZZWidgetPinCodeView *view = [[ZZWidgetPinCodeView alloc] initWithFrame:frame];
    view.itemNumber = itemNumber;
    view.itemGap = itemGap;
    view.normalUnderLineColor = normalUnderLineColor;
    view.highlightedUnderLineColor = highlightedUnderLineColor;
    view.normalUnderLineWidth = normalUnderLineWidth;
    view.highlightedUnderLineWidth = highlightedUnderLineWidth;
    view.pinTextFont = pinTextFont;
    view.pinTextColor = pinTextColor;
    [view _buildUI];
    return view;
}

- (void)_buildUI {
    
    CGFloat itemWidth = (self.frame.size.width - (self.itemNumber - 1.0) * self.itemGap) / self.itemNumber;
    CGFloat itemHeight = self.frame.size.height;
    CGFloat itemOriginX = 0;
    CGFloat oneNumberWidth = [@"1234567890".typeset.font(self.pinTextFont.fontName, self.pinTextFont.pointSize).string zz_width:MAXFLOAT] / 10.0;
    for (int i = 0 ; i < self.itemNumber; i++) {
        
        itemOriginX = (itemWidth + self.itemGap) * i;
        
        NormalLine *normalLine = [[NormalLine alloc] initWithFrame:CGRectMake(itemOriginX, itemHeight - self.normalUnderLineWidth, itemWidth, self.normalUnderLineWidth)];
        normalLine.backgroundColor = self.normalUnderLineColor;
        normalLine.tag = i;
        [self addSubview:normalLine];
        
        HighlightedLine *highlightedLine = [[HighlightedLine alloc] initWithFrame:CGRectMake(itemOriginX, itemHeight - self.highlightedUnderLineWidth, itemWidth, self.highlightedUnderLineWidth)];
        highlightedLine.backgroundColor = self.highlightedUnderLineColor;
        highlightedLine.tag = i;
        [self addSubview:highlightedLine];
        if (i > 0) {
            highlightedLine.hidden = YES;
        }
    }
    ZZWidgetNoPasteTextField *tf = [[ZZWidgetNoPasteTextField alloc] initWithFrame:self.bounds];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake((itemWidth - oneNumberWidth) / 2.0, 0, self.frame.size.width + 100.0, self.frame.size.height)];
    tf.font = self.pinTextFont;
    tf.textColor = [UIColor clearColor];
    tf.textAlignment = NSTextAlignmentLeft;
    tf.tintColor = [UIColor clearColor];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:tf];
    [self addSubview:lb];
    [tf becomeFirstResponder];
    
    self.textField = tf;
    self.labelText = lb;
    
    __weak typeof(self) weakSelf = self;
    [[self.textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(ZZWidgetNoPasteTextField *tf) {
        NSString *text = nil;
        if (tf.text.length >= weakSelf.itemNumber) {
            text = [tf.text substringToIndex:weakSelf.itemNumber];
        }else if (tf.text.length > 0) {
            text = tf.text;
        }
        if (text.length >= 1) {
            CGFloat oneNumberWidth = [weakSelf.textField.text.typeset.font(weakSelf.pinTextFont.fontName, weakSelf.pinTextFont.pointSize).string zz_width:MAXFLOAT] / weakSelf.textField.text.length;
            CGFloat kern = (weakSelf.textField.frame.size.width - itemWidth - oneNumberWidth * 5.0) / 5.0;
            weakSelf.textField.text = text;
            weakSelf.labelText.attributedText = text.typeset.font(weakSelf.pinTextFont.fontName, weakSelf.pinTextFont.pointSize).color(weakSelf.pinTextColor).kern(kern).string;
            [weakSelf _setTfHighlighted:text.length - 1];
            weakSelf.text = text;
        }else {
            weakSelf.labelText.attributedText = nil;
            [weakSelf _setTfHighlighted:-1];
        }
    }];
}


- (void)_setTfHighlighted:(NSInteger)index {
    
    if (index >= self.itemNumber) {
        return;
    }
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[HighlightedLine class]]) {
            HighlightedLine *line = subView;
            if (line.tag <= index) {
                line.hidden = NO;
            }else {
                line.hidden = YES;
            }
        }
    }
}

- (ZZWidgetNoPasteTextField *)_getTf:(NSInteger)index {
    
    for (ZZWidgetNoPasteTextField *tf in self.subviews) {
        if ([tf isKindOfClass:[ZZWidgetNoPasteTextField class]]) {
            if (tf.tag == index) {
                return tf;
            }
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

