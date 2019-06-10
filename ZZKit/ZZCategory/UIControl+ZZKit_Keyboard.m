//
//  UIControl+ZZKit_Keyboard.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIControl+ZZKit_Keyboard.h"

@implementation UIControl (ZZKit_Keyboard)

/**
 *  创建UITextField和UITextView的键盘InputAccessoryView
 */
- (void)zz_createInputAccessory:(UIView *(^)(void))inputAccessoryBlock {
    
    if (inputAccessoryBlock != nil && ([self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UITextField class]])) {
        
        if ([self isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)self;
            textView.inputAccessoryView = inputAccessoryBlock();
        }else {
            UITextField *textField = (UITextField *)self;
            textField.inputAccessoryView = inputAccessoryBlock();
        }
    }
}

@end
