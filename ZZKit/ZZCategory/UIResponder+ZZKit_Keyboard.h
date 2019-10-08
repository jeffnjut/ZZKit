//
//  UIResponder+ZZKit_Keyboard.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (ZZKit_Keyboard)

/**
 *  创建UITextField和UITextView的键盘InputAccessoryView
 */
- (void)zz_createInputAccessory:(UIView *(^)(UIResponder * _Nonnull responder))inputAccessoryBlock;

@end

NS_ASSUME_NONNULL_END
