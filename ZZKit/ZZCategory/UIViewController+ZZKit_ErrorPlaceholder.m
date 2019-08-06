//
//  UIViewController+ZZKit_ErrorPlaceholder.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIViewController+ZZKit_ErrorPlaceholder.h"
#import <objc/runtime.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "ZZNetworkErrorDropSheet.h"
#import "NSString+ZZKit.h"
#import "UIControl+ZZKit_Blocks.h"
#import "ZZDevice.h"

@implementation UIViewController (ZZKit_ErrorPlaceholder)

#pragma mark - Network Error Reload 相关
- (void)_setNetworkErrorView:(ZZNetworkErrorView *)networkErrorView {
    
    objc_setAssociatedObject(self, @"ZZNetworkErrorView", networkErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 显示 Network Error View
- (ZZNetworkErrorView *)_getNetworkErrorView {
    
    return objc_getAssociatedObject(self, @"ZZNetworkErrorView");
}

// 显示 Network Error View
- (void)zz_showNetworkError:(ZZNetworkReloadBlock)reload {
    
    [self zz_showError:[[ZZErrorItem alloc] init] reload:reload];
}

// 显示 Error View (自定义)
- (void)zz_showError:(ZZErrorItem *)item reload:(ZZNetworkReloadBlock)reload {
    
    if ([self _getNetworkErrorView] == nil) {
        ZZNetworkErrorView *errorView = [ZZNetworkErrorView zz_networkErrorView:item reload:reload];
        [self _setNetworkErrorView:errorView];
        [self.view addSubview:errorView];
        __weak typeof(self) weakSelf = self;
        [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
    }
    [self zz_reShowError];
}

// 隐藏 Network Error View
- (void)zz_hideError {
    
    [self _getNetworkErrorView].hidden = YES;
}

// 重显 Network Error View
- (void)zz_reShowError {
    
    __weak typeof(self) weakSelf = self;
    [[self.view subviews] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[ZZNetworkErrorView class]]) {
            [weakSelf.view bringSubviewToFront:obj];
            *stop = YES;
        }
    }];
    [self _getNetworkErrorView].hidden = NO;
    [[self _getNetworkErrorView] zz_restore];
}

#pragma mark - Network Error DropSheet 相关

- (void)_setNetworkErrorDropSheet:(ZZNetworkErrorDropSheet *)networkErrorDropSheet {
    
    objc_setAssociatedObject(self, @"ZZNetworkErrorDropSheet", networkErrorDropSheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取 Network Error DropSheet
- (ZZNetworkErrorDropSheet *)_getNetworkErrorDropSheet {
    
    return objc_getAssociatedObject(self, @"ZZNetworkErrorDropSheet");
}

// 显示 Network Error DropSheet
- (void)zz_showNetworkErrorDropSheet {
    
    if ([self _getNetworkErrorDropSheet] == nil) {
        ZZNetworkErrorDropSheet *networkErrorDropSheet = [ZZNetworkErrorDropSheet zz_networkErrorDropSheet:self];
        [self _setNetworkErrorDropSheet:networkErrorDropSheet];
        [self.view addSubview:networkErrorDropSheet];
        __weak typeof(self) weakSelf = self;
        [networkErrorDropSheet mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
                make.left.right.equalTo(weakSelf.view);
            }else {
                make.left.right.equalTo(weakSelf.view);
                if (weakSelf.navigationController.navigationBar.isHidden == NO) {
                    make.top.equalTo(weakSelf.view).offset(ZZ_DEVICE_NAVIGATION_TOP_HEIGHT);
                }
            }
            make.height.equalTo(@40.0);
        }];
    }else{
        [self _getNetworkErrorDropSheet].hidden = NO;
    }
}

// 隐藏 Network Error DropSheet
- (void)zz_dismissNetworkErrorDropSheet {
    
    [self _getNetworkErrorDropSheet].hidden = YES;
}

