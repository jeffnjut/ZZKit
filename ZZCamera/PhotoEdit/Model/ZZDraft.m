//
//  ZZDraft.m
//  ZZKit
//
//  Created by Fu Jie on 2020/1/21.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "ZZDraft.h"

#pragma mark - 草稿的照片信息

@implementation ZZDraftPhoto

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageTags = (NSMutableArray<ZZPhotoTag *> *)[[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"tuningObject" : ZZPhotoTuning.class , @"imageTags" : ZZPhotoTag.class};
}

@end

#pragma mark - 草稿的信息

@implementation ZZDraft

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.photos = (NSMutableArray<ZZDraftPhoto *> *)[[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"photos" : ZZDraftPhoto.class};
}

@end

#pragma mark - 草稿的信息列表

@implementation ZZDraftList

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.drafts = (NSMutableArray<ZZDraft *> *)[[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"drafts" : ZZDraft.class};
}

@end
