//
//  UIView+ZZKit_HUD.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/31.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class ZZDropSheet;
@class ZZSpinnerLoadingView;
@class ZZPopupView;
@class ZZPopupBlurView;

typedef NS_ENUM(NSInteger, ZZToastType) {
    ZZToastTypeText,       // 纯文本消息
    ZZToastTypeSuccess,    // 成功
    ZZToastTypeError,      // 异常
    ZZToastTypeWarning,    // 警告
    ZZToastTypeSignSuccess // 签到成功
};

typedef NS_ENUM(NSInteger, ZZSpinnerLoadingStyle) {
    ZZSpinnerLoadingStyleWhite,
    ZZSpinnerLoadingStyleBlack
};

typedef NS_ENUM(NSInteger, ZZSpinnerPosistion) {
    ZZSpinnerPosistionOffset,           // 参考偏移量
    ZZSpinnerPosistionTop,              // 顶端
    ZZSpinnerPosistionNearTop,          // 靠近顶端
    ZZSpinnerPosistionTopNearCenter,    // 顶端靠近中线
    ZZSpinnerPosistionCenter,           // 中线
    ZZSpinnerPosistionBottomNearCenter, // 底端靠近中线
    ZZSpinnerPosistionNearBottom,       // 靠近底端
    ZZSpinnerPosistionBottom            // 底端
};

typedef NS_ENUM(NSInteger, ZZSpinnerLoadingViewLayout) {
    ZZSpinnerLoadingViewLayoutUp,     // Spinner在上，文字在下
    ZZSpinnerLoadingViewLayoutDown,   // Spinner在下，文字在上
    ZZSpinnerLoadingViewLayoutLeft,   // Spinner在左，文字在右
    ZZSpinnerLoadingViewLayoutRight   // Spinner在右，文字在左
};

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UIView Category

@interface UIView (ZZKit_HUD)

#pragma mark - 加载

/**
 *  默认加载的动画
 */
- (MBProgressHUD *)zz_startLoading;

/**
 *  默认加载的动画（Gif文件, 背景颜色, bezelView背景色, animatedImageView背景色, 边框颜色, 边框宽度, 四角角度）
 */
- (MBProgressHUD *)zz_startLoading:(nonnull NSData *)gifData backgroundColor:(nullable UIColor *)backgroundColor bezelViewColor:(nullable UIColor *)bezelViewColor gifViewColor:(nullable UIColor *)gifViewColor boderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled;

/**
 *  停止加载动画
 */
- (void)zz_stopLoading;

#pragma mark - 吐司

/**
 *  吐司（消息）
 */
- (nullable MBProgressHUD *)zz_toast:(nullable NSString *)message;

/**
 *  吐司（消息、动画）
 */
- (nullable MBProgressHUD *)zz_toast:(nullable NSString *)message toastType:(ZZToastType)toastType;

/**
 *  吐司（消息、动画等完整参数）
 */
- (nullable MBProgressHUD *)zz_toast:(nullable NSAttributedString *)message lottiePath:(nullable NSString *)lottiePath lottieViewSize:(CGSize)lottieViewSize edgeInsects:(UIEdgeInsets)edgeInsets imageTextPadding:(CGFloat)imageTextPadding textMaxWidth:(CGFloat)textMaxWidth textMinWidth:(CGFloat)textMinWidth borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius duration:(CGFloat)duration scaleAnimation:(BOOL)scaleAnimation dissmisPreviousHUD:(BOOL)dissmisPreviousHUD otherDisappearAnimationBlock:(nullable void(^)(id contentView, void(^finished)(void)))otherDisappearAnimationBlock;

#pragma mark - 顶部消息

/**
 *  顶部消息（message）
 */
- (void)zz_dropSheet:(nonnull NSString *)message;

/**
 *  顶部消息（message和block）
 */
- (void)zz_dropSheet:(nonnull NSString *)message tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock;

/**
 *  顶部消息（完整参数）
 */
- (void)zz_dropSheet:(nonnull NSString *)message textFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor sheetbackgroundColor:(nullable UIColor *)sheetbackgroundColor closeImageNormal:(nullable UIImage *)closeImageNormal closeImageHighlighted:(nullable UIImage *)closeImageHighlighted stayDuration:(CGFloat)stayDuration tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock;

#pragma mark - Spinner动画

/**
 * Spinner动画开始
 */
- (void)zz_startSpinningNoMessage:(ZZSpinnerLoadingStyle)style;

/**
 * Spinner动画开始
 */
- (void)zz_startSpinningNoMessage:(ZZSpinnerPosistion)position style:(ZZSpinnerLoadingStyle)style;

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(ZZSpinnerLoadingStyle)style;

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(nullable NSString *)title style:(ZZSpinnerLoadingStyle)style;

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(nullable NSString *)title position:(ZZSpinnerPosistion)position style:(ZZSpinnerLoadingStyle)style;

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence position:(ZZSpinnerPosistion)position offsetRateFromTop:(CGFloat)offsetRateFromTop layout:(ZZSpinnerLoadingViewLayout)layout backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

/**
 * Spinner动画开始
 */
- (void)zz_startSpinning:(CGPoint)point layout:(ZZSpinnerLoadingViewLayout)layout loadingWidth:(CGFloat)loadingWidth spinnerHeight:(CGFloat)spinnerHeight labelHeight:(CGFloat)labelHeight spinnerLabelGap:(CGFloat)spinnerLabelGap backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius title:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence cycleDuration:(CGFloat)cycleDuration;

