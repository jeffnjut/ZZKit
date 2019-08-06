//
//  ZZWidgetTagView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetTagView.h"
#import "NSString+ZZKit.h"
#import "UIControl+ZZKit_Blocks.h"

#pragma mark - ZZWidgetTagView

#define DefaultHeight (20.0)

@interface ZZWidgetTagView()

@property (nonatomic, assign) ZZTagViewPattern _zzViewPattern;
@property (nonatomic, strong) ZZTagConfig *_zzTagConfig;
@property (nonatomic, strong) NSMutableArray<ZZTagModel *> *_zzTags;

@end

@implementation ZZWidgetTagView

- (instancetype)init
{
    NSAssert(FALSE, @"请使用initWithFrame:pattern:初始化");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    NSAssert(FALSE, @"请使用initWithFrame:pattern:初始化");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame pattern:(ZZTagViewPattern)pattern {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self._zzViewPattern = pattern;
    }
    return self;
}


- (NSMutableArray<ZZTagModel *> *)_zzTags {
    
    if (__zzTags == nil) {
        __zzTags = (NSMutableArray<ZZTagModel *> *)[[NSMutableArray alloc] init];
    }
    return __zzTags;
}

// 添加Tags
- (void)zz_addTags:(nonnull NSArray<ZZTagModel *> *)tags {
    
    [self zz_addTags:tags config:nil];
}

// 添加Tags(Config)
- (void)zz_addTags:(nonnull NSArray<ZZTagModel *> *)tags config:(nullable ZZTagConfig*)config {
    
    if (tags == nil || [tags count] == 0) {
        return;
    }
    [self._zzTags addObjectsFromArray:tags];
    if (config != nil) {
        self._zzTagConfig = config;
    }
}

// 插入Tags
- (void)zz_insertTag:(nonnull ZZTagModel *)tag atIndex:(NSUInteger)index {
    
    [self zz_insertTag:tag atIndex:index config:nil];
}

// 插入Tags(Config)
- (void)zz_insertTag:(nonnull ZZTagModel *)tag atIndex:(NSUInteger)index config:(nullable ZZTagConfig*)config {
    
    [__zzTags insertObject:tag atIndex:index];
    if (config != nil) {
        self._zzTagConfig = config;
    }
}

// 删除Tags(名称)
- (void)zz_removeTag:(nonnull ZZTagModel *)tag {
    
    [__zzTags removeObject:tag];
}

// 删除Tags(Index)
- (void)zz_removeTagAt:(NSUInteger)index {
    
    [__zzTags removeObjectAtIndex:index];
}

// 删除所有Tags
- (void)zz_removeAllTags {
    
    [__zzTags removeAllObjects];
}

