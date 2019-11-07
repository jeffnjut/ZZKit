//
//  FJImagePreviewController.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJMediaObject.h"

@interface FJImagePreviewController : UIViewController

- (instancetype)initWithMedia:(FJMediaObject *)media callback:(void(^)(BOOL saved, FJMediaObject *media))callback;

- (void)dismissToRoot;

@end
