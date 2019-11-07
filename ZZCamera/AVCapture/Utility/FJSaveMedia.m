//
//  FJSaveMedia.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/21.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJSaveMedia.h"
#import "FJAVCatpureCommonHeader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMMetadata.h>
#import <Photos/Photos.h>

@implementation FJSaveMedia

// 保存视频
+ (void)saveMovieToCameraRoll:(NSURL *)url completionBlock:(void (^)(NSURL *mediaURL, NSError *error))completionBlock {
    
    if (@available(iOS 9.0, *)) {
        
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            
            if (status != PHAuthorizationStatusAuthorized) return;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
                [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:url options:nil];
            } completionHandler:^( BOOL success, NSError * _Nullable error ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock == nil ? : completionBlock( success ? url : nil, error);
                });
            }];
        }];
    }else {
        
        ALAssetsLibrary *lab = [[ALAssetsLibrary alloc] init];
        [lab writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock == nil ? : completionBlock( assetURL, error);
            });
        }];
    }
}

// 保存图片
+ (void)savePhotoToPhotoLibrary:(UIImage *)image completionBlock:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completionBlock {
    
    if (@available(iOS 9.0, *)) {
        
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            
            if (status != PHAuthorizationStatusAuthorized) return;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^( BOOL success, NSError * _Nullable error ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock == nil ? : completionBlock( success ? image : nil, nil, error);
                });
            }];
        }];
    }else {
        
        ALAssetsLibrary *lab = [[ALAssetsLibrary alloc] init];
        [lab writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock == nil ? : completionBlock( nil, assetURL, error);
            });
        }];
    }
}

@end
