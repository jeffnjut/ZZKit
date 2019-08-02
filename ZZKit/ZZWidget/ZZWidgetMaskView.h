//
//  ZZWidgetMaskView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ZZWidgetMaskView

@class ZZWidgetMaskView;

typedef NS_ENUM(NSUInteger, ZZWidgetMaskViewRevealType) {
    ZZWidgetMaskViewRevealTypeRect = 0,    //矩形 default
    ZZWidgetMaskViewRevealTypeOval         //椭圆
};

typedef NS_ENUM(NSUInteger, ZZWidgetMaskViewCoverType) {
    ZZWidgetMaskViewCoverTypeColored,      //颜色 default
    ZZWidgetMaskViewCoverTypeBlurred       //模糊
};

typedef NS_ENUM(NSUInteger, ZZWidgetMaskViewLayoutType) {
    ZZWidgetMaskViewLayoutTypeUP,          //描述label所处的位置
    ZZWidgetMaskViewLayoutTypeLeftUP,
    ZZWidgetMaskViewLayoutTypeLeft,
    ZZWidgetMaskViewLayoutTypeLeftDown,
    ZZWidgetMaskViewLayoutTypeDown,
    ZZWidgetMaskViewLayoutTypeRightDown,
    ZZWidgetMaskViewLayoutTypeRight,
    ZZWidgetMaskViewLayoutTypeRightUP,
};

@protocol ZZWidgetMaskViewDelegate <NSObject>

@optional

- (void)maskViewDidClickedDismissBtn:(ZZWidgetMaskView *)maskView;

- (void)maskViewDidClickedNeverBtn:(ZZWidgetMaskView *)maskView;

@end

@interface ZZWidgetMaskView : UIView

@property (nonatomic, weak) id<ZZWidgetMaskViewDelegate> delegate;

@property (nonatomic, assign) ZZWidgetMaskViewCoverType maskCoverType;

@property (nonatomic, assign) ZZWidgetMaskViewRevealType revealType;

@property (nonatomic, assign, getter = isDesHidden) BOOL desHidden;

// is essential to bluredCoverType  0 — 1  default is 0.5
@property (nonatomic, assign) CGFloat blurRadius;

// is essential to coloredCoverType  default is 0 0 0 0.8
@property (nonatomic, strong) UIColor *coverColor;

//white
@property (nonatomic, strong, readonly) UIColor* tintColor;

//default is 0.2
@property (nonatomic, assign) CGFloat showDuration;

//default is 0.2
@property (nonatomic, assign) CGFloat dismissDuration;

//x轴外扩的值   default is -5

@property (nonatomic, assign) CGFloat insetX;

//Y轴外扩的值   default is -5
@property (nonatomic, assign) CGFloat insetY;

@property (nonatomic, assign, readonly) CGRect revealFrame;

@property (nonatomic, assign) ZZWidgetMaskViewLayoutType layoutType;

@property (nonatomic, assign) CGPoint neverBtnCenter;

//default is 确定
@property (nonatomic, copy) NSString* dismissBtnTitle;

@property (nonatomic, copy) NSString* des;

@property (nonatomic, copy) NSString* detailDes;

- (instancetype)initWithRevalView:(UIView *)revalView layoutType:(ZZWidgetMaskViewLayoutType)layoutType;

// color背景色, aView漏出来的view, aType露出的类型
- (instancetype)initWithBgColor:(UIColor *)bgColor revealView:(UIView *)revealView revealType:(ZZWidgetMaskViewRevealType)type layoutType:(ZZWidgetMaskViewLayoutType)layoutType;

// 带模糊背景的初始化
- (instancetype)initWithBlurRadius:(CGFloat)blurRadius revealView:(UIView *)revealView revealType:(ZZWidgetMaskViewRevealType)type layoutType:(ZZWidgetMaskViewLayoutType)layoutType;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end

#pragma mark - ZZWidgetMaskQueue

@class ZZWidgetMaskQueue, ZZWidgetMaskView;

@protocol ZZWidgetMaskQueueDelegate <NSObject>

@optional

- (void)maskViewQueue:(ZZWidgetMaskQueue *)queue didDismissMaskAtIndex:(NSUInteger)index;
- (void)maskViewQueueDidDismissAllMasks:(ZZWidgetMaskQueue *)queue;
- (void)maskViewQueue:(ZZWidgetMaskQueue *)queue didClickedNeverBtnInMaskView:(ZZWidgetMaskView *)maskView;

@end

@interface ZZWidgetMaskQueue : NSObject

@property (nonatomic, weak) id<ZZWidgetMaskQueueDelegate>delegate;

@property (nonatomic, strong, readonly) NSMutableArray<__kindof ZZWidgetMaskView *> *masks;

@property (nonatomic, strong, readonly) ZZWidgetMaskView* showingMask;

- (void)addPromptMaskView:(ZZWidgetMaskView *)aMask;

- (void)showMasksInView:(UIView *)aView;

- (void)dismissAllMasks;

@end

NS_ASSUME_NONNULL_END
