//
//  UIViewController+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIViewController+ZZKit.h"
#import <objc/runtime.h>
#import "UIControl+ZZKit_Blocks.h"
#import "NSAttributedString+ZZKit.h"
#import "NSString+ZZKit.h"
#import "UIView+ZZKit_Blocks.h"

#pragma mark - UIViewController Extension

@implementation UIViewController (ZZKit)

#pragma mark - 导航视图

/**
 *  增加图片类型导航按钮（左）
 */
- (void)zz_navigationAddLeftBarButton:(nonnull UIImage *)image action:(nullable void(^)(void))action {
    [self zz_navigationAddBarButton:YES object:image size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

/**
 *  增加图片类型导航按钮（右）
 */
- (void)zz_navigationAddRightBarButton:(nonnull UIImage *)image action:(nullable void(^)(void))action {
    [self zz_navigationAddBarButton:NO object:image size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

/**
 *  增加文本类型导航按钮（左）
 */
- (void)zz_navigationAddLeftBarTextButton:(nonnull NSAttributedString *)text action:(nullable void(^)(void))action {
    [self zz_navigationAddBarButton:YES object:text size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

/**
 *  增加文本类型导航按钮（右）
 */
- (void)zz_navigationAddRightBarTextButton:(nonnull NSAttributedString *)text action:(nullable void(^)(void))action {
    [self zz_navigationAddBarButton:NO object:text size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

/**
 *  增加自定义类型导航按钮（左）
 */
- (void)zz_navigationAddLeftBarCustomView:(nonnull UIView *)customeView action:(void(^)(void))action {
    [self zz_navigationAddBarButton:YES object:customeView size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

/**
 *  增加自定义类型导航按钮（右）
 */
- (void)zz_navigationAddRightBarCustomView:(nonnull UIView *)customeView action:(void(^)(void))action {
    [self zz_navigationAddBarButton:NO object:customeView size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

/**
 *  移除左侧导航按钮
 */
- (void)zz_navigationRemoveLeftBarButtons {
    self.navigationItem.leftBarButtonItems = nil;
}

/**
 *  移除右侧导航按钮
 */
- (void)zz_navigationRemoveRightBarButtons {
    self.navigationItem.rightBarButtonItems = nil;
}

/**
 *  增加UIBarButtonItem（Base）
 */
- (void)zz_navigationAddBarButton:(BOOL)left object:(nonnull id)object size:(CGSize)size margin:(UIEdgeInsets)margin action:(void(^)(void))action {
    id customView = nil;
    if ([object isKindOfClass:[UIImage class]]) {
        // 图片类型，图片保持 24 * 24
        UIImage *image = object;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal | UIControlStateHighlighted];
        if (size.width > 0 && size.height > 0) {
            button.frame = CGRectMake(0, 0, size.width, size.height);
        }else{
            button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof UIControl * _Nonnull sender) {
            action == nil ? : action();
        }];
        customView = button;
        
    }else if ([object isKindOfClass:[NSAttributedString class]]) {
        // 文本类型
        NSAttributedString *attributedText = object;
        CGSize size = [attributedText zz_size:CGSizeMake(MAXFLOAT, 24.0) enableCeil:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, size.width + 10, 24.0);
        [button setAttributedTitle:attributedText forState:UIControlStateNormal];
        [button setAttributedTitle:attributedText forState:UIControlStateHighlighted];
        [button zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof UIControl * _Nonnull sender) {
            action == nil ? : action();
        }];
        customView = button;
        
    }else if ([object isKindOfClass:[UIView class]]) {
        // 自定义类型
        customView = object;
        [customView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
            action == nil ? : action();
        }];
    }else{
        return;
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    UIBarButtonItem *marginLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *marginRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    marginLeft.width = margin.left;
    marginRight.width = margin.right;
    if (left) {
        if ([self.navigationItem.leftBarButtonItems count] > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
            [arr addObject:marginLeft];
            [arr addObject:barButton];
            [arr addObject:marginRight];
            self.navigationItem.leftBarButtonItems = nil;
            self.navigationItem.leftBarButtonItems = arr;
        }else{
            self.navigationItem.leftBarButtonItems = @[marginLeft, barButton, marginRight];
        }
        
    }else{
        if ([self.navigationItem.rightBarButtonItems count] > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
            [arr addObject:marginLeft];
            [arr addObject:barButton];
            [arr addObject:marginRight];
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItems = arr;
        }else {
            self.navigationItem.rightBarButtonItems = @[marginLeft, barButton, marginRight];
        }
    }
}

/**
 *  导航条设置是否隐藏
 */
- (void)zz_navigationBarHidden:(BOOL)isBarHidden {
    if (self.navigationController.navigationBarHidden == isBarHidden) {
        return;
    }
    [self.navigationController setNavigationBarHidden:isBarHidden];
}

/**
 *  设置导航条BarTintColor、Translucent和BottomLineColor
 */
- (void)zz_navigationBarStyle:(nullable UIColor *)barTintColor translucent:(BOOL)translucent bottomLineColor:(nullable UIColor *)bottomLineColor {
    [self zz_navigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.translucent = translucent;
    [self _setupBottomLineColor:bottomLineColor];
}

/**
 *  设置导航条BarTitle（NSAttributedString）
 */
- (void)zz_navigationBarAttributedTitle:(nonnull NSAttributedString *)attributedTitle {
    [self zz_navigationBarHidden:NO];
    if (self.navigationItem.titleView == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        titleLabel.attributedText = attributedTitle;
        self.navigationItem.titleView = titleLabel;
    }else{
        UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            titleLabel.attributedText = attributedTitle;
        }else{
            self.navigationItem.titleView = nil;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
            titleLabel.attributedText = attributedTitle;
            self.navigationItem.titleView = titleLabel;
        }
    }
}

/**
 *  设置导航条BarTitle（NSString， 格式）
 */
- (void)zz_navigationBarTitle:(nonnull NSString *)title titleAttrs:(nullable NSDictionary *)titleAttrs {
    [self zz_navigationBarHidden:NO];
    if (titleAttrs == nil) {
        [self zz_navigationBarTitle:title];
    }else {
        self.navigationItem.title = title;
        self.navigationController.navigationBar.titleTextAttributes = titleAttrs;
    }
}

/**
 *  设置导航条的Title（NSString）
 */
- (void)zz_navigationBarTitle:(nonnull NSString *)title {
    [self zz_navigationBarHidden:NO];
    // 方法一
    if (@available(iOS 8.2, *)) {
        [self zz_navigationBarTitle:title titleAttrs:@{NSForegroundColorAttributeName : @"#1D1D1F".zz_color, NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold]}];
    } else {
        [self zz_navigationBarTitle:title titleAttrs:@{NSForegroundColorAttributeName : @"#1D1D1F".zz_color, NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    }
    // 方法二
    // NSAttributedString *attrStr = title.typeset.font(MediumWithSize(16).fontName, 16).color(HTColor1D1D1F.zz_color).textAlignment(NSTextAlignmentCenter).string;
    // [self ht_navigationBarTitle:attrStr];
}

#pragma mark - 电池条

/**
 *  设置StatusBar是否隐藏
 */
- (void)zz_statusBarHidden:(BOOL)hidden {
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}

#pragma mark - Push、Present、Popup、Dismiss

/**
 *  Push Controller
 */
- (void)zz_push:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    @synchronized (self) {
        if (![self _isLastPushOver:1.0]) {
            // Push间隔1秒
            return;
        }
        [self _updateLastPushDate];
        __block UINavigationController *navigationController;
        if ([self isKindOfClass:[UINavigationController class]]) {
            // self为UINavigationController类型
            navigationController = (UINavigationController *)self;
        }else {
            // self为其他类型控制器
            navigationController = self.navigationController;
        }
        
        if (navigationController == nil ||
            navigationController.topViewController == viewController ||
            viewController.presentingViewController != nil) {
            // 1）导航控制器为空，
            // 或者，2）导航控制器的topViewController和被Push的viewController是同一个
            // 否则，报错Pushing the same view controller instance more than once is not supported
            // 或者，3）viewController不能是模态过的控制器，否则EXC_BAD_ACCESS
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [navigationController pushViewController:viewController animated:animated];
        });
    }
}

/**
 *  Present Controller
 */
- (void)zz_present:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    @synchronized (self) {
        if (![self _isLastPushOver:1.0]) {
            // Present间隔1秒
            return;
        }
        [self _updateLastPushDate];
        if (viewController.presentingViewController != nil ||
            viewController.navigationController != nil) {
            // 1）当viewController的模态弹出控制器不为空，
            // 否则，会报错 Application tried to present modally an active controller
            // 或者2）viewController已经被Push出来
            // 否则，同样会报1）的错误
            return;
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:viewController animated:animated completion:completion];
        });
    }
}

/**
 *  Pop到上一级ViewController
 */
- (void)zz_popToPrevious:(BOOL)animated {
    __block UINavigationController *navigationController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // self为UINavigationController类型
        navigationController = (UINavigationController *)self;
    }else {
        // self为其他类型控制器
        navigationController = self.navigationController;
    }
    if ([navigationController.viewControllers count] <= 1) {
        // Controller Stack 数量小于等于1
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [navigationController popViewControllerAnimated:animated];
    });
}

/**
 *  Pop到Root ViewController
 */
- (void)zz_popToRoot:(BOOL)animated {
    __block UINavigationController *navigationController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // self为UINavigationController类型
        navigationController = (UINavigationController *)self;
    }else {
        // self为其他类型控制器
        navigationController = self.navigationController;
    }
    if ([navigationController.viewControllers count] <= 1) {
        // Controller Stack 数量小于等于1
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [navigationController popToRootViewControllerAnimated:animated];
    });
}

/**
 *  消失或者上一页[默认动画转场]
 */
- (void)zz_dismiss {
    [self zz_dismiss:YES];
}

/**
 *  消失或者上一页[Base]
 */
- (void)zz_dismiss:(BOOL)animated {
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // UINavigationController
        UINavigationController *navigationController = (UINavigationController *)self;
        if ([navigationController.viewControllers count] > 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UINavigationController *)weakSelf popViewControllerAnimated:animated];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }else {
        // UIViewController
        if (self.navigationController != nil) {
            if ([self.navigationController.viewControllers count] > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:animated];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController dismissViewControllerAnimated:animated completion:nil];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }
}

