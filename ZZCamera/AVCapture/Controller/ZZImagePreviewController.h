//
//  ZZImagePreviewController.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMediaObject.h"

@interface ZZImagePreviewController : UIViewController

- (instancetype)initWithMedia:(ZZMediaObject *)media callback:(void(^)(BOOL saved, ZZMediaObject *media))callback;

- (void)dismissToRoot;

@end
