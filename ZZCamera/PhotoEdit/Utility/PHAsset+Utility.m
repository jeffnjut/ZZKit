//
//  PHAsset+Utility.m
//  AFNetworking
//
//  Created by Fu Jie on 2018/11/7.
//

#import "PHAsset+Utility.h"
#import <objc/runtime.h>

@implementation PHAsset (Utility)

/**
 * 同步获取固定尺寸的图片
 */
- (UIImage *)zz_imageSyncTargetSize:(CGSize)size fast:(BOOL)fast iCloudAsyncDownload:(BOOL)iCloudAsyncDownload {
    
    __block PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    if (fast) {
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    }else {
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    __block UIImage *ret = nil;
    __weak typeof(self) weakSelf = self;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        if (image == nil) {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] == YES) {
                // 异步加载iCloud照片
                if (iCloudAsyncDownload == YES) {
                    options.networkAccessAllowed = YES;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        // TODO 优化下载
                        [[PHImageManager defaultManager] requestImageForAsset:weakSelf targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                        }];
                    });
                }
            }
            dispatch_semaphore_signal(semaphore);
        }else {
            ret = image;
            dispatch_semaphore_signal(semaphore);
        }
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return ret;
}

/**
 * 异步获取固定尺寸的图片
 */
- (void)zz_imageAsyncTargetSize:(CGSize)size fast:(BOOL)fast iCloud:(BOOL)iCloud progress:(PHAssetImageProgressHandler)progress result:(void(^)(UIImage * image))result {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        if (fast) {
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        }else{
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        }
        options.networkAccessAllowed = iCloud;
        options.progressHandler = progress;
        [[PHImageManager defaultManager] requestImageForAsset:self targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                result == nil ? : result(image);
            });
        }];
    });
}

/**
 * 同步获取固定倍数尺寸的图片
 */
- (UIImage *)zz_imageSyncTargetSize:(CGSize)size multiples:(CGFloat)multiples fast:(BOOL)fast {
    
    CGSize targetSize = CGSizeZero;
    if ((CGFloat)self.pixelHeight / (CGFloat)self.pixelWidth > size.height / size.width) {
        targetSize = CGSizeMake(size.height * ((CGFloat)self.pixelWidth / (CGFloat)self.pixelHeight) * multiples, size.height * multiples);
    }else {
        targetSize = CGSizeMake(size.width * multiples, size.width * ((CGFloat)self.pixelHeight / (CGFloat)self.pixelWidth) * multiples);
    }
    return [self zz_imageSyncTargetSize:targetSize fast:fast iCloudAsyncDownload:YES];
}

/**
 * 异步获取固定倍数尺寸的图片
 */
- (void)zz_imageASyncTargetSize:(CGSize)size multiples:(CGFloat)multiples fast:(BOOL)fast result:(void(^)(UIImage * image))result {
    
    CGSize targetSize = CGSizeZero;
    if ((CGFloat)self.pixelHeight / (CGFloat)self.pixelWidth > size.height / size.width) {
        targetSize = CGSizeMake(size.height * ((CGFloat)self.pixelWidth / (CGFloat)self.pixelHeight) * multiples, size.height * multiples);
    }else {
        targetSize = CGSizeMake(size.width * multiples, size.width * ((CGFloat)self.pixelHeight / (CGFloat)self.pixelWidth) * multiples);
    }
    [self zz_imageAsyncTargetSize:targetSize fast:fast iCloud:YES progress:nil result:result];
}

/**
 *  是否是iCloud图片
 */
- (BOOL)zz_isCloudImage {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    __block BOOL isICloudAsset = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        //根据请求会调中的参数重 NSDictionary *info 是否有cloudKey 来判断是否是  iCloud
        if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
            isICloudAsset = YES;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return !isICloudAsset;
}

@end
