//
//  ZZPhotoEditViewController.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoEditViewController.h"
#import <Masonry/Masonry.h>
#import <Typeset/Typeset.h>
#import <CoreImage/CoreImage.h>
#import <CoreImage/CIFilter.h>
#import "ZZPhotoEditTitleScrollView.h"
#import "ZZPhotoEditToolbarView.h"
#import "ZZPhotoManager.h"
#import "ZZStaticCropperView.h"
#import "ZZFilterImageView.h"
#import "ZZPhotoSelectTagBaseViewController.h"
#import "ZZPhotoImageTagView.h"
#import "ZZPhotoTagAlertView.h"
#import "ZZPhotoTag.h"
#import "NSString+ZZKit.h"
#import "UIImage+ZZKit.h"
#import "UIViewController+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "UIView+ZZKit_HUD.h"
#import "UIView+ZZKit.h"
#import "ZZDevice.h"

@interface ZZPhotoScrollView : UIScrollView

@end

@implementation ZZPhotoScrollView

- (void)dealloc
{
    for (UIImageView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            subView.image = nil;
        }
    }
}

@end

@interface ZZPhotoEditViewController () <UIScrollViewDelegate, ZZPhotoEditTagDelegate>

// 用户自定义的Tag Controller
@property (nonatomic, strong) UIViewController *userTagController;

// Custome TitleView
@property (nonatomic, strong) ZZPhotoEditTitleScrollView *customTitleView;

// Next Button
@property (nonatomic, strong) UIButton *nextBtn;

// Tool Bar
@property (nonatomic, strong) ZZPhotoEditToolbarView *toolbar;

// ScrollView
@property (nonatomic, strong) ZZPhotoScrollView *scrollView;

// Cropper View
@property (nonatomic, strong) ZZStaticCropperView *cropperView;

// Filter View
@property (nonatomic, strong) ZZFilterImageView *filterView;

// Tag Deletion ImageView
@property (nonatomic, strong) UIImageView *deletionImageView;

// Current ImageView on ScrollView
@property (nonatomic, strong) UIImageView *currentImageView;

// Edit Controller Block
@property (nonatomic, copy) __kindof ZZPhotoSelectTagBaseViewController * (^editController)(ZZPhotoEditViewController *controller);

// Index
@property (nonatomic, assign) NSUInteger index;

@end

@implementation ZZPhotoEditViewController

#pragma mark - Properties

- (UIImageView *)deletionImageView {
    
    if (_deletionImageView == nil) {
        _deletionImageView = [[UIImageView alloc] init];
        _deletionImageView.image = @"ZZPhotoEditViewController.ic_tag_garbage".zz_image;
        [self.view addSubview:_deletionImageView];
    }
    return _deletionImageView;
}

