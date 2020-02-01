//
//  ZZPhotoFilter.h
//  ZZKit
//
//  Created by Fu Jie on 2020/1/21.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <CoreImage/CoreImage.h>

typedef NS_ENUM(NSInteger, ZZPhotoFilterType) {
    
    ZZPhotoFilterTypeOriginal = 0,
    ZZPhotoFilterTypeEffectChrome,
    ZZPhotoFilterTypeEffectFade,
    ZZPhotoFilterTypeEffectInstant,
    ZZPhotoFilterTypeEffectMono,
    ZZPhotoFilterTypeEffectNoir,
    ZZPhotoFilterTypeEffectProcess,
    ZZPhotoFilterTypeEffectTonal,
    ZZPhotoFilterTypeEffectTransfer
};

NS_ASSUME_NONNULL_BEGIN

@interface ZZPhotoFilter : NSObject

@property (nonatomic, assign) ZZPhotoFilterType filterType;

@property (nonatomic, copy, nonnull) NSString *filterName;

@property (nonatomic, strong, nullable) CIFilter *filter;

/**
 * 初始化
 */
- (instancetype)initWithType:(ZZPhotoFilterType)type;

/**
 * 获取滤镜名称
 */
+ (nonnull NSString *)filterName:(ZZPhotoFilterType)type;

@end

NS_ASSUME_NONNULL_END
