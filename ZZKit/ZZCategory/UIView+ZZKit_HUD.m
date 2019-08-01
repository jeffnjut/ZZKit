//
//  UIView+ZZKit_HUD.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/31.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "UIView+ZZKit_HUD.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <Lottie/Lottie.h>
#import <Masonry/Masonry.h>
#import <Typeset/Typeset.h>
#import "NSString+ZZKit.h"
#import "UIColor+ZZKit.h"
#import "NSAttributedString+ZZKit.h"

#pragma mark - UIView Category

#define kToastTextMaxWidth ([UIScreen mainScreen].bounds.size.width - 40.0 - 16.0 - 16.0)
#define kToastTextMinWidth 140.0

@implementation UIView (ZZKit_HUD)

#pragma mark - 加载

/**
 *  默认加载的动画
 */
- (MBProgressHUD *)zz_startLoading {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_loading_shopping" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self zz_startLoading:data backgroundColor:[UIColor clearColor] bezelViewColor:[UIColor clearColor] gifViewColor:[UIColor clearColor] boderWidth:0.5 borderColor:@"#E6E6E6".zz_color cornerRadius:2.0 userInteractionEnabled:NO];
}

/**
 *  默认加载的动画（Gif文件, 背景颜色, bezelView背景色, animatedImageView背景色, 边框颜色, 边框宽度, 四角角度）
 */
- (MBProgressHUD *)zz_startLoading:(nonnull NSData *)gifData backgroundColor:(nullable UIColor *)backgroundColor bezelViewColor:(nullable UIColor *)bezelViewColor gifViewColor:(nullable UIColor *)gifViewColor boderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled {
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // NO不影响当前手势
    hud.userInteractionEnabled = userInteractionEnabled;
    hud.backgroundColor = backgroundColor;
    
    // 设置bezeView
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = bezelViewColor;
    
    // 设置自定义View
    FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    animatedImageView.backgroundColor = gifViewColor;
    animatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    hud.customView = animatedImageView;
    hud.customView.layer.masksToBounds = YES;
    hud.customView.layer.borderWidth = borderWidth;
    hud.customView.layer.borderColor = borderColor.CGColor;
    hud.customView.layer.cornerRadius = cornerRadius;
    hud.customView.tag = 1234;
    
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

/**
 *  停止加载动画
 */
- (void)zz_stopLoading {
    
    for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
        MBProgressHUD *hud = [self.subviews objectAtIndex:i];
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            if ([hud.customView isKindOfClass:[FLAnimatedImageView class]] && hud.customView.tag == 1234) {
                [hud hideAnimated:YES];
            }
        }
    }
}

#pragma mark - 吐司

/**
 *  吐司（消息）
 */
- (MBProgressHUD *)zz_toast:(nullable NSString *)message {
    
    NSAttributedString *attributedString = message.typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).color([UIColor whiteColor]).textAlignment(NSTextAlignmentCenter).minimumLineHeight(20.0).string;
    return [self zz_showHUD:attributedString lottiePath:nil lottieViewSize:CGSizeZero edgeInsects:UIEdgeInsetsMake(12.0, 16.0, 12.0, 16.0) imageTextPadding:0 textMaxWidth:0 textMinWidth:0 borderColor:nil borderWidth:0 cornerRadius:2.0 duration:3.0 scaleAnimation:YES otherDisappearAnimationBlock:nil];
}

/**
 *  吐司（消息、动画）
 */
- (MBProgressHUD *)zz_toast:(nullable NSString *)message toastType:(ZZToastType)toastType {
    
    NSAttributedString *attributedString = message.typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).color([UIColor whiteColor]).textAlignment(NSTextAlignmentCenter).minimumLineHeight(20.0).string;
    NSString *path = nil;
    switch (toastType) {
        case ZZToastTypeSuccess:
        {
            path = [[NSBundle mainBundle] pathForResource:@"lottie_toast_success" ofType:@"json"];
            break;
        }
        case ZZToastTypeError:
        {
            path = [[NSBundle mainBundle] pathForResource:@"lottie_toast_error" ofType:@"json"];
            break;
        }
        case ZZToastTypeWarning:
        {
            path = [[NSBundle mainBundle] pathForResource:@"lottie_toast_warning" ofType:@"json"];
            break;
        }
        default:
            return nil;
    }
    return [self zz_showHUD:attributedString lottiePath:path lottieViewSize:CGSizeMake(64.0, 32.0) edgeInsects:UIEdgeInsetsMake(12.0, 16.0, 12.0, 16.0) imageTextPadding:12.0 textMaxWidth:0 textMinWidth:0 borderColor:nil borderWidth:0 cornerRadius:2.0 duration:3.0 scaleAnimation:YES otherDisappearAnimationBlock:nil];
}

