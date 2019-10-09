//
//  UIView+ZZKit_HUD.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/31.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIView+ZZKit_HUD.h"
#import "UIView+ZZKit_Blocks.h"
#import <objc/runtime.h>
#import <Lottie/Lottie.h>
#import <Masonry/Masonry.h>
#import <Typeset/Typeset.h>
#import <SDWebImage/UIImage+GIF.h>
#import "NSString+ZZKit.h"
#import "UIColor+ZZKit.h"
#import "NSAttributedString+ZZKit.h"
#import "ZZWidgetSpinnerView.h"
#import "UIView+ZZKit.h"

#pragma mark - UIView Category

#define kToastTextMaxWidth ([UIScreen mainScreen].bounds.size.width - 40.0 - 16.0 - 16.0)
#define kToastTextMinWidth 140.0

@implementation UIView (ZZKit_HUD)

#pragma mark - 加载

/**
 *  默认加载的动画
 */
- (MBProgressHUD *)zz_startLoading {
    
    NSString *path = [[NSBundle bundleForClass:[ZZWidgetSpinnerView class]] pathForResource:@"gif_loading_shopping" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self zz_startLoading:data backgroundColor:[UIColor clearColor] bezelViewColor:[UIColor clearColor] gifViewColor:[UIColor clearColor] boderWidth:0.5 borderColor:@"#E6E6E6".zz_color cornerRadius:2.0 userInteractionEnabled:NO];
}

/**
 *  默认加载的动画（Gif文件, 背景颜色, bezelView背景色, animatedImageView背景色, 边框颜色, 边框宽度, 四角角度）
 */
- (MBProgressHUD *)zz_startLoading:(nonnull NSData *)gifData backgroundColor:(nullable UIColor *)backgroundColor bezelViewColor:(nullable UIColor *)bezelViewColor gifViewColor:(nullable UIColor *)gifViewColor boderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled {
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // NO不影响当前手势
    hud.userInteractionEnabled = userInteractionEnabled;
    hud.backgroundColor = backgroundColor;
    
    // 设置bezeView
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = bezelViewColor;
    
    // 设置自定义View
    UIImageView *animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    animatedImageView.backgroundColor = gifViewColor;
    animatedImageView.image = [UIImage sd_animatedGIFWithData:gifData];
    hud.customView = animatedImageView;
    hud.customView.layer.masksToBounds = YES;
    hud.customView.layer.borderWidth = borderWidth;
    hud.customView.layer.borderColor = borderColor.CGColor;
    hud.customView.layer.cornerRadius = cornerRadius;
    hud.customView.tag = 1234;
    
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

/**
 *  停止加载动画
 */
- (void)zz_stopLoading {
    
    for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
        MBProgressHUD *hud = [self.subviews objectAtIndex:i];
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            if ([hud.customView isKindOfClass:[UIImageView class]] && hud.customView.tag == 1234) {
                [hud hideAnimated:YES];
            }
        }
    }
}

#pragma mark - 吐司

/**
 *  吐司（消息）
 */
- (nullable MBProgressHUD *)zz_toast:(nullable NSString *)message {
    
    if (message == nil || message.length == 0) {
        return nil;
    }
    
    NSAttributedString *attributedString = message.typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).color([UIColor whiteColor]).textAlignment(NSTextAlignmentCenter).minimumLineHeight(20.0).string;
    return [self zz_toast:attributedString lottiePath:nil lottieViewSize:CGSizeZero edgeInsects:UIEdgeInsetsMake(12.0, 16.0, 12.0, 16.0) imageTextPadding:0 textMaxWidth:0 textMinWidth:0 borderColor:nil borderWidth:0 cornerRadius:2.0 duration:3.0 scaleAnimation:YES otherDisappearAnimationBlock:nil];
}

/**
 *  吐司（消息、动画）
 */
- (nullable MBProgressHUD *)zz_toast:(nullable NSString *)message toastType:(ZZToastType)toastType {
    
    if (toastType == ZZToastTypeText && (message == nil || message.length == 0)) {
        return nil;
    }
    
    NSAttributedString *attributedString = message.typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).color([UIColor whiteColor]).textAlignment(NSTextAlignmentCenter).minimumLineHeight(20.0).string;
    NSString *path = nil;
    switch (toastType) {
        case ZZToastTypeSuccess:
        {
            path = [[NSBundle bundleForClass:[ZZWidgetSpinnerView class]] pathForResource:@"lottie_toast_success" ofType:@"json"];
            break;
        }
        case ZZToastTypeError:
        {
            path = [[NSBundle bundleForClass:[ZZWidgetSpinnerView class]] pathForResource:@"lottie_toast_error" ofType:@"json"];
            break;
        }
        case ZZToastTypeWarning:
        {
            path = [[NSBundle bundleForClass:[ZZWidgetSpinnerView class]] pathForResource:@"lottie_toast_warning" ofType:@"json"];
            break;
        }
        case ZZToastTypeSignSuccess:
        {
            path = [[NSBundle bundleForClass:[ZZWidgetSpinnerView class]] pathForResource:@"lottie_toast_sign" ofType:@"json"];
            break;
        }
        case ZZToastTypeText:
        {
            path = nil;
            break;
        }
        default:
            return nil;
    }
    return [self zz_toast:attributedString lottiePath:path lottieViewSize:CGSizeMake(64.0, 32.0) edgeInsects:UIEdgeInsetsMake(12.0, 16.0, 12.0, 16.0) imageTextPadding:12.0 textMaxWidth:0 textMinWidth:0 borderColor:nil borderWidth:0 cornerRadius:2.0 duration:2.0 scaleAnimation:YES otherDisappearAnimationBlock:nil];
}