// 获取TagCollectionView的大小
- (CGSize)zz_getTagViewSize {
    
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

// 获取所有Tags
- (NSArray<ZZTagModel *> *)zz_allTags {
    
    return __zzTags;
}

// 获取所有已选的Tags
- (NSArray<ZZTagModel *> *)zz_allSelectedTags {
    
    NSMutableArray *allSelectedTags = [[NSMutableArray alloc] init];
    for (ZZTagModel *model in __zzTags) {
        if (model.zzSelected == YES) {
            [allSelectedTags addObject:model];
        }
    }
    return (NSArray<ZZTagModel *> *)allSelectedTags;
}

// 刷新UI
// 自动根据设置的固定宽度调整高度
// 或者当设置固定高度后自动调节间距
// 带callback
- (CGSize)zz_refresh {
    
    CGSize size = CGSizeZero;
    if (__zzTagConfig == nil) {
        self._zzTagConfig = [[ZZTagConfig alloc] init];
    }
    // Clear UI
    for (UIButton *tagButton in [self subviews]) {
        [tagButton removeFromSuperview];
    }
    
    switch (self._zzViewPattern) {
        case ZZTagViewPatternFixedWidthDynamicHeight:
        {
            // 非固定高度
            CGFloat orgX = __zzTagConfig.zzEdgeInsets.left;
            CGFloat orgY = __zzTagConfig.zzEdgeInsets.top;
            CGFloat endX = self.bounds.size.width - __zzTagConfig.zzEdgeInsets.right;
            CGFloat eachX = orgX;
            CGFloat eachY = orgY;
            for (ZZTagModel *tag in self._zzTags) {
                ZZTextButton *btn = [self _tagButton:tag];
                if (btn.frame.size.width + eachX > endX) {
                    // 换行
                    eachX = orgX;
                    eachY = eachY + btn.bounds.size.height + __zzTagConfig.zzItemVerticalSpace;
                    btn.frame = CGRectMake(eachX, eachY, btn.frame.size.width, btn.frame.size.height);
                }else {
                    // 不换行
                    btn.frame = CGRectMake(eachX, eachY, btn.frame.size.width, btn.frame.size.height);
                }
                [self addSubview:btn];
                eachX += btn.bounds.size.width + __zzTagConfig.zzItemHorizontalSpace;
            }
            CGFloat currentHeight = (eachY + __zzTagConfig.zzItemMinHeight + __zzTagConfig.zzEdgeInsets.bottom);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, currentHeight);
            size.width = self.bounds.size.width;
            size.height = currentHeight;
            break;
        }
            
        case ZZTagViewPatternFixedHeightDynamicWidth:
        {
            // 非固定宽度
            CGFloat orgX = __zzTagConfig.zzEdgeInsets.left;
            CGFloat orgY = __zzTagConfig.zzEdgeInsets.top;
            CGFloat eachX = orgX;
            for (ZZTagModel *tag in self._zzTags) {
                ZZTextButton *btn = [self _tagButton:tag];
                btn.frame = CGRectMake(eachX, orgY, btn.frame.size.width, btn.frame.size.height);
                [self addSubview:btn];
                eachX += btn.bounds.size.width + __zzTagConfig.zzItemHorizontalSpace;
            }
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, eachX, self.bounds.size.height);
            size.width = eachX;
            size.height = self.bounds.size.height;
            break;
        }
            
        case ZZTagViewPatternFixedWidthFixedHeightVertical:
        {
            // 固定高度
            CGFloat orgX = __zzTagConfig.zzEdgeInsets.left;
            CGFloat orgY = __zzTagConfig.zzEdgeInsets.top;
            CGFloat endX = self.bounds.size.width - __zzTagConfig.zzEdgeInsets.right;
            CGFloat eachX = orgX;
            CGFloat eachY = orgY;
            int row = 0;
            for (ZZTagModel *tag in self._zzTags) {
                ZZTextButton *btn = [self _tagButton:tag];
                if (btn.frame.size.width + eachX > endX) {
                    // 换行
                    eachX = orgX;
                    eachY = eachY + btn.bounds.size.height;
                    btn.frame = CGRectMake(eachX, eachY, btn.frame.size.width, btn.frame.size.height);
                    row++;
                }else {
                    // 不换行
                    btn.frame = CGRectMake(eachX, eachY, btn.frame.size.width, btn.frame.size.height);
                }
                btn.tag = row;
                [self addSubview:btn];
                eachX += btn.bounds.size.width + __zzTagConfig.zzItemHorizontalSpace;
            }
            CGFloat currentHeight = (eachY + __zzTagConfig.zzItemMinHeight + __zzTagConfig.zzEdgeInsets.bottom);
            CGFloat fixedHeight = self.bounds.size.height;
            if (currentHeight > fixedHeight) {
                // 现有高度已经超出了固定高度，调整item各自高度
                // assert(@"现有高度已经超出了固定高度，调整item各自高度");
                CGFloat eachVerticalSpace = 2.0;
                CGFloat echItemHeight = (fixedHeight - __zzTagConfig.zzEdgeInsets.top - __zzTagConfig.zzEdgeInsets.bottom - (row + 2.0) * eachVerticalSpace) / (row + 1.0);
                for (ZZTextButton *btn in [self subviews]) {
                    btn.frame = CGRectMake(btn.frame.origin.x, __zzTagConfig.zzEdgeInsets.top + eachVerticalSpace + btn.tag * (eachVerticalSpace + echItemHeight), btn.frame.size.width, echItemHeight);
                }
            }else if(currentHeight < fixedHeight) {
                // 现有高度小于固定高度，调整item之间的间隔
                CGFloat eachVerticalSpace = (fixedHeight - currentHeight) / (row + 2.0);
                for (ZZTextButton *btn in [self subviews]) {
                    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y + (eachVerticalSpace * (1 + btn.tag)), btn.frame.size.width, btn.frame.size.height);
                }
            }
            size.width = self.bounds.size.width;
            size.height = fixedHeight;
            break;
        }
            
        case ZZTagViewPatternFixedWidthFixedHeightHorizontal:
        {
            break;
        }
            
        default:
            break;
    }
    
    // Debug
    if (__zzTagConfig.zzDebug) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.84 blue:0.38 alpha:1.0];
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(__zzTagConfig.zzEdgeInsets.left, __zzTagConfig.zzEdgeInsets.top, self.bounds.size.width - __zzTagConfig.zzEdgeInsets.left - __zzTagConfig.zzEdgeInsets.right, self.bounds.size.height - __zzTagConfig.zzEdgeInsets.top - __zzTagConfig.zzEdgeInsets.bottom)];
        [self insertSubview:v atIndex:0];
        v.backgroundColor = [UIColor colorWithRed:0.0 green:0.73 blue:0.98 alpha:1.0];
    }
    return size;
}