/**
 *  吐司（消息、动画等完整参数）
 */
- (MBProgressHUD *)zz_showHUD:(nullable NSAttributedString *)message lottiePath:(nullable NSString *)lottiePath lottieViewSize:(CGSize)lottieViewSize edgeInsects:(UIEdgeInsets)edgeInsets imageTextPadding:(CGFloat)imageTextPadding textMaxWidth:(CGFloat)textMaxWidth textMinWidth:(CGFloat)textMinWidth borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius duration:(CGFloat)duration scaleAnimation:(BOOL)scaleAnimation otherDisappearAnimationBlock:(nullable void(^)(id contentView, void(^finished)(void)))otherDisappearAnimationBlock  {
    
    CGSize contentViewSize = CGSizeZero;
    __block CGSize textSize = CGSizeZero;
    if (textMaxWidth == 0 || textMinWidth ==0) {
        textMaxWidth = kToastTextMaxWidth;
        textMinWidth = kToastTextMinWidth;
    }
    if (message && lottiePath) {
        textSize = [message zz_size:CGSizeMake(textMaxWidth, MAXFLOAT) enableCeil:YES];
        contentViewSize.width = textSize.width < textMinWidth ? textMinWidth + edgeInsets.left + edgeInsets.right : textSize.width + edgeInsets.left + edgeInsets.right;
        contentViewSize.height =  edgeInsets.top + lottieViewSize.height + imageTextPadding + textSize.height + edgeInsets.bottom;
    }else if (message) {
        textSize = [message zz_size:CGSizeMake(textMaxWidth, MAXFLOAT) enableCeil:YES];
        contentViewSize.width = textSize.width < textMinWidth ? textMinWidth + edgeInsets.left + edgeInsets.right : textSize.width + edgeInsets.left + edgeInsets.right;
        contentViewSize.height =  edgeInsets.top + textSize.height + edgeInsets.bottom;
    }else if (lottiePath) {
        contentViewSize.width = textMaxWidth + edgeInsets.left + edgeInsets.right;
        contentViewSize.height =  edgeInsets.top + lottieViewSize.height + edgeInsets.bottom;
    }else {
        return nil;
    }
   
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // NO不影响当前手势
    hud.userInteractionEnabled = NO;
    hud.backgroundColor = [UIColor clearColor];
    
    // 设置bezeView
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    
    // 设置自定义View
    UIImage *image = [[UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:0.7] zz_image:contentViewSize];
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
    contentView.image = image;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor = borderColor.CGColor;
    contentView.layer.borderWidth = borderWidth;
    contentView.layer.cornerRadius = cornerRadius;
    __weak typeof(contentView) weakContentView = contentView;
    
    if (message && lottiePath) {
        
        // LOTAnimationView
        LOTAnimationView *animationView = [LOTAnimationView animationWithFilePath:lottiePath];
        [animationView play];
        [contentView addSubview:animationView];
        [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lottieViewSize.width));
            make.height.equalTo(@(lottieViewSize.height));
            make.centerX.equalTo(weakContentView.mas_centerX);
            make.top.equalTo(weakContentView).offset(edgeInsets.top);
        }];
        
        // 文字
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.attributedText = message;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakContentView.mas_left).offset(edgeInsets.left);
            make.right.equalTo(weakContentView.mas_right).offset(-edgeInsets.right);
            make.bottom.equalTo(weakContentView.mas_bottom).offset(-edgeInsets.bottom);
            make.height.equalTo(@(textSize.height));
        }];
        
    }else if (message) {
        
        // 文字
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.attributedText = message;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakContentView.mas_left).offset(edgeInsets.left);
            make.right.equalTo(weakContentView.mas_right).offset(-edgeInsets.right);
            make.top.equalTo(weakContentView.mas_top).offset(edgeInsets.top);
            make.height.equalTo(@(textSize.height));
        }];
        
    }else if (lottiePath) {
        
        // LOTAnimationView
        LOTAnimationView *animationView = [LOTAnimationView animationWithFilePath:lottiePath];
        [animationView play];
        [contentView addSubview:animationView];
        [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lottieViewSize.width));
            make.height.equalTo(@(lottieViewSize.height));
            make.centerX.equalTo(weakContentView.mas_centerX);
            make.top.equalTo(weakContentView).offset(edgeInsets.top);
        }];
    }
    
    hud.customView = contentView;
    hud.customView.tag = 4321;
    
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    __weak typeof(hud) weakHUD = hud;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (scaleAnimation) {
            contentView.alpha = 1.0;
            [UIView animateWithDuration:0.25 animations:^{
                contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakContentView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakHUD hideAnimated:NO];
                }];
            }];
        }else if (otherDisappearAnimationBlock != nil) {
            otherDisappearAnimationBlock(weakContentView, ^{
                [weakHUD hideAnimated:YES];
            });
        }else {
            [weakHUD hideAnimated:YES];
        }
    });
    
    return hud;
}