/**
 *  吐司（消息、动画等完整参数）
 */
- (nullable MBProgressHUD *)zz_toast:(nullable NSAttributedString *)message lottiePath:(nullable NSString *)lottiePath lottieViewSize:(CGSize)lottieViewSize edgeInsects:(UIEdgeInsets)edgeInsets imageTextPadding:(CGFloat)imageTextPadding textMaxWidth:(CGFloat)textMaxWidth textMinWidth:(CGFloat)textMinWidth borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius duration:(CGFloat)duration scaleAnimation:(BOOL)scaleAnimation otherDisappearAnimationBlock:(nullable void(^)(id contentView, void(^finished)(void)))otherDisappearAnimationBlock  {
    
    CGSize contentViewSize = CGSizeZero;
    __block CGSize textSize = CGSizeZero;
    if (textMaxWidth == 0 || textMinWidth ==0) {
        textMaxWidth = kToastTextMaxWidth;
        textMinWidth = kToastTextMinWidth;
    }
    if (message && lottiePath) {
        textSize = [message zz_size:CGSizeMake(textMaxWidth, MAXFLOAT) enableCeil:YES];
        contentViewSize.width = textSize.width < textMinWidth ? textMinWidth + edgeInsets.left + edgeInsets.right : textSize.width + edgeInsets.left + edgeInsets.right;
        contentViewSize.height =  edgeInsets.top + lottieViewSize.height + imageTextPadding + textSize.height + edgeInsets.bottom;
    }else if (message) {
        textSize = [message zz_size:CGSizeMake(textMaxWidth, MAXFLOAT) enableCeil:YES];
        contentViewSize.width = textSize.width < textMinWidth ? textMinWidth + edgeInsets.left + edgeInsets.right : textSize.width + edgeInsets.left + edgeInsets.right;
        contentViewSize.height =  edgeInsets.top + textSize.height + edgeInsets.bottom;
    }else if (lottiePath) {
        contentViewSize.width = textMaxWidth + edgeInsets.left + edgeInsets.right;
        contentViewSize.height =  edgeInsets.top + lottieViewSize.height + edgeInsets.bottom;
    }else {
        return nil;
    }
   
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // NO不影响当前手势
    hud.userInteractionEnabled = NO;
    hud.backgroundColor = [UIColor clearColor];
    
    // 设置bezeView
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    
    // 设置自定义View
    UIImage *image = [[UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:0.7] zz_image:contentViewSize];
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
    contentView.image = image;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor = borderColor.CGColor;
    contentView.layer.borderWidth = borderWidth;
    contentView.layer.cornerRadius = cornerRadius;
    __weak typeof(contentView) weakContentView = contentView;
    
    if (message && lottiePath) {
        
        // LOTAnimationView
        LOTAnimationView *animationView = [LOTAnimationView animationWithFilePath:lottiePath];
        [animationView play];
        [contentView addSubview:animationView];
        [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lottieViewSize.width));
            make.height.equalTo(@(lottieViewSize.height));
            make.centerX.equalTo(weakContentView.mas_centerX);
            make.top.equalTo(weakContentView).offset(edgeInsets.top);
        }];
        
        // 文字
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.attributedText = message;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakContentView.mas_left).offset(edgeInsets.left);
            make.right.equalTo(weakContentView.mas_right).offset(-edgeInsets.right);
            make.bottom.equalTo(weakContentView.mas_bottom).offset(-edgeInsets.bottom);
            make.height.equalTo(@(textSize.height));
        }];
        
    }else if (message) {
        
        // 文字
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.attributedText = message;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakContentView.mas_left).offset(edgeInsets.left);
            make.right.equalTo(weakContentView.mas_right).offset(-edgeInsets.right);
            make.top.equalTo(weakContentView.mas_top).offset(edgeInsets.top);
            make.height.equalTo(@(textSize.height));
        }];
        
    }else if (lottiePath) {
        
        // LOTAnimationView
        LOTAnimationView *animationView = [LOTAnimationView animationWithFilePath:lottiePath];
        [animationView play];
        [contentView addSubview:animationView];
        [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lottieViewSize.width));
            make.height.equalTo(@(lottieViewSize.height));
            make.centerX.equalTo(weakContentView.mas_centerX);
            make.top.equalTo(weakContentView).offset(edgeInsets.top);
        }];
    }
    
    hud.customView = contentView;
    hud.customView.tag = 4321;
    
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    __weak typeof(hud) weakHUD = hud;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (scaleAnimation) {
            contentView.alpha = 1.0;
            [UIView animateWithDuration:0.25 animations:^{
                contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakContentView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakHUD hideAnimated:NO];
                }];
            }];
        }else if (otherDisappearAnimationBlock != nil) {
            otherDisappearAnimationBlock(weakContentView, ^{
                [weakHUD hideAnimated:YES];
            });
        }else {
            [weakHUD hideAnimated:YES];
        }
    });
    
    return hud;
}

#pragma mark - 顶部消息

/**
 *  顶部消息（message）
 */
- (void)zz_dropSheet:(nonnull NSString *)message {
    
    [self zz_dropSheet:message tapBlock:nil cancelBlock:nil];
}

/**
 *  顶部消息（message和block）
 */
