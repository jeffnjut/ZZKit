//
//  FJPhotoDraftHistoryViewController.h
//  FJCamera
//
//  Created by Fu Jie on 2019/1/16.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditCommonHeader.h"
#import "FJPhotoManager.h"

@interface FJPhotoDraftHistoryViewController : UIViewController

// User ID
@property (nonatomic, copy, nullable) NSString *uid;

@property (nonatomic, copy, nullable) void(^userSelectDraftBlock)(FJPhotoPostDraftSavingModel * _Nullable draft, BOOL pictureRemoved);

@end