/**
 * Spinner动画停止
 */
- (void)zz_stopSpinning;

#pragma mark - Popup View

/**
 *  Popup动画
 */
- (void)zz_popup:(nullable ZZPopupView *)popupView blurColor:(nullable UIColor *)blurColor userInteractionEnabled:(BOOL)userInteractionEnabled springs:(nullable NSArray<NSNumber *> *)springs actionBlock:(nullable void(^)(id value))actionBlock;

@end

#pragma mark - ZZDropSheet

@interface ZZDropSheet : UIView

#pragma mark - 初始化函数

- (instancetype)initWithMessage:(nonnull NSString *)message;

- (instancetype)initWithMessage:(nonnull NSString *)message tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock;

- (instancetype)initWithMessage:(nonnull NSString *)message textFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor sheetbackgroundColor:(nullable UIColor *)sheetbackgroundColor closeImageNormal:(nullable UIImage *)closeImageNormal closeImageHighlighted:(nullable UIImage *)closeImageHighlighted stayDuration:(CGFloat)stayDuration tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock;

#pragma mark - Public

/**
 *  显示DropSheet
 */
- (void)zz_show;

@end

#pragma mark - ZZSpinnerLoadingView

@interface ZZSpinnerLoadingView : UIView

@property (nonatomic, assign, readonly) CGFloat zzLoadingWidth;
@property (nonatomic, assign, readonly) CGFloat zzSpinnerHeight;
@property (nonatomic, assign, readonly) CGFloat zzLabelHeight;
@property (nonatomic, assign, readonly) CGFloat zzSpinnerLabelGap;

/**
 *  创建ZZSpinnerLoadingView
 */
+ (ZZSpinnerLoadingView *)zz_spinnerLoadingView:(ZZSpinnerLoadingViewLayout)layout backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius title:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence;

/**
 *  创建ZZSpinnerLoadingView
 */
+ (ZZSpinnerLoadingView *)zz_spinnerLoadingView:(ZZSpinnerLoadingViewLayout)layout loadingWidth:(CGFloat)loadingWidth spinnerHeight:(CGFloat)spinnerHeight labelHeight:(CGFloat)labelHeight spinnerLabelGap:(CGFloat)spinnerLabelGap backgroundColor:(nullable UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius title:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont kern:(CGFloat)kern colorSequence:(nullable NSArray *)colorSequence;

/**
 *  ZZSpinnerLoadingView启动动画
 */
- (void)zz_StartSpinning;

/**
 *  ZZSpinnerLoadingView启动动画
 */
- (void)zz_startSpinningCycleDuration:(CGFloat)drawCycleDuration;

/**
 *  ZZSpinnerLoadingView启动动画
 */
- (void)zz_startSpinning:(id)title;

/**
 *  ZZSpinnerLoadingView停止动画
 */
- (void)zz_stopSpinning;

@end

#pragma mark - ZZPopupView

typedef NS_ENUM(NSInteger, ZZPopupViewAnimation) {
    ZZPopupViewAnimationNoneCenter,      // 没有动画Center
    ZZPopupViewAnimationNoneTop,         // 没有动画Top
    ZZPopupViewAnimationNoneBottom,      // 没有动画Bottom
    ZZPopupViewAnimationScaleCenter,     // 缩放动画Center
    ZZPopupViewAnimationDropCenter,      // 从顶至下动画Center
    ZZPopupViewAnimationDropTop,         // 从顶至下动画Top
    ZZPopupViewAnimationPopCenter,       // 从底至上动画Center
    ZZPopupViewAnimationPopBottom,       // 从底至上动画Bottom
};

@interface ZZPopupView : UIView

// 默认的显示动画类型
@property (nonatomic, assign) ZZPopupViewAnimation zzPopupAppearAnimation;

// 默认的消失动画类型
@property (nonatomic, assign) ZZPopupViewAnimation zzPopupDisappearAnimation;

// 自定义显示动画Block
@property (nonnull, nonatomic, copy) void(^zzPopupAppearAnimationBlock)(void);

// 自定义消失动画Block
@property (nonnull, nonatomic, copy) void(^zzPopupDisappearAnimationBlock)(void(^_Nullable dismissCompletion)(void));

// 消失动画后的后续Block
@property (nullable, nonatomic, copy) void(^zzPopupActionBlock)(id value);

// 点击取消的事件回调
@property (nullable, nonatomic, copy) void(^zzPopupTapCloseBlock)(void);

// 点击Blur空白处的事件回调
@property (nullable, nonatomic, copy) void(^zzPopupTapBlurBlock)(void);

// 父页面
@property (nonatomic, weak) UIView *zzPopupParentView;

// 背景页
@property (nonatomic, weak) ZZPopupBlurView *zzPopupBlurView;

// Spring动画参数Duration
@property (nonatomic, strong) NSNumber *zzPopupDuration;

// Spring动画参数DampingRation
@property (nonatomic, strong) NSNumber *zzPopupSpringDampingRatio;

// Spring动画参数Velocity
@property (nonatomic, strong) NSNumber *zzPopupSpringVelocity;

// 关闭PopupView
- (IBAction)zz_tapClosePopupView:(nullable id)sender;

@end

@interface ZZPopupBlurView : UIView

@end

NS_ASSUME_NONNULL_END
