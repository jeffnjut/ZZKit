//
//  FJCameraManager.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FJCameraManager : NSObject

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

@end

NS_ASSUME_NONNULL_END
