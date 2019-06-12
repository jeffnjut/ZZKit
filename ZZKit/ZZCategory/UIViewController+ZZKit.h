//
//  UIViewController+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAlertModel;
@protocol ZZAlertModel;

#pragma mark - UIViewController Extension

@interface UIViewController (ZZKit)

#pragma mark - 导航视图

/**
 *  增加图片类型导航按钮（左）
 */
- (void)zz_navigationAddLeftBarButton:(nonnull UIImage *)image action:(nullable void(^)(void))action;

/**
 *  增加图片类型导航按钮（右）
 */
- (void)zz_navigationAddRightBarButton:(nonnull UIImage *)image action:(nullable void(^)(void))action;

/**
 *  增加文本类型导航按钮（左）
 */
- (void)zz_navigationAddLeftBarTextButton:(nonnull NSAttributedString *)text action:(nullable void(^)(void))action;

/**
 *  增加文本类型导航按钮（右）
 */
- (void)zz_navigationAddRightBarTextButton:(nonnull NSAttributedString *)text action:(nullable void(^)(void))action;

/**
 *  增加自定义类型导航按钮（左）
 */
- (void)zz_navigationAddLeftBarCustomView:(nonnull UIView *)customeView action:(nullable void(^)(void))action;

/**
 *  增加自定义类型导航按钮（右）
 */
- (void)zz_navigationAddRightBarCustomView:(nonnull UIView *)customeView action:(nullable void(^)(void))action;

/**
 *  移除左侧导航按钮
 */
- (void)zz_navigationRemoveLeftBarButtons;

/**
 *  移除右侧导航按钮
 */
- (void)zz_navigationRemoveRightBarButtons;

/**
 *  增加UIBarButtonItem（Base）
 */
- (void)zz_navigationAddBarButton:(BOOL)left object:(nonnull id)object size:(CGSize)size margin:(UIEdgeInsets)margin action:(void(^)(void))action;

/**
 *  导航条设置是否隐藏
 */
- (void)zz_navigationBarHidden:(BOOL)isBarHidden;

/**
 *  设置导航条BarTintColor、Translucent和BottomLineColor
 */
- (void)zz_navigationBarStyle:(nullable UIColor *)barTintColor translucent:(BOOL)translucent bottomLineColor:(nullable UIColor *)bottomLineColor;

/**
 *  设置导航条BarTitle（NSAttributedString）
 */
- (void)zz_navigationBarAttributedTitle:(nonnull NSAttributedString *)title;

/**
 *  设置导航条BarTitle（NSString， 格式）
 */
- (void)zz_navigationBarTitle:(nonnull NSString *)title titleAttrs:(nullable NSDictionary *)titleAttrs;

/**
 *  设置导航条的Title（NSString）
 */
- (void)zz_navigationBarTitle:(nonnull NSString *)title;

#pragma mark - 电池条

/**
 *  设置StatusBar是否隐藏
 */
- (void)zz_statusBarHidden:(BOOL)hidden;

#pragma mark - Push、Present、Popup、Dismiss

/**
 *  Push Controller
 */
- (void)zz_push:(nonnull UIViewController *)viewController animated:(BOOL)animated;

/**
 *  Present Controller
 */
- (void)zz_present:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/**
 *  Pop到上一级ViewController
 */
- (void)zz_popToPrevious:(BOOL)animated;

/**
 *  Pop到Root ViewController
 */
- (void)zz_popToRoot:(BOOL)animated;

/**
 *  消失或者上一页[默认动画转场]
 */
- (void)zz_dismiss;

/**
 *  消失或者上一页[Base]
 */
- (void)zz_dismiss:(BOOL)animated;

/**
 *  消失或者Root页[默认动画转场]
 */
- (void)zz_dismissRoot;

/**
 *  消失或者Root页[Base]
 */
- (void)zz_dismissRoot:(BOOL)animated;

/**
 *  消失或者Offset页[默认动画转场]
 */
- (void)zz_dismissOffset:(NSUInteger)offset;

/**
 *  消失或者Offset页，当前页是0，上一页是1...[Base]
 */
- (void)zz_dismissOffset:(NSUInteger)offset animated:(BOOL)animated;

#pragma mark - Alert View & Sheet

/**
 *  弹出OK AlertView
 */
-(void)zz_alertView:(NSString *)title message:(NSString *)message;

/**
 *  弹出AlertView(Title,Message,Cancel,可变参数)
 */
-(void)zz_alertView:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel item:(ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

/**
 *  弹出AlertView(Title,Message,Cancel,Cancel颜色,可变参数)
 */
-(void)zz_alertView:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

/**
 *  弹出ActionSheet(Title,Message,Cancel,可变参数)
 */
-(void)zz_alertSheet:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel item:(ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

/**
 *  弹出ActionSheet(Title,Message,Cancel,Cancel颜色,可变参数)
 */
-(void)zz_alertSheet:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

/**
 *  弹窗,AlertView + ActionSheet
 */
- (void)zz_alert:(NSString *)title message:(NSString *)message items:(NSMutableArray *)items cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor alertStyle:(UIAlertControllerStyle)alertStyle;

@end

#pragma mark - ZZAlertModel

@interface ZZAlertModel : NSObject

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   void(^action)(void);
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, strong) UIColor *color;

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModelOkayButton:(nullable void(^)(void))action;

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModelCancelButton:(nullable void(^)(void))action;

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModel:(nonnull NSString *)title action:(nullable void(^)(void))action;

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModel:(nonnull NSString *)title style:(UIAlertActionStyle)style action:(nullable void(^)(void))action;

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModel:(nonnull NSString *)title style:(UIAlertActionStyle)style action:(nullable void(^)(void))action color:(nullable UIColor *)color;

@end

@protocol ZZAlertModel <NSObject>

@end

NS_ASSUME_NONNULL_END
