//
//  WKWebView+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2020/3/31.
//  Copyright © 2020 wm. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (ZZKit)

- (void)zz_capture:(nullable void(^)(UIImage *image))block;

@end

NS_ASSUME_NONNULL_END
