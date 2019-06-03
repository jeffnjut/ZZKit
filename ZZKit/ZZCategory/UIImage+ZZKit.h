//
//  UIImage+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/3.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FJImageType) {
    FJImageTypeJPEG,    // JPEG
    FJImageTypePNG,     // PNG
    FJImageTypeGIF,     // GIF
    FJImageTypeTIFF,    // TIFF
    FJImageTypeWEBP,    // WEBP
    FJImageTypeUnknown  // UNKNOWN
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZZKit)

/**
 *  获得图片（指定区域）
 */
- (UIImage *)zz_imageCropRect:(CGRect)rect;

/**
 *  获得图片（指定比例区域）
 */
- (UIImage *)zz_imageCropBeginPointRatio:(CGPoint)beginPointRatio endPointRatio:(CGPoint)endPointRatio;

/**
 *  裁剪图片（指定区域）
 */
- (UIImage *)zz_imageCropRect:(CGRect)rect sameRation:(BOOL)sameRatio;

/**
 *  截图UIView（对每个继承自UIView的对象都适用）
 */
+ (UIImage *)zz_imageCaptureView:(UIView *)view;

/**
 *  截屏（指定UIView，正方形，无损）
 */
+ (UIImage *)zz_imageCaptureView:(UIView *)view rect:(CGSize)rect;

/**
 *  截全屏（指定UIViewController）
 */
+ (UIImage *)zz_imageCaptureController:(UIViewController *)viewController;

/**
 *  截全屏(NSData)
 */
+ (NSData *)zz_imageDataCaptureScreen;

/**
 *  截全屏(UIImage)
 */
+ (UIImage *)zz_imageCaptureScreen;

#pragma mark - 压缩

/**
 *  压缩图片，宽度固定，返回Image（调整尺寸减少像素，降低像素质量）
 */
- (UIImage *)zz_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte width:(CGFloat)width;

/**
 *  压缩图片，尺寸固定，返回Image（调整尺寸减少像素，降低像素质量）
 */
- (UIImage *)zz_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte size:(CGSize)size;

/**
 *  压缩图片，宽度固定，返回Data（调整尺寸减少像素，降低像素质量）
 */
- (NSData *)zz_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte width:(CGFloat)width;

/**
 *  压缩图片，尺寸固定，返回Data（调整尺寸减少像素，降低像素质量）
 */
- (NSData *)zz_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte size:(CGSize)size;

/**
 *  压缩图片，输出Image（降低像素质量）
 */
- (UIImage *)zz_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte;

/**
 *  压缩图片，输出Data（降低像素质量）
 */
- (NSData *)zz_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte;

/**
 *  等比率调整图片（减少像素）
 */
- (UIImage *)zz_imageAdjustScale:(float)scale;

/**
 *  等比率调整图片，图片方向（减少像素）
 */
- (UIImage *)zz_imageAdjustScale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

/**
 *  自定义长宽调整图片（减少像素）
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size;

/**
 *  自定义长宽调整图片,可裁切图片（减少像素）
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size cropped:(BOOL)cropped;

#pragma mark - 图片类型

/**
 *  判断图片类型
 */
+ (FJImageType)zz_imageType:(NSData *)imageData;

/**
 *  判断图片类型
 */
- (FJImageType)zz_imageType;

#pragma mark - 转码

/**
 *  UIImage转成PNG或JPEG格式的base64码
 */
- (NSString *)zz_image2Base64;

/**
 *  UIImage转成PNG格式的base64码
 */
- (NSString *)zz_image2Base64_PNG;


/**
 *  UIImage转成JPEG格式的base64码
 */
- (NSString *)zz_image2Base64_JPEG;

#pragma mark - 颜色

/**
 *  根据颜色，输出10*10的图片
 */
+ (UIImage *)zz_imageWithColor:(UIColor *)color;

/**
 *  根据指定大小和颜色，输出图片
 */
+ (UIImage *)zz_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  获取UIImage的主色
 */
- (UIColor *)zz_imageMainColor;

#pragma mark - 二维码

/**
 *  根据文字输出二维码图片
 */
+ (UIImage *)zz_imageQR:(NSString *)text width:(CGFloat)width;

#pragma mark - 水印

/**
 *  按起始点，添加带alpha的图片的水印
 */
- (UIImage *)zz_imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha;

/**
 *  按范围，添加带alpha的图片的水印
 */
- (UIImage *)zz_imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha;

/**
 *  按起始点，添加带属性的字符串
 */
- (UIImage *)zz_imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attribute;

/**
 *  按范围，添加带属性的字符串
 */
- (UIImage *)zz_imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attribute;

/**
 *  按起始点，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)zz_imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attribute image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha;

/**
 *  按范围，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)zz_imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attribute image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha;

#pragma mark - 高斯模糊
- (UIImage *)zz_gaussBlur:(CGFloat)blurRadius;

- (UIImage *)zz_boxBlur:(CGFloat)blur;

#pragma mark - 测试
- (void)zz_debugShow:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
