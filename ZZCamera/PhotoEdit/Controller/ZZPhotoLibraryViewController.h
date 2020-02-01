//
//  ZZPhotoLibraryViewController.h
//  ZZKit
//
//  Created by Fu Jie on 2020/1/20.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoEditViewController.h"
#import "ZZPhotoTag.h"
#import "ZZPhotoSelectTagBaseViewController.h"
#import "ZZPhotoManager.h"
#import "ZZPhotoLibraryConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZPhotoLibraryViewController : UIViewController

// User ID
@property (nonatomic, copy) NSString *uid;

- (instancetype)initWithSessionId:(nonnull NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