// 重置所有TagButton
- (void)zz_reset {
    
    for (ZZTextButton *textButton in self.subviews) {
        if ([textButton isKindOfClass:[ZZTextButton class]]) {
            [textButton zz_reset];
        }
    }
}

- (ZZTextButton*)_tagButton:(ZZTagModel *)tagModel {
    
    ZZTextButton *button = [[ZZTextButton alloc] initWithFrame:CGRectMake(0, 0, __zzTagConfig.zzItemMinWidth, __zzTagConfig.zzItemMinHeight)];
    button.zzTag = tagModel;
    [button zz_setTitle:tagModel.zzName selected:tagModel.zzSelected disabled:tagModel.zzDisabled config:__zzTagConfig];
    // 当numsPerRow设值
    if (__zzTagConfig.zzNumsPerRow > 0) {
        CGFloat itemWidth = (self.bounds.size.width - __zzTagConfig.zzEdgeInsets.left - __zzTagConfig.zzEdgeInsets.right - __zzTagConfig.zzItemHorizontalSpace * (__zzTagConfig.zzNumsPerRow - 1)) / __zzTagConfig.zzNumsPerRow;
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, itemWidth, button.frame.size.height);
    }else {
        CGFloat textWidth = [[tagModel zzName] zz_width:__zzTagConfig.zzTitleFont enableCeil:YES];
        CGFloat buttonWidth = textWidth + __zzTagConfig.zzItemTextPadding + __zzTagConfig.zzItemTextPadding;
        if (self._zzViewPattern == ZZTagViewPatternFixedHeightDynamicWidth) {
            if (buttonWidth >= __zzTagConfig.zzItemMinWidth) {
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, buttonWidth, button.frame.size.height);
            }else {
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, __zzTagConfig.zzItemMinWidth, button.frame.size.height);
            }
        }else {
            if (buttonWidth >= self.bounds.size.width - __zzTagConfig.zzEdgeInsets.left - __zzTagConfig.zzEdgeInsets.right) {
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, self.bounds.size.width - __zzTagConfig.zzEdgeInsets.left - __zzTagConfig.zzEdgeInsets.right, button.frame.size.height);
            }else if (buttonWidth >= __zzTagConfig.zzItemMinWidth) {
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, buttonWidth, button.frame.size.height);
            }else {
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, __zzTagConfig.zzItemMinWidth, button.frame.size.height);
            }
        }
    }
    // 设置事件
    __weak typeof(self) weakSelf = self;
    [button zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof ZZTextButton * _Nonnull sender) {
        if (weakSelf._zzTagConfig.zzEnableMultiTap) {
            sender.zzTag.zzSelected = !sender.zzTag.zzSelected;
            weakSelf.zzTagMultiTappedBlock == nil ? : weakSelf.zzTagMultiTappedBlock(sender.zzTag, [(ZZTextButton*)sender zz_selected]);
        }else {
            for (ZZTagModel *model in weakSelf._zzTags) {
                if ([model isEqual:sender.zzTag]) {
                    model.zzSelected = YES;
                }else {
                    model.zzSelected = NO;
                }
            }
            weakSelf.zzTagTappedBlock == nil ? : weakSelf.zzTagTappedBlock(sender.zzTag);
        }
    }];
    return button;
}