// 重显 Network Error DropSheet
- (void)zz_reShowNetworkErrorDropSheet {
    
    __weak typeof(self) weakSelf = self;
    [[self.view subviews] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[ZZNetworkErrorDropSheet class]]) {
            [weakSelf.view bringSubviewToFront:obj];
            *stop = YES;
        }
    }];
    [self _getNetworkErrorDropSheet].hidden = NO;
}

@end

@interface ZZNetworkErrorView()

// ZZErrorItem
@property (nonatomic, strong) ZZErrorItem *item;
// UI
@property (nonatomic, weak) UIImageView *networkErrorImageView;
@property (nonatomic, weak) UILabel *lbHint;
@property (nonatomic, weak) UIButton *btnReload;
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
// Reload CallBack
@property (nonatomic, copy) void(^reloadCallBack)(void);

@end

@implementation ZZNetworkErrorView

+ (ZZNetworkErrorView *)zz_networkErrorView:(void(^)(void))reload {
    
    ZZErrorItem *item = [[ZZErrorItem alloc] init];
    return [self zz_networkErrorView:item reload:reload];
}

+ (ZZNetworkErrorView *)zz_networkErrorView:(ZZErrorItem *)item reload:(ZZNetworkReloadBlock)reload {
    
    ZZNetworkErrorView *errorView = [[ZZNetworkErrorView alloc] initWithNetworkErrorItem:item];
    errorView.reloadCallBack = reload;
    [errorView _setupUI];
    return errorView;
}

- (void)zz_restore {
    
    self.networkErrorImageView.hidden = NO;
    self.lbHint.hidden = NO;
    self.btnReload.hidden = NO;
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
}

- (instancetype)initWithNetworkErrorItem:(ZZErrorItem *)item {
    
    self = [super init];
    if (self) {
        self.item = item;
    }
    return self;
}

- (void)_setupUI {
    
    for (UIView *anyView in self.subviews) {
        [anyView removeFromSuperview];
    }
    
    if (self.item.zzBackgroundColor) {
        self.backgroundColor = self.item.zzBackgroundColor;
    }
    
    __weak typeof(self) weakSelf = self;
    UIImageView *networkErrorImageView = [[UIImageView alloc] init];
    networkErrorImageView.tag = 1;
    [self addSubview:networkErrorImageView];
    [networkErrorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).offset(weakSelf.item.zzImageOffsetFromCenter);
        make.width.equalTo(@(weakSelf.item.zzImageSize.width));
        make.width.equalTo(@(weakSelf.item.zzImageSize.height));
    }];
    if (self.item.zzImageUrl) {
        [networkErrorImageView sd_setImageWithURL:[NSURL URLWithString:self.item.zzImageUrl]];
    }else if (self.item.zzImageName) {
        [networkErrorImageView setImage:[UIImage imageNamed:self.item.zzImageName]];
    }else if (self.item.zzImage) {
        [networkErrorImageView setImage:self.item.zzImage];
    }else {
        [networkErrorImageView setImage:@"icon_network_error".zz_image];
    }
    
    networkErrorImageView.contentMode = UIViewContentModeScaleAspectFit;
    networkErrorImageView.clipsToBounds = YES;
    self.networkErrorImageView = networkErrorImageView;
    
    // Hint Label
    UILabel *lbHint = [[UILabel alloc] init];
    lbHint.tag = 2;
    [self addSubview:lbHint];
    [lbHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).offset(weakSelf.item.zzHintOffsetFromCenter);
        make.width.equalTo(@(weakSelf.item.zzHintSize.width));
        make.height.equalTo(@(weakSelf.item.zzHintSize.height));
    }];
    lbHint.text = self.item.zzHintText;
    lbHint.textColor = self.item.zzHintTextColor;
    lbHint.font = self.item.zzHintTextFont;
    lbHint.textAlignment = NSTextAlignmentCenter;
    lbHint.numberOfLines = 0;
    self.lbHint = lbHint;
    
    // Reload Button
    UIButton *btnReload = [[UIButton alloc] init];
    btnReload.tag = 3;
    [self addSubview:btnReload];
    [btnReload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).offset(weakSelf.item.zzReloadOffsetFromCenter);
        make.width.equalTo(@(weakSelf.item.zzReloadSize.width));
        make.height.equalTo(@(weakSelf.item.zzReloadSize.height));
    }];
    [btnReload setTitle:self.item.zzReloadText forState:UIControlStateNormal];
    [btnReload setTitleColor:self.item.zzReloadTextColor forState:UIControlStateNormal];
    btnReload.titleLabel.font = self.item.zzReloadTextFont;
    btnReload.backgroundColor = self.item.zzReloadBorderBackgroundColor;
    btnReload.layer.borderColor = self.item.zzReloadBorderColor.CGColor;
    btnReload.layer.borderWidth = self.item.zzReloadBorderWidth;
    btnReload.layer.cornerRadius = self.item.zzReloadBorderRadius;
    self.btnReload = btnReload;
    [btnReload zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof UIControl * _Nonnull sender) {
        weakSelf.networkErrorImageView.hidden = YES;
        weakSelf.lbHint.hidden = YES;
        weakSelf.btnReload.hidden = YES;
        weakSelf.indicatorView.hidden = NO;
        [weakSelf.indicatorView startAnimating];
        weakSelf.reloadCallBack == nil ? : weakSelf.reloadCallBack();
    }];
    
    // IndicatorView
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.tag = 4;
    [self addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).offset(weakSelf.item.zzHintOffsetFromCenter - weakSelf.item.zzHintSize.height);
    }];
    self.indicatorView = indicatorView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


