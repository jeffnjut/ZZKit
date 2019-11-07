//
//  FJSaveMedia.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/21.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FJSaveMedia : NSObject

// 保存视频
+ (void)saveMovieToCameraRoll:(NSURL *)url completionBlock:(void (^)(NSURL *mediaURL, NSError *error))completionBlock;

// 保存图片
+ (void)savePhotoToPhotoLibrary:(UIImage *)image completionBlock:(void (^)(UIImage *image, NSURL *imageURL, NSError *error))completionBlock;

@end