- (void)zz_dropSheet:(nonnull NSString *)message tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    ZZDropSheet *dropSheet = [[ZZDropSheet alloc] initWithMessage:message tapBlock:tapBlock cancelBlock:cancelBlock];
    [dropSheet zz_show];
}

/**
 *  顶部消息（完整参数）
 */
- (void)zz_dropSheet:(nonnull NSString *)message textFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor sheetbackgroundColor:(nullable UIColor *)sheetbackgroundColor closeImageNormal:(nullable UIImage *)closeImageNormal closeImageHighlighted:(nullable UIImage *)closeImageHighlighted stayDuration:(CGFloat)stayDuration tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    ZZDropSheet *dropSheet = [[ZZDropSheet alloc] initWithMessage:message
                                                         textFont:textFont
                                                        textColor:textColor
                                             sheetbackgroundColor:sheetbackgroundColor
                                                 closeImageNormal:closeImageNormal
                                            closeImageHighlighted:closeImageHighlighted
                                                     stayDuration:stayDuration
                                                         tapBlock:tapBlock
                                                      cancelBlock:cancelBlock];
    [dropSheet zz_show];
}

#pragma mark - Spinner动画

/**
 * Spinner动画开始
 */
- (void)zz_startSpinningNoMessage:(ZZSpinnerLoadingStyle)style {
    
    [self zz_startSpinning:nil style:style];
}

/**
 * Spinner动画开始
 */
- (void)zz_startSpinningNoMessage:(ZZSpinnerPosistion)position style:(ZZSpinnerLoadingStyle)style {
    
    [self zz_startSpinning:nil position:position style:style];
}

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(ZZSpinnerLoadingStyle)style {
    
    [self zz_startSpinning:@"正在加载..." style:style];
}

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(nullable NSString *)title style:(ZZSpinnerLoadingStyle)style {
    
    [self zz_startSpinning:title position:ZZSpinnerPosistionCenter style:style];
}

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(nullable NSString *)title position:(ZZSpinnerPosistion)position style:(ZZSpinnerLoadingStyle)style {
    
    UIColor *color = nil;
    switch (style) {
        case ZZSpinnerLoadingStyleWhite:
        {
            color = @"#FFFFFF".zz_color;
            break;
        }
        case ZZSpinnerLoadingStyleBlack:
        {
            color = @"#333333".zz_color;
            break;
        }
    }
    [self zz_startSpinning:title titleColor:color titleFont:[UIFont systemFontOfSize:12.0] kern:2.0 colorSequence:@[color] position:ZZSpinnerPosistionCenter offsetRateFromTop:0 layout:ZZSpinnerLoadingViewLayoutLeft backgroundColor:[UIColor clearColor] cornerRadius:0];
}

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence position:(ZZSpinnerPosistion)position offsetRateFromTop:(CGFloat)offsetRateFromTop layout:(ZZSpinnerLoadingViewLayout)layout backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGFloat y = self.bounds.size.height / 8.0;
        switch (position) {
            case ZZSpinnerPosistionTop:
            {
                y = 10.0;
                break;
            }
            case ZZSpinnerPosistionNearTop:
            {
                y = 2 * y;
                break;
            }
            case ZZSpinnerPosistionTopNearCenter:
            {
                y = 3 * y;
                break;
            }
            case ZZSpinnerPosistionCenter:
            {
                y = 4 * y;
                break;
            }
            case ZZSpinnerPosistionBottomNearCenter:
            {
                y = 5 * y;
                break;
            }
            case ZZSpinnerPosistionNearBottom:
            {
                y = 6 * y;
                break;
            }
            case ZZSpinnerPosistionBottom:
            {
                y = 7 * y;
                break;
            }
            case ZZSpinnerPosistionOffset:
            {
                y = offsetRateFromTop;
                break;
            }
            default:
                break;
        }
        
        if ([weakSelf isKindOfClass:[UIButton class]]) {
            [weakSelf setUserInteractionEnabled:NO];
            [weakSelf _setButtonTitle:((UIButton *)weakSelf).titleLabel.text];
            [(UIButton *)weakSelf setTitle:@"" forState:UIControlStateNormal];
        }
        
        [weakSelf zz_startSpinning:CGPointMake(weakSelf.bounds.size.width / 2.0, y) layout:layout loadingWidth:0 spinnerHeight:0 labelHeight:0 spinnerLabelGap:0 backgroundColor:backgroundColor cornerRadius:cornerRadius title:title titleColor:titleColor titleFont:titleFont kern:kern colorSequence:colorSequence cycleDuration:0];
    });
}

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(CGPoint)point layout:(ZZSpinnerLoadingViewLayout)layout loadingWidth:(CGFloat)loadingWidth spinnerHeight:(CGFloat)spinnerHeight labelHeight:(CGFloat)labelHeight spinnerLabelGap:(CGFloat)spinnerLabelGap backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius title:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence cycleDuration:(CGFloat)cycleDuration {
    
    for (ZZSpinnerLoadingView *loadingView in [self subviews]) {
        if ([loadingView isKindOfClass:[ZZSpinnerLoadingView class]]) {
            [self bringSubviewToFront:loadingView];
            [loadingView zz_startSpinning:title];
            break;
        }
    }
    if (![[[self subviews] lastObject] isKindOfClass:[ZZSpinnerLoadingView class]]) {
        ZZSpinnerLoadingView *loadingView = [ZZSpinnerLoadingView zz_spinnerLoadingView:layout loadingWidth:loadingWidth spinnerHeight:spinnerHeight labelHeight:labelHeight spinnerLabelGap:spinnerLabelGap backgroundColor:backgroundColor cornerRadius:cornerRadius title:title titleColor:titleColor titleFont:titleFont kern:kern colorSequence:colorSequence ];
        [self addSubview:loadingView];
        if (point.x > 0 && point.y > 0) {
            loadingView.center = point;
        }
        if (cycleDuration > 0) {
            [loadingView zz_startSpinningCycleDuration:cycleDuration];
        }else{
            [loadingView zz_StartSpinning];
        }
    }
}

