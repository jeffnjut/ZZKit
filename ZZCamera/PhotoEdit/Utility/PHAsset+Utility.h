//
//  PHAsset+Utility.h
//  AFNetworking
//
//  Created by Fu Jie on 2018/11/7.
//

#import <Photos/Photos.h>
#import "ZZMacro.h"

@interface PHAsset (Utility)

/**
 * 同步获取固定尺寸的图片
 */
- (UIImage *)zz_imageSyncTargetSize:(CGSize)size fast:(BOOL)fast iCloudAsyncDownload:(BOOL)iCloudAsyncDownload;

/**
 * 异步获取固定尺寸的图片
 */
- (void)zz_imageAsyncTargetSize:(CGSize)size fast:(BOOL)fast iCloud:(BOOL)iCloud progress:(PHAssetImageProgressHandler)progress result:(void(^)(UIImage * image))result;

/**
 * 同步获取固定倍数尺寸的图片
 */
- (UIImage *)zz_imageSyncTargetSize:(CGSize)size multiples:(CGFloat)multiples fast:(BOOL)fast;

/**
 * 异步获取固定倍数尺寸的图片
 */
- (void)zz_imageASyncTargetSize:(CGSize)size multiples:(CGFloat)multiples fast:(BOOL)fast result:(void(^)(UIImage * image))result;

/**
 *  是否是iCloud图片
 */
- (BOOL)zz_isCloudImage;

@end
