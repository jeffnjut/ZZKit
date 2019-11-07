//
//  FJImagePickerController.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJImagePickerController : UIImagePickerController

// 是否允许拍照（默认YES）
@property (nonatomic, assign) BOOL enablePhoto;
// 是否允许录像（默认YES）
@property (nonatomic, assign) BOOL enableVideo;
// 录像最长时间显示（默认15秒）
@property (nonatomic, assign) float videoMaxDuration;

@end
