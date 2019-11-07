//
//  UIView+FJAdditions.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (FJAdditions)

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

- (UIViewController *)viewController;

@end