#pragma mark - 顶部消息

/**
 *  顶部消息（message）
 */
- (void)zz_dropSheet:(nonnull NSString *)message {
    
    [self zz_dropSheet:message tapBlock:nil cancelBlock:nil];
}

/**
 *  顶部消息（message和block）
 */
- (void)zz_dropSheet:(nonnull NSString *)message tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    ZZDropSheet *dropSheet = [[ZZDropSheet alloc] initWithMessage:message tapBlock:tapBlock cancelBlock:cancelBlock];
    [dropSheet zz_show];
}

/**
 *  顶部消息（完整参数）
 */
- (void)zz_dropSheet:(nonnull NSString *)message textFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor sheetbackgroundColor:(nullable UIColor *)sheetbackgroundColor closeImageNormal:(nullable UIImage *)closeImageNormal closeImageHighlighted:(nullable UIImage *)closeImageHighlighted stayDuration:(CGFloat)stayDuration tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    ZZDropSheet *dropSheet = [[ZZDropSheet alloc] initWithMessage:message
                                                         textFont:textFont
                                                        textColor:textColor
                                             sheetbackgroundColor:sheetbackgroundColor
                                                 closeImageNormal:closeImageNormal
                                            closeImageHighlighted:closeImageHighlighted
                                                     stayDuration:stayDuration
                                                         tapBlock:tapBlock
                                                      cancelBlock:cancelBlock];
    [dropSheet zz_show];
}

@end

#pragma mark - ZZDropSheet

#define ZZDROPSHEET_TEXT_FONT                [UIFont systemFontOfSize:14.0]
#define ZZDROPSHEET_TEXT_COLOR               [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define ZZDROPSHEET_BACKGROUND_COLOR         [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define ZZDROPSHEET_STAY_DURATION            (2.0)

typedef NS_ENUM(NSInteger, ZZDropSheetState) {
    ZZDropSheetStateNone,      // 未初始化
    ZZDropSheetStateAnimating, // 动画中
    ZZDropSheetStateShown,     // 展现中
    ZZDropSheetStateHidden     // 已消失
};

@interface ZZDropSheet ()

// DropSheet消息停留时间
@property (nonatomic, assign) CGFloat stayDuration;
// DropSheet消息字体
@property (nonatomic, strong) UIFont  *textFont;
// DropSheet消息颜色
@property (nonatomic, strong) UIColor *textColor;
// DropSheet的背景颜色
@property (nonatomic, strong) UIColor *sheetBackgroundColor;
// DropSheet消息关闭按钮Normal
@property (nonatomic, strong) UIImage *img_close_normal;
// DropSheet消息关闭按钮Highlighted
@property (nonatomic, strong) UIImage *img_close_highlighted;

// Alert Window
@property (nonatomic, strong)   UIWindow   *window;
// DropSheet View
@property (nonatomic, retain)   UIView     *sheetView;
// DropSheet Cancel Button
@property (nonatomic, strong)   UIButton   *cancelButton;
// DropSheet Message
@property (nonatomic, copy)     NSString   *message;
// DropSheet State
@property (atomic, assign)      ZZDropSheetState state;
// DropSheet Tapped Block
@property (nonatomic, copy)     void(^tapBlock)(void);
// DropSheet Cancelled Block
@property (nonatomic, copy)     void(^cancelBlock)(void);

@end

@implementation ZZDropSheet

#pragma mark - 初始化函数

- (instancetype)initWithMessage:(nonnull NSString *)message {
    
    return [self initWithMessage:message tapBlock:nil cancelBlock:nil];
}

- (instancetype)initWithMessage:(nonnull NSString *)message tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    return [self initWithMessage:message
                        textFont:ZZDROPSHEET_TEXT_FONT
                       textColor:ZZDROPSHEET_TEXT_COLOR
            sheetbackgroundColor:ZZDROPSHEET_BACKGROUND_COLOR
                closeImageNormal:@"toast_close_normal".zz_image
           closeImageHighlighted:@"toast_close_active".zz_image
                    stayDuration:ZZDROPSHEET_STAY_DURATION
                        tapBlock:tapBlock
                     cancelBlock:cancelBlock];
}

