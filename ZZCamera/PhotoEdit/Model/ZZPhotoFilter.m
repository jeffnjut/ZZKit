//
//  ZZPhotoFilter.m
//  ZZKit
//
//  Created by Fu Jie on 2020/1/21.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "ZZPhotoFilter.h"

@implementation ZZPhotoFilter

/**
 * 初始化
 */
- (instancetype)initWithType:(ZZPhotoFilterType)type {
    
    self = [super init];
    if (self) {
        self.filterType = type;
        switch (type) {
            case ZZPhotoFilterTypeOriginal:
            {
                self.filterName = @"原图";
                self.filter = nil;
                break;
            }
            case ZZPhotoFilterTypeEffectChrome:
            {
                self.filterName = @"铬黄";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
                break;
            }
            case ZZPhotoFilterTypeEffectFade:
            {
                self.filterName = @"褪色";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
                break;
            }
            case ZZPhotoFilterTypeEffectInstant:
            {
                self.filterName = @"怀旧";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
                break;
            }
            case ZZPhotoFilterTypeEffectMono:
            {
                self.filterName = @"单色";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
                break;
            }
            case ZZPhotoFilterTypeEffectNoir:
            {
                self.filterName = @"黑白";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
                break;
            }
            case ZZPhotoFilterTypeEffectProcess:
            {
                self.filterName = @"冲印";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
                break;
            }
            case ZZPhotoFilterTypeEffectTonal:
            {
                self.filterName = @"色调";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
                break;
            }
            case ZZPhotoFilterTypeEffectTransfer:
            {
                self.filterName = @"岁月";
                self.filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
                break;
            }
        }
    }
    return self;
}

/**
 * 获取滤镜名称
 */
+ (nonnull NSString *)filterName:(ZZPhotoFilterType)type {
    
    switch (type) {
        case ZZPhotoFilterTypeOriginal:
            return @"原图";
        case ZZPhotoFilterTypeEffectChrome:
            return @"铬黄";
        case ZZPhotoFilterTypeEffectFade:
            return @"褪色";
        case ZZPhotoFilterTypeEffectInstant:
            return @"怀旧";
        case ZZPhotoFilterTypeEffectMono:
            return @"单色";
        case ZZPhotoFilterTypeEffectNoir:
            return @"黑白";
        case ZZPhotoFilterTypeEffectProcess:
            return @"冲印";
        case ZZPhotoFilterTypeEffectTonal:
            return @"色调";
        case ZZPhotoFilterTypeEffectTransfer:
            return @"岁月";
    }
    return @"";
}

@end
