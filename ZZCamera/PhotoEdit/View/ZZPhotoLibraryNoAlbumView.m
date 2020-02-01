//
//  ZZPhotoLibraryNoAlbumView.m
//  ZZCamera
//
//  Created by Fu Jie on 2019/1/23.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "ZZPhotoLibraryNoAlbumView.h"
#import "ZZMacro.h"

@implementation ZZPhotoLibraryNoAlbumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ZZPhotoLibraryNoAlbumView *)create {
    
    ZZPhotoLibraryNoAlbumView *view = ZZ_LOAD_NIB(@"ZZPhotoLibraryNoAlbumView");
    return view;
}

@end
