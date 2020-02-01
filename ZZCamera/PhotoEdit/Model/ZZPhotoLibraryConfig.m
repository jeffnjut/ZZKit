//
//  ZZPhotoLibraryConfig.m
//  ZZKit
//
//  Created by Fu Jie on 2020/1/22.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "ZZPhotoLibraryConfig.h"

@implementation ZZPhotoLibraryConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.cameraButtonType = ZZPhotoLibraryCameraButtonTypeBottom;
        self.showDraft = NO;
        self.sortType = ZZPhotoLibrarySortTypeCreationDateDesc;
        self.maxSelectionCount = 9;
        self.column = 4.0;
        self.filterMinPhotoPixelSize = CGSizeMake(400.0, 400.0);
        self.cropperType = ZZPhotoLibraryCropperTypeShow;
        self.cropperHorizontalExtemeRatio = 9.0 / 16.0;
        self.cropperVerticalExtemeRatio = 4.0 / 5.0;
    }
    return self;
}

@end
