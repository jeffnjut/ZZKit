//
//  UIViewController+ZZKit_ErrorPlaceholder.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZNetworkErrorView,ZZNetworkErrorDropSheet,ZZErrorItem;

typedef void (^ZZNetworkReloadBlock)(void);

@interface UIViewController (ZZKit_ErrorPlaceholder)

// 显示 Network Error View
- (void)zz_showNetworkError:(ZZNetworkReloadBlock)reload;

// 显示 Error View (自定义)
- (void)zz_showError:(ZZErrorItem *)item reload:(ZZNetworkReloadBlock)reload;

// 隐藏 Network Error View
- (void)zz_hideError;

// 重显 Network Error View
- (void)zz_reShowError;

#pragma mark - Network Error DropSheet 相关

// 显示 Network Error DropSheet
- (void)zz_showNetworkErrorDropSheet;

// 隐藏 Network Error DropSheet
- (void)zz_dismissNetworkErrorDropSheet;

// 重显 Network Error DropSheet
- (void)zz_reShowNetworkErrorDropSheet;

@end

@interface ZZNetworkErrorView : UIView

+ (ZZNetworkErrorView *)zz_networkErrorView:(void(^)(void))reload;

+ (ZZNetworkErrorView *)zz_networkErrorView:(ZZErrorItem *)item reload:(ZZNetworkReloadBlock)reload;

- (void)zz_restore;

@end


@interface ZZErrorItem : NSObject

// 背景颜色
@property (nonatomic, strong) UIColor *zzBackgroundColor;

// 故障默认图（网络图片）
@property (nullable, nonatomic, copy)   NSString *zzImageUrl;

// 故障默认图（本地图片）
@property (nullable, nonatomic, copy)   NSString *zzImageName;

// 故障默认图（本地图片, UIImage）
@property (nonatomic, strong) UIImage *zzImage;

// 网络故障默认图大小（本地、网络图片都有效）
@property (nonatomic, assign) CGSize zzImageSize;

// 网络故障默认图默认是水平居中，垂直相对中心便宜可以设置
@property (nonatomic, assign) CGFloat zzImageOffsetFromCenter;

// 提示语，比如“网络开小差。。。”，“网络有点异常”等等
@property (nonatomic, copy)   NSString *zzHintText;

// 提示语（颜色）
@property (nonatomic, strong) UIColor *zzHintTextColor;

// 提示语（字体）
@property (nonatomic, strong) UIFont *zzHintTextFont;

// 提示语（大小）
@property (nonatomic, assign) CGSize zzHintSize;

// 提示语（偏移image的距离）
@property (nonatomic, assign) CGFloat zzHintOffsetFromCenter;

// 重新加载按钮Text
@property (nonatomic, copy)   NSString *zzReloadText;

// 重新加载按钮Text（颜色）
@property (nonatomic, strong) UIColor *zzReloadTextColor;

// 重新加载按钮Text（字体）
@property (nonatomic, strong) UIFont *zzReloadTextFont;

// 重新加载按钮Text（大小）
@property (nonatomic, assign) CGSize zzReloadSize;

// 重新加载按钮Text（Border Color）
@property (nonatomic, strong) UIColor *zzReloadBorderColor;

// 重新加载按钮Text（Border Width）
@property (nonatomic, assign) CGFloat zzReloadBorderWidth;

// 重新加载按钮Text（Radius）
@property (nonatomic, assign) CGFloat zzReloadBorderRadius;

// 重新加载按钮Text（Background Color）
@property (nonatomic, strong) UIColor *zzReloadBorderBackgroundColor;

// 重新加载按钮（偏移image的距离）
@property (nonatomic, assign) CGFloat zzReloadOffsetFromCenter;

+ (ZZErrorItem *)error:(UIImage *)image msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END