/**
 * Spinner动画停止
 */
- (void)zz_stopSpinning {
    
    for (ZZSpinnerLoadingView *loadingView in [self subviews]) {
        if ([loadingView isKindOfClass:[ZZSpinnerLoadingView class]]) {
            [self bringSubviewToFront:loadingView];
            [loadingView zz_stopSpinning];
            break;
        }
    }
    if ([self isKindOfClass:[UIButton class]]) {
        [(UIButton *)self setTitle:[self _getButtonTitle] forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
    }
}

- (void)_setButtonTitle:(NSString *)title {
    
    objc_setAssociatedObject(self, @"ButtonTitle", title, OBJC_ASSOCIATION_COPY);
}

- (nullable NSString *)_getButtonTitle {
    
    NSString *title = objc_getAssociatedObject(self, @"ButtonTitle");
    return title;
}


#pragma mark - Popup View

/**
 *  Popup动画
 */
- (void)zz_popup:(nullable ZZPopupView *)popupView blurColor:(nullable UIColor *)blurColor userInteractionEnabled:(BOOL)userInteractionEnabled springs:(nullable NSArray<NSNumber *> *)springs actionBlock:(nullable void(^)(id value))actionBlock {

    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _popup:popupView blurColor:blurColor userInteractionEnabled:userInteractionEnabled springs:springs actionBlock:actionBlock];
    });
}

- (void)_popup:(nullable ZZPopupView *)popupView blurColor:(nullable UIColor *)blurColor userInteractionEnabled:(BOOL)userInteractionEnabled springs:(nullable NSArray<NSNumber *> *)springs actionBlock:(nullable void(^)(id value))actionBlock {

    if (popupView == nil || popupView.zzPopupAppearAnimationBlock == nil || popupView.zzPopupDisappearAnimationBlock == nil) {
        return;
    }
    popupView.zzPopupParentView = self;
    popupView.zzPopupActionBlock = actionBlock;
    if (springs.count == 1) {
        popupView.zzPopupDuration = springs[0];
    }
    else if (springs.count == 3) {
        popupView.zzPopupDuration = springs[0];
        popupView.zzPopupSpringDampingRatio = springs[1];
        popupView.zzPopupSpringVelocity = springs[2];
    }
    
    ZZPopupBlurView *blurView = nil;
    if (blurColor != nil) {
        blurView = [[ZZPopupBlurView alloc] init];
        blurView.backgroundColor = blurColor;
        blurView.frame = self.bounds;
        [self addSubview:blurView];
        if (userInteractionEnabled == YES) {
            [blurView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
                popupView.zzPopupDisappearAnimationBlock(nil);
            }];
        }
        popupView.zzPopupBlurView = blurView;
    }
    popupView.zzPopupAppearAnimationBlock();
}

@end

#pragma mark - ZZDropSheet

#define ZZDROPSHEET_TEXT_FONT                [UIFont systemFontOfSize:14.0]
#define ZZDROPSHEET_TEXT_COLOR               [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define ZZDROPSHEET_BACKGROUND_COLOR         [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define ZZDROPSHEET_STAY_DURATION            (2.0)

typedef NS_ENUM(NSInteger, ZZDropSheetState) {
    ZZDropSheetStateNone,      // 未初始化
    ZZDropSheetStateAnimating, // 动画中
    ZZDropSheetStateShown,     // 展现中
    ZZDropSheetStateHidden     // 已消失
};

@interface ZZDropSheet ()

// DropSheet消息停留时间
@property (nonatomic, assign) CGFloat stayDuration;
// DropSheet消息字体
@property (nonatomic, strong) UIFont  *textFont;
// DropSheet消息颜色
@property (nonatomic, strong) UIColor *textColor;
// DropSheet的背景颜色
@property (nonatomic, strong) UIColor *sheetBackgroundColor;
// DropSheet消息关闭按钮Normal
@property (nonatomic, strong) UIImage *img_close_normal;
// DropSheet消息关闭按钮Highlighted
@property (nonatomic, strong) UIImage *img_close_highlighted;

// Alert Window
@property (nonatomic, strong)   UIWindow   *window;
// DropSheet View
@property (nonatomic, retain)   UIView     *sheetView;
// DropSheet Cancel Button
@property (nonatomic, strong)   UIButton   *cancelButton;
// DropSheet Message
@property (nonatomic, copy)     NSString   *message;
// DropSheet State
@property (atomic, assign)      ZZDropSheetState state;
// DropSheet Tapped Block
@property (nonatomic, copy)     void(^tapBlock)(void);
// DropSheet Cancelled Block
@property (nonatomic, copy)     void(^cancelBlock)(void);

@end

@implementation ZZDropSheet

#pragma mark - 初始化函数

- (instancetype)initWithMessage:(nonnull NSString *)message {
    
    return [self initWithMessage:message tapBlock:nil cancelBlock:nil];
}

