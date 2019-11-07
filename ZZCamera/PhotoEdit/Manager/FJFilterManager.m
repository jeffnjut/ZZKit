//
//  FJFilterManager.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/2.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJFilterManager.h"
#import "NSMutableArray+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "PHAsset+QuickEdit.h"

@interface FJFilterManager ()

// 上下文
@property (nonatomic, strong) CIContext *context;
// 当前设置的UIImage输入源（加上滤镜效果不改变原值）
@property (nonatomic, strong) UIImage *originalImage;
// image -> ciImage
@property (nonatomic, strong) CIImage *originalCIImage;

// 控制Brightness, contrast, saturation的滤镜
@property (nonatomic, strong) CIFilter *colorControlFilter;
// 控制色温滤镜
@property (nonatomic, strong) CIFilter *temperatureFilter;
// 暗角滤镜
@property (nonatomic, strong) CIFilter *vignetteFilter;

// 固定滤镜
// 预制滤镜Photo 8款 
@property (nonatomic, strong) CIFilter *photoEffectChromeFilter;
@property (nonatomic, strong) CIFilter *photoEffectFadeFilter;
@property (nonatomic, strong) CIFilter *photoEffectInstantFilter;
@property (nonatomic, strong) CIFilter *photoEffectMonoFilter;
@property (nonatomic, strong) CIFilter *photoEffectNoirFilter;
@property (nonatomic, strong) CIFilter *photoEffectProcessFilter;
@property (nonatomic, strong) CIFilter *photoEffectTonalFilter;
@property (nonatomic, strong) CIFilter *photoEffectTransferFilter;

@end

@implementation FJFilterManager

static FJFilterManager *SINGLETON = nil;
static bool isFirstAccess = YES;

+ (nonnull FJFilterManager *)shared {
    
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
    return [[FJFilterManager alloc] init];
}

- (id)mutableCopy {
    return [[FJFilterManager alloc] init];
}

