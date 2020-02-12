//
//  ZZMovieManager.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZMovieManager.h"
#import "ZZStorage.h"
#import "ZZMacro.h"

@implementation ZZAVInputSettingConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 视频写入参数
        // 视频编码格式
        self.videoCodec = AVVideoCodecH264;
        // 视频像素宽
        self.videoWidth = nil;
        // 视频像素高
        self.videoHeight = nil;
        // 采样率
        self.videoAverageBitRate = [NSNumber numberWithInt:16 * 100000];
        // 帧数
        self.videoMaxKeyFrameInterval = [NSNumber numberWithInt:30];
        /// 音频写入参数
        // 音频编码格式
        self.audioFormatID = [NSNumber numberWithInteger: kAudioFormatMPEG4AAC];
        // 采样率
        self.audioEncoderBitRatePerChannel = [NSNumber numberWithInt: 64000];
    }
    return self;
}

@end

@interface ZZMovieManager()
{
    BOOL                _readyToRecordVideo;
    BOOL                _readyToRecordAudio;
    dispatch_queue_t    _movieWritingQueue;

    AVAssetWriter      *_movieWriter;
    AVAssetWriterInput *_movieAudioInput;
    AVAssetWriterInput *_movieVideoInput;
    
    ZZAVFileType       _exportAVFileType;
    ZZAVInputSettingConfig *_inputSettingConfig;
}

@property (nonatomic, strong) NSURL *movieURL;

@end

@implementation ZZMovieManager

- (NSURL *)movieURL {

    long long date = [[NSDate date] timeIntervalSince1970];
    NSString *extension = nil;
    switch (_exportAVFileType) {
        case ZZAVFileTypeMOV:
        {
            extension = @".mov";
            break;
        }
        case ZZAVFileTypeMP4:
        {
            extension = @".mp4";
            break;
        }
        default:
            break;
    }
    _movieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@movie_%lld%@", NSTemporaryDirectory(), date, extension]];
    return _movieURL;
}

- (instancetype)init {
    
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithAVFileType:" userInfo:nil];
}

- (instancetype)initWithAVFileType:(ZZAVFileType)type inputSettingConfig:(ZZAVInputSettingConfig *)inputSettingConfig {
    
    self = [super init];
    if (self) {
        _exportAVFileType = type;
        _inputSettingConfig = inputSettingConfig;
        _movieWritingQueue = dispatch_queue_create("Movie.Writing.Queue", DISPATCH_QUEUE_SERIAL);
        _referenceOrientation = AVCaptureVideoOrientationPortrait;
    }
    return self;
}

- (void)start:(void(^)(NSError *error))handle {
    
    // [self removeFile:self.movieURL];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_movieWritingQueue, ^{
        NSError *error;
        if (!self->_movieWriter) {
            AVFileType exportAVFileType;
            switch (self->_exportAVFileType) {
                case ZZAVFileTypeMOV:
                {
                    exportAVFileType = AVFileTypeQuickTimeMovie;
                    break;
                }
                case ZZAVFileTypeMP4:
                {
                    exportAVFileType = AVFileTypeMPEG4;
                    break;
                }
                default:
                    break;
            }
            self->_movieWriter = [[AVAssetWriter alloc] initWithURL:weakSelf.movieURL fileType:exportAVFileType error:&error];
        }
        handle(error);
    });
}

- (void)stop:(void(^)(NSURL *url, NSError *error))handle {
    
    _readyToRecordVideo = NO;
    _readyToRecordAudio = NO;
    dispatch_async(_movieWritingQueue, ^{
        [self->_movieWriter finishWritingWithCompletionHandler:^(){
            if (self->_movieWriter.status == AVAssetWriterStatusCompleted) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    handle(self->_movieURL, nil);
                });
            } else {
                handle(nil, self->_movieWriter.error);
            }
            self->_movieWriter = nil;
        }];
    });
}

