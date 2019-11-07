//
//  FJCameraView.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJVideoPreview.h"
#import "FJCaptureConfig.h"

@class FJCameraView;

@protocol FJCameraViewDelegate <NSObject>
@optional;

/// 闪光灯
- (void)flashLightAction:(FJCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 补光
- (void)torchLightAction:(FJCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 转换摄像头
- (void)swicthCameraAction:(FJCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 自动聚焦曝光
- (void)autoFocusAndExposureAction:(FJCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 聚焦
- (void)focusAction:(FJCameraView *)cameraView point:(CGPoint)point handle:(void(^)(NSError *error))handle;

/// 曝光
- (void)exposAction:(FJCameraView *)cameraView point:(CGPoint)point handle:(void(^)(NSError *error))handle;

/// 缩放
- (void)zoomAction:(FJCameraView *)cameraView factor:(CGFloat)factor;

/// 取消
- (void)cancelAction:(FJCameraView *)cameraView;

/// 拍照
- (void)takePhotoAction:(FJCameraView *)cameraView;

/// 停止录制视频
- (void)stopRecordVideoAction:(FJCameraView *)cameraView;

/// 开始录制视频
- (void)startRecordVideoAction:(FJCameraView *)cameraView;

/// 点击预览和编辑
- (void)previewAction:(FJCameraView *)cameraView;

/// 完成预览和编辑
- (void)doneAction:(FJCameraView *)cameraView;

@end

@interface FJCameraView : UIView

@property (nonatomic, weak) id <FJCameraViewDelegate> delegate;

@property (nonatomic, strong, readonly) FJVideoPreview *previewView;

@property (nonatomic, assign, readonly) FJCaptureType captureType;

@property (nonatomic, strong) FJCaptureConfig *config;

- (instancetype)initWithFrame:(CGRect)frame config:(FJCaptureConfig *)config;

- (void)changeTorch:(BOOL)on;

- (void)changeFlash:(BOOL)on;

- (void)updateMedias:(NSMutableArray *)medias;

@end