- (instancetype)initWithMessage:(nonnull NSString *)message tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    return [self initWithMessage:message
                        textFont:ZZDROPSHEET_TEXT_FONT
                       textColor:ZZDROPSHEET_TEXT_COLOR
            sheetbackgroundColor:ZZDROPSHEET_BACKGROUND_COLOR
                closeImageNormal:@"toast_close_normal".zz_image
           closeImageHighlighted:@"toast_close_active".zz_image
                    stayDuration:ZZDROPSHEET_STAY_DURATION
                        tapBlock:tapBlock
                     cancelBlock:cancelBlock];
}

- (instancetype)initWithMessage:(nonnull NSString *)message textFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor sheetbackgroundColor:(nullable UIColor *)sheetbackgroundColor closeImageNormal:(nullable UIImage *)closeImageNormal closeImageHighlighted:(nullable UIImage *)closeImageHighlighted stayDuration:(CGFloat)stayDuration tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.message = message;
        self.textFont = textFont;
        self.textColor = textColor;
        self.sheetBackgroundColor = sheetbackgroundColor;
        self.img_close_normal = closeImageNormal;
        self.img_close_highlighted = closeImageHighlighted;
        self.stayDuration = stayDuration;
        self.tapBlock = tapBlock;
        self.cancelBlock = cancelBlock;
        [self _buildSheetView];
        [self addSubview:self.sheetView];
    }
    return self;
}

#pragma mark - Public

/**
 *  显示DropSheet
 */
- (void)zz_show {
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 64);
    [self _showRect:rect animated:YES];
}

#pragma mark - Private

// 显示[basic]
- (void)_showRect:(CGRect)rect animated:(BOOL)animated {
    
    if (self.state == ZZDropSheetStateNone || self.state == ZZDropSheetStateHidden) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.windowLevel = UIWindowLevelAlert;
        [self.window addSubview:self];
        [self.window makeKeyAndVisible];
        CGRect from = (CGRect){.origin = {rect.origin.x,-64}, .size = self.sheetView.bounds.size};
        self.sheetView.frame = from;
        CGRect to = (CGRect){.origin = {0, 0}, .size = self.sheetView.bounds.size};
        self.state = ZZDropSheetStateAnimating;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.sheetView.frame = to;
        } completion:^(BOOL finished) {
            weakSelf.state = ZZDropSheetStateShown;
            if (weakSelf.stayDuration < 0.1) {
                weakSelf.stayDuration = self.stayDuration;
            }
            // 几秒后自动消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(weakSelf.stayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf _dismissDropSheet:nil];
            });
        }];
    }
}

// 消失UI
- (void)_dismissDropSheet:(void(^)(void))finishBlock {
    
    if (self.state == ZZDropSheetStateShown) {
        self.state = ZZDropSheetStateHidden;
        __weak typeof(self) weakSelf = self;
        CGRect to = (CGRect){.origin = {0, -64}, .size = self.sheetView.bounds.size};
        self.state = ZZDropSheetStateAnimating;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.sheetView.frame = to;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.window = nil;
        }];
    }
}

// 生成UI
- (void)_buildSheetView {
    
    if (!self.sheetView) {
        UILabel *sheetTitleLable = nil;
        if (self.message.length > 0) {
            sheetTitleLable = [[UILabel alloc] initWithFrame:CGRectZero];
            sheetTitleLable.font = self.textFont;
            sheetTitleLable.numberOfLines = 0;
            sheetTitleLable.text = self.message;
            sheetTitleLable.textAlignment = NSTextAlignmentCenter;
            sheetTitleLable.backgroundColor = [UIColor clearColor];
            sheetTitleLable.textColor = self.textColor;
        }
        UIButton *cancelButton = nil;
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(_tapClose:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setBackgroundImage:self.img_close_normal forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:self.img_close_highlighted forState:UIControlStateHighlighted];
        self.cancelButton = cancelButton;
        NSInteger width = [UIScreen mainScreen].bounds.size.width;
        UIView *sheetBgView = [[UIView alloc] initWithFrame:(CGRect){.origin = {0.f,0.f}, .size = {width, 64}}];
        sheetBgView.backgroundColor = self.sheetBackgroundColor;
        if (sheetTitleLable) {
            CGSize size = [self.message sizeWithAttributes:@{NSFontAttributeName : sheetTitleLable.font}];
            sheetTitleLable.frame = CGRectMake((width-size.width)/2, 30, size.width, 34.0f);
            [sheetTitleLable sizeToFit];
            sheetTitleLable.textAlignment = NSTextAlignmentCenter;
            [sheetBgView addSubview:sheetTitleLable];
        }
        if (cancelButton) {
            cancelButton.frame = (CGRect){.origin = {width-30, 30}, .size = CGSizeMake(20, 20)};
            [sheetBgView addSubview:cancelButton];
        }
        sheetBgView.frame = (CGRect){.origin = {0.f,0.f}, .size = {width, 64}};
        self.sheetView = sheetBgView;
    }
}

// 关闭
- (void)_tapClose:(id)sender {
    
    self.cancelBlock == nil ? : self.cancelBlock();
    [self _dismissDropSheet:nil];
}

#pragma mark - UIResponder touchesBegan

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    @synchronized (self) {
        NSSet *allTouches = [event allTouches];
        UITouch *touch = [allTouches anyObject];
        CGPoint point = [touch locationInView:[touch view]];
        if (point.y <= 64.0) {
            // 只允许一次点击后回调Tapped Block
            if (self.tag == 0) {
                self.tag = -1;
                self.tapBlock == nil ? : self.tapBlock();
            }
        }
        [self _dismissDropSheet:nil];
    }
}