- (void)removeAllTemporaryVideoFiles {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:[ZZStorage zz_temporaryDirectory] error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"] ||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"mov"]) {
            [fileManager removeItemAtPath:[[ZZStorage zz_temporaryDirectory] stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

- (void)writeData:(AVCaptureConnection *)connection video:(AVCaptureConnection*)video audio:(AVCaptureConnection *)audio buffer:(CMSampleBufferRef)buffer {
    
    CFRetain(buffer);
    dispatch_async(_movieWritingQueue, ^{
        if (connection == video){
            if (!self->_readyToRecordVideo){
                self->_readyToRecordVideo = [self setupAssetWriterVideoInput:CMSampleBufferGetFormatDescription(buffer)] == nil;
            }
            if ([self inputsReadyToRecord]){
                [self writeSampleBuffer:buffer ofType:AVMediaTypeVideo];
            }
        } else if (connection == audio){
            if (!self->_readyToRecordAudio){
                self->_readyToRecordAudio = [self setupAssetWriterAudioInput:CMSampleBufferGetFormatDescription(buffer)] == nil;
            }
            if ([self inputsReadyToRecord]){
                [self writeSampleBuffer:buffer ofType:AVMediaTypeAudio];
            }
        }
        CFRelease(buffer);
    });
}

- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(NSString *)mediaType {
    
    if (_movieWriter.status == AVAssetWriterStatusUnknown){
        if ([_movieWriter startWriting]){
            [_movieWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
        } else {
            ZZLog(@"%@", _movieWriter.error);
        }
    }
    if (_movieWriter.status == AVAssetWriterStatusWriting){
        if (mediaType == AVMediaTypeVideo){
            if (!_movieVideoInput.readyForMoreMediaData){
                return;
            }
            if (![_movieVideoInput appendSampleBuffer:sampleBuffer]){
                ZZLog(@"%@", _movieWriter.error);
            }
        } else if (mediaType == AVMediaTypeAudio){
            if (!_movieAudioInput.readyForMoreMediaData){
                return;
            }
            if (![_movieAudioInput appendSampleBuffer:sampleBuffer]){
                ZZLog(@"%@", _movieWriter.error);
            }
        }
    }
}

- (BOOL)inputsReadyToRecord {
    
    return _readyToRecordVideo && _readyToRecordAudio;
}

/// 音频源数据写入配置
- (NSError *)setupAssetWriterAudioInput:(CMFormatDescriptionRef)currentFormatDescription {
    
    size_t aclSize = 0;
    const AudioStreamBasicDescription *currentASBD = CMAudioFormatDescriptionGetStreamBasicDescription(currentFormatDescription);
    const AudioChannelLayout *channelLayout = CMAudioFormatDescriptionGetChannelLayout(currentFormatDescription,&aclSize);
    NSData *dataLayout = aclSize > 0 ? [NSData dataWithBytes:channelLayout length:aclSize] : [NSData data];
    NSNumber *audioFormat = _inputSettingConfig.audioFormatID == nil ? [NSNumber numberWithInteger: kAudioFormatMPEG4AAC] : _inputSettingConfig.audioFormatID;
    NSNumber *encoderBitRatePerChannel = _inputSettingConfig.audioEncoderBitRatePerChannel == nil ? [NSNumber numberWithInt: 64000] : _inputSettingConfig.audioEncoderBitRatePerChannel;
    NSDictionary *settings = @{AVFormatIDKey: audioFormat,
                             AVSampleRateKey: [NSNumber numberWithFloat: currentASBD->mSampleRate],
                          AVChannelLayoutKey: dataLayout,
                       AVNumberOfChannelsKey: [NSNumber numberWithInteger: currentASBD->mChannelsPerFrame],
               AVEncoderBitRatePerChannelKey: encoderBitRatePerChannel};

    if ([_movieWriter canApplyOutputSettings:settings forMediaType: AVMediaTypeAudio]){
        _movieAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeAudio outputSettings:settings];
        _movieAudioInput.expectsMediaDataInRealTime = YES;
        if ([_movieWriter canAddInput:_movieAudioInput]){
            [_movieWriter addInput:_movieAudioInput];
        } else {
            return _movieWriter.error;
        }
    } else {
        return _movieWriter.error;
    }
    return nil;
}

/// 视频源数据写入配置
- (NSError *)setupAssetWriterVideoInput:(CMFormatDescriptionRef)currentFormatDescription {
    
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(currentFormatDescription);
    NSUInteger numPixels = dimensions.width * dimensions.height;
    CGFloat bitsPerPixel = numPixels < (640 * 480) ? 4.05 : 11.0;
    NSNumber *videoAverageBitRate = _inputSettingConfig.videoAverageBitRate == nil ? [NSNumber numberWithInteger: numPixels * bitsPerPixel] : _inputSettingConfig.videoAverageBitRate;
    NSString *videoCodec = _inputSettingConfig.videoCodec == nil ? AVVideoCodecH264 : _inputSettingConfig.videoCodec;
    NSNumber *videoMaxKeyFrameInterval = _inputSettingConfig.videoMaxKeyFrameInterval == nil ? [NSNumber numberWithInteger:30] : _inputSettingConfig.videoMaxKeyFrameInterval;
    NSNumber *videoWidth = nil;
    NSNumber *videoHeight = nil;
    if (_inputSettingConfig.videoWidth == nil && _inputSettingConfig.videoHeight ==nil) {
        videoWidth = [NSNumber numberWithInteger:dimensions.width];
        videoHeight = [NSNumber numberWithInteger:dimensions.height];
    }else if (_inputSettingConfig.videoWidth) {
        videoWidth = _inputSettingConfig.videoWidth;
        float h = [_inputSettingConfig.videoWidth floatValue] * ((float)dimensions.height / (float)dimensions.width);
        videoHeight = [NSNumber numberWithInt:(int)h];
    }else if (_inputSettingConfig.videoHeight) {
        videoHeight = _inputSettingConfig.videoHeight;
        float w = [_inputSettingConfig.videoHeight floatValue] * ((float)dimensions.width / (float)dimensions.height);
        videoWidth = [NSNumber numberWithInteger:(int)w];
    }
    NSDictionary *compression = @{AVVideoAverageBitRateKey: videoAverageBitRate,
                                  AVVideoMaxKeyFrameIntervalKey: videoMaxKeyFrameInterval};
    NSDictionary *settings = @{AVVideoCodecKey: videoCodec,
                               AVVideoWidthKey: videoWidth,
                              AVVideoHeightKey: videoHeight,
                               AVVideoCompressionPropertiesKey: compression};
    if ([_movieWriter canApplyOutputSettings:settings forMediaType:AVMediaTypeVideo]){
        _movieVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
        _movieVideoInput.expectsMediaDataInRealTime = YES;
        _movieVideoInput.transform = [self transformFromCurrentVideoOrientationToOrientation:self.referenceOrientation];
        if ([_movieWriter canAddInput:_movieVideoInput]){
            [_movieWriter addInput:_movieVideoInput];
        } else {
            return _movieWriter.error;
        }
    } else {
        return _movieWriter.error;
    }
    return nil;
}

// 获取视频旋转矩阵
- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation {
    
    CGFloat orientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:orientation];
    CGFloat videoOrientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:self.currentOrientation];
    CGFloat angleOffset;
    if (self.currentDevice.position == AVCaptureDevicePositionBack) {
        angleOffset = videoOrientationAngleOffset - orientationAngleOffset + M_PI_2;
    } else {
        angleOffset = orientationAngleOffset - videoOrientationAngleOffset + M_PI_2;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleOffset);
    return transform;
}

// 获取视频旋转角度
- (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation {
    
    CGFloat angle = 0.0;
    switch (orientation){
        case AVCaptureVideoOrientationPortrait:
            angle = 0.0;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
    }
    return angle;
}

// 移除文件
- (void)removeFile:(NSURL *)fileURL {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = fileURL.path;
    if ([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success){
            ZZLog(@"删除视频文件失败：%@", error);
        } else {
            ZZLog(@"删除视频文件成功");
        }
    }
}

@end