- (instancetype)initWithMessage:(nonnull NSString *)message textFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor sheetbackgroundColor:(nullable UIColor *)sheetbackgroundColor closeImageNormal:(nullable UIImage *)closeImageNormal closeImageHighlighted:(nullable UIImage *)closeImageHighlighted stayDuration:(CGFloat)stayDuration tapBlock:(nullable void(^)(void))tapBlock cancelBlock:(nullable void(^)(void))cancelBlock {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.message = message;
        self.textFont = textFont;
        self.textColor = textColor;
        self.sheetBackgroundColor = sheetbackgroundColor;
        self.img_close_normal = closeImageNormal;
        self.img_close_highlighted = closeImageHighlighted;
        self.stayDuration = stayDuration;
        self.tapBlock = tapBlock;
        self.cancelBlock = cancelBlock;
        [self _buildSheetView];
        [self addSubview:self.sheetView];
    }
    return self;
}

#pragma mark - Public

/**
 *  显示DropSheet
 */
- (void)zz_show {
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 64);
    [self _showRect:rect animated:YES];
}

#pragma mark - Private

// 显示[basic]
- (void)_showRect:(CGRect)rect animated:(BOOL)animated {
    
    if (self.state == ZZDropSheetStateNone || self.state == ZZDropSheetStateHidden) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.windowLevel = UIWindowLevelAlert;
        [self.window addSubview:self];
        [self.window makeKeyAndVisible];
        CGRect from = (CGRect){.origin = {rect.origin.x,-64}, .size = self.sheetView.bounds.size};
        self.sheetView.frame = from;
        CGRect to = (CGRect){.origin = {0, 0}, .size = self.sheetView.bounds.size};
        self.state = ZZDropSheetStateAnimating;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.sheetView.frame = to;
        } completion:^(BOOL finished) {
            weakSelf.state = ZZDropSheetStateShown;
            if (weakSelf.stayDuration < 0.1) {
                weakSelf.stayDuration = self.stayDuration;
            }
            // 几秒后自动消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(weakSelf.stayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf _dismissDropSheet:nil];
            });
        }];
    }
}

// 消失UI
- (void)_dismissDropSheet:(void(^)(void))finishBlock {
    
    if (self.state == ZZDropSheetStateShown) {
        self.state = ZZDropSheetStateHidden;
        __weak typeof(self) weakSelf = self;
        CGRect to = (CGRect){.origin = {0, -64}, .size = self.sheetView.bounds.size};
        self.state = ZZDropSheetStateAnimating;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.sheetView.frame = to;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.window = nil;
        }];
    }
}

// 生成UI
- (void)_buildSheetView {
    
    if (!self.sheetView) {
        UILabel *sheetTitleLable = nil;
        if (self.message.length > 0) {
            sheetTitleLable = [[UILabel alloc] initWithFrame:CGRectZero];
            sheetTitleLable.font = self.textFont;
            sheetTitleLable.numberOfLines = 0;
            sheetTitleLable.text = self.message;
            sheetTitleLable.textAlignment = NSTextAlignmentCenter;
            sheetTitleLable.backgroundColor = [UIColor clearColor];
            sheetTitleLable.textColor = self.textColor;
        }
        UIButton *cancelButton = nil;
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(_tapClose:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setBackgroundImage:self.img_close_normal forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:self.img_close_highlighted forState:UIControlStateHighlighted];
        self.cancelButton = cancelButton;
        NSInteger width = [UIScreen mainScreen].bounds.size.width;
        UIView *sheetBgView = [[UIView alloc] initWithFrame:(CGRect){.origin = {0.f,0.f}, .size = {width, 64}}];
        sheetBgView.backgroundColor = self.sheetBackgroundColor;
        if (sheetTitleLable) {
            CGSize size = [self.message sizeWithAttributes:@{NSFontAttributeName : sheetTitleLable.font}];
            sheetTitleLable.frame = CGRectMake((width-size.width)/2, 30, size.width, 34.0f);
            [sheetTitleLable sizeToFit];
            sheetTitleLable.textAlignment = NSTextAlignmentCenter;
            [sheetBgView addSubview:sheetTitleLable];
        }
        if (cancelButton) {
            cancelButton.frame = (CGRect){.origin = {width-30, 30}, .size = CGSizeMake(20, 20)};
            [sheetBgView addSubview:cancelButton];
        }
        sheetBgView.frame = (CGRect){.origin = {0.f,0.f}, .size = {width, 64}};
        self.sheetView = sheetBgView;
    }
}

// 关闭
- (void)_tapClose:(id)sender {
    
    self.cancelBlock == nil ? : self.cancelBlock();
    [self _dismissDropSheet:nil];
}

#pragma mark - UIResponder touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    @synchronized (self) {
        NSSet *allTouches = [event allTouches];
        UITouch *touch = [allTouches anyObject];
        CGPoint point = [touch locationInView:[touch view]];
        if (point.y <= 64.0) {
            // 只允许一次点击后回调Tapped Block
            if (self.tag == 0) {
                self.tag = -1;
                self.tapBlock == nil ? : self.tapBlock();
            }
        }
        [self _dismissDropSheet:nil];
    }
}

@end
