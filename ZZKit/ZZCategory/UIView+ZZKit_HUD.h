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

typedef NS_ENUM(NSInteger, ZZToastType) {
    ZZToastTypeSuccess,  // 成功
    ZZToastTypeError,    // 异常
    ZZToastTypeWarning   // 警告
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
- (MBProgressHUD *)zz_toast:(nullable NSString *)message;

/**
 *  吐司（消息、动画）
 */
- (MBProgressHUD *)zz_toast:(nullable NSString *)message toastType:(ZZToastType)toastType;

/**
 *  吐司（消息、动画等完整参数）
 */
- (MBProgressHUD *)zz_showHUD:(nullable NSAttributedString *)message lottiePath:(nullable NSString *)lottiePath lottieViewSize:(CGSize)lottieViewSize edgeInsects:(UIEdgeInsets)edgeInsets imageTextPadding:(CGFloat)imageTextPadding textMaxWidth:(CGFloat)textMaxWidth textMinWidth:(CGFloat)textMinWidth borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius duration:(CGFloat)duration scaleAnimation:(BOOL)scaleAnimation otherDisappearAnimationBlock:(nullable void(^)(id contentView, void(^finished)(void)))otherDisappearAnimationBlock;

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

NS_ASSUME_NONNULL_END
