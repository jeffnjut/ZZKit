//
//  ZZPhotoFilterManager.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/2.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoFilterManager.h"
#import "NSMutableArray+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "PHAsset+QuickEdit.h"
#import "ZZStorage.h"
#import "ZZPhotoFilter.h"

@interface ZZPhotoFilterManager ()

// 原始的CoreImage
@property (nonatomic, strong) CIImage *originalCIImage;

// 基础滤镜（控制亮度、对比度和饱和度）
@property (nonatomic, strong) CIFilter *colorControlFilter;

// 色温滤镜
@property (nonatomic, strong) CIFilter *temperatureFilter;

// 晕影滤镜
@property (nonatomic, strong) CIFilter *vignetteFilter;

// CoreImage上下文
@property (nonatomic, strong) CIContext *context;

// 原始Image，不受滤镜影响
@property (nonatomic, strong) UIImage *originalImage;

// 预制滤镜
@property (nonatomic, strong) NSMutableArray<ZZPhotoFilter *> *systemFilters;

@end

@implementation ZZPhotoFilterManager

static ZZPhotoFilterManager *SINGLETON = nil;
static bool isFirstAccess = YES;

+ (nonnull ZZPhotoFilterManager *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle
+ (id)allocWithZone:(NSZone *)zone {
    return [self shared];
}

- (id)copy {
    return [[ZZPhotoFilterManager alloc] init];
}

- (id)mutableCopy {
    return [[ZZPhotoFilterManager alloc] init];
}

- (id)init {
    
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    self.systemFilters = (NSMutableArray<ZZPhotoFilter *> *)[[NSMutableArray alloc] init];
    for (NSNumber *filterType in [ZZPhotoFilterManager filterTypes]) {
        ZZPhotoFilterType type = [filterType integerValue];
        [self.systemFilters addObject:[[ZZPhotoFilter alloc] initWithType:type]];
    }
    return self;
}

- (CIContext *)context {
    
    if (_context == nil) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

#pragma mark - Filter
- (CIFilter *)colorControlFilter {
    
    if (_colorControlFilter == nil) {
        _colorControlFilter = [CIFilter filterWithName:@"CIColorControls"];
    }
    return _colorControlFilter;
}

- (CIFilter *)temperatureFilter {
    
    if (_temperatureFilter == nil) {
        _temperatureFilter = [CIFilter filterWithName:@"CITemperatureAndTint"];
    }
    return _temperatureFilter;
}

- (CIFilter *)vignetteFilter {
    
    if (_vignetteFilter == nil) {
        _vignetteFilter = [CIFilter filterWithName:@"CIVignette"];
    }
    return _vignetteFilter;
}

#pragma mark - Public

/**
 * 设置当前图片
 */
- (void)setOriginalImage:(nonnull UIImage *)originalImage {
    
    _originalImage = originalImage;
    self.originalCIImage = [[CIImage alloc] initWithImage:originalImage];
}

/**
 * 获取CoreImage Filter（亮度、对比度、饱和度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(brightness) forKey:kCIInputBrightnessKey];
    [self.colorControlFilter setValue:@(contrast) forKey:kCIInputContrastKey];
    [self.colorControlFilter setValue:@(saturation) forKey:kCIInputSaturationKey];
    return self.colorControlFilter;
}

/**
 * 获取CoreImage Filter（亮度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage brightness:(float)brightness {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(brightness) forKey:kCIInputBrightnessKey];
    return self.colorControlFilter;
}

/**
 * 获取CoreImage Filter（对比度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage contrast:(float)contrast {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(contrast) forKey:kCIInputContrastKey];
    return self.colorControlFilter;
}

/**
 * 获取CoreImage Filter（饱和度）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage saturation:(float)saturation {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(saturation) forKey:kCIInputSaturationKey];
    return self.colorControlFilter;
}

/**
 * 获取CoreImage Filter（色温）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage temperature:(float)temperature {

    if (ciImage != nil) {
        [self.temperatureFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.temperatureFilter setValue:[CIVector vectorWithX:temperature Y:0] forKey:@"inputTargetNeutral"];
    return self.temperatureFilter;
}

/**
 * 获取CoreImage Filter（晕影）
 */
- (nonnull CIFilter *)coreImageFilter:(nullable CIImage *)ciImage vignette:(float)vignette {
    
    if (ciImage != nil) {
        [self.vignetteFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.vignetteFilter setValue:@(vignette) forKey:kCIInputIntensityKey];
    [self.vignetteFilter setValue:@(vignette + 1.0) forKey:kCIInputRadiusKey];
    return self.vignetteFilter;
}

/**
 * 获取Image Filter（Filter Type）
 */
- (nonnull UIImage *)image:(nonnull UIImage *)image filterType:(ZZPhotoFilterType)filterType {
    
    CIFilter *filter = [self filter:filterType].filter;
    if (filter == nil) {
        return image;
    }
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    CGImageRef ref = [self.context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    UIImage *filterImage = [UIImage imageWithCGImage:ref];
    //释放
    CGImageRelease(ref);
    return filterImage;
}

/**
 * 获取一组滤镜后的照片（滤镜中已经设置inputImage）
 */
- (nonnull UIImage *)image:(nonnull NSArray<CIFilter *> *)filters {
    
    // 去重
    NSArray *uniqueArray = [filters zz_arrayRemoveDuplicateObjects];
    
    // 合成Filter
    // 第一个Filter必须有CIImage输入源
    for (int i = 1; i < uniqueArray.count; i++) {
        CIFilter *filter = [uniqueArray objectAtIndex:i];
        CIFilter *preFilter = [uniqueArray objectAtIndex:i-1];
        if (preFilter.outputImage == nil) {
            NSString *debugStr = [NSString stringWithFormat:@"Context:%@\nprefilter:%@\nfilterinputKeys:%@",_context,preFilter,preFilter];
            [ZZStorage zz_plistSave:debugStr forKey:@"DebugStr_FJCamera_getImageCombine:"];
        }
        NSAssert(preFilter.outputImage != nil, @"前序滤镜outputImage输出不能为nil");
        [filter setValue:preFilter.outputImage forKey:kCIInputImageKey];
    }
    CIFilter *lastFilter = [uniqueArray lastObject];
    CGImageRef ref = [self.context createCGImage:lastFilter.outputImage fromRect:lastFilter.outputImage.extent];
    UIImage *filterImage = [UIImage imageWithCGImage:ref];
    //释放
    CGImageRelease(ref);
    if (filterImage == nil) {
        NSString *debugStr = [NSString stringWithFormat:@"Context:%@\nfilters:%@\nCGImageRef:%@",_context,filters,ref];
        [ZZStorage zz_plistSave:debugStr forKey:@"DebugStr_FJCamera_getImageCombine:"];
    }
    return filterImage;
}

/**
 * 获取Tuning和滤镜类型效果的照片（输入UIImage）
 */
- (nonnull UIImage *)image:(nonnull UIImage *)image tuningObject:(nonnull ZZPhotoTuning *)tuningObject appendFilterType:(ZZPhotoFilterType)filterType {
    
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter1 = [[ZZPhotoFilterManager shared] coreImageFilter:ciImage brightness:tuningObject.brightnessValue contrast:tuningObject.contrastValue saturation:tuningObject.saturationValue];
    CIFilter *filter2 = [[ZZPhotoFilterManager shared] coreImageFilter:nil temperature:tuningObject.temperatureValue];
    CIFilter *filter3 = [[ZZPhotoFilterManager shared] coreImageFilter:nil vignette:tuningObject.vignetteValue];
    CIFilter *filter4 = [self filter:filterType].filter;
    UIImage *retImage = nil;
    if (filter4 != nil) {
        retImage = [self image:@[filter1, filter2, filter3, filter4]];
    }else {
        retImage = [self image:@[filter1, filter2, filter3]];
    }
    if (retImage == nil) {
        NSString *debugStr = [NSString stringWithFormat:@"Context:%@\nfilter1:%@\nfilter2:%@\nfilter3:%@\nfilter4:%@\n",_context,filter1,filter2,filter3,filter4];
        [ZZStorage zz_plistSave:debugStr forKey:@"DebugStr_FJCamera_getImage:tuningObject:appendFilterType"];
        retImage = image;
    }
    return retImage;
}

/**
 * 获取Tuning和滤镜类型效果的照片（输入PHAsset）
 */
- (nonnull UIImage *)imageWithAsset:(nonnull PHAsset *)asset tuningObject:(nonnull ZZPhotoTuning *)tuningObject appendFilterType:(ZZPhotoFilterType)filterType {
    
    UIImage *image = [asset getGeneralTargetImage];
    return [self image:image tuningObject:tuningObject appendFilterType:filterType];
}

/**
 * 异步方式获取一组滤镜后的照片（滤镜中已经设置inputImage）
 */
- (void)asyncImageWithFilters:(nonnull NSArray<CIFilter *> *)filters result:(nonnull void(^)(UIImage * _Nonnull image))result {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block UIImage *filterImage = [weakSelf image:filters];
        dispatch_async(dispatch_get_main_queue(), ^{
            result == nil ? : result(filterImage);
        });
    });
}

/**
 * 根据FilterType获取ZZPhotoFilter
 */
- (nullable ZZPhotoFilter *)filter:(ZZPhotoFilterType)type {
    
    for (ZZPhotoFilter *filter in self.systemFilters) {
        if (filter.filterType == type) {
            return filter;
        }
    }
    return nil;
}

/**
 * 支持的滤镜类型
 */
+ (nonnull NSArray *)filterTypes {
    
    return @[@(ZZPhotoFilterTypeOriginal),
             @(ZZPhotoFilterTypeEffectChrome),
             @(ZZPhotoFilterTypeEffectFade),
             @(ZZPhotoFilterTypeEffectInstant),
             @(ZZPhotoFilterTypeEffectMono),
             @(ZZPhotoFilterTypeEffectNoir),
             @(ZZPhotoFilterTypeEffectProcess),
             @(ZZPhotoFilterTypeEffectTonal),
             @(ZZPhotoFilterTypeEffectTransfer)];
}

@end