/**
 *  消失或者Root页[默认动画转场]
 */
- (void)zz_dismissRoot {
    [self zz_dismissRoot:YES];
}

/**
 *  消失或者Root页[Base]
 */
- (void)zz_dismissRoot:(BOOL)animated {
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // UINavigationController
        UINavigationController *navigationController = (UINavigationController *)self;
        if ([navigationController.viewControllers count] > 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UINavigationController *)weakSelf popToRootViewControllerAnimated:animated];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }else {
        // UIViewController
        if (self.navigationController != nil) {
            if ([self.navigationController.viewControllers count] > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:animated];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController dismissViewControllerAnimated:animated completion:nil];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }
}

/**
 *  消失或者Offset页[默认动画转场]
 */
- (void)zz_dismissOffset:(NSUInteger)offset {
    [self zz_dismissOffset:offset animated:YES];
}

/**
 *  消失或者Offset页，当前页是0，上一页是1...[Base]
 */
- (void)zz_dismissOffset:(NSUInteger)offset animated:(BOOL)animated {
    if (offset <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // UINavigationController
        UINavigationController *navigationController = (UINavigationController *)self;
        if ([navigationController.viewControllers count] > 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *toVC = [((UINavigationController *)weakSelf).viewControllers objectAtIndex:((UINavigationController *)weakSelf).viewControllers.count - 1 - offset];
                [(UINavigationController *)weakSelf popToViewController:toVC animated:animated];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }else {
        // UIViewController
        if (self.navigationController != nil) {
            if ([self.navigationController.viewControllers count] > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *toVC = [weakSelf.navigationController.viewControllers objectAtIndex:weakSelf.navigationController.viewControllers.count - 1 - offset];
                    [weakSelf.navigationController popToViewController:toVC animated:animated];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController dismissViewControllerAnimated:animated completion:nil];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }
}

#pragma mark - Alert View & Sheet

/**
 *  弹出OK AlertView
 */
-(void)zz_alertView:(nullable NSString *)title message:(nullable NSString *)message {
    ZZAlertModel *okAlertModel = [ZZAlertModel zz_alertModelOkayButton:nil];
    [self zz_alertView:title message:message cancel:NO cancelColor:nil item:okAlertModel, nil];
}

/**
 *  弹出AlertView(Title,Message,Cancel,可变参数)
 */
-(void)zz_alertView:(nullable NSString *)title message:(nullable NSString *)message cancel:(BOOL)cancel item:(nonnull ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self zz_alert:title message:message items:items cancel:cancel cancelColor:nil alertStyle:UIAlertControllerStyleAlert];
}

/**
 *  弹出AlertView(Title,Message,Cancel,Cancel颜色,可变参数)
 */
-(void)zz_alertView:(nullable NSString *)title message:(nullable NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(nonnull ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self zz_alert:title message:message items:items cancel:cancel cancelColor:cancelColor alertStyle:UIAlertControllerStyleAlert];
}

/**
 *  弹出ActionSheet(Title,Message,Cancel,可变参数)
 */
-(void)zz_alertSheet:(nullable NSString *)title message:(nullable NSString *)message cancel:(BOOL)cancel item:(nonnull ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self zz_alert:title message:message items:items cancel:cancel cancelColor:nil alertStyle:UIAlertControllerStyleActionSheet];
}