@end

#pragma mark - ZZSpinnerLoadingView

static CGFloat kZZSpinnerLoadingViewSpinnerH = 20.0;
static CGFloat kZZSpinnerLoadingViewLabelH   = 20.0;
static CGFloat kZZSpinnerLoadingViewW        = 100.0;
static CGFloat kZZSpinnerLoadingViewGap      = 10.0;

@interface ZZSpinnerLoadingView()

@property (nonatomic, assign) CGFloat zzLoadingWidth;
@property (nonatomic, assign) CGFloat zzSpinnerHeight;
@property (nonatomic, assign) CGFloat zzLabelHeight;
@property (nonatomic, assign) CGFloat zzSpinnerLabelGap;
@property (nonatomic, assign) CGFloat zzLabelWidth;
@property (nonatomic, strong) ZZWidgetSpinnerView *spinner;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) ZZSpinnerLoadingViewLayout layout;

@end

@implementation ZZSpinnerLoadingView

- (ZZWidgetSpinnerView *)spinner {
    
    if (_spinner == nil) {
        _spinner = [[ZZWidgetSpinnerView alloc] init];
        _spinner.lineWidth = 2.0;
        [self addSubview:_spinner];
        switch (self.layout) {
            case ZZSpinnerLoadingViewLayoutUp:
            {
                _spinner.frame = CGRectMake(0, 0, _zzLoadingWidth, _zzSpinnerHeight);
                break;
            }
            case ZZSpinnerLoadingViewLayoutDown:
            {
                _spinner.frame = CGRectMake(0, _zzLabelHeight, _zzLoadingWidth, _zzSpinnerHeight);
                break;
            }
            case ZZSpinnerLoadingViewLayoutLeft:
            {
                _spinner.frame = CGRectMake(0, 0, _zzSpinnerHeight, _zzSpinnerHeight);
                break;
            }
            case ZZSpinnerLoadingViewLayoutRight:
            {
                _spinner.frame = CGRectMake(_zzLabelWidth + _zzSpinnerLabelGap, 0, _zzSpinnerHeight , _zzSpinnerHeight);
                break;
            }
        }
    }
    return _spinner;
}

- (UILabel *)label {
    
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:8.0];
        _label.textColor = @"#999999".zz_color;
        [self addSubview:_label];
        switch (self.layout) {
            case ZZSpinnerLoadingViewLayoutUp:
            {
                _label.frame = CGRectMake(0, _zzSpinnerHeight, _zzLoadingWidth, _zzLabelHeight);
                _label.textAlignment = NSTextAlignmentCenter;
                break;
            }
            case ZZSpinnerLoadingViewLayoutDown:
            {
                _label.frame = CGRectMake(0, 0, _zzLoadingWidth, _zzLabelHeight);
                _label.textAlignment = NSTextAlignmentCenter;
                break;
            }
            case ZZSpinnerLoadingViewLayoutLeft:
            {
                _label.frame = CGRectMake(_zzSpinnerHeight, 0, _zzLabelWidth + _zzSpinnerLabelGap, _zzLabelHeight);
                _label.textAlignment = NSTextAlignmentCenter;
                break;
            }
            case ZZSpinnerLoadingViewLayoutRight:
            {
                _label.frame = CGRectMake(0, 0, _zzLabelWidth + _zzSpinnerLabelGap, _zzLabelHeight);
                _label.textAlignment = NSTextAlignmentCenter;
                break;
            }
        }
    }
    return _label;
}

/**
 *  创建ZZSpinnerLoadingView
 */
+ (ZZSpinnerLoadingView *)zz_spinnerLoadingView:(ZZSpinnerLoadingViewLayout)layout backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius title:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence {
    
    
    return [self zz_spinnerLoadingView:layout loadingWidth:0 spinnerHeight:0 labelHeight:0 spinnerLabelGap:0 backgroundColor:backgroundColor cornerRadius:cornerRadius title:title titleColor:titleColor titleFont:titleFont kern:kern colorSequence:colorSequence];
}

/**
 *  创建ZZSpinnerLoadingView
 */
