//
//  FJCaptureConfig.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/22.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FJCaptureType) {
    
    FJCaptureTypePhoto = 0x0001,
    FJCaptureTypeVidio = 0x0002,
    FJCaptureTypeAll   = FJCaptureTypePhoto | FJCaptureTypeVidio
};

@interface FJCaptureConfig : NSObject

// 每次拍照、录像完成确认界面
@property (nonatomic, assign) BOOL enableConfirmPreview;
// 支持浏览和编辑所有照片、录像
@property (nonatomic, assign) BOOL enablePreviewAll;
// 默认最大拍摄Media数量
@property (nonatomic, assign) NSUInteger maxMediaCount;
// 超过最大数量是否提示
@property (nonatomic, assign) BOOL enableWarningOverMaxMediaCount;
// 支持前后置摄像头切换
@property (nonatomic, assign) BOOL enableSwitch;
// 支持补光
@property (nonatomic, assign) BOOL enableLightSupplement;
// 支持闪光灯
@property (nonatomic, assign) BOOL enableFlashLight;
// 支持自动聚焦和曝光
@property (nonatomic, assign) BOOL enableAutoFocusAndExposure;
// 支持缩放
@property (nonatomic, assign) BOOL enableZoom;
// 支持缩放显示条
@property (nonatomic, assign) BOOL enableZoomIndicator;
// 支持手动聚焦/曝光
@property (nonatomic, assign) BOOL enableManualTapFocusAndExposure;
// 支持拍摄模式
@property (nonatomic, assign) FJCaptureType captureType;
// Preview全屏
@property (nonatomic, assign) BOOL capturePreviewFullScreen;
// Top Bar 背景颜色
@property (nonatomic, strong) UIColor *topBarTintColor;
// Bottom Bar 背景颜色
@property (nonatomic, strong) UIColor *bottomBarTintColor;
// Top Bar 高度
@property (nonatomic, assign) CGFloat topBarHeight;
// Bottom Bar 高度
@property (nonatomic, assign) CGFloat bottomBarHeight;
// 聚焦框颜色
@property (nonatomic, strong) UIColor *focusBorderColor;
// 聚焦框边长
@property (nonatomic, assign) CGFloat focusSideLength;
// 聚焦框厚度
@property (nonatomic, assign) CGFloat focusBorderWidth;
// 曝光框颜色
@property (nonatomic, strong) UIColor *exposureBorderColor;
// 曝光框边长
@property (nonatomic, assign) CGFloat exposureSideLength;
// 曝光框厚度
@property (nonatomic, assign) CGFloat exposureBorderWidth;
// 缩放显示条 maximumTrackTintColor
@property (nonatomic, strong) UIColor *zoomIndicatorMaximumTrackTintColor;
// 缩放显示条 minimumTrackTintColor
@property (nonatomic, strong) UIColor *zoomIndicatorMinimumTrackTintColor;
// 缩放显示条 thumbTintColor
@property (nonatomic, strong) UIColor *zoomIndicatorThumbTintColor;
// 缩放显示条 OffsetTop
@property (nonatomic, assign) CGFloat zoomIndicatorOffsetTop;
// 缩放显示条 OffsetRight
@property (nonatomic, assign) CGFloat zoomIndicatorOffsetRight;
// 缩放显示条 Width
@property (nonatomic, assign) CGFloat zoomIndicatorWidth;
// 缩放显示条 Height
@property (nonatomic, assign) CGFloat zoomIndicatorHeight;
// 控件使用图标 Top View (Cancel Button除外)
@property (nonatomic, assign) BOOL widgetUsingImageTopView;
// 控件使用图标 Cancel Button
@property (nonatomic, assign) BOOL widgetUsingImageCancel;
// 控件使用图标 Bottom View
@property (nonatomic, assign) BOOL widgetUsingImageBottomView;
// Take View Size
@property (nonatomic, assign) CGSize takeViewSize;
// Take Button Size
@property (nonatomic, assign) CGSize takeButtonSize;
// Take Button Stroke Color
@property (nonatomic, strong) UIColor *takeButtonStrokeColor;
// Take Button Stroke Width
@property (nonatomic, assign) CGFloat takeButtonStrokeWidth;
// Take Button Stroke Long Press Duration
@property (nonatomic, assign) CGFloat takeButtonLongTapPressDuration;
// Take Button Stroke Circle Duration
@property (nonatomic, assign) CGFloat takeButtonCircleDuration;
// Hint Height
@property (nonatomic, assign) CGFloat hintHeight;

@end
