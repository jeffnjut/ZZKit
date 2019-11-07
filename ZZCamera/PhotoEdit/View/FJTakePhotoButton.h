//
//  FJTakePhotoButton.h
//  FJCamera
//
//  Created by Fu Jie on 2018/12/24.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJTakePhotoButton : UIView

+ (FJTakePhotoButton *)createOn:(UIView *)view withDraft:(BOOL)withDraft draftBlock:(void(^)(void))draftBlock takePhotoBlock:(void(^)(void))takePhotoBlock;

- (void)updateWithDraft:(BOOL)withDraft;

@end