@implementation ZZErrorItem

- (instancetype)init {
    
    self = [super init];
    if (self) {
        // 背景颜色
        self.zzBackgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.98 alpha:1.0];
        // 网络故障默认图（本地图片）
        self.zzImageName = nil;
        // 网络故障默认图（网络图片）
        self.zzImageUrl = nil;
        // 网络故障默认图大小（本地、网络图片都有效）
        self.zzImageSize = CGSizeMake(144.0, 100.0);
        // 网络故障默认图默认是水平居中，垂直相对中心便宜可以设置
        self.zzImageOffsetFromCenter = -80.0;
        // 提示语，比如“网络开小差。。。”，“网络有点异常”等等
        self.zzHintText = @"咦，网络状态不佳哦~";
        // 提示语（颜色）
        self.zzHintTextColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        // 提示语（字体）
        self.zzHintTextFont = [UIFont systemFontOfSize:16.0];
        // 提示语（偏移image的距离）
        self.zzHintOffsetFromCenter = 40.0;
        // 重新加载按钮Text
        self.zzReloadText = @"重新加载";
        // 重新加载按钮Text（颜色）
        self.zzReloadTextColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        // 重新加载按钮Text（字体）
        self.zzReloadTextFont = [UIFont systemFontOfSize:14.0];
        // 重新加载按钮Text（Border Color）
        self.zzReloadBorderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        // 重新加载按钮Text（Border Width）
        self.zzReloadBorderWidth = 0.5;
        // 重新加载按钮Text（Radius）
        self.zzReloadBorderRadius = 4.0;
        // 重新加载按钮Text（Background Color）
        self.zzReloadBorderBackgroundColor = [UIColor clearColor];
        // 重新加载按钮（偏移image的距离）
        self.zzReloadOffsetFromCenter = 90.0;
        self.zzHintSize = CGSizeMake(300.0, 30.0);
        self.zzReloadSize = CGSizeMake(108.0, 30.0);
    }
    return self;
}

+ (ZZErrorItem *)error:(UIImage *)image msg:(NSString *)msg {
    
    ZZErrorItem *item = [[ZZErrorItem alloc] init];
    item.zzImage = image;
    item.zzHintText = msg;
    item.zzHintTextFont = [UIFont systemFontOfSize:12.0];
    item.zzHintSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    return item;
}

@end
