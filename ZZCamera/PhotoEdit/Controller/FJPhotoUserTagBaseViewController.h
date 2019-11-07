//
//  FJPhotoUserTagBaseViewController.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/5.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJPhotoEditViewController.h"

@protocol FJPhotoEditTagDelegate;

@interface FJPhotoUserTagBaseViewController : UIViewController

@property (nonatomic, weak) id<FJPhotoEditTagDelegate> delegate;

@property (nonatomic, assign) CGPoint point;

@end
