//
//  FJVideoPreview.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJVideoPreview.h"

@implementation FJVideoPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [(AVCaptureVideoPreviewLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    return self;
}

- (AVCaptureSession*)captureSessionsion {
    return [(AVCaptureVideoPreviewLayer*)self.layer session];
}

- (void)setCaptureSessionsion:(AVCaptureSession *)session {
    [(AVCaptureVideoPreviewLayer*)self.layer setSession:session];
}

- (CGPoint)captureDevicePointForPoint:(CGPoint)point {
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    return [layer captureDevicePointOfInterestForPoint:point];
}

// 使该view的layer方法返回AVCaptureVideoPreviewLayer对象
+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

@end
