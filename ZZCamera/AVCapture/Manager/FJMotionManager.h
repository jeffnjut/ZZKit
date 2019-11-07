//
//  FJMotionManager.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FJMotionManager : NSObject

@property(nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property(nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

@end
