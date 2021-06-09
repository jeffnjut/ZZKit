//
//  UIImageView+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIImageView+ZZKit.h"
#import <objc/runtime.h>
#import "NSString+ZZKit.h"
#import "UIView+ZZKit.h"
#import "NSData+ZZKit.h"

@implementation UIImageView (ZZKit)

#pragma mark - Public

/**
 * 加载图片
 * URL                        imageURL : NSString / NSURL
 * placeholderImage           占位图
 * backgroundColor 占位图的背景色
 * contentMode     占位图的填充方式
 * completion                 加载完图片的回调Block
 */
- (____ZZKitVoid____)zz_load:(nonnull id)URL
            placeholderImage:(nullable UIImage *)placeholderImage
             backgroundColor:(nullable UIColor *)backgroundColor
                 contentMode:(UIViewContentMode)contentMode
                  completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    [self zz_load:URL placeholderImage:placeholderImage placeholderBackgroundColor:backgroundColor finishedBackgroundColor:backgroundColor placeholderContentMode:contentMode finishedContentMode:contentMode fadeIn:YES completion:completion];
}

- (____ZZKitVoid____)zz_load:(nonnull id)URL
                   placeholderImage:(nullable UIImage *)placeholderImage
         placeholderBackgroundColor:(nullable UIColor *)placeholderBackgroundColor
            finishedBackgroundColor:(nullable UIColor *)finishedBackgroundColor
             placeholderContentMode:(UIViewContentMode)placeholderContentMode
                finishedContentMode:(UIViewContentMode)finishedContentMode
                             fadeIn:(BOOL)fadeIn
                         completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    if ([[NSThread currentThread] isMainThread]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [weakSelf _inner_zz_load:URL
                    placeholderImage:placeholderImage
          placeholderBackgroundColor:placeholderBackgroundColor
             finishedBackgroundColor:finishedBackgroundColor
              placeholderContentMode:placeholderContentMode
                 finishedContentMode:finishedContentMode
                              fadeIn:fadeIn
                          completion:completion];
            
        });
    }else {
        [self _inner_zz_load:URL
            placeholderImage:placeholderImage
  placeholderBackgroundColor:placeholderBackgroundColor
     finishedBackgroundColor:finishedBackgroundColor
      placeholderContentMode:placeholderContentMode
         finishedContentMode:finishedContentMode
                      fadeIn:fadeIn
                  completion:completion];
    }
}

/**
 * 加载图片
 * URL                        imageURL : NSString / NSURL
 * placeholderImage           占位图
 * placeholderBackgroundColor 占位图的背景色
 * placeholderContentMode     占位图的填充方式
 * finishedBackgroundColor    加载完图片的背景色
 * finishedContentMode        显示图片的填充方式
 * fadeIn                     是否淡入显示
 * completion                 加载完图片的回调Block
 */
- (____ZZKitVoid____)_inner_zz_load:(nonnull id)URL
                   placeholderImage:(nullable UIImage *)placeholderImage
         placeholderBackgroundColor:(nullable UIColor *)placeholderBackgroundColor
            finishedBackgroundColor:(nullable UIColor *)finishedBackgroundColor
             placeholderContentMode:(UIViewContentMode)placeholderContentMode
                finishedContentMode:(UIViewContentMode)finishedContentMode
                             fadeIn:(BOOL)fadeIn
                         completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    @synchronized (self) {
        __weak typeof(self) weakSelf = self;
        
        // 处理URL Encode
        __block NSString *_zzKey = nil;
        __block NSURL *_zzURL = nil;
        if ([URL isKindOfClass:[NSURL class]]) {
            _zzURL = URL;
            _zzKey = _zzURL.absoluteString;
        }else if ([URL isKindOfClass:[NSString class]] && ((NSString *)URL).length > 0) {
            _zzKey = URL;
            if (![_zzKey containsString:@"%"]) {
                // 未Encode的URL，URL需要Encode
                _zzKey = [_zzKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }
            _zzURL = [NSURL URLWithString:_zzKey];
        }else {
            // 设置Placeholder背景颜色
            dispatch_async(dispatch_get_main_queue(), ^{
                if (placeholderBackgroundColor) {
                    weakSelf.backgroundColor = placeholderBackgroundColor;
                }
                weakSelf.contentMode = placeholderContentMode;
                weakSelf.image = placeholderImage;
            });
            return;
        }
        [self _setZzHash:_zzKey.hash];
        
        // 设置Placeholder背景颜色
        // 设置Placeholder ContentMode
        dispatch_async(dispatch_get_main_queue(), ^{
            if (placeholderBackgroundColor) {
                weakSelf.backgroundColor = placeholderBackgroundColor;
                weakSelf.contentMode = placeholderContentMode;
            }
        });

        UIImage *_image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:_zzKey];
        if (_image) {
            [self _setWebPImage:_image key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
            return;
        }
        [self sd_setImageWithURL:_zzURL placeholderImage:placeholderImage options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:_zzURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        UIImage *image = nil;
                        if (location) {
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                        }
                        [weakSelf _complete:image error:error zzKey:_zzKey finishedBackgroundColor:finishedBackgroundColor finishedContentMode:finishedContentMode completion:completion];
                    }];
                    [task resume];
                });
            }else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [weakSelf _complete:image error:error zzKey:_zzKey finishedBackgroundColor:finishedBackgroundColor finishedContentMode:finishedContentMode completion:completion];
                });
            }
        }];
    }
}

