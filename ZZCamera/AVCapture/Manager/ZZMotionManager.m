//
//  ZZMotionManager.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZMotionManager.h"
#import <CoreMotion/CoreMotion.h>
#import "ZZMacro.h"

@interface ZZMotionManager()

@property(nonatomic, strong) CMMotionManager * motionManager;

@end

@implementation ZZMotionManager

-(instancetype)init {
    
    self = [super init];
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 1/15.0;
        if (!_motionManager.deviceMotionAvailable) {
            _motionManager = nil;
            return self;
        }
        ZZ_WEAK_SELF
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [weakSelf performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
    return self;
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {
    
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x)) {
        if (y >= 0) {
            _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            _videoOrientation  = AVCaptureVideoOrientationPortraitUpsideDown;
        } else {
            _deviceOrientation = UIDeviceOrientationPortrait;
            _videoOrientation  = AVCaptureVideoOrientationPortrait;
        }
    } else {
        if (x >= 0) {
            _deviceOrientation = UIDeviceOrientationLandscapeRight;
            _videoOrientation  = AVCaptureVideoOrientationLandscapeRight;
        } else {
            _deviceOrientation = UIDeviceOrientationLandscapeLeft;
            _videoOrientation  = AVCaptureVideoOrientationLandscapeLeft;
        }
    }
}

-(void)dealloc {
    
    ZZLog(@"陀螺仪对象销毁了");
    [_motionManager stopDeviceMotionUpdates];
}

@end