// 计算控件高度
+ (CGSize)zz_calculateSize:(CGFloat)width tags:(nonnull NSArray<ZZTagModel *> *)tags config:(nonnull ZZTagConfig*)config {
    
    CGFloat orgX = config.zzEdgeInsets.left;
    CGFloat orgY = config.zzEdgeInsets.top;
    CGFloat endX = width - config.zzEdgeInsets.right;
    CGFloat eachX = orgX;
    CGFloat eachY = orgY;
    for (ZZTagModel *tag in tags) {
        CGFloat buttonWidth = 0;
        // 当numsPerRow设值
        if (config.zzNumsPerRow > 0) {
            buttonWidth = (width - config.zzEdgeInsets.left - config.zzEdgeInsets.right - config.zzItemHorizontalSpace * (config.zzNumsPerRow - 1)) / config.zzNumsPerRow;
        }else {
            CGFloat textWidth = [tag.zzName zz_width:config.zzTitleFont enableCeil:YES];
            buttonWidth = textWidth + config.zzItemTextPadding + config.zzItemTextPadding;
            if (buttonWidth >= width) {
                buttonWidth = width - config.zzEdgeInsets.left - config.zzEdgeInsets.right - 1.0;
            }else if (buttonWidth >= config.zzItemMinWidth) {
                
            }else {
                buttonWidth = config.zzItemMinWidth;
            }
        }
        if (buttonWidth + eachX > endX) {
            // 换行
            eachX = orgX;
            eachY = eachY + config.zzItemMinHeight + config.zzItemVerticalSpace;
        }else {
            // 不换行
        }
        eachX += buttonWidth + config.zzItemHorizontalSpace;
    }
    return CGSizeMake(width, (eachY + config.zzItemMinHeight + config.zzEdgeInsets.bottom));
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

#pragma mark - ZZTagButtonConfig

@implementation ZZTagButtonConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.zzTitleColor                         = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.zzBackgroundColor              = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        self.zzBorderColor                      = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.zzMultiTappedTitleColor        = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.zzMultiTappedBackgroundColor   = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        self.zzMultiTappedBorderColor     = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.zzTitleFont                           = [UIFont systemFontOfSize:12.0];
        self.zzMultiTappedTitleFont         = [UIFont systemFontOfSize:12.0];
        self.zzBorderWidth                  = 0.5;
        self.zzCornerRadius                 = 4.0;
        self.zzEnableMultiTap               = NO;
        self.zzSelectedImageEdgeInsets = UIEdgeInsetsZero;
        
    }
    return self;
}

@end

#pragma mark - ZZTagConfig

@implementation ZZTagConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.zzEdgeInsets           = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        self.zzItemHorizontalSpace  = 5.0;
        self.zzItemVerticalSpace    = 5.0;
        self.zzItemMinWidth         = 40.0;
        self.zzItemMinHeight        = 24.0;
        self.zzItemTextPadding      = 5.0;
    }
    return self;
}

