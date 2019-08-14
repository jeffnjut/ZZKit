//
//  UIImageView+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIImageView+ZZKit.h"
#import <objc/runtime.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/NSData+ImageContentType.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <YYImage/YYImage.h>
#import "UIView+ZZKit.h"

@implementation UIImageView (ZZKit)

#pragma mark - Public

/**
 * 加载图片（所有网络图片格式）
 * url              url
 * placeholderImage 占位图
 * backgroundColor  加载完图片的背景色
 * contentMode      占位图或image url加载的填充方式
 * completion       完成加载的回调block
 */
- (void)zz_load:(nonnull NSString *)url placeholderImage:(nullable UIImage *)placeholderImage backgroundColor:(nullable UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    @synchronized(self) {
        
        FLAnimatedImageView *gifImageView = [self viewWithTag:1000];
        gifImageView.hidden = YES;
        
        self.contentMode = contentMode;
        self.backgroundColor = backgroundColor;
        
        if (url == nil || url.length == 0 || ![url isKindOfClass:[NSString class]] || ![url hasPrefix:@"http"]) {
            // 非法的http或者https的URL
            self.image = placeholderImage;
            return;
        }else {
            // 合法URL，URL字符转义
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            // 设置Hash
            [self _setHash:[url hash]];
        }
        
        __weak typeof(self) weakSelf = self;
        if (self.image == nil) {
            self.image = placeholderImage;
        }else {
            [self sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (data) {
                // 防止复用Cell产生的图片错乱问题
                if ([strongSelf _hash] != [url hash]) {
                    return;
                }
                SDImageFormat format = [NSData sd_imageFormatForImageData:data];
                if (format == SDImageFormatGIF) {
                    // SDWebImgae+Gif对高帧的gif支持不理想
                    FLAnimatedImageView *gifImageView = [strongSelf viewWithTag:1000];
                    if (gifImageView == nil) {
                        gifImageView = [[FLAnimatedImageView alloc] initWithFrame:strongSelf.bounds];
                        [strongSelf addSubview:gifImageView];
                        gifImageView.tag = 1000;
                    }
                    gifImageView.hidden = NO;
                    gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                    strongSelf.image = nil;
                    if (!backgroundColor) {
                        strongSelf.backgroundColor = [UIColor clearColor];
                    }
                }else {
                    [strongSelf zz_load:url round:NO borderWidth:0 borderColor:nil placeholderImage:placeholderImage placeholderContentMode:contentMode placeholderBackgroudColor:backgroundColor contentMode:contentMode backgroundColor:backgroundColor completion:completion];
                    return;
                }
            }else if (error) {
                strongSelf.image = placeholderImage;
                strongSelf.contentMode = contentMode;
            }
            if (completion != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(strongSelf, image, data, error, url);
                });
            }
        }];
    }
}

/**
 * 加载图片（除了Gif的网络图片格式）
 * url                       image url
 * round                     是否圆型
 * borderWidth               边框宽度
 * borderColor               边框颜色
 * placeholderImage          占位图
 * placeholderContentMode    占位图的填充方式
 * placeholderBackgroudColor 占位图的背景色
 * contentMode               显示图片的填充方式
 * backgroundColor           加载完图片的背景色
 * completion                加载完图片的回调block
 */
