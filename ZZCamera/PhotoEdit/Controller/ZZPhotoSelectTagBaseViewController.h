//
//  ZZPhotoSelectTagBaseViewController.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/5.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoEditViewController.h"

@interface ZZPhotoSelectTagBaseViewController : UIViewController

@property (nonatomic, weak) id<ZZPhotoEditTagDelegate> delegate;

@property (nonatomic, assign) CGPoint point;

@end
