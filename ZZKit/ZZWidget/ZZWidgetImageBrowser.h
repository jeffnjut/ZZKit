//
//  ZZWidgetImageBrowser.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZWidgetImageLoadingView,ZZWidgetImageItemCell,ZZWidgetImageToolBar;

typedef void(^ZZWidgetImageBrowserVoidBlock)(void);

#pragma mark - ZZWidgetImageBrowser

@interface ZZWidgetImageBrowser : UIView

/**
 * 单例方法
 */
+(ZZWidgetImageBrowser *)shareInstanse;

/**
 * 显示网络图片方法
 * imageUrls      网络图片地址
 * index          显示第几张图片
 * imageContainer 图片容器
 */
-(void)zz_showNetImages:(NSArray <NSString *> *)imageUrls index:(NSInteger)index fromImageContainer:(UIView *)imageContainer;

/**
 * 显示本地图片方法
 * imagePathes    本地图片路径
 * index          显示第几张图片
 * imageContainer 图片容器
 */
-(void)zz_showLocalImages:(NSArray <NSString *> *)imagePathes index:(NSInteger)index fromImageContainer:(UIView *)imageContainer;


/**
 *  加载图片的block实现
 */
@property (nonatomic, copy) void(^zzLoadImageBlock)(UIImageView *imageView, NSString *imageUrl, ZZWidgetImageLoadingView *loadingView, ZZWidgetImageBrowserVoidBlock finished);

@end

#pragma mark - ZZWidgetImageItemCell

@interface ZZWidgetImageItemCell : UICollectionViewCell

// 显示网路图片
@property (nonatomic ,assign) BOOL showNetImage;

// 起始位置
@property (nonatomic, assign) CGRect anchorFrame;

// 是否是起始Cell
@property (nonatomic, assign) BOOL isStart;

// 图片地址
@property (nonatomic, copy) NSString *imageUrl;

// imageView的ContentMode，与Superview相同
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;

// 保存CollectionView
@property (nonatomic, weak) UICollectionView *collectionView;

// 返回回调
-(void)zz_addHideBlockStart:(ZZWidgetImageBrowserVoidBlock)start finish:(ZZWidgetImageBrowserVoidBlock)finish cancel:(ZZWidgetImageBrowserVoidBlock)cancel;

// 显示放大动画
-(void)zz_showEnlargeAnimation;

// 保存图片
-(void)zz_saveImage;

@end

#pragma mark - ZZWidgetImageLoadingView

@interface ZZWidgetImageLoadingView : UIView

// 加载进度
@property (nonatomic,assign) CGFloat progress;

// 提示信息
@property (nonatomic,copy)  NSArray *message;

+(ZZWidgetImageLoadingView *)zz_showInView:(UIView *)view;

+(ZZWidgetImageLoadingView *)zz_showAlertInView:(UIView *)view message:(NSString *)message;

-(void)zz_show;

-(void)zz_hide;

@end

#pragma mark - ZZWidgetImageToolBar

static CGFloat ToolBarHeight = 40.0;

@interface ZZWidgetImageToolBar : UIView

@property (nonatomic, copy) NSString *text;

-(void)zz_show;

-(void)zz_hide;

@end


NS_ASSUME_NONNULL_END