+ (ZZSpinnerLoadingView *)zz_spinnerLoadingView:(ZZSpinnerLoadingViewLayout)layout loadingWidth:(CGFloat)loadingWidth spinnerHeight:(CGFloat)spinnerHeight labelHeight:(CGFloat)labelHeight spinnerLabelGap:(CGFloat)spinnerLabelGap backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius title:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence {
    
    ZZSpinnerLoadingView *loadingView = [[ZZSpinnerLoadingView alloc] init];
    loadingView.zzLoadingWidth = loadingWidth > 0 ? loadingWidth : kZZSpinnerLoadingViewW;
    loadingView.zzSpinnerHeight = spinnerHeight > 0 ? spinnerHeight : kZZSpinnerLoadingViewSpinnerH;
    loadingView.zzLabelHeight = labelHeight > 0 ? labelHeight : kZZSpinnerLoadingViewLabelH;
    loadingView.zzSpinnerLabelGap = spinnerLabelGap > 0 ? spinnerLabelGap : kZZSpinnerLoadingViewGap;
    loadingView.layout = layout;
    if (backgroundColor != nil) {
        loadingView.backgroundColor = backgroundColor;
    }else {
        loadingView.backgroundColor = [UIColor clearColor];
    }
    if (cornerRadius > 0 ) {
        [loadingView zz_cornerRadius:cornerRadius];
    }
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    if ([title length] > 0) {
        CGFloat labelWidth = [title zz_size:titleFont kern:kern space:0 linebreakmode:NSLineBreakByCharWrapping limitedlineHeight:loadingView.zzLabelHeight renderSize:CGSizeMake(MAXFLOAT, loadingView.zzLabelHeight)].width;
        loadingView.zzLabelWidth = labelWidth;
        switch (layout) {
            case ZZSpinnerLoadingViewLayoutUp:
            case ZZSpinnerLoadingViewLayoutDown:
            {
                w = labelWidth > loadingView.zzLoadingWidth ? labelWidth : loadingView.zzLoadingWidth;
                h = loadingView.zzSpinnerHeight + loadingView.zzLabelHeight;
                break;
            }
            case ZZSpinnerLoadingViewLayoutLeft:
            case ZZSpinnerLoadingViewLayoutRight:
            {
                w = labelWidth + loadingView.zzSpinnerHeight + loadingView.zzSpinnerLabelGap;
                h = loadingView.zzSpinnerHeight > loadingView.zzLabelHeight ? loadingView.zzSpinnerHeight : loadingView.zzLabelHeight;
                break;
            }
        }
    }else{
        w = loadingView.zzLoadingWidth;
        h = loadingView.zzLoadingWidth;
        loadingView.spinner.center = loadingView.center;
    }
    loadingView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - w) / 2.0 , ([UIScreen mainScreen].bounds.size.height - h) / 2.0 , w , h);
    if (colorSequence != nil) {
        loadingView.spinner.colorSequence = colorSequence;
        if (title == nil || [title length] == 0) {
            loadingView.spinner.frame = CGRectMake((loadingView.bounds.size.width  - loadingView.spinner.bounds.size.width) / 2.0,
                                                   (loadingView.bounds.size.height - loadingView.spinner.bounds.size.height) / 2.0,
                                                   loadingView.spinner.bounds.size.width,
                                                   loadingView.spinner.bounds.size.height);
        }
    }
    if ([title length] > 0) {
        loadingView.label.attributedText = title.typeset.font(titleFont.fontName, titleFont.pointSize).color(titleColor).kern(kern).string;
    }
    return loadingView;
}

/**
 *  ZZSpinnerLoadingView启动动画
 */
- (void)zz_StartSpinning {
    
    [self.spinner startAnimating];
}

/**
 *  ZZSpinnerLoadingView启动动画
 */
- (void)zz_startSpinningCycleDuration:(CGFloat)drawCycleDuration {
    
    self.spinner.drawCycleDuration = drawCycleDuration;
    [self.spinner startAnimating];
}

/**
 *  ZZSpinnerLoadingView启动动画
 */
- (void)zz_startSpinning:(id)title {
    
    [self.spinner startAnimating];
    if ([title isKindOfClass:[NSAttributedString class]]) {
        self.label.attributedText = title;
    }else if ([title isKindOfClass:[NSString class]]) {
        self.label.text = title;
    }
}

/**
 *  ZZSpinnerLoadingView停止动画
 */
- (void)zz_stopSpinning {
    
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    [self.label removeFromSuperview];
    [self removeFromSuperview];
}

@end

#pragma mark - ZZPopupView

@interface ZZPopupView ()

@end

@implementation ZZPopupView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.zzPopupAppearAnimation = ZZPopupViewAnimationNoneCenter;
        self.zzPopupDisappearAnimation = ZZPopupViewAnimationNoneCenter;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzPopupAppearAnimation = ZZPopupViewAnimationNoneCenter;
        self.zzPopupDisappearAnimation = ZZPopupViewAnimationNoneCenter;
    }
    return self;
}

