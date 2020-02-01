//
//  ZZAVCaptureViewController.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCameraView.h"
#import "ZZMediaObject.h"
#import "ZZCaptureConfig.h"
#import "ZZMovieManager.h"

@interface ZZAVCaptureViewController : UIViewController

// 自定义初始化
- (instancetype)initWithAVInputSettingConfig:(FJAVInputSettingConfig *)inputSettingConfig outputExtension:(FJAVFileType)outputExtension;

// Media
@property (nonatomic, strong, readonly) NSMutableArray *medias;

// ZZCaptureConfig参数
@property (nonatomic, strong) ZZCaptureConfig *config;

// 图片/视频拍摄完成的回调
@property (nonatomic, copy) void(^mediasTakenBlock)(NSArray *medias);

@end
