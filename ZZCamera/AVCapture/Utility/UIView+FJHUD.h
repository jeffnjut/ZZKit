//
//  UIView+FJHUD.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FJHUD)

@property(nonatomic, strong ,readonly)UIAlertController *alertController;

// 加载框
-(void)showHUD:(NSString *)message;      // 没有菊花

-(void)showLoadHUD:(NSString *)message;  // 有菊花

-(void)hideHUD;

// 提示框
-(void)showAutoDismissHUD:(NSString *)message;

-(void)showAutoDismissHUD:(NSString *)message delay:(NSTimeInterval)delay;

// 弹出框
-(void)showError:(NSError *)error;

-(void)showAlertView:(NSString *)message ok:(void(^)(UIAlertAction * action))ok cancel:(void(^)(UIAlertAction * action))cancel;

@end