- (void)setZzPopupAppearAnimation:(ZZPopupViewAnimation)zzPopupAppearAnimation {
    
    _zzPopupAppearAnimation = zzPopupAppearAnimation;
    __weak typeof(self) weakSelf = self;
    switch (zzPopupAppearAnimation) {
        case ZZPopupViewAnimationNoneCenter:
        {
            // 没有动画Center
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.center = weakSelf.zzPopupParentView.center;
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationNoneTop:
        {
            // 没有动画Top
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.zzLeft = (weakSelf.zzPopupParentView.frame.size.width - weakSelf.frame.size.width) / 2.0;
                weakSelf.zzTop = weakSelf.zzPopupParentView.zzTop;
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationNoneBottom:
        {
            // 没有动画Bottom
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.zzLeft = (weakSelf.zzPopupParentView.frame.size.width - weakSelf.frame.size.width) / 2.0;
                weakSelf.zzBottom = weakSelf.zzPopupParentView.zzBottom;
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationScaleCenter:
        {
            // 缩放动画Center
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.center = weakSelf.zzPopupParentView.center;
                weakSelf.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                if (weakSelf.zzPopupDuration && weakSelf.zzPopupSpringDampingRatio && weakSelf.zzPopupSpringVelocity) {
                    [UIView animateWithDuration:[weakSelf.zzPopupDuration floatValue] delay:0.0 usingSpringWithDamping:[weakSelf.zzPopupSpringDampingRatio floatValue] initialSpringVelocity:[weakSelf.zzPopupSpringVelocity floatValue] options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        weakSelf.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {

                    }];
                }else{
                    CGFloat duration = weakSelf.zzPopupDuration ? [weakSelf.zzPopupDuration floatValue] : 0.3;
                    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        weakSelf.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {

                    }];
                }
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationDropCenter:
        {
            // 从顶至下动画Center
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.zzLeft = (weakSelf.zzPopupParentView.frame.size.width - weakSelf.frame.size.width) / 2.0;
                weakSelf.zzBottom = weakSelf.zzPopupParentView.zzTop;
                CGFloat duration = weakSelf.zzPopupDuration ? [weakSelf.zzPopupDuration floatValue] : 0.3;
                [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    weakSelf.center = weakSelf.zzPopupParentView.center;
                } completion:^(BOOL finished) {
                    
                }];
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationDropTop:
        {
            // 从顶至下动画Top
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.zzLeft = (weakSelf.zzPopupParentView.frame.size.width - weakSelf.frame.size.width) / 2.0;
                weakSelf.zzBottom = weakSelf.zzPopupParentView.zzTop;
                CGFloat duration = weakSelf.zzPopupDuration ? [weakSelf.zzPopupDuration floatValue] : 0.2;
                [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    weakSelf.zzTop = weakSelf.zzPopupParentView.zzTop;
                } completion:^(BOOL finished) {
                    
                }];
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationPopCenter:
        {
            // 从底至上动画Center
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.zzLeft = (weakSelf.zzPopupParentView.frame.size.width - weakSelf.frame.size.width) / 2.0;
                weakSelf.zzTop = weakSelf.zzPopupParentView.zzBottom;
                CGFloat duration = weakSelf.zzPopupDuration ? [weakSelf.zzPopupDuration floatValue] : 0.3;
                [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    weakSelf.center = weakSelf.zzPopupParentView.center;
                } completion:^(BOOL finished) {
                    
                }];
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
        case ZZPopupViewAnimationPopBottom:
        {
            // 从底至上动画Bottom
            self.zzPopupAppearAnimationBlock = ^{
                weakSelf.zzLeft = (weakSelf.zzPopupParentView.frame.size.width - weakSelf.frame.size.width) / 2.0;
                weakSelf.zzTop = weakSelf.zzPopupParentView.zzBottom;
                CGFloat duration = weakSelf.zzPopupDuration ? [weakSelf.zzPopupDuration floatValue] : 0.2;
                [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    weakSelf.zzBottom = weakSelf.zzPopupParentView.zzBottom;
                } completion:^(BOOL finished) {
                    
                }];
                [weakSelf.zzPopupParentView addSubview:weakSelf];
            };
        }
            break;
    }
}

- (void)setZzPopupDisappearAnimation:(ZZPopupViewAnimation)zzPopupDisappearAnimation {
    
    __weak typeof(self) weakSelf = self;
    _zzPopupDisappearAnimation = zzPopupDisappearAnimation;
    switch (zzPopupDisappearAnimation) {
        case ZZPopupViewAnimationNoneCenter:
        case ZZPopupViewAnimationNoneTop:
        case ZZPopupViewAnimationNoneBottom:
        {
            // 消失无动画，立即消失
            self.zzPopupDisappearAnimationBlock = ^(void (^ _Nullable dismissCompletion)(void)) {
                [weakSelf.zzPopupBlurView removeFromSuperview];
                [weakSelf removeFromSuperview];
                dismissCompletion == nil ? : dismissCompletion();
            };
        }
            break;
        case ZZPopupViewAnimationScaleCenter:
        {
            // 缩放消失
            self.zzPopupDisappearAnimationBlock = ^(void (^ _Nullable dismissCompletion)(void)) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.zzPopupBlurView.backgroundColor = [UIColor clearColor];
                    weakSelf.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                } completion:^(BOOL finished) {
                    [weakSelf.zzPopupBlurView removeFromSuperview];
                    [weakSelf removeFromSuperview];
                    dismissCompletion == nil ? : dismissCompletion();
                }];
            };
            break;
        }
        case ZZPopupViewAnimationDropCenter:
        case ZZPopupViewAnimationDropTop:
        {
            // 从顶至下消失
            self.zzPopupDisappearAnimationBlock = ^(void (^ _Nullable dismissCompletion)(void)) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.zzPopupBlurView.backgroundColor = [UIColor clearColor];
                    weakSelf.zzTop = weakSelf.zzPopupParentView.zzBottom;
                } completion:^(BOOL finished) {
                    [weakSelf.zzPopupBlurView removeFromSuperview];
                    [weakSelf removeFromSuperview];
                    dismissCompletion == nil ? : dismissCompletion();
                }];
            };
        }
            break;
        case ZZPopupViewAnimationPopCenter:
        case ZZPopupViewAnimationPopBottom:
        {
            // 从底至上消失
            self.zzPopupDisappearAnimationBlock = ^(void (^ _Nullable dismissCompletion)(void)) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.zzPopupBlurView.backgroundColor = [UIColor clearColor];
                    weakSelf.zzBottom = weakSelf.zzPopupParentView.zzTop;
                } completion:^(BOOL finished) {
                    [weakSelf.zzPopupBlurView removeFromSuperview];
                    [weakSelf removeFromSuperview];
                    dismissCompletion == nil ? : dismissCompletion();
                }];
            };
        }
            break;
    }
}

// 关闭PopupView
- (IBAction)zz_tapClosePopupView:(nullable id)sender {
    
    self.zzPopupDisappearAnimationBlock == nil ? : self.zzPopupDisappearAnimationBlock(nil);
}

@end

@interface ZZPopupBlurView ()

@end

@implementation ZZPopupBlurView

@end