- (UIButton *)nextBtn {
    
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        if (@available(iOS 8.2, *)) {
            _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        } else {
            _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        }
        [_nextBtn setTitleColor:@"#FF7725".zz_color forState:UIControlStateNormal];
        [_nextBtn setUserInteractionEnabled:YES];
        [_nextBtn addTarget:self action:@selector(_tapNext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (ZZStaticCropperView *)cropperView {
    
    if (_cropperView == nil) {
        _cropperView = [[ZZStaticCropperView alloc] initWithFrame:_scrollView.frame];
        [self.view addSubview:_cropperView];
        [self.view bringSubviewToFront:_cropperView];
    }
    return _cropperView;
}

- (ZZFilterImageView *)filterView {
    
    if (_filterView == nil) {
        _filterView = [ZZFilterImageView create:_scrollView.frame];
        [self.view addSubview:_filterView];
        [self.view bringSubviewToFront:_filterView];
    }
    return _filterView;
}

// 当前操作的Image视图
- (UIImageView *)currentImageView {
    
    ZZPhotoAsset *currentModel = ZZPhotoManager.shared.currentPhoto;
    for (UIImageView *imageView in self.scrollView.subviews) {
        if (currentModel.asset != nil) {
            if (imageView.tag == [currentModel.asset hash]) {
                return imageView;
            }
        }else if (currentModel.photoUrl != nil) {
            if (imageView.tag == [currentModel.photoUrl hash]) {
                return imageView;
            }
        }
    }
    return nil;
}

#pragma mark - Life Cycle

- (void)dealloc {
    NSLog(@"Dealloc - ZZPhotoDraftHistoryViewController");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (ZZPhotoManager.shared.config.userEditSelectTagBlock != nil) {
        __kindof ZZPhotoSelectTagBaseViewController *userTagAddVC = ZZPhotoManager.shared.config.userEditSelectTagBlock(self);
        userTagAddVC.delegate = self;
        self.userTagController = userTagAddVC;
    }
    
    // 初始化UI
    [self _buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_buildUI {
    
    ZZ_WEAK_SELF
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self zz_navigationBarHidden:NO];
    [self zz_navigationBarStyle:[UIColor whiteColor] translucent:NO bottomLineColor:@"#E6E6E6".zz_color];
    if (ZZPhotoManager.shared.config.editPhotoIndex == nil) {
        [self zz_navigationAddLeftBarButton:@"ZZPhotoEditViewController.ic_back".zz_image action:^{
            [weakSelf zz_dismiss];
        }];
    }
    [self zz_navigationAddRightBarCustomView:self.nextBtn action:nil];
    
    // 定位当前Photo Index
    if (ZZPhotoManager.shared.config.editPhotoIndex != nil) {
        self.index = [ZZPhotoManager.shared.config.editPhotoIndex intValue];
        // 当从编辑进来的，相册数量同步ZZPhotoManager
        ZZPhotoAsset *photoModel = [ZZPhotoManager.shared.photoQueue zz_arrayObjectAtIndex:self.index];
        if (photoModel) {
            ZZPhotoManager.shared.currentPhoto = photoModel;
        }else {
            self.index = 0;
            ZZPhotoManager.shared.currentPhoto = [ZZPhotoManager.shared.photoQueue zz_arrayObjectAtIndex:0];
        }
    }else {
        self.index = 0;
        ZZPhotoManager.shared.currentPhoto = [ZZPhotoManager.shared.photoQueue zz_arrayObjectAtIndex:0];
    }
    
    // Title View
    if (_customTitleView == nil) {
        _customTitleView = [ZZPhotoEditTitleScrollView create:ZZPhotoManager.shared.photoQueue.count];
        self.navigationItem.titleView = _customTitleView;
    }
    
    // Tool Bar
    if (_toolbar == nil) {
        static NSString *_ratio = nil;
        static BOOL _confirm = NO;
        _toolbar = [ZZPhotoEditToolbarView create:ZZPhotoManager.shared.config.mode editingBlock:^(BOOL inEditing) {
            
            if (inEditing) {
                weakSelf.scrollView.hidden = YES;
                [weakSelf.customTitleView setPageControllHidden:YES];
                [weakSelf.nextBtn setTitleColor:@"#78787D".zz_color forState:UIControlStateNormal];
                [weakSelf.nextBtn setUserInteractionEnabled:NO];
            }else {
                weakSelf.scrollView.hidden = NO;
                [weakSelf.customTitleView setPageControllHidden:NO];
                [weakSelf.nextBtn setTitleColor:@"#FF7725".zz_color forState:UIControlStateNormal];
                [weakSelf.nextBtn setUserInteractionEnabled:YES];
                weakSelf.cropperView.hidden = YES;
                weakSelf.filterView.hidden = YES;
                _ratio = nil;
                ZZPhotoAsset *currentPhoto = ZZPhotoManager.shared.currentPhoto;
                if (currentPhoto.imageTags.count > 0 && weakSelf.currentImageView.subviews.count == 0) {
                    // 裁剪界面返回完成后恢复TagView
                    for (ZZPhotoTag *tagModel in currentPhoto.imageTags) {
                        CGPoint p = CGPointMake(weakSelf.currentImageView.bounds.size.width * tagModel.xPercent, weakSelf.currentImageView.bounds.size.height * tagModel.yPercent);
                        [weakSelf _addImageTagOnImageView:weakSelf.currentImageView tag:tagModel point:p];
                    }
                }
            }
        } filterBlock:^(ZZPhotoFilterType filterType) {
            
            ZZPhotoAsset *currentPhoto = ZZPhotoManager.shared.currentPhoto;
            currentPhoto.tuningObject.filterType = filterType;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf _refreshCurrentImageViewToScrollView:nil];
            });
        } cropBlock:^(NSString *ratio, BOOL confirm) {
            
            // 暂时删除当前ImageView视图的所有TagView
            for (ZZPhotoImageTagView *tagView in weakSelf.currentImageView.subviews) {
                if ([tagView isKindOfClass:[ZZPhotoImageTagView class]]) {
                    [tagView removeFromSuperview];
                }
            }
            
            if ([ratio isEqualToString:_ratio] && confirm == _confirm) {
                return;
            }else {
                _ratio = ratio;
                _confirm = confirm;
            }
            if (confirm) {
                UIImage *croppedImage = [weakSelf.cropperView croppedImage];
                ZZPhotoAsset *currentPhoto = ZZPhotoManager.shared.currentPhoto;
                ZZPhotoManager.shared.currentPhoto.croppedImage = croppedImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf _refreshCurrentImageViewToScrollView:nil];
                });
                // 裁剪完成后恢复TagView
                for (ZZPhotoTag *tagModel in currentPhoto.imageTags) {
                    CGPoint p = CGPointMake(weakSelf.currentImageView.bounds.size.width * tagModel.xPercent, weakSelf.currentImageView.bounds.size.height * tagModel.yPercent);
                    [weakSelf _addImageTagOnImageView:weakSelf.currentImageView tag:tagModel point:p];
                }
            }else {
                float r = 1.0;
                if ([ratio isEqualToString:@"1:1"]) {
                    r = 1.0;
                }else if ([ratio isEqualToString:@"3:4"]) {
                    r = 3.0 / 4.0;
                }else if ([ratio isEqualToString:@"4:3"]) {
                    r = 4.0 / 3.0;
                }else if ([ratio isEqualToString:@"4:5"]) {
                    r = 4.0 / 5.0;
                }else if ([ratio isEqualToString:@"5:4"]) {
                    r = 5.0 / 4.0;
                }
                weakSelf.cropperView.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.cropperView];
                // 效果图
                ZZPhotoAsset *currentPhoto = ZZPhotoManager.shared.currentPhoto;
                [weakSelf.cropperView updateImage:currentPhoto.currentImage ratio:r];
                [weakSelf.cropperView updateCurrentTuning:currentPhoto.tuningObject];
            }
        } tuneBlock:^(ZZPhotoTuningType type, float value, BOOL confirm) {
            
            ZZPhotoAsset *currentPhoto = ZZPhotoManager.shared.currentPhoto;
            if (confirm) {
                [currentPhoto.tuningObject setType:type value:value];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf _refreshCurrentImageViewToScrollView:nil];
                });
            }else {
                [weakSelf.view bringSubviewToFront:weakSelf.filterView];
                weakSelf.filterView.hidden = NO;
                
                // 当点击调整Tab时候，默认会进来一次
                // 当tuningObject值和value相等表示是第一次进来
                // 否则，非第一次进来，不设置效果图，提高性能
                BOOL isFirst = NO;
                switch (type) {
                    case ZZPhotoTuningTypeBrightness:
                    {
                        if (currentPhoto.tuningObject.brightnessValue == value) {
                            isFirst = YES;
                        }
                        break;
                    }
                    case ZZPhotoTuningTypeContrast:
                    {
                        if (currentPhoto.tuningObject.contrastValue == value) {
                            isFirst = YES;
                        }
                        break;
                    }
                    case ZZPhotoTuningTypeSaturation:
                    {
                        if (currentPhoto.tuningObject.saturationValue == value) {
                            isFirst = YES;
                        }
                        break;
                    }
                    case ZZPhotoTuningTypeTemperature:
                    {
                        if (currentPhoto.tuningObject.temperatureValue == value) {
                            isFirst = YES;
                        }
                        break;
                    }
                    case ZZPhotoTuningTypeVignette:
                    {
                        if (currentPhoto.tuningObject.vignetteValue == value) {
                            isFirst = YES;
                        }
                        break;
                    }
                }
                if (isFirst) {
                    // 效果图
                    [weakSelf.filterView updateImage:currentPhoto.currentImage];
                    [weakSelf.filterView updateCurrentTuning:currentPhoto.tuningObject];
                }
                switch (type) {
                    case ZZPhotoTuningTypeBrightness:
                    {
                        [weakSelf.filterView updatePhoto:currentPhoto brightness:value contrast:currentPhoto.tuningObject.contrastValue saturation:currentPhoto.tuningObject.saturationValue];
                        break;
                    }
                    case ZZPhotoTuningTypeContrast:
                    {
                        [weakSelf.filterView updatePhoto:currentPhoto brightness:currentPhoto.tuningObject.brightnessValue contrast:value saturation:currentPhoto.tuningObject.saturationValue];
                        break;
                    }
                    case ZZPhotoTuningTypeSaturation:
                    {
                        [weakSelf.filterView updatePhoto:currentPhoto brightness:currentPhoto.tuningObject.brightnessValue contrast:currentPhoto.tuningObject.contrastValue saturation:value];
                        break;
                    }
                    case ZZPhotoTuningTypeTemperature:
                    {
                        [weakSelf.filterView updatePhoto:currentPhoto temperature:value];
                        break;
                    }
                    case ZZPhotoTuningTypeVignette:
                    {
                        [weakSelf.filterView updatePhoto:currentPhoto vignette:value];
                        break;
                    }
                    default:
                        break;
                }
            }
        }];
        
        [self.view addSubview:_toolbar];
        [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(weakSelf.view);
            make.height.equalTo(@167.0);
        }];
        
        _toolbar.tagBlock = ^{
            [weakSelf _touch:weakSelf.currentImageView point:CGPointMake(weakSelf.currentImageView.bounds.size.width / 2.0, weakSelf.currentImageView.bounds.size.height / 2.0)];   
        };
    }
    
    // ScrollView
    if (_scrollView == nil) {
        _scrollView = [[ZZPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT - _toolbar.bounds.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        for (NSUInteger index = 0; index < ZZPhotoManager.shared.photoQueue.count; index++) {
            
            ZZPhotoAsset *model = [ZZPhotoManager.shared.photoQueue objectAtIndex:index];
            UIImage *image = model.croppedImage;
            if (image == nil) {
                if (model.needCrop) {
                    model.croppedImage = [model.originalImage zz_imageCropBeginPointRatio:model.beginCropPoint endPointRatio:model.endCropPoint];
                    image = model.croppedImage;
                }
                if (image == nil) {
                    image = model.originalImage;
                }
            }
            
            // 加调整和滤镜效果
            UIImage *filteredImage = [[ZZPhotoFilterManager shared] image:image tuningObject:model.tuningObject appendFilterType:model.tuningObject.filterType];
            if (filteredImage == nil) {
                // 可能内存异常了
                filteredImage = image;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithImage:filteredImage];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if (filteredImage.size.width / filteredImage.size.height >= _scrollView.bounds.size.width / _scrollView.bounds.size.height) {
                CGFloat h = filteredImage.size.height / filteredImage.size.width * _scrollView.bounds.size.width;
                CGFloat y = (_scrollView.bounds.size.height - h) / 2.0;
                imageView.frame = CGRectMake(_scrollView.bounds.size.width * index, y, _scrollView.bounds.size.width, h);
            }else {
                CGFloat w = filteredImage.size.width / filteredImage.size.height * _scrollView.bounds.size.height;
                CGFloat x = (_scrollView.bounds.size.width - w) / 2.0;
                imageView.frame = CGRectMake(_scrollView.bounds.size.width * index + x, 0, w, _scrollView.bounds.size.height);
            }
            [_scrollView addSubview:imageView];
            if (model.asset != nil) {
                imageView.tag = [model.asset hash];
            }else if(model.photoUrl != nil) {
                imageView.tag = [model.photoUrl hash];
            }
            
            // 添加TagView
            if ((ZZPhotoManager.shared.config.mode & ZZPhotoEditModeTag) && model.imageTags.count == 0) {
                // 添加提示标签语：添加说明标签可以被更多人看见
                ZZPhotoTag *hintTagModel = [[ZZPhotoTag alloc] init];
                hintTagModel.isHint = YES;
                hintTagModel.name = @"添加说明标签可以被更多人看见";
                hintTagModel.xPercent = (ZZDevice.zz_screenWidth) / 4.0 / ZZDevice.zz_screenWidth;
                hintTagModel.yPercent = (imageView.bounds.size.height - 50.0) / imageView.bounds.size.height;
                hintTagModel.direction = 0;
                hintTagModel.v = @"1";
                CGPoint p = CGPointMake(imageView.bounds.size.width * hintTagModel.xPercent, imageView.bounds.size.height * hintTagModel.yPercent);
                [weakSelf _addImageTagOnImageView:imageView tag:hintTagModel point:p];
            }else {
                for (ZZPhotoTag *tagModel in model.imageTags) {
                    CGPoint p = CGPointMake(imageView.bounds.size.width * tagModel.xPercent, imageView.bounds.size.height * tagModel.yPercent);
                    [weakSelf _addImageTagOnImageView:imageView tag:tagModel point:p];
                }
            }
            // 打Tag手势
            [imageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_touchOnImageView:)];
            [imageView addGestureRecognizer:tap];
            
        }
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * ZZPhotoManager.shared.photoQueue.count, _scrollView.bounds.size.height);
    }
    
    // 滚动到当前相片
    [_scrollView setContentOffset:CGPointMake(ZZDevice.zz_screenWidth * self.index, 0)];
    [self.customTitleView updateIndex:self.index];
}

