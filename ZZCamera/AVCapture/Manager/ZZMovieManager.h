//
//  ZZMovieManager.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ZZAVFileType) {
    ZZAVFileTypeMP4,   // MPEG4
    ZZAVFileTypeMOV    // QuickMovie
};

@interface ZZAVInputSettingConfig : NSObject

/// 视频写入参数
// 视频编码格式
@property (nonatomic, copy) NSString *videoCodec;
// 视频像素宽
@property (nonatomic, copy) NSNumber *videoWidth;
// 视频像素高
@property (nonatomic, copy) NSNumber *videoHeight;
// 采样率
@property (nonatomic, copy) NSNumber *videoAverageBitRate;
// 帧数
@property (nonatomic, copy) NSNumber *videoMaxKeyFrameInterval;
/// 音频写入参数
// 音频编码格式
@property (nonatomic, copy) NSNumber *audioFormatID;
// 采样率
@property (nonatomic, copy) NSNumber *audioEncoderBitRatePerChannel;

@end

@interface ZZMovieManager : NSObject

@property(nonatomic, assign) AVCaptureVideoOrientation referenceOrientation; // 视频播放方向

@property(nonatomic, assign) AVCaptureVideoOrientation currentOrientation;

@property(nonatomic, strong) AVCaptureDevice *currentDevice;

- (instancetype)initWithAVFileType:(ZZAVFileType)type inputSettingConfig:(ZZAVInputSettingConfig *)inputSettingConfig;

- (void)start:(void(^)(NSError *error))handle;

- (void)stop:(void(^)(NSURL *url, NSError *error))handle;

- (void)removeAllTemporaryVideoFiles;

- (void)writeData:(AVCaptureConnection *)connection video:(AVCaptureConnection*)video audio:(AVCaptureConnection *)audio buffer:(CMSampleBufferRef)buffer;

@end