- (id)init {
    
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
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

#pragma mark - Photo Effect Filters

- (CIFilter *)photoEffectChromeFilter {
    
    if (_photoEffectChromeFilter == nil) {
        _photoEffectChromeFilter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
    }
    return _photoEffectChromeFilter;
}

- (CIFilter *)photoEffectFadeFilter {
    
    if (_photoEffectFadeFilter == nil) {
        _photoEffectFadeFilter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
    }
    return _photoEffectFadeFilter;
}

- (CIFilter *)photoEffectInstantFilter {
    
    if (_photoEffectInstantFilter == nil) {
        _photoEffectInstantFilter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    }
    return _photoEffectInstantFilter;
}

- (CIFilter *)photoEffectMonoFilter {
    
    if (_photoEffectMonoFilter == nil) {
        _photoEffectMonoFilter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
    }
    return _photoEffectMonoFilter;
}

- (CIFilter *)photoEffectNoirFilter {
    
    if (_photoEffectNoirFilter == nil) {
        _photoEffectNoirFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    }
    return _photoEffectNoirFilter;
}

- (CIFilter *)photoEffectProcessFilter {
    
    if (_photoEffectProcessFilter == nil) {
        _photoEffectProcessFilter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
    }
    return _photoEffectProcessFilter;
}

- (CIFilter *)photoEffectTonalFilter {
    
    if (_photoEffectTonalFilter == nil) {
        _photoEffectTonalFilter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
    }
    return _photoEffectTonalFilter;
}

- (CIFilter *)photoEffectTransferFilter {
    
    if (_photoEffectTransferFilter == nil) {
        _photoEffectTransferFilter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    }
    return _photoEffectTransferFilter;
}

#pragma mark - Public

- (void)updateImage:(nonnull UIImage *)image {
    
    self.originalImage = image;
    self.originalCIImage = [[CIImage alloc] initWithImage:image];
}

- (void)setFilter:(nonnull CIFilter *)filter inputImage:(nonnull CIImage *)ciImage {
    
    [filter setValue:ciImage forKey:kCIInputImageKey];
}

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage brightness:(float)brightness contrast:(float)contrast saturation:(float)saturation {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(brightness) forKey:kCIInputBrightnessKey];
    [self.colorControlFilter setValue:@(contrast) forKey:kCIInputContrastKey];
    [self.colorControlFilter setValue:@(saturation) forKey:kCIInputSaturationKey];
    return self.colorControlFilter;
}

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage brightness:(float)brightness {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(brightness) forKey:kCIInputBrightnessKey];
    return self.colorControlFilter;
}

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage contrast:(float)contrast {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(contrast) forKey:kCIInputContrastKey];
    return self.colorControlFilter;
}

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage saturation:(float)saturation {
    
    if (ciImage != nil) {
        [self.colorControlFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.colorControlFilter setValue:@(saturation) forKey:kCIInputSaturationKey];
    return self.colorControlFilter;
}

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage temperature:(float)temperature {

    if (ciImage != nil) {
        [self.temperatureFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.temperatureFilter setValue:[CIVector vectorWithX:temperature Y:0] forKey:@"inputTargetNeutral"];
    return self.temperatureFilter;
}

- (nonnull CIFilter *)filterApplyTo:(nullable CIImage *)ciImage vignette:(float)vignette {
    
    if (ciImage != nil) {
        [self.vignetteFilter setValue:ciImage forKey:kCIInputImageKey];
    }
    [self.vignetteFilter setValue:@(vignette) forKey:kCIInputIntensityKey];
    [self.vignetteFilter setValue:@(vignette + 1.0) forKey:kCIInputRadiusKey];
    return self.vignetteFilter;
}

- (nonnull UIImage *)getImage:(nonnull UIImage *)image filterType:(FJFilterType)filterType {
    
    CIFilter *filter = [self filterBy:filterType];
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

- (void)getImageCombine:(nonnull NSArray<CIFilter *> *)filters result:(nonnull void(^)(UIImage * _Nonnull image))result {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block UIImage *filterImage = [weakSelf getImageCombine:filters];
        dispatch_async(dispatch_get_main_queue(), ^{
            result == nil ? : result(filterImage);
        });
    });
}

- (nonnull UIImage *)getImageCombine:(nonnull NSArray<CIFilter *> *)filters {
    
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

- (nonnull UIImage *)getImage:(nonnull UIImage *)image tuningObject:(nonnull FJTuningObject *)tuningObject appendFilterType:(FJFilterType)filterType {
    
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter1 = [[FJFilterManager shared] filterApplyTo:ciImage brightness:tuningObject.brightnessValue contrast:tuningObject.contrastValue saturation:tuningObject.saturationValue];
    CIFilter *filter2 = [[FJFilterManager shared] filterApplyTo:nil temperature:tuningObject.temperatureValue];
    CIFilter *filter3 = [[FJFilterManager shared] filterApplyTo:nil vignette:tuningObject.vignetteValue];
    CIFilter *filter4 = [self filterBy:filterType];
    UIImage *retImage = nil;
    if (filter4 != nil) {
        retImage = [self getImageCombine:@[filter1, filter2, filter3, filter4]];
    }else {
        retImage = [self getImageCombine:@[filter1, filter2, filter3]];
    }
    if (retImage == nil) {
        NSString *debugStr = [NSString stringWithFormat:@"Context:%@\nfilter1:%@\nfilter2:%@\nfilter3:%@\nfilter4:%@\n",_context,filter1,filter2,filter3,filter4];
        [ZZStorage zz_plistSave:debugStr forKey:@"DebugStr_FJCamera_getImage:tuningObject:appendFilterType"];
        retImage = image;
    }
    return retImage;
}

- (nonnull UIImage *)getImageAsset:(nonnull PHAsset *)asset tuningObject:(nonnull FJTuningObject *)tuningObject appendFilterType:(FJFilterType)filterType {
    
    UIImage *image = [asset getGeneralTargetImage];
    return [self getImage:image tuningObject:tuningObject appendFilterType:filterType];
}

- (nonnull CIFilter *)filterBy:(FJFilterType)type {
    
    switch (type) {
        case FJFilterTypePhotoEffectChrome:
        {
            return self.photoEffectChromeFilter;
        }
        case FJFilterTypePhotoEffectFade:
        {
            return self.photoEffectFadeFilter;
        }
        case FJFilterTypePhotoEffectInstant:
        {
            return self.photoEffectInstantFilter;
        }
        case FJFilterTypePhotoEffectMono:
        {
            return self.photoEffectMonoFilter;
        }
        case FJFilterTypePhotoEffectNoir:
        {
            return self.photoEffectNoirFilter;
        }
        case FJFilterTypePhotoEffectProcess:
        {
            return self.photoEffectProcessFilter;
        }
        case FJFilterTypePhotoEffectTonal:
        {
            return self.photoEffectTonalFilter;
        }
        case FJFilterTypePhotoEffectTransfer:
        {
            return self.photoEffectTransferFilter;
        }
        case FJFilterTypeOriginal:
        default:
            return nil;
    }
}

@end
