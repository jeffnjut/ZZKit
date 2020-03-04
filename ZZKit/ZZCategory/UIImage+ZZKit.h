//
//  UIImage+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/3.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZZImageType) {
    ZZImageTypeJPEG,    // JPEG
    ZZImageTypePNG,     // PNG
    ZZImageTypeGIF,     // GIF
    ZZImageTypeTIFF,    // TIFF
    ZZImageTypeWEBP,    // WEBP
    ZZImageTypeUnknown  // UNKNOWN
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZZKit)

#pragma mark - 裁切、截屏

/**
 *  截图UIView以及UIView的子视图
 */
+ (UIImage *)zz_imageCaptureView:(nonnull UIView *)targetView;

/**
 *  截全屏(UIImage)
 */
+ (UIImage *)zz_imageCaptureScreen;

/**
 *  截全屏(NSData)
 */
+ (NSData *)zz_imageDataCaptureScreen;

/**
 *  获得图片（指定区域）
 */
- (UIImage *)zz_imageCropRect:(CGRect)rect;

/**
 *  获得图片（指定比例区域）
 */
- (UIImage *)zz_imageCropBeginPointRatio:(CGPoint)beginPointRatio endPointRatio:(CGPoint)endPointRatio;

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
 *  等比率宽高调整图片（增减像素）
 *  scale输出和原图一致
 */
- (UIImage *)zz_imageAdjustScale:(CGFloat)scale;

/**
 *  自定义长宽调整图片,可变形图片（增减像素）
 *  可能变形
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size;

/**
 *  自定义长宽调整图片,可裁切、可变形图片（增减像素）
 *  cropped : NO 可能变形，保证画面完整度，但可能因为size的宽高比和原图不一致导致图片被压扁
 *  cropped : YES 可能裁切，不保证画面完整度（只有size比例和原图一致才能完整），多余的宽或高按平均裁切
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size cropped:(BOOL)cropped;

/**
 *  自定义长宽调整图片,可裁切、可变形图片（增减像素）
 *  cropped : NO 可能变形，保证画面完整度，但可能因为size的宽高比和原图不一致导致图片被压扁
 *  cropped : YES 可能裁切，不保证画面完整度（只有size比例和原图一致才能完整），多余的宽或高按平均裁切
 *  scale : 按scale输出图片
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size scale:(CGFloat)scale cropped:(BOOL)cropped;

/**
 *  等比率调整图片，图片方向（等比调整像素，scale）
 *  scale取值，建议1.0、2.0和3.0
 */
- (UIImage *)zz_imageTuningScale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

#pragma mark - 图片类型

/**
 *  判断图片类型
 */
+ (ZZImageType)zz_imageType:(nonnull NSData *)imageData;

/**
 *  判断图片类型
 */
- (ZZImageType)zz_imageType;

#pragma mark - 转码

/**
 *  UIImage转成PNG或JPEG格式的Data
 */
- (NSData *)zz_imageData;

/**
 *  UIImage转成PNG或JPEG格式的base64码
 */
- (NSString *)zz_image2Base64;

/**
 *  UIImage转成PNG或JPEG格式的base64码，
 *  带Scheme的URI,比如image/png;base64,xxxxxxx
 */
- (NSString *)zz_image2Base64:(BOOL)withScheme;

/**
 *  UIImage转成PNG格式的base64码
 */
- (NSString *)zz_image2Base64PNG;

/**
 *  UIImage转成JPEG格式的base64码
 */
- (NSString *)zz_image2Base64JPEG;

#pragma mark - 颜色

/**
 *  根据颜色，输出10*10的图片
 */
+ (UIImage *)zz_imageWithColor:(nonnull UIColor *)color;

/**
 *  根据指定大小和颜色，输出图片
 */
+ (UIImage *)zz_imageWithColor:(nonnull UIColor *)color size:(CGSize)size;

/**
 *  获取UIImage的主色
 */
- (UIColor *)zz_imageMainColor;

#pragma mark - 二维码

/**
 *  根据文字输出二维码图片
 */
+ (UIImage *)zz_imageQR:(nonnull NSString *)text width:(CGFloat)width;

/**
 *  生成带图片的二维码
 */
+ (UIImage *)zz_imageQR:(nonnull NSString *)text width:(CGFloat)width icon:(nullable UIImage *)icon iconWidth:(CGFloat)iconWidth;

#pragma mark - 水印

/**
 *  按起始点，添加带alpha的图片的水印
 */
- (UIImage *)zz_imageWaterMarkWithImage:(nonnull UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha;

/**
 *  按范围，添加带alpha的图片的水印
 */
- (UIImage *)zz_imageWaterMarkWithImage:(nonnull UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha;

/**
 *  按起始点，添加带属性的字符串
 */
- (UIImage *)zz_imageWaterMarkWithText:(nonnull NSString*)text textPoint:(CGPoint)textPoint attribute:(NSDictionary*)attribute;

/**
 *  按范围，添加带属性的字符串
 */
- (UIImage *)zz_imageWaterMarkWithText:(nullable NSString*)text textRect:(CGRect)textRect attribute:(nullable NSDictionary *)attribute;

/**
 *  按起始点，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)zz_imageWaterMarkWithText:(nullable NSString*)text textPoint:(CGPoint)textPoint attribute:(nullable NSDictionary*)attribute image:(nullable UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha;

/**
 *  按范围，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)zz_imageWaterMarkWithText:(nullable NSString*)text textRect:(CGRect)textRect attribute:(nullable NSDictionary *)attribute image:(nullable UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha;

#pragma mark - 高斯模糊

/**
 *  高斯模糊滤镜（默认值10.0）
 *  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius. Default value: 10.00
 */
- (UIImage *)zz_gaussBlur;

/**
 *  高斯模糊滤镜
 *  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius. Default value: 10.00
 *  clipExtent:是否裁掉高斯模糊边缘部分
 */
- (UIImage *)zz_gaussBlur:(CGFloat)blurRadius clipExtent:(BOOL)clipExtent;

/**
 *  通过Accelerate库vImageBoxConvolve_ARGB8888的模糊算法
 *  blur范围[0, 1.0]，异常或默认为0.5
 */
- (UIImage *)zz_boxBlur;

/**
 *  通过Accelerate库vImageBoxConvolve_ARGB8888的模糊算法
 *  blur范围[0, 1.0]，异常或默认为0.5
 */
- (UIImage *)zz_boxBlur:(CGFloat)blur;

#pragma mark - 测试

- (NSInteger)zz_show:(CGRect)frame backgroundColor:(nullable UIColor *)backgroundColor;

- (NSInteger)zz_show:(CGRect)frame;

- (NSInteger)zz_debugShow:(CGRect)frame;

+ (void)zz_removeShow:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