// 重新加载当前图片视图
- (void)_refreshCurrentImageViewToScrollView:(void(^)(UIImage *image))result {
    
    // 裁切
    ZZ_WEAK_SELF
    ZZPhotoAsset *currentModel = ZZPhotoManager.shared.currentPhoto;
    UIImage *image = currentModel.croppedImage;
    BOOL cropped = NO;
    if (image == nil) {
        // 原图
        image = currentModel.originalImage;
    }else {
        // 裁切
        cropped = YES;
    }
    // 加调整和滤镜效果
    image = [[ZZPhotoFilterManager shared] image:image tuningObject:currentModel.tuningObject appendFilterType:currentModel.tuningObject.filterType];
    
    self.currentImageView.image = image;
    if (cropped) {
        if (image.size.width /
            image.size.height >= weakSelf.scrollView.bounds.size.width / weakSelf.scrollView.bounds.size.height) {
            CGFloat h = image.size.height / image.size.width * weakSelf.scrollView.bounds.size.width;
            CGFloat y = (weakSelf.scrollView.bounds.size.height - h) / 2.0;
            self.currentImageView.frame = CGRectMake(weakSelf.scrollView.bounds.size.width * weakSelf.index, y, weakSelf.scrollView.bounds.size.width, h);
        }else {
            CGFloat w = image.size.width / image.size.height * weakSelf.scrollView.bounds.size.height;
            CGFloat x = (weakSelf.scrollView.bounds.size.width - w) / 2.0;
            self.currentImageView.frame = CGRectMake(weakSelf.scrollView.bounds.size.width * weakSelf.index + x, 0, w, weakSelf.scrollView.bounds.size.height);
        }
    }
    result == nil ? : result(image);
}