- (void)_complete:(UIImage *)image error:(NSError *)error zzKey:(NSString *)zzKey finishedBackgroundColor:(UIColor *)finishedBackgroundColor finishedContentMode:(UIViewContentMode)finishedContentMode completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    // 查询缓存
    NSData *_data = [[SDWebImageManager sharedManager].imageCache diskImageDataForKey:zzKey];
    SDImageFormat format;
    if (image) {
        // from webp
        format = SDImageFormatWebP;
        UIImage *_image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:zzKey];
        if (_image == nil) {
            [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:zzKey toDisk:YES completion:nil];
        }else {
            return;
        }
    }else {
        format =  [NSData sd_imageFormatForImageData:_data];
    }
    switch (format) {
        case SDImageFormatGIF:
        {
            // 缓存Gif
            [self _setGifImage:_data key:zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
            break;
        }
        case SDImageFormatWebP:
        {
            // 缓存WebP
            [self _setWebPImage:(image != nil ? image : _data) key:zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
            break;
        }
        default:
        {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finishedBackgroundColor) {
                    weakSelf.backgroundColor = finishedBackgroundColor;
                }
                weakSelf.contentMode = finishedContentMode;
                
                completion == nil ? : completion(weakSelf, image, nil, error, zzKey);
            });
            break;
        }
    }
}

- (void)_setGifImage:(nonnull NSData *)data key:(nonnull NSString *)key backgroundColor:(nullable UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    if (key.hash != [self _zzHash]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.image = [UIImage sd_animatedGIFWithData:data];
        // 设置背景颜色
        if (backgroundColor) {
            weakSelf.backgroundColor = backgroundColor;
        }
        // 设置ContentMode
        weakSelf.contentMode = contentMode;
        
        // 回调
        completion == nil ? : completion(weakSelf, data.zz_imageFirstGifFrame, data, nil, key);
    });
}

- (void)_setWebPImage:(nonnull id)data key:(nonnull NSString *)key backgroundColor:(nullable UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    if (key.hash != [self _zzHash]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([data isKindOfClass:[NSData class]]) {
            YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:[UIScreen mainScreen].scale];
            UIImage *_webPImage = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
            
            // 设置图片
            weakSelf.image = _webPImage;
            
            // 设置背景颜色
            if (backgroundColor) {
                weakSelf.backgroundColor = backgroundColor;
            }
            
            // 设置ContentMode
            weakSelf.contentMode = contentMode;
            
            // 回调
            completion == nil ? : completion(weakSelf, _webPImage, data, nil, key);
        }else if ([data isKindOfClass:[UIImage class]]) {
            
            
            // 设置图片
            weakSelf.image = (UIImage *)data;
            
            // 设置背景颜色
            if (backgroundColor) {
                weakSelf.backgroundColor = backgroundColor;
            }
            
            // 设置ContentMode
            weakSelf.contentMode = contentMode;
            
            // 回调
            completion == nil ? : completion(weakSelf, data, nil, nil, key);
        }
        
    });
}

- (void)_setOtherImage:(nullable UIImage *)image data:(nullable NSData *)data key:(nonnull NSString *)key backgroundColor:(nullable UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode fadeIn:(BOOL)fadeIn completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    if (key.hash != [self _zzHash]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置图片
        if (image == nil) {
            weakSelf.image = data.zz_image;
        }else {
            weakSelf.image = image;
        }
        
        // 设置背景颜色
        if (backgroundColor) {
            weakSelf.backgroundColor = backgroundColor;
        }
        
        // 设置ContentMode
        self.contentMode = contentMode;
        
        if (fadeIn) {
            weakSelf.alpha = 0.5;
            [weakSelf.layer removeAllAnimations];
            [UIView transitionWithView:weakSelf
                              duration:1.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ weakSelf.alpha = 1.0; }
                            completion:nil];
        }
        // 回调
        completion == nil ? : completion(weakSelf, weakSelf.image, data, nil, key);
    });
}

#pragma mark - Private

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *userAgent = @"";
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
        
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
            [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        }
    });
}

static void const* kImageViewUrlHash = "kImageViewUrlHash";

- (NSInteger)_zzHash {
    
    return [objc_getAssociatedObject(self, kImageViewUrlHash) integerValue];
}

- (void)_setZzHash:(NSInteger)hash {
    
    objc_setAssociatedObject(self, kImageViewUrlHash, @(hash), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
