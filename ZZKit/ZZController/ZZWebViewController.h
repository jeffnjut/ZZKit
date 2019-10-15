//
//  ZZWebViewController.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZWebView.h"

// TODO

NS_ASSUME_NONNULL_BEGIN

@interface ZZWebViewController : UIViewController

// WebView容器
@property (nonatomic, strong, readonly) ZZWebView *zzWebView;

// URL
@property (nonatomic, copy) NSString *zzURL;

// 返回按钮的Image
@property (nonatomic, strong) UIImage *zzBackImage;

// 重新加载按钮的Image
@property (nonatomic, strong) UIImage *zzReloadImage;

@end

NS_ASSUME_NONNULL_END
