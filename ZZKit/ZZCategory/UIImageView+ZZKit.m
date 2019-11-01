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
- (____ZZKitVoid____)zz_load:(nonnull id)URL
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
        }else if ([URL isKindOfClass:[NSString class]]) {
            _zzKey = URL;
            if (![_zzKey containsString:@"%"]) {
                // 未Encode的URL，URL需要Encode
                _zzKey = [_zzKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }
            _zzURL = [NSURL URLWithString:_zzKey];
        }else if (URL == nil) {
            // 设置Placeholder背景颜色
            if (placeholderBackgroundColor) {
                self.backgroundColor = placeholderBackgroundColor;
            }
            self.contentMode = placeholderContentMode;
            self.image = placeholderImage;
            return;
        }else {
            NSAssert(NO, @"UIImageView : imageURL 参数不正确");
        }
        [self _setZzHash:_zzKey.hash];
        
        // 设置Placeholder背景颜色
        if (placeholderBackgroundColor) {
            self.backgroundColor = placeholderBackgroundColor;
        }
        // 设置Placeholder ContentMode
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.contentMode = placeholderContentMode;
        });
        
        // 查询缓存
        NSData *_data = [[SDWebImageManager sharedManager].imageCache diskImageDataForKey:_zzKey];
        SDImageFormat format =  [NSData sd_imageFormatForImageData:_data];
        switch (format) {
            case SDImageFormatUndefined:
            {
                // 缓存未命中
                [self sd_setImageWithURL:_zzURL placeholderImage:placeholderImage options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    if (!error && image) {
                        NSData *_data = [[SDWebImageManager sharedManager].imageCache diskImageDataForKey:_zzKey];
                        SDImageFormat format = [NSData sd_imageFormatForImageData:_data];
                        switch (format) {
                            case SDImageFormatGIF:
                            {
                                // 缓存Gif
                                [weakSelf _setGifImage:_data key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
                                break;
                            }
                            case SDImageFormatWebP:
                            {
                                // 缓存WebP
                                [weakSelf _setWebPImage:_data key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
                                break;
                            }
                            default:
                            {
                                // 其它图片
                                [weakSelf _setOtherImage:image data:nil key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode fadeIn:fadeIn completion:completion];
                                break;
                            }
                        }
                    }else {
                        completion == nil ? : completion(weakSelf, image, nil, error, _zzKey);
                    }
                }];
                break;
            }
            case SDImageFormatGIF:
            {
                // 缓存Gif
                [self _setGifImage:_data key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
                break;
            }
            case SDImageFormatWebP:
            {
                // 缓存WebP
                [self _setWebPImage:_data key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode completion:completion];
                break;
            }
            default:
            {
                [self _setOtherImage:nil data:_data key:_zzKey backgroundColor:finishedBackgroundColor contentMode:finishedContentMode fadeIn:NO completion:completion];
                break;
            }
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

- (void)_setWebPImage:(nonnull NSData *)data key:(nonnull NSString *)key backgroundColor:(nullable UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    if (key.hash != [self _zzHash]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
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
        }else {
            
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