@end

#pragma mark - ZZTagModel

@implementation ZZTagModel

- (instancetype)initWithName:(nonnull NSString *)name {
    
    return [self initWithName:name selected:NO];
}

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected {
    
    return [self initWithName:name selected:selected reservedData:nil];
}

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected reservedData:(nullable id)reservedData {
    
    return [self initWithName:name selected:selected disabled:NO reservedData:reservedData];
}

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled {
    
    return [self initWithName:name selected:selected disabled:disbaled reservedData:nil];
}

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled reservedData:(nullable id)reservedData {
    
    self = [super init];
    if (self) {
        self.zzName = name;
        self.zzSelected = selected;
        self.zzDisabled = disbaled;
        self.zzReservedData = reservedData;
    }
    return self;
}

// 创建ZZTagModel（默认selected为NO）
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name {
    
    return [self zz_tagName:name selected:NO];
}

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected {
    
    ZZTagModel *tagModel = [[ZZTagModel alloc] initWithName:name selected:selected];
    return tagModel;
}

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name reservedData:(nullable id)reservedData {
    
    ZZTagModel *tagModel = [[ZZTagModel alloc] initWithName:name selected:NO reservedData:reservedData];
    return tagModel;
}

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected reservedData:(nullable id)reservedData {
    
    ZZTagModel *tagModel = [[ZZTagModel alloc] initWithName:name selected:selected reservedData:reservedData];
    return tagModel;
}

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled {
    
    ZZTagModel *tagModel = [[ZZTagModel alloc] initWithName:name selected:selected disabled:disbaled];
    return tagModel;
}

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled reservedData:(nullable id)reservedData {
    
    ZZTagModel *tagModel = [[ZZTagModel alloc] initWithName:name selected:selected disabled:disbaled reservedData:reservedData];
    return tagModel;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end

#pragma mark - ZZTextButton

@interface ZZTextButton()

@property (nonatomic, weak) ZZTagButtonConfig *zzConfig;
@property (nonatomic, assign) BOOL disabled;

@end

@implementation ZZTextButton

- (void)zz_setTitle:(nonnull NSString *)title selected:(BOOL)selected disabled:(BOOL)disabled config:(nonnull ZZTagButtonConfig *)config {
    
    self.zzConfig = config;
    self.disabled = disabled;
    [self setTitle:title forState:UIControlStateNormal];
    UIColor *textColor = nil;
    UIColor *backgroundColor = nil;
    UIColor *borderColor = nil;
    UIFont *textFont = nil;
    UIImage *image = nil;
    CGFloat borderWidth = 0;
    if (disabled) {
        textColor = config.zzDisabledTitleColor;
        backgroundColor = config.zzDisabledBackgroundColor;
        textFont = config.zzDisabledTitleFont;
        borderColor = config.zzDisabledBorderColor;
        borderWidth = config.zzDisabledBorderWidth;
    }else {
        if (selected) {
            self.tag = 1;
            textColor = config.zzMultiTappedTitleColor;
            backgroundColor = config.zzMultiTappedBackgroundColor;
            textFont = config.zzMultiTappedTitleFont;
            borderColor = config.zzMultiTappedBorderColor;
            borderWidth = config.zzMultiTappedBorderWidth;
            if ([self.zzConfig.zzSelectedImage isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:config.zzSelectedImage];
            }else if ([self.zzConfig.zzSelectedImage isKindOfClass:[UIImage class]]) {
                image = self.zzConfig.zzSelectedImage;
            }
        }else{
            self.tag = 0;
            textColor = config.zzTitleColor;
            backgroundColor = config.zzBackgroundColor;
            textFont = config.zzTitleFont;
            borderColor = config.zzBorderColor;
            borderWidth = config.zzBorderWidth;
        }
    }
    [self setTitleColor:textColor forState:UIControlStateNormal];
    [self setBackgroundColor:backgroundColor];
    self.titleLabel.font = textFont;
    if (borderWidth > 0) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
    }
    self.layer.cornerRadius = config.zzCornerRadius;
    self.layer.masksToBounds = YES;
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    if (selected) {
        self.imageEdgeInsets = config.zzSelectedImageEdgeInsets;
    }
    
    __weak typeof(self) weakSelf = self;
    if (disabled) {
        [self setUserInteractionEnabled:NO];
    }else {
        [self setUserInteractionEnabled:YES];
        [self zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof UIControl * _Nonnull sender) {
            if (config.zzEnableMultiTap == NO) {
                ZZWidgetTagView *tagView = (ZZWidgetTagView *)[weakSelf superview];
                [tagView zz_reset];
            }
            [weakSelf _updateHighlightedState];
        }];
    }
}

