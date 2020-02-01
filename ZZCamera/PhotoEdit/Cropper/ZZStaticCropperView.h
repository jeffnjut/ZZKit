//
//  ZZStaticCropperView.h
//  ZZKit
//

#import <UIKit/UIKit.h>
#import "ZZPhotoManager.h"

@interface ZZStaticCropperView : UIView

- (void)updateImage:(UIImage*)image ratio:(CGFloat)ratio;

- (void)updateCurrentTuning:(ZZPhotoTuning *)tuningObject;

- (UIImage *)croppedImage;

@end
