//
//  UIImage+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/3.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIImage+ZZKit.h"
// 高斯模糊
#import <Accelerate/Accelerate.h>
#import "UIView+ZZKit_Blocks.h"

@implementation UIImage (ZZKit)

#pragma mark - 裁切、截屏

/**
 *  截图UIView以及UIView的子视图
 */
+ (UIImage *)zz_imageCaptureView:(nonnull UIView *)targetView {
    
    CGSize size = targetView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [targetView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  截全屏(UIImage)
 */
+ (UIImage *)zz_imageCaptureScreen {
    
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        // Portrait
        imageSize = [UIScreen mainScreen].bounds.size;
    }else {
        // Landscape
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, - M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        
        @try {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }@catch (NSException *ex) {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  截全屏(NSData)
 */
+ (NSData *)zz_imageDataCaptureScreen {
    
    UIImage *image = [UIImage zz_imageCaptureScreen];
    // JPEG
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData == nil) {
        // PNG
        imageData = UIImagePNGRepresentation(image);
    }
    return imageData;
}

/**
 *  获得图片（指定区域）
 */
- (UIImage *)zz_imageCropRect:(CGRect)rect {
    
    CGImageRef sourceImageRef = self.CGImage;
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale, rect.size.width * self.scale, rect.size.height * self.scale));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

/**
 *  获得图片（指定比例区域）
 */
- (UIImage *)zz_imageCropBeginPointRatio:(CGPoint)beginPointRatio endPointRatio:(CGPoint)endPointRatio {
    
    CGRect rect = CGRectMake(self.size.width * beginPointRatio.x, self.size.height * beginPointRatio.y, self.size.width * (endPointRatio.x - beginPointRatio.x), self.size.height * (endPointRatio.y - beginPointRatio.y));
    return [self zz_imageCropRect:rect];
}

#pragma mark - 压缩

/**
 *  压缩图片，宽度固定，返回Image（调整尺寸减少像素，降低像素质量）
 */
- (UIImage *)zz_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte width:(CGFloat)width {
    
    NSData *data = [self zz_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte width:width];
    if (data != nil) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

/**
 *  压缩图片，尺寸固定，返回Image（调整尺寸减少像素，降低像素质量）
 */
- (UIImage *)zz_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte size:(CGSize)size {
    
    NSData *data = [self zz_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte size:size];
    if (data != nil) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

/**
 *  压缩图片，宽度固定，返回Data（调整尺寸减少像素，降低像素质量）
 */
- (NSData *)zz_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte width:(CGFloat)width {
    
    return [self zz_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte size:CGSizeMake(width, width * (self.size.height / self.size.width))];
}

/**
 *  压缩图片，尺寸固定，返回Data（调整尺寸减少像素，降低像素质量）
 */
- (NSData *)zz_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte size:(CGSize)size {
    
    UIImage *adjustImage = self;
    if (size.width < adjustImage.size.width ) {
        adjustImage = [self zz_imageAdjustSize:size];
    }
    return [adjustImage zz_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte];
}

/**
 *  压缩图片，输出Image（降低像素质量）
 */
- (UIImage *)zz_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte {
    
    NSData *compressedData = [self zz_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte];
    if (compressedData != nil) {
        return [UIImage imageWithData:compressedData];
    }
    return nil;
}

/**
 *  压缩图片，输出Data（降低像素质量）
 */
- (NSData *)zz_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte {
    
    // JPEG
    NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
    if (imageData == nil) {
        // PNG,PNG不支持压缩
        return UIImagePNGRepresentation(self);
    }
    if (mbyte <= 0 || compressionQuality <= 0 || compressionQuality > 1.0) {
        // 压缩目标限值和压缩比例设置错误
        return imageData;
    }
    NSUInteger bytesPerMB = 1024 * 1024;
    if ( imageData.length  / (bytesPerMB * mbyte) < 1) {
        // 在压缩范围内
        return imageData;
    }else if (compressionQuality < 0.05) {
        // 压缩超出极限压缩比
        return imageData;
    }
    
    // 默认再压缩为0.7倍
    CGFloat compressedRate = 0;
    if ( imageData.length  / (bytesPerMB * mbyte) > 40) {
        // 实际值/目标值 > 40
        compressedRate = compressionQuality * 0.2;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 20) {
        // 实际值/目标值 > 20
        compressedRate = compressionQuality * 0.3;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 10) {
        // 实际值/目标值 > 10
        compressedRate = compressionQuality * 0.4;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 5) {
        // 实际值/目标值 > 5
        compressedRate = compressionQuality * 0.5;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 4) {
        // 实际值/目标值 > 4
        compressedRate = compressionQuality * 0.6;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 3) {
        // 实际值/目标值 > 3
        compressedRate = compressionQuality * 0.65;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 2) {
        // 实际值/目标值 > 2
        compressedRate = compressionQuality * 0.7;
    }else {
        // 实际值/目标值 其它值
        compressedRate = compressionQuality * 0.8;
    }
    imageData = UIImageJPEGRepresentation(self, compressedRate);
    if ( imageData.length  / (bytesPerMB * mbyte) < 1) {
        // 在压缩范围内
        return imageData;
    }else if (compressedRate < 0.05) {
        // 压缩超出极限压缩比
        return imageData;
    }else {
        return [self zz_imageDataCompressQuality:compressedRate lessThanMegaByte:mbyte];
    }
}

/**
 *  等比率宽高调整图片（增减像素）
 *  scale输出和原图一致
 */
- (UIImage *)zz_imageAdjustScale:(CGFloat)scale {
    
    return [self zz_imageAdjustSize:CGSizeMake(self.size.width * scale, self.size.height * scale) scale:self.scale cropped:NO];
}

/**
 *  自定义长宽调整图片,可变形图片（增减像素）
 *  可能变形
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size {
    
    return [self zz_imageAdjustSize:size scale:self.scale cropped:NO];
}

/**
 *  自定义长宽调整图片,可裁切、可变形图片（增减像素）
 *  cropped : NO 可能变形，保证画面完整度，但可能因为size的宽高比和原图不一致导致图片被压扁
 *  cropped : YES 可能裁切，不保证画面完整度（只有size比例和原图一致才能完整），多余的宽或高按平均裁切
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size cropped:(BOOL)cropped {
    
    return [self zz_imageAdjustSize:size scale:self.scale cropped:cropped];
}

/**
 *  自定义长宽调整图片,可裁切、可变形图片（增减像素）
 *  cropped : NO 可能变形，保证画面完整度，但可能因为size的宽高比和原图不一致导致图片被压扁
 *  cropped : YES 可能裁切，不保证画面完整度（只有size比例和原图一致才能完整），多余的宽或高按平均裁切
 *  scale : 按scale输出图片
 */
- (UIImage *)zz_imageAdjustSize:(CGSize)size scale:(CGFloat)scale cropped:(BOOL)cropped {

    if (CGSizeEqualToSize(self.size, size) && self.scale == scale) {
        return self;
    }else if(cropped && (fabs(self.size.height / self.size.width - size.height / size.width) > 0.0001)) {
        
        // 画布以原图的scale展开scale倍
        CGSize ctxSize = CGSizeMake(size.width * scale, size.height * scale);
        UIGraphicsBeginImageContext(ctxSize);
        // 按照原点开始裁切
        if (ctxSize.height / ctxSize.width < self.size.height / self.size.width) {
            // 上下裁切
            CGFloat y = (ctxSize.width * (self.size.height / self.size.width) - ctxSize.height) / 2.0;
            [self drawInRect:CGRectMake(0, -y, ctxSize.width, ctxSize.width * (self.size.height / self.size.width))];
        }else {
            // 左右裁切
            CGFloat x = (ctxSize.height * (self.size.width / self.size.height) - ctxSize.width) / 2.0;
            [self drawInRect:CGRectMake(-x, 0, ctxSize.height * (self.size.width / self.size.height), ctxSize.height)];
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 还原scale
        image = [image zz_imageTuningScale:scale orientation:self.imageOrientation];
        UIGraphicsEndImageContext();
        if(image == nil) NSLog(@"could not adjust image");
        return image;
    }else {
        
        // 画布以原图的scale展开scale倍
        CGSize ctxSize = CGSizeMake(size.width * scale, size.height * scale);
        UIGraphicsBeginImageContext(ctxSize);
        // 按照原点开始裁切
        [self drawInRect:CGRectMake(0, 0, ctxSize.width, ctxSize.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 还原scale
        image = [image zz_imageTuningScale:scale orientation:self.imageOrientation];
        UIGraphicsEndImageContext();
        if(image == nil) NSLog(@"could not adjust image");
        return image;
    }
}

/**
 *  等比率调整图片，图片方向（等比调整像素，scale）
 *  scale取值，建议1.0、2.0和3.0
 */
- (UIImage *)zz_imageTuningScale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    
    if (scale <= 0 || scale > 3.0 || scale == self.scale) {
        return self;
    }
    CGImageRef imageRef = self.CGImage;
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    return image;
}

#pragma mark - 图片类型

/**
 *  判断图片类型
 */
+ (ZZImageType)zz_imageType:(nonnull NSData *)imageData {
    
    if (imageData == nil || ![imageData isKindOfClass:[NSData class]]) {
        return ZZImageTypeUnknown;
    }
    
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return ZZImageTypeJPEG;
        case 0x89:
            return ZZImageTypePNG;
        case 0x47:
            return ZZImageTypeGIF;
        case 0x49:
        case 0x4D:
            return ZZImageTypeTIFF;
        case 0x52:
            if ([imageData length] < 12) {
                return ZZImageTypeUnknown;
            }
            NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return ZZImageTypeWEBP;
            }
            return ZZImageTypeUnknown;
    }
    return ZZImageTypeUnknown;
}

/**
 *  判断图片类型
 */
- (ZZImageType)zz_imageType {
    
    // JPEG
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    if (imageData == nil) {
        // PNG
        imageData = UIImagePNGRepresentation(self);
    }
    return [UIImage zz_imageType:imageData];
}

#pragma mark - 转码

/**
 *  UIImage转成PNG或JPEG格式的Data
 */
- (NSData *)zz_imageData {
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    if (!data) {
        data = UIImagePNGRepresentation(self);
    }
    return data;
}

/**
 *  UIImage转成PNG或JPEG格式的base64码
 */
- (NSString *)zz_image2Base64 {
    
    return [self zz_image2Base64:NO];
}

/**
 *  UIImage转成PNG或JPEG格式的base64码，
 *  带Scheme的URI,比如image/png;base64,xxxxxxx
 */
- (NSString *)zz_image2Base64:(BOOL)withScheme {
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSString *scheme = nil;
    NSString *base64 = nil;
    if (data) {
        scheme = @"data:image/jpeg;base64,";
        base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else {
        data = UIImagePNGRepresentation(self);
        if (data) {
            scheme = @"data:image/png;base64,";
            base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
    }
    if (scheme && base64) {
        return [NSString stringWithFormat:@"%@%@", scheme, base64];
    }
    return base64;
}


/**
 *  UIImage转成PNG格式的base64码
 */
- (NSString *)zz_image2Base64PNG {
    
    NSData *data = UIImagePNGRepresentation(self);
    if (data) {
        NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return base64;
    }
    return nil;
}

/**
 *  UIImage转成JPEG格式的base64码
 */
- (NSString *)zz_image2Base64JPEG {
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    if (data) {
        NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return base64;
    }
    return nil;
}

#pragma mark - 颜色

/**
 *  根据颜色，输出10*10的图片
 */
+ (UIImage *)zz_imageWithColor:(nonnull UIColor *)color {
    
    return [UIImage zz_imageWithColor:color size:CGSizeMake(10, 10)];
}

/**
 *  根据指定大小和颜色，输出图片
 */
+ (UIImage *)zz_imageWithColor:(nonnull UIColor *)color size:(CGSize)size {
    
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

/**
 *  获取UIImage的主色
 */
- (UIColor *)zz_imageMainColor {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    // 第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(self.size.width / 2.0, self.size.height / 2.0);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,   //bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    // 第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData(context);
    if (data == NULL) return nil;
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4 * ( x * y );
            int red   = data[offset];
            int green = data[offset+1];
            int blue  = data[offset+2];
            int alpha = data[offset+3];
            if (alpha > 0) {
                NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
                [cls addObject:clr];
            }
        }
    }
    CGContextRelease(context);
    // 第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *maxColor = nil;
    NSUInteger maxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil ) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < maxCount ) continue;
        maxCount = tmpCount;
        maxColor = curColor;
    }
    if (maxColor == nil) return nil;
    int r = [[maxColor objectAtIndex:0] intValue];
    int g = [[maxColor objectAtIndex:1] intValue];
    int b = [[maxColor objectAtIndex:2] intValue];
    int a = [[maxColor objectAtIndex:3] intValue];
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a/255.0f)];
}

