//
//  WKWebView+HideToolbar.h
//  ZZKit
//
//  Created by Fu Jie on 2020/2/12.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (HideToolbar)

@property (nonatomic, assign) BOOL hackishlyHidesInputAccessoryView;

@end

NS_ASSUME_NONNULL_END