- (BOOL)zz_selected {
    
    return self.tag == 1 ? YES : NO;
}

- (void)_updateHighlightedState {
    
    if (self.disabled) {
        UIColor *textColor = self.zzConfig.zzDisabledTitleColor;
        UIColor *backgroundColor = self.zzConfig.zzDisabledBackgroundColor;
        UIColor *borderColor = self.zzConfig.zzDisabledBorderColor;
        UIFont *textFont = self.zzConfig.zzDisabledTitleFont;
        [self setTitleColor:textColor forState:UIControlStateNormal];
        [self setBackgroundColor:backgroundColor];
        self.titleLabel.font = textFont;
        if (self.zzConfig.zzDisabledBorderWidth > 0) {
            self.layer.borderWidth = self.zzConfig.zzDisabledBorderWidth;
            self.layer.borderColor = borderColor.CGColor;
        }
        self.layer.cornerRadius = self.zzConfig.zzCornerRadius;
        self.layer.masksToBounds = YES;
        [self setImage:nil forState:UIControlStateNormal];
    }else {
        if (self.zzConfig.zzEnableMultiTap) {
            UIColor *textColor = nil;
            UIColor *backgroundColor = nil;
            UIColor *borderColor = nil;
            UIFont *textFont = nil;
            UIImage *image = nil;
            CGFloat borderWidth = 0;
            // tag == 0 为高亮， tag == 1 为高亮
            if (self.tag == 0) {
                textColor = self.zzConfig.zzMultiTappedTitleColor;
                backgroundColor = self.zzConfig.zzMultiTappedBackgroundColor;
                borderColor = self.zzConfig.zzMultiTappedBorderColor;
                textFont = self.zzConfig.zzMultiTappedTitleFont;
                borderWidth = self.zzConfig.zzMultiTappedBorderWidth;
                if ([self.zzConfig.zzSelectedImage isKindOfClass:[NSString class]]) {
                    image = [UIImage imageNamed:self.zzConfig.zzSelectedImage];
                }else if ([self.zzConfig.zzSelectedImage isKindOfClass:[UIImage class]]) {
                    image = self.zzConfig.zzSelectedImage;
                }
            }else{
                textColor = self.zzConfig.zzTitleColor;
                backgroundColor = self.zzConfig.zzBackgroundColor;
                borderColor = self.zzConfig.zzBorderColor;
                textFont = self.zzConfig.zzTitleFont;
                borderWidth = self.zzConfig.zzBorderWidth;
                image = nil;
            }
            [self setTitleColor:textColor forState:UIControlStateNormal];
            [self setBackgroundColor:backgroundColor];
            self.titleLabel.font = textFont;
            if (borderWidth > 0) {
                self.layer.borderWidth = borderWidth;
                self.layer.borderColor = borderColor.CGColor;
            }
            self.layer.cornerRadius = self.zzConfig.zzCornerRadius;
            self.layer.masksToBounds = YES;
            [self setImage:image forState:UIControlStateNormal];
            self.tag = self.tag == 0 ? 1 : 0;
        }else{
            UIColor *textColor = nil;
            UIColor *backgroundColor = nil;
            UIColor *borderColor = nil;
            UIFont *textFont = nil;
            UIImage *image = nil;
            CGFloat borderWidth = 0;
            if (self.zzConfig.zzMultiTappedTitleColor != nil) {
                textColor = self.zzConfig.zzMultiTappedTitleColor;
            }else{
                textColor = self.zzConfig.zzTitleColor;
            }
            if (self.zzConfig.zzMultiTappedBackgroundColor != nil) {
                backgroundColor = self.zzConfig.zzMultiTappedBackgroundColor;
            }else{
                backgroundColor = self.zzConfig.zzBackgroundColor;
            }
            if (self.zzConfig.zzMultiTappedBorderColor != nil) {
                borderColor = self.zzConfig.zzMultiTappedBorderColor;
                borderWidth = self.zzConfig.zzMultiTappedBorderWidth;
            }else{
                borderColor = self.zzConfig.zzBorderColor;
                borderWidth = self.zzConfig.zzBorderWidth;
            }
            if (self.zzConfig.zzMultiTappedTitleFont != nil) {
                textFont = self.zzConfig.zzMultiTappedTitleFont;
            }else{
                textFont = self.zzConfig.zzTitleFont;
            }
            if ([self.zzConfig.zzSelectedImage isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:self.zzConfig.zzSelectedImage];
            }else if ([self.zzConfig.zzSelectedImage isKindOfClass:[UIImage class]]) {
                image = self.zzConfig.zzSelectedImage;
            }
            [self setTitleColor:textColor forState:UIControlStateNormal];
            [self setBackgroundColor:backgroundColor];
            self.titleLabel.font = textFont;
            if (borderWidth > 0) {
                self.layer.borderWidth = borderWidth;
                self.layer.borderColor = borderColor.CGColor;
            }
            self.layer.cornerRadius = self.zzConfig.zzCornerRadius;
            self.layer.masksToBounds = YES;
            [self setImage:image forState:UIControlStateNormal];
            self.tag = self.tag == 0 ? 1 : 0;
        }
    }
}

