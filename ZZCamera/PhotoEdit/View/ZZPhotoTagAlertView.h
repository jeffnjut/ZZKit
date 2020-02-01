//
//  ZZPhotoTagAlertView.h
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/6.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZPhotoTagAlertView : UIView

+ (ZZPhotoTagAlertView *)create:(CGRect)frame deleteBlock:(void(^)(void))deleteBlock switchBlock:(void(^)(void))switchBlock;

@end

NS_ASSUME_NONNULL_END