// 点击图片
- (void)_touchOnImageView:(UITapGestureRecognizer *)tapGesuture {
    
    UIImageView *imageView = (UIImageView *)tapGesuture.view;
    if ([imageView isKindOfClass:[UIImageView class]]) {
        CGPoint p = [tapGesuture locationInView:imageView];
        [self _touch:imageView point:p];
    }
}

// 点击图片(具体point点位)
- (void)_touch:(nonnull UIImageView *)imageView point:(CGPoint)point {
    
    // 限制一张图片上的Tag个数
    if (ZZPhotoManager.shared.config.limitedTagCnt > 0) {
        int tagsCnt = 0;
        for (ZZPhotoImageTagView *tagView in imageView.subviews) {
            if ([tagView isKindOfClass:[ZZPhotoImageTagView class]]) {
                tagsCnt++;
            }
        }
        if (tagsCnt >= ZZPhotoManager.shared.config.limitedTagCnt) {
            [self.view zz_toast:[NSString stringWithFormat:@"每张图片最多可以添加 %lu 个标签", (unsigned long)ZZPhotoManager.shared.config.limitedTagCnt] toastType:ZZToastTypeWarning];
            return;
        }
    }
    
    // 把Hint Tag View删除
    for (ZZPhotoImageTagView *tagView in self.currentImageView.subviews) {
        if ([tagView isKindOfClass:[ZZPhotoImageTagView class]]) {
            if ([tagView getTagModel].isHint == YES) {
                [tagView removeFromSuperview];
            }
        }
    }
    
    // 跳转用户的标签选择页面
    if ([imageView isKindOfClass:[UIImageView class]]) {
        if ([self.userTagController isKindOfClass:[ZZPhotoSelectTagBaseViewController class]]) {
            ((ZZPhotoSelectTagBaseViewController *)self.userTagController).point = point;
            [self.navigationController pushViewController:self.userTagController animated:YES];
        }
    }
}

