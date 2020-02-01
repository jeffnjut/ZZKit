//
//  ZZPhotoDraftHistoryViewController.h
//  ZZCamera
//
//  Created by Fu Jie on 2019/1/16.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoManager.h"

@interface ZZPhotoDraftHistoryViewController : UIViewController

// User ID
@property (nonatomic, copy, nullable) NSString *uid;

@property (nonatomic, copy, nullable) void(^userSelectDraftBlock)(UINavigationController *navigationController, ZZDraft * _Nullable draft, BOOL pictureRemoved);

@end
