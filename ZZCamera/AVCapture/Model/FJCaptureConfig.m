//
//  FJCaptureConfig.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/22.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJCaptureConfig.h"
#import "NSString+ZZKit.h"

@implementation FJCaptureConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        // 每次拍照、录像完成确认界面
        self.enableConfirmPreview = YES;
        // 支持浏览和编辑所有照片、录像
        self.enablePreviewAll = YES;
        // 默认最大拍摄Media数量
        self.maxMediaCount = 9;
        // 超过最大数量是否提示
        self.enableWarningOverMaxMediaCount = YES;
        // 支持前后置摄像头切换
        self.enableSwitch = YES;
        // 支持补光
        self.enableLightSupplement = YES;
        // 支持闪光灯
        self.enableFlashLight = YES;
        // 支持自动聚焦和曝光
        self.enableAutoFocusAndExposure = YES;
        // 支持缩放
        self.enableZoom = YES;
        // 支持缩放显示条
        self.enableZoomIndicator = YES;
        // 支持手动聚焦/曝光
        self.enableManualTapFocusAndExposure = YES;
        // 支持拍摄模式
        self.captureType = FJCaptureTypeAll;
        // Preview全屏
        self.capturePreviewFullScreen = YES;
        // Top Bar 背景颜色
        self.topBarTintColor = [UIColor clearColor];
        // Bottom Bar 背景颜色
        self.bottomBarTintColor = [UIColor clearColor];
        // Top Bar 高度
        self.topBarHeight = 64.0;
        // Bottom Bar 高度
        self.bottomBarHeight = 220.0;
        // 聚焦框颜色
        self.focusBorderColor = [UIColor whiteColor];
        // 聚焦框边长
        self.focusSideLength = 160.0;
        // 聚焦框厚度
        self.focusBorderWidth = 2.0;
        // 曝光框颜色
        self.exposureBorderColor = [UIColor whiteColor];
        // 曝光框边长
        self.exposureSideLength = 180.0;
        // 曝光框厚度
        self.exposureBorderWidth = 5.0;
        // 缩放显示条 maximumTrackTintColor
        self.zoomIndicatorMaximumTrackTintColor = [UIColor whiteColor];
        // 缩放显示条 minimumTrackTintColor
        self.zoomIndicatorMinimumTrackTintColor = [UIColor whiteColor];
        // 缩放显示条 thumbTintColor
        self.zoomIndicatorThumbTintColor = [UIColor whiteColor];
        // 缩放显示条 OffsetTop
        self.zoomIndicatorOffsetTop = 104.0;
        // 缩放显示条 OffsetRight
        self.zoomIndicatorOffsetRight = 30.0;
        // 缩放显示条 Width
        self.zoomIndicatorWidth = 10.0;
        // 缩放显示条 Height
        self.zoomIndicatorHeight = 200.0;
        // 控件使用图标 Top View (Cancel Button除外)
        self.widgetUsingImageTopView = NO;
        // 控件使用图标 Cancel Button
        self.widgetUsingImageCancel = NO;
        // 控件使用图标 Bottom Button
        self.widgetUsingImageBottomView = NO;
        // Take View Size
        CGFloat w = 0.25 * UIScreen.mainScreen.bounds.size.width;
        self.takeViewSize = CGSizeMake(w, w);
        // Take Button Size
        self.takeButtonSize = CGSizeMake(w - 20.0, w - 20.0);
        // Take Button Stroke Color
        self.takeButtonStrokeColor = @"#00D76E".zz_color;
        // Take Button Stroke Width
        self.takeButtonStrokeWidth = 10.0;
        // Take Button Stroke Long Press Duration
        self.takeButtonLongTapPressDuration = 0.5;
        // Take Button Stroke Circle Duration
        self.takeButtonCircleDuration = 15.0;
        // Hint Height
        self.hintHeight = 27.0;
    }
    return self;
}

@end