#pragma mark - 二维码

/**
 *  根据文字输出二维码图片
 */
+ (UIImage *)zz_imageQR:(nonnull NSString *)text width:(CGFloat)width {
    
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3.设置数据
    NSData *infoData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKey:@"inputMessage"];
    // 4.生成二维码, 缩放
    CIImage *ciImage = filter.outputImage;
    CGRect extent = CGRectIntegral(ciImage.extent);
    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(width / CGRectGetWidth(extent), width / CGRectGetWidth(extent))];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    return image;
}

/**
 *  生成带图片的二维码
 */
+ (UIImage *)zz_imageQR:(NSString *)text width:(CGFloat)width icon:(UIImage *)icon iconWidth:(CGFloat)iconWidth {
    
    // 生成二维码
    UIImage *codeImage = [UIImage zz_imageQR:text width:width];
    
    if (icon == nil || iconWidth == 0) {
        return codeImage;
    }
    
    //开启上下文
    CGSize imageSize = codeImage.size;
    UIGraphicsBeginImageContext(imageSize);
    //画原图
    [codeImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    //在中间画用户头像，宽高为20%，正方形
    [icon drawInRect:CGRectMake((imageSize.width - iconWidth) * 0.5, (imageSize.height - iconWidth) * 0.5, iconWidth, iconWidth)];
    
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 水印

/**
 *  按起始点，添加带alpha的图片的水印
 */
- (UIImage *)zz_imageWaterMarkWithImage:(nonnull UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha {
    
    return [self zz_imageWaterMarkWithText:nil textPoint:CGPointZero attribute:nil image:image imagePoint:imgPoint alpha:alpha];
}

/**
 *  按范围，添加带alpha的图片的水印
 */
- (UIImage *)zz_imageWaterMarkWithImage:(nonnull UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha {
    
    return [self zz_imageWaterMarkWithText:nil textRect:CGRectZero attribute:nil image:image imageRect:imgRect alpha:alpha];
}

/**
 *  按起始点，添加带属性的字符串
 */
- (UIImage *)zz_imageWaterMarkWithText:(nonnull NSString*)text textPoint:(CGPoint)textPoint attribute:(NSDictionary*)attribute {
    
    return [self zz_imageWaterMarkWithText:text textPoint:textPoint attribute:attribute image:nil imagePoint:CGPointZero alpha:0];
}

/**
 *  按范围，添加带属性的字符串
 */
- (UIImage *)zz_imageWaterMarkWithText:(nullable NSString*)text textRect:(CGRect)textRect attribute:(nullable NSDictionary *)attribute {
    
    return [self zz_imageWaterMarkWithText:text textRect:textRect attribute:attribute image:nil imageRect:CGRectZero alpha:0];
}

/**
 *  按起始点，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)zz_imageWaterMarkWithText:(nullable NSString*)text textPoint:(CGPoint)textPoint attribute:(nullable NSDictionary*)attribute image:(nullable UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawAtPoint:imgPoint blendMode:kCGBlendModeNormal alpha:alpha];
    }
    if (text) {
        [text drawAtPoint:textPoint withAttributes:attribute];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/**
 *  按范围，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)zz_imageWaterMarkWithText:(nullable NSString*)text textRect:(CGRect)textRect attribute:(nullable NSDictionary *)attribute image:(nullable UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    if (text) {
        [text drawInRect:textRect withAttributes:attribute];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark - 高斯模糊

/**
 *  高斯模糊滤镜（默认值10.0）
 *  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius. Default value: 10.00
 */
- (UIImage *)zz_gaussBlur {
    
    return [self zz_gaussBlur:10.0 clipExtent:YES];
}

/**
 *  高斯模糊滤镜
 *  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius. Default value: 10.00
 *  clipExtent:是否裁掉高斯模糊边缘部分
 */
- (UIImage *)zz_gaussBlur:(CGFloat)blurRadius clipExtent:(BOOL)clipExtent {
    
    // Context
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:self.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blurRadius) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect outImageRect = CGRectZero;
    if (clipExtent) {
        outImageRect = CGRectMake(0, 0, result.extent.size.width - fabs(result.extent.origin.x) * 2.0, result.extent.size.height - fabs(result.extent.origin.y) * 2.0);
    }else {
        outImageRect = result.extent;
    }
    CGImageRef outImage = [context createCGImage:result fromRect:outImageRect];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

/**
 *  通过Accelerate库vImageBoxConvolve_ARGB8888的模糊算法
 *  blur范围[0, 1.0]，异常或默认为0.5
 */
- (UIImage *)zz_boxBlur {
    
    return [self zz_boxBlur:0.5];
}

/**
 *  通过Accelerate库vImageBoxConvolve_ARGB8888的模糊算法
 *  blur范围[0, 1.0]，异常或默认为0.5
 */
- (UIImage *)zz_boxBlur:(CGFloat)blur {
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

#pragma mark - 测试

- (NSInteger)zz_show:(CGRect)frame backgroundColor:(nullable UIColor *)backgroundColor {
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = backgroundColor;
    imageView.image = self;
    [window addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = arc4random() % 100000 + 100000;
    [imageView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        [sender removeFromSuperview];
    }];
    return imageView.tag;
}

- (NSInteger)zz_show:(CGRect)frame {
    
    return [self zz_show:frame backgroundColor:[UIColor clearColor]];
}

- (NSInteger)zz_debugShow:(CGRect)frame {
    
    return [self zz_show:frame backgroundColor:[UIColor lightGrayColor]];
}

+ (void)zz_removeShow:(NSInteger)tag {
    
    if (tag >= 100000) {
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [window.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]] && obj.tag == tag) {
                [obj removeFromSuperview];
                *stop = YES;
            }
        }];
    }
}

@end
