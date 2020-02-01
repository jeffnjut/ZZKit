//
//  ZZCameraManager.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCameraManager : NSObject

- (AVCaptureDeviceInput *)switchCamera:(AVCaptureSession *)session
                                   old:(AVCaptureDeviceInput *)oldinput
                                   new:(AVCaptureDeviceInput *)newinput;

- (id)resetFocusAndExposure:(AVCaptureDevice *)device;

- (id)zoom:(AVCaptureDevice *)device factor:(CGFloat)factor;

- (id)focus:(AVCaptureDevice *)device point:(CGPoint)point;

- (id)expose:(AVCaptureDevice *)device point:(CGPoint)point;

- (id)changeFlash:(AVCaptureDevice *)device mode:(AVCaptureFlashMode)mode;

- (id)changeTorch:(AVCaptureDevice *)device model:(AVCaptureTorchMode)mode;

- (AVCaptureFlashMode)flashMode:(AVCaptureDevice *)device;

- (AVCaptureTorchMode)torchMode:(AVCaptureDevice *)device;

// 保存视频
+ (void)saveMovieToCameraRoll:(NSURL *)url completionBlock:(void (^)(NSURL *mediaURL, NSError *error))completionBlock;

// 保存图片
+ (void)savePhotoToPhotoLibrary:(UIImage *)image completionBlock:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completionBlock;

@end

NS_ASSUME_NONNULL_END