// 添加标签
- (void)_addImageTagOnImageView:(UIImageView *)imageView tag:(ZZPhotoTag *)tag point:(CGPoint)point {
    
    ZZ_WEAK_SELF
    tag.createdTime = [[NSDate date] timeIntervalSince1970];
    tag.xPercent = point.x / imageView.bounds.size.width;
    tag.yPercent = point.y / imageView.bounds.size.height;
    tag.v = @"1";
    // 切换方向的Hint
    __block NSNumber *shownImageTagHint = [[NSUserDefaults standardUserDefaults] valueForKey:@"shownImageTagHint"];
    if (shownImageTagHint == nil && tag.isHint == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shownImageTagHint"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    ZZPhotoImageTagView *tagView = [ZZPhotoImageTagView create:point containerSize:imageView.bounds.size model:tag fixEdge:YES autoChangeDirection:YES tapBlock:^(__weak ZZPhotoImageTagView * photoImageTagView) {
        
        if (shownImageTagHint == nil && tag.isHint == NO) {
            for (UILabel *hintLabel in imageView.subviews) {
                if ([hintLabel isKindOfClass:[UILabel class]] && hintLabel.tag == 1001) {
                    [hintLabel removeFromSuperview];
                    break;
                }
            }
        }
    } movingBlock:^(UIGestureRecognizerState state, CGPoint point, ZZPhotoImageTagView *imageTagView) {
        
        static BOOL isDeletion;
        switch (state) {
            case UIGestureRecognizerStateBegan:
            {
                weakSelf.deletionImageView.hidden = NO;
                weakSelf.deletionImageView.frame = CGRectMake((weakSelf.scrollView.frame.size.width - 48.0) / 2.0, weakSelf.currentImageView.frame.origin.y + weakSelf.currentImageView.frame.size.height - 48.0 - 20.0 , 48.0, 48.0);
                [weakSelf.view bringSubviewToFront:weakSelf.deletionImageView];
                if (shownImageTagHint == nil && tag.isHint == NO) {
                    for (UILabel *hintLabel in imageView.subviews) {
                        if ([hintLabel isKindOfClass:[UILabel class]] && hintLabel.tag == 1001) {
                            [hintLabel removeFromSuperview];
                            break;
                        }
                    }
                }
                break;
            }
            case UIGestureRecognizerStateChanged:
            {
                if (point.x >= weakSelf.deletionImageView.frame.origin.x &&
                    point.x <= weakSelf.deletionImageView.frame.origin.x + weakSelf.deletionImageView.frame.size.width &&
                    point.y >= weakSelf.deletionImageView.frame.origin.y &&
                    point.y <= weakSelf.deletionImageView.frame.origin.y + weakSelf.deletionImageView.frame.size.height) {
                    if (isDeletion == NO) {
                        [UIView animateWithDuration:0.3 animations:^{
                            weakSelf.deletionImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                        }];
                    }
                    imageTagView.hidden = YES;
                    isDeletion = YES;
                }else {
                    if (isDeletion == YES) {
                        weakSelf.deletionImageView.transform = CGAffineTransformIdentity;
                    }
                    imageTagView.hidden = NO;
                    isDeletion = NO;
                }
                break;
            }
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
            {
                weakSelf.deletionImageView.hidden = YES;
                if (isDeletion && state == UIGestureRecognizerStateEnded) {
                    ZZPhotoAsset *photoModel = ZZPhotoManager.shared.currentPhoto;
                    [photoModel.imageTags removeObject:[imageTagView getTagModel]];
                    [imageTagView removeFromSuperview];
                }
                isDeletion = NO;
                weakSelf.deletionImageView.transform = CGAffineTransformIdentity;
                break;
            }
            default:
                break;
        }
    }];
    [imageView addSubview:tagView];
    
    if (shownImageTagHint == nil && tag.isHint == NO) {
        UILabel *hintTapReverseLabel = [[UILabel alloc] init];
        hintTapReverseLabel.tag = 1001;
        if (tagView.frame.origin.y < 40) {
            hintTapReverseLabel.frame = CGRectMake(tagView.frame.origin.x, tagView.frame.origin.y + tagView.frame.size.height + 8.0, 120.0, 18.0);
        }else {
            hintTapReverseLabel.frame = CGRectMake(tagView.frame.origin.x, tagView.frame.origin.y - 18.0, 120.0, 18.0);
        }
        hintTapReverseLabel.backgroundColor = @"#FF7A00".zz_color;
        hintTapReverseLabel.attributedText = @"轻触标签切换方向".typeset.font([UIFont systemFontOfSize:12.0].fontName, 12.0).color([UIColor whiteColor]).textAlignment(NSTextAlignmentCenter).string;
        [hintTapReverseLabel zz_cornerRadius:hintTapReverseLabel.frame.size.height / 2.0];
        [imageView addSubview:hintTapReverseLabel];
    }
}

// 点击下一步
- (void)_tapNext {
    
    ZZPhotoManager.shared.config.userPhotoEditNextBlock == nil ? : ZZPhotoManager.shared.config.userPhotoEditNextBlock(self.navigationController, ZZPhotoManager.shared.photoQueue);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSUInteger page = (NSUInteger)(scrollView.contentOffset.x / ZZDevice.zz_screenWidth);
    self.index = page;
    [self.customTitleView updateIndex:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    ZZPhotoManager.shared.currentPhoto = [ZZPhotoManager.shared.photoQueue objectAtIndex:self.index];
    if ([_toolbar getIndex] == 0) {
        [self.toolbar refreshFilterToolbar];
    }
}

#pragma mark - ZZPhotoEditTagDelegate

- (void)zz_photoEditAddTag:(ZZPhotoTag *)model point:(CGPoint)point {
    
    ZZPhotoAsset *photoModel = ZZPhotoManager.shared.currentPhoto;
    [photoModel.imageTags addObject:model];
    [self _addImageTagOnImageView:self.currentImageView tag:model point:point];
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
