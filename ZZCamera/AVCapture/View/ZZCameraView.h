//
//  ZZCameraView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZVideoPreview.h"
#import "ZZCaptureConfig.h"

@class ZZCameraView;

@protocol ZZCameraViewDelegate <NSObject>
@optional;

/// 闪光灯
- (void)flashLightAction:(ZZCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 补光
- (void)torchLightAction:(ZZCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 转换摄像头
- (void)swicthCameraAction:(ZZCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 自动聚焦曝光
- (void)autoFocusAndExposureAction:(ZZCameraView *)cameraView handle:(void(^)(NSError *error))handle;

/// 聚焦
- (void)focusAction:(ZZCameraView *)cameraView point:(CGPoint)point handle:(void(^)(NSError *error))handle;

/// 曝光
- (void)exposAction:(ZZCameraView *)cameraView point:(CGPoint)point handle:(void(^)(NSError *error))handle;

/// 缩放
- (void)zoomAction:(ZZCameraView *)cameraView factor:(CGFloat)factor;

/// 取消
- (void)cancelAction:(ZZCameraView *)cameraView;

/// 拍照
- (void)takePhotoAction:(ZZCameraView *)cameraView;

/// 停止录制视频
- (void)stopRecordVideoAction:(ZZCameraView *)cameraView;

/// 开始录制视频
- (void)startRecordVideoAction:(ZZCameraView *)cameraView;

/// 点击预览和编辑
- (void)previewAction:(ZZCameraView *)cameraView;

/// 完成预览和编辑
- (void)doneAction:(ZZCameraView *)cameraView;

@end

@interface ZZCameraView : UIView

@property (nonatomic, weak) id <ZZCameraViewDelegate> delegate;

@property (nonatomic, strong, readonly) ZZVideoPreview *previewView;

@property (nonatomic, assign, readonly) ZZCaptureType captureType;

@property (nonatomic, strong) ZZCaptureConfig *config;

- (instancetype)initWithFrame:(CGRect)frame config:(ZZCaptureConfig *)config;

- (void)changeTorch:(BOOL)on;

- (void)changeFlash:(BOOL)on;

- (void)updateMedias:(NSMutableArray *)medias;

@end
