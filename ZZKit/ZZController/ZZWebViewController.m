//
//  ZZWebViewController.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWebViewController.h"
#import "ZZWebView.h"
#import <Masonry/Masonry.h>
#import "UIViewController+ZZKit.h"
#import "NSString+ZZKit.h"

@interface ZZWebViewController ()

@property (nonatomic, strong) ZZWebView *zzWebView;

@end

@implementation ZZWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    if (!self.zzBackImage || ![self.zzBackImage isKindOfClass:[UIImage class]]) {
        self.zzBackImage = @"ic_nav_back".zz_image;
    }
    if (!self.zzReloadImage || ![self.zzReloadImage isKindOfClass:[UIImage class]]) {
        self.zzReloadImage = @"ic_nav_close".zz_image;
    }
    [self zz_navigationAddLeftBarButton:self.zzBackImage action:^{
        if ([weakSelf.zzWebView.zzWKWebView canGoBack]) {
            [weakSelf.zzWebView.zzWKWebView goBack];
        }else {
            [weakSelf zz_dismiss];
        }
    }];
    [self zz_navigationAddLeftBarButton:self.zzReloadImage action:^{
        [weakSelf zz_dismiss];
    }];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_zzWebView == nil) {
        _zzWebView = [ZZWebView zz_quickAddOnView:self.view frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
            make.edges.equalTo(superView);
        }];
    }
    [self.zzWebView zz_loadRequest:self.zzURL headerFields:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
