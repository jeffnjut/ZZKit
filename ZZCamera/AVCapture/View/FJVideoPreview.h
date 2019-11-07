//
//  FJVideoPreview.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FJVideoPreview : UIView

@property (strong, nonatomic) AVCaptureSession *captureSessionsion;

- (CGPoint)captureDevicePointForPoint:(CGPoint)point;

@end