- (void)zz_reset {
    
    if (self.disabled) {
        return;
    }
    [self setTitleColor:self.zzConfig.zzTitleColor forState:UIControlStateNormal];
    [self setBackgroundColor:self.zzConfig.zzBackgroundColor];
    self.titleLabel.font = self.zzConfig.zzTitleFont;
    if (self.zzConfig.zzBorderWidth > 0) {
        self.layer.borderWidth = self.zzConfig.zzBorderWidth;
        self.layer.borderColor = self.zzConfig.zzBorderColor.CGColor;
    }
    self.layer.cornerRadius = self.zzConfig.zzCornerRadius;
    self.layer.masksToBounds = YES;
    [self setImage:nil forState:UIControlStateNormal];
    self.tag = 0;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

#pragma mark - NSArray (ZZTagModel)

@implementation NSArray (ZZTagModel)

// 是否包含TagModel (判断tag名称)
- (BOOL)zz_containsTagName:(nonnull NSString *)tag {
    
    for (ZZTagModel *tagModel in self) {
        if ([[tagModel zzName] isEqualToString:tag]) {
            return YES;
        }
    }
    return NO;
}

// 是否包含TagModel (判断内存)
- (BOOL)zz_containsTagModel:(nonnull ZZTagModel *)tagModel {
    
    return [self containsObject:tagModel];
}

// 删除TagModel (判断tag名称)
- (void)zz_removeTagName:(nonnull ZZTagModel *)tagModel {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        for (int i = (int)[self count] - 1; i >=0; i--) {
            if ([[(ZZTagModel *)[self objectAtIndex:i] zzName] isEqualToString:[tagModel zzName]]) {
                [(NSMutableArray*)self removeObjectAtIndex:i];
            }
        }
    }
}

// 删除TagModel (判断内存)
- (void)zz_removeTagModel:(nonnull ZZTagModel *)tagModel {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray*)self removeObject:tagModel];
    }
}


@end