/**
 *  弹出ActionSheet(Title,Message,Cancel,Cancel颜色,可变参数)
 */
-(void)zz_alertSheet:(nullable NSString *)title message:(nullable NSString *)message cancel:(BOOL)cancel cancelColor:(nullable UIColor *)cancelColor item:(nonnull ZZAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self zz_alert:title message:message items:items cancel:cancel cancelColor:cancelColor alertStyle:UIAlertControllerStyleActionSheet];
}

/**
 *  弹窗,AlertView + ActionSheet
 */
- (void)zz_alert:(nullable NSString *)title message:(nullable NSString *)message items:(nonnull NSMutableArray *)items cancel:(BOOL)cancel cancelColor:(nullable UIColor *)cancelColor alertStyle:(UIAlertControllerStyle)alertStyle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    for (ZZAlertModel *item in items) {
        if (item.title.length != 0) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title style:item.style handler:^(UIAlertAction * _Nonnull action) {
                item.action == nil ? : item.action();
            }];
            if (item.color != nil && [[UIDevice currentDevice].systemVersion floatValue] >= 8.2) {
                [alertAction setValue:item.color forKey:@"_titleTextColor"];
            }
            [alertController addAction:alertAction];
        }
    }
    if (cancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        if (cancelColor != nil && [[UIDevice currentDevice].systemVersion floatValue] >= 8.2) {
            [cancelAction setValue:cancelColor forKey:@"_titleTextColor"];
        }
        [alertController addAction:cancelAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private

/**
 *  设置 Bottom Line Color
 */
- (void)_setupBottomLineColor:(nullable UIColor *)bottomLineColor {
    UIImageView *shadowImageView = [self _findHairlineImageView:self.navigationController.navigationBar];
    if (shadowImageView) {
        if (bottomLineColor == nil) {
            shadowImageView.hidden = YES;
        }else{
            shadowImageView.backgroundColor = bottomLineColor;
            shadowImageView.hidden = NO;
        }
    }else {
        if (bottomLineColor == nil) {
            [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        }else {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:nil];
        }
    }
}

/**
 *  找出一个View的子控件中高度小于等于1像素的UIImageView控件
 */
- (UIImageView *)_findHairlineImageView:(nonnull UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && CGRectGetHeight(view.bounds) <= 1.f) {
        return (UIImageView *)view;
    }
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self _findHairlineImageView:subView];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

/**
 *  上一次Push是否超出seconds秒
 */
- (BOOL)_isLastPushOver:(double)seconds {
    double last = [self _lastCheckDate];
    double now = [[NSDate date] timeIntervalSince1970];
    if (now - last > seconds) {
        return YES;
    }
    return NO;
}

/**
 *  上一次Push的时间
 */
- (double)_lastCheckDate {
    return [objc_getAssociatedObject(self, "_LastPushDate") doubleValue];
}

/**
 *  更新上一次Push的时间
 */
- (void)_updateLastPushDate {
    NSNumber *date = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    objc_setAssociatedObject(self, "_LastPushDate", date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - ZZAlertModel

@implementation ZZAlertModel

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModelOkayButton:(nullable void(^)(void))action {
    return [ZZAlertModel zz_alertModel:@"确定" style:UIAlertActionStyleDefault action:action color:nil];
}

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModelCancelButton:(nullable void(^)(void))action {
    return [ZZAlertModel zz_alertModel:@"取消" style:UIAlertActionStyleDefault action:action color:nil];
}

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModel:(nonnull NSString *)title action:(nullable void(^)(void))action {
    return [ZZAlertModel zz_alertModel:title style:UIAlertActionStyleDefault action:action color:nil];
}

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModel:(nonnull NSString *)title style:(UIAlertActionStyle)style action:(nullable void(^)(void))action {
    return [ZZAlertModel zz_alertModel:title style:style action:action color:nil];
}

/**
 *  ZZAlertModel构造方法
 */
+ (ZZAlertModel *)zz_alertModel:(nonnull NSString *)title style:(UIAlertActionStyle)style action:(nullable void(^)(void))action color:(nullable UIColor *)color {
    ZZAlertModel *model = [[ZZAlertModel alloc] init];
    model.title = title;
    model.style = style;
    model.action = action;
    model.color = color;
    return model;
}

@end