- (void)zz_load:(nonnull NSString *)url round:(BOOL)round borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor placeholderImage:(nullable UIImage *)placeholderImage placeholderContentMode:(UIViewContentMode)placeholderContentMode placeholderBackgroudColor:(nullable UIColor *)placeholderBackgroudColor contentMode:(UIViewContentMode)contentMode backgroundColor:(nullable UIColor *)backgroundColor completion:(nullable void(^)(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url))completion {
    
    if (url == nil || url.length == 0 || ![url isKindOfClass:[NSString class]] || ![url hasPrefix:@"http"]) {
        // 非法的http或者https的URL
        self.image = placeholderImage;
        self.contentMode = placeholderContentMode;
        return;
    }else {
        // 合法URL，URL字符转义
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 设置Hash
        [self _setHash:[url hash]];
    }
    
    // 设置Round、BorderWidth和BorderColor
    if (borderWidth > 0 && borderColor != nil) {
        if (round) {
            [self zz_roundWithBorderWidth:borderWidth borderColor:borderColor];
        }else {
            [self zz_borderWidth:borderWidth boderColor:borderColor];
        }
    }else if (round == YES) {
        [self zz_round];
    }else {
        [self setClipsToBounds:YES];
        [self.layer setMasksToBounds:YES];
    }
    // 设置PlaceHolder图片
    self.image = placeholderImage;
    // 设置PlaceHolder背景颜色
    self.backgroundColor = placeholderBackgroudColor;
    // 设置PlaceHolder的ContentMode
    self.contentMode = placeholderContentMode;
    // 加载图片
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage options:SDWebImageDownloaderHighPriority | SDWebImageAllowInvalidSSLCertificates progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 防止复用Cell产生的图片错乱问题
        if ([strongSelf _hash] != [url hash]) {
            return;
        }
        if (image != nil) {
            // 图片设置成功
            // 设置图片的ContentMode
            strongSelf.contentMode = contentMode;
            // 设置图片的BackgroundColor
            strongSelf.backgroundColor = backgroundColor;
            // 图片渲染动画
            if (cacheType == SDImageCacheTypeNone) {
                // 设置图片
                strongSelf.image = image;
                // 设置“淡入淡出”动画
                strongSelf.alpha = 0.5;
                [strongSelf.layer removeAllAnimations];
                [UIView transitionWithView:strongSelf
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{ strongSelf.alpha = 1.0; }
                                completion:nil];
            }else{
                // 设置图片
                strongSelf.image = image;
            }
            // 成功回调
            if (completion != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(strongSelf, image, image.sd_imageData, error, imageURL.absoluteString);
                });
            }
        }else if (error != nil) {
            // 图片设置异常
            // WebP处理
            __block NSData *_data = [[SDWebImageManager sharedManager].imageCache diskImageDataForKey:imageURL.absoluteString];
            if (_data != nil) {
                NSString *url = [imageURL.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                // 防止复用Cell产生的图片错乱问题
                if ([strongSelf _hash] != [url hash]) {
                    return;
                }
                __block UIImage *decodeImage = nil;
                YYImageDecoder *decoder = [YYImageDecoder decoderWithData:_data scale:[UIScreen mainScreen].scale];
                decodeImage = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
                if (decodeImage != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf.image = decodeImage;
                    });
                    if (completion != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(strongSelf, decodeImage, _data, error, imageURL.absoluteString);
                        });
                    }
                }else {
                    if (completion != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(strongSelf, image, image.sd_imageData, error, imageURL.absoluteString);
                        });
                    }
                }
            }else {
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    __block UIImage *decodeImage = nil;
                    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:[UIScreen mainScreen].scale];
                    decodeImage = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
                    if (decodeImage != nil) {
                        [[SDWebImageManager sharedManager] saveImageToCache:decodeImage forURL:imageURL];
                        NSString *url = [imageURL.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        // 防止复用Cell产生的图片错乱问题
                        if ([strongSelf _hash] != [url hash]) {
                            return;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            strongSelf.image = decodeImage;
                        });
                        if (completion != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(strongSelf, decodeImage, data, error, imageURL.absoluteString);
                            });
                        }
                    }else {
                        if (completion != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(strongSelf, image, image.sd_imageData, error, imageURL.absoluteString);
                            });
                        }
                    }
                }];
                [task resume];
            }
        }
    }];
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

- (NSInteger)_hash {
    
    return [objc_getAssociatedObject(self, kImageViewUrlHash) integerValue];
}

- (void)_setHash:(NSInteger)hash {
    
    objc_setAssociatedObject(self, kImageViewUrlHash, @(hash), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
