//
//  ZZSegmentView.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/5.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ZZSegmentView.h"

#define IndicatorW (18.0)
#define IndicatorH (6.0)

@interface ZZSegmentView ()

@property (nonatomic, strong) NSNumber *fixedItems;
@property (nonatomic, strong) NSNumber *fixedItemWidth;
@property (nonatomic, strong) NSNumber *fixedPadding;
 
@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIFont *highlightedTextFont;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) NSMutableArray *titleViews;
@property (nonatomic, assign) NSUInteger currentIndex;

@property(nonatomic, copy) void(^selectedBlock)(NSUInteger index);

@end

@implementation ZZSegmentView

- (NSMutableArray *)titleViews {
    
    if (_titleViews == nil) {
        _titleViews = [[NSMutableArray alloc] init];
    }
    return _titleViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.highlightedTextColor = UIColor.blackColor;
        self.highlightedTextFont = [UIFont systemFontOfSize:21.0 weight:UIFontWeightBold];
        self.normalTextColor = UIColor.blackColor;
        self.normalTextFont = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
        self.indicatorColor = UIColor.redColor;
    }
    return self;
}

+ (ZZSegmentView *)create:(CGRect)frame
               fixedItems:(nullable NSNumber *)fixedItems
           fixedItemWidth:(nullable NSNumber *)fixedItemWidth
             fixedPadding:(nullable NSNumber *)fixedPadding
           normalTextFont:(nullable UIFont *)normalTextFont
          normalTextColor:(nullable UIColor *)normalTextColor
      highlightedTextFont:(nullable UIFont *)highlightedTextFont
     highlightedTextColor:(nullable UIColor *)highlightedTextColor
           indicatorColor:(nullable UIColor *)indicatorColor
                   titles:(nonnull NSArray *)titles
            selectedBlock:(void(^)(NSUInteger index))selectedBlock {
    
    ZZSegmentView *segmentView = [[ZZSegmentView alloc] initWithFrame:frame];
    [segmentView _build:fixedItems fixedItemWidth:fixedItemWidth fixedPadding:fixedPadding normalTextFont:normalTextFont normalTextColor:normalTextColor highlightedTextFont:highlightedTextFont highlightedTextColor:highlightedTextColor indicatorColor:indicatorColor titles:titles selectedBlock:selectedBlock];
    return segmentView;
}

- (void)_build:(nullable NSNumber *)fixedItems fixedItemWidth:(nullable NSNumber *)fixedItemWidth fixedPadding:(nullable NSNumber *)fixedPadding normalTextFont:(nullable UIFont *)normalTextFont normalTextColor:(nullable UIColor *)normalTextColor highlightedTextFont:(nullable UIFont *)highlightedTextFont highlightedTextColor:(nullable UIColor *)highlightedTextColor indicatorColor:(nullable UIColor *)indicatorColor titles:(nonnull NSArray *)titles selectedBlock:(void(^)(NSUInteger index))selectedBlock {
    
    self.backgroundColor = UIColor.whiteColor;
    self.fixedItems = fixedItems;
    self.fixedItemWidth = fixedItemWidth;
    self.fixedPadding = fixedPadding;
    self.selectedBlock = selectedBlock;
    self.normalTextFont = normalTextFont;
    self.normalTextColor = normalTextColor;
    self.highlightedTextFont = highlightedTextFont;
    self.highlightedTextColor = highlightedTextColor;
    
    if (fixedItems.integerValue > 0) {
        CGFloat labelH = self.frame.size.height - 3.0 - IndicatorH;
        CGFloat labelW = self.frame.size.width / fixedItems.integerValue;
        UILabel *lastLb = nil;
        for (int i = 0; i < titles.count; i++) {
            NSString *title = [titles objectAtIndex:i];
            UILabel *lb = [[UILabel alloc] init];
            if (lastLb == nil) {
                lb.frame = CGRectMake(0, 0, labelW, labelH);
            }else {
                lb.frame = CGRectMake(lastLb.frame.origin.x + lastLb.frame.size.width, lastLb.frame.origin.y, lastLb.frame.size.width, lastLb.frame.size.height);
            }
            lb.text = title;
            lb.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                lb.textColor = self.highlightedTextColor;
                lb.font = self.highlightedTextFont;
            }else {
                lb.textColor = self.normalTextColor;
                lb.font = self.normalTextFont;
            }
            lastLb = lb;
            [self addSubview:lastLb];
            [self.titleViews addObject:lastLb];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y, lb.frame.size.width, self.frame.size.height)];
            btn.tag = i;
            [self addSubview:btn];
            [btn addTarget:self action:@selector(_tap:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.indicator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - IndicatorH, IndicatorW, IndicatorH)];
    self.indicator.backgroundColor = self.indicatorColor;
    [self addSubview:self.indicator];
    
    UILabel *firstTitleLb = [self.titleViews zz_arrayObjectAtIndex:0];
    self.indicator.zzCenter = CGPointMake(firstTitleLb.zzCenter.x, self.indicator.zzCenter.y);
    self.currentIndex = 0;
}

- (void)_tap:(UIButton *)sender {
    
    [self selectIndex:sender.tag];
    self.selectedBlock == nil ? : self.selectedBlock(sender.tag);
}

- (void)selectIndex:(NSUInteger)index {
    
    if (self.currentIndex == index) {
        return;
    }
    // TODO KIWI
    UILabel *titleLb = [self.titleViews zz_arrayObjectAtIndex:index];
    self.indicator.zzCenter = CGPointMake(titleLb.zzCenter.x, self.indicator.zzCenter.y);
    self.currentIndex = index;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
