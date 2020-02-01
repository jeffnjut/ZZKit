//
//  ZZPhotoEditViewController.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoLibraryConfig.h"
#import "ZZPhotoManager.h"
#import "ZZPhotoLibraryConfig.h"

@class ZZPhotoSelectTagBaseViewController;

@protocol ZZPhotoEditTagDelegate <NSObject>

@optional

- (void)zz_photoEditAddTag:(ZZPhotoTag *)model point:(CGPoint)point;

@end

@interface ZZPhotoEditViewController : UIViewController

@end
