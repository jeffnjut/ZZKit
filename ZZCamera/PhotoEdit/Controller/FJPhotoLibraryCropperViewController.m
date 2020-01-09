//
//  FJPhotoLibraryCropperViewController.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/13.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJPhotoLibraryCropperViewController.h"
#import "FJPhotoLibrarySelectionView.h"
#import "FJPhotoLibraryAlbumSelectionView.h"
#import "FJPhotoCollectionViewCell.h"
#import "FJCropperView.h"
#import "PHAsset+Utility.h"
#import "FJTakePhotoButton.h"
#import "PHAsset+QuickEdit.h"
#import "FJPhotoDraftHistoryViewController.h"
#import "FJPhotoLibraryNoAlbumView.h"
#import "NSString+ZZKit.h"
#import "UIImage+ZZKit.h"

#define PREVIEW_IMAGE_LEAST_HEIGHT (48.0)
#define UPDOWN_LEAST_HEIGHT (48.0)

@interface FJPhotoLibraryCropperViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// CropperView
@property (nonatomic, strong) FJCropperView *cropperView;
// CollectionView
@property (nonatomic, strong) ZZCollectionView *collectionView;
// Navigation TitleView
@property (nonatomic, strong) FJPhotoLibrarySelectionView *customTitleView;
// Image Picker Controller
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
// Next Button
@property (nonatomic, strong) UIButton *nextBtn;
// 选择相册组件
@property (nonatomic, strong) FJPhotoLibraryAlbumSelectionView *albumSelectionView;
// 拍摄照片Button
@property (nonatomic, strong) FJTakePhotoButton *takePhotoButton;
// 没有相片的提示图片和文案控件
@property (nonatomic, strong) FJPhotoLibraryNoAlbumView *noAlbumView;
// 所有相册
@property (nonatomic, strong) NSMutableArray<PHAssetCollection *> *photoAssetCollections;
// 当前相册
@property (nonatomic, strong) PHAssetCollection *currentPhotoAssetColletion;
// 已选中的照片
@property (nonatomic, strong) NSMutableArray<FJPhotoModel *> *selectedPhotos;

// Edit Controller Block
@property (nonatomic, copy) __kindof FJPhotoUserTagBaseViewController * (^editController)(FJPhotoEditViewController *controller);

// First Picture Auto Selected (拍照后刷新自动选择)
@property (nonatomic, assign) BOOL firstPhotoAutoSelected;

// temporary photo model array
@property (nonatomic, strong) NSMutableArray<FJPhotoModel *> *temporaryPhotoModels;

// 打开相册时间戳，相同的assetIdentifier在不同时间戳打开属于不同的照片
@property (nonatomic, copy) NSString *uuid;

@end

@implementation FJPhotoLibraryCropperViewController

- (void)dealloc {
    NSLog(@"Dealloc - FJPhotoLibraryCropperViewController");
}

- (NSMutableArray<FJPhotoModel *> *)temporaryPhotoModels {
    
    if (_temporaryPhotoModels == nil) {
        _temporaryPhotoModels = (NSMutableArray<FJPhotoModel *> *)[[NSMutableArray alloc] init];
    }
    return _temporaryPhotoModels;
}

- (UIImagePickerController *)imagePickerController {
    
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

- (FJPhotoLibraryNoAlbumView *)noAlbumView {
    
    if (_noAlbumView == nil) {
        _noAlbumView = [FJPhotoLibraryNoAlbumView create];
        [self.view addSubview:_noAlbumView];
        __weak typeof(self) weakSelf = self;
        [_noAlbumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.takePhotoButton.mas_top);
        }];
    }
    return _noAlbumView;
}

- (UIButton *)nextBtn {
    
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        if (@available(iOS 8.2, *)) {
            _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        } else {
            // Fallback on earlier versions
            _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        }
        [_nextBtn setTitleColor:@"#78787D".zz_color forState:UIControlStateNormal];
        // [_nextBtn setUserInteractionEnabled:NO];
        [_nextBtn addTarget:self action:@selector(_tapNext:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (NSMutableArray<PHAssetCollection *> *)photoAssetCollections {
    
    if (_photoAssetCollections == nil) {
        _photoAssetCollections = (NSMutableArray<PHAssetCollection *> *)[NSMutableArray new];
    }
    return _photoAssetCollections;
}

- (NSMutableArray<FJPhotoModel *> *)selectedPhotos {
    
    if (_selectedPhotos == nil) {
        _selectedPhotos = (NSMutableArray<FJPhotoModel *> *)[NSMutableArray new];
    }
    return _selectedPhotos;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.maxSelectionCount = 9;
        self.photoListColumn = 4;
        self.takeButtonPosition = FJTakePhotoButtonPositionBottom;
        self.sortType = FJPhotoSortTypeCreationDateDesc;
        self.uuid = [NSString zz_uuidRandomTimestamp];
        self.filterMinPhotoPixelSize = CGSizeMake(400.0, 400.0);
        self.cropperViewVisible = YES;
        self.horizontalExtemeRatio = 9.0 / 16.0;
        self.verticalExtemeRatio = 4.0 / 5.0;
    }
    return self;
}

- (instancetype)initWithMode:(FJPhotoEditMode)mode editController:(__kindof FJPhotoUserTagBaseViewController * (^)(FJPhotoEditViewController *controller))editController {
    
    self = [self init];
    if (self) {
        self.mode = mode;
        self.editController = editController;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.takeButtonPosition == FJTakePhotoButtonPositionBottomWithDraft) {
        if (![[FJPhotoManager shared] isDraftExist:self.uid]) {
            [self.takePhotoButton updateWithDraft:NO];
        }
    }
}

- (void)viewDidLoad {
    
    ZZ_WEAK_SELF
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = @"#F5F5F5".zz_color;
    [self zz_navigationBarHidden:NO];
    [self zz_navigationBarStyle:[UIColor whiteColor] translucent:NO bottomLineColor:@"#E6E6E6".zz_color];
    [self zz_navigationAddLeftBarButton:@"FJPhotoLibraryCropperViewController.ic_back".zz_image action:^{
        [weakSelf zz_dismiss];
    }];
    
    // 获取权限
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    if (oldStatus == PHAuthorizationStatusDenied || oldStatus == PHAuthorizationStatusRestricted) {
        if (self.userNoPhotoLibraryPermissionBlock != nil) {
            self.userNoPhotoLibraryPermissionBlock();
        }else {
            ZZAlertModel *alert = [ZZAlertModel zz_alertModel:@"去开启" action:^{
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success){}];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            ZZAlertModel *cancel = [ZZAlertModel zz_alertModel:@"取消" action:^{
                [weakSelf zz_dismiss];
            }];
            [weakSelf zz_alertView:@"打开相册权限" message:@"打开相册权限后，才能浏览相册哦" cancel:NO item:alert,cancel, nil];
        }
        return;
    }
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后才会调用block
    // 如果之前做过选择，会直接执行调用block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) {
                //用户拒绝当前APP访问相册
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    //提醒用户打开开关
                    ZZAlertModel *goSettingAlertModel = [ZZAlertModel zz_alertModel:@"去开启" action:^{
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }];
                    ZZAlertModel *cancelAlertModel = [ZZAlertModel zz_alertModel:@"取消" action:^{
                        [weakSelf zz_dismiss];
                    }];
                    [weakSelf zz_alertView:@"打开相册权限" message:@"打开相册权限后，才能浏览相册哦" cancel:NO item:goSettingAlertModel,cancelAlertModel, nil];
                }else {
                    [weakSelf zz_dismiss];
                }
            }else if (status == PHAuthorizationStatusRestricted) {
                // (系统原因)无法访问相册
                [weakSelf zz_dismiss];
            }else if (status == PHAuthorizationStatusAuthorized) {
                // 用户允许当前APP访问相册
                [weakSelf _buildUI];
                [weakSelf _reloadPhotoAssetCollections];
                FJPhotoCollectionViewCellDataSource *ds = nil;
                ZZCollectionSectionObject *sectionObject = [weakSelf.collectionView.zzDataSource zz_arrayObjectAtIndex:0];
                if (weakSelf.takeButtonPosition == FJTakePhotoButtonPositionCell) {
                    ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:1];
                }else if (weakSelf.takeButtonPosition == FJTakePhotoButtonPositionNone ||
                          weakSelf.takeButtonPosition == FJTakePhotoButtonPositionBottom ||
                          weakSelf.takeButtonPosition == FJTakePhotoButtonPositionBottomWithDraft) {
                    ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:0];
                }
                if (ds != nil) {
                    if (weakSelf.cropperViewVisible) {
                        ds.isHighlighted = YES;
                        FJPhotoModel *model = [weakSelf _addTemporary:ds.photoAsset];
                        // 更新CropperView
                        [weakSelf.cropperView updateModel:model];
                    }
                }
            }
        });
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.userInitBlock == nil ? : weakSelf.userInitBlock();
    });
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)_buildUI {
    
    ZZ_WEAK_SELF
    [self zz_navigationAddRightBarCustomView:self.nextBtn action:nil];
    
    if (_customTitleView == nil) {
        self.customTitleView = [FJPhotoLibrarySelectionView create:@"手机相册"];
        self.navigationItem.titleView = self.customTitleView;
        [self.customTitleView setExtendBlock:^{
            [weakSelf _setAblumSelectionViewHidden:NO animation:YES];
        }];
        [self.customTitleView setCollapseBlock:^{
            [weakSelf _setAblumSelectionViewHidden:YES animation:YES];
        }];
    }
    
    if (_cropperViewVisible) {
        if (_cropperView == nil) {
            _cropperView = [FJCropperView create:NO grid:YES horizontalExtemeRatio:self.horizontalExtemeRatio verticalExtemeRatio:self.verticalExtemeRatio croppedBlock:^(FJPhotoModel *photoModel, CGRect frame) {
                
            } updownBlock:^(BOOL up) {
                [weakSelf _move:up];
            }];
            _cropperView.frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenWidth);
            [self.view addSubview:_cropperView];
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
            [_cropperView addGestureRecognizer:panGesture];
        }
    }
    
    if (_collectionView == nil) {
        
        CGRect frame = CGRectZero;
        if (_cropperViewVisible) {
            frame = CGRectMake(0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZDevice.zz_screenWidth - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT);
        }else {
            frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT);
        }
        
        _collectionView = [ZZCollectionView zz_quickAdd:[UIColor whiteColor] onView:self.view frame:frame registerCellsBlock:^NSArray * _Nonnull{
            
            return @[[FJPhotoCollectionViewCell class]];
        } constraintBlock:nil actionBlock:^(ZZCollectionView *__weak  _Nonnull collectionView, NSInteger section, NSInteger row, ZZCollectionViewCellAction action, __kindof ZZCollectionViewCellDataSource * _Nullable cellData, __kindof ZZCollectionViewCell * _Nullable cell) {
            
            if ([cellData isKindOfClass:[FJPhotoCollectionViewCellDataSource class]]) {
                FJPhotoCollectionViewCellDataSource *ds = (FJPhotoCollectionViewCellDataSource *)cellData;
                if (ds.isCameraPlaceholer) {
                    // 打开相机
                    [weakSelf _openCamera];
                    return;
                }
                
                if (action == ZZCollectionViewCellActionCustomTapped) {
                    
                    if ([weakSelf _selectPicture:&ds section:section item:row]) {
                        return;
                    }
                }else if (action == ZZCollectionViewCellActionTapped) {
                    
                    if (weakSelf.cropperViewVisible) {
                        FJPhotoModel *model = [weakSelf _addTemporary:ds.photoAsset];
                        // 更新CropperView
                        model.needCrop = ds.isSelected;
                        BOOL updateSuccess = [weakSelf.cropperView updateModel:model];
                        if (updateSuccess == NO) {
                            return;
                        }
                    }else {
                        if ([weakSelf _selectPicture:&ds section:section item:row] == NO) {
                            return;
                        }
                    }
                }
                if (weakSelf.cropperViewVisible) {
                    // 将选中的图片边框设置成高亮，其余不高亮
                    for (FJPhotoCollectionViewCellDataSource *data in weakSelf.collectionView.zzDataSource) {
                        if ([data isEqual:cellData]) {
                            data.isHighlighted = YES;
                        }else {
                            data.isHighlighted = NO;
                        }
                    }
                    FJPhotoCollectionViewCell *cl = (FJPhotoCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
                    for (FJPhotoCollectionViewCell *c in [weakSelf.collectionView visibleCells]) {
                        if ([c isEqual:cl]) {
                            [c updateHighlighted:YES];
                        }else {
                            [c updateHighlighted:NO];
                        }
                    }
                }
            }
        }];
        
        if (self.takeButtonPosition == FJTakePhotoButtonPositionBottom ||
            self.takeButtonPosition == FJTakePhotoButtonPositionBottomWithDraft) {
            _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 48.0, 0);
        }
    }
    
    if (self.cropperViewVisible) {
        
        self.collectionView.zzScrollBlock = ^(ZZCollectionView *__weak  _Nonnull collectionView, ZZCollectionViewScrollAction action, CGPoint velocity, CGPoint targetContentOffset, BOOL decelerate) {
            // TODO 图片预览隐藏和展开
        };
    }
    
    // Take Photo Button
    if (self.takeButtonPosition == FJTakePhotoButtonPositionBottom ||
        self.takeButtonPosition == FJTakePhotoButtonPositionBottomWithDraft) {
        if (_takePhotoButton == nil) {
            BOOL enableDraft =  [[FJPhotoManager shared] isDraftExist:self.uid] && self.takeButtonPosition == FJTakePhotoButtonPositionBottomWithDraft;
            _takePhotoButton = [FJTakePhotoButton createOn:self.view withDraft:enableDraft draftBlock:^{
                [weakSelf _openDraft];
            } takePhotoBlock:^{
                // 打开相机
                [weakSelf _openCamera];
            }];
        }
    }
}

- (BOOL)_selectPicture:(FJPhotoCollectionViewCellDataSource **)cellData section:(NSInteger)section item:(NSInteger)item {
    
    FJPhotoCollectionViewCellDataSource *ds = *cellData;
    
    // 选择照片
    if (ds.isSelected) {
        // 移除
        ds.isSelected = NO;
        [[FJPhotoManager shared] remove:ds.photoAsset];
        for (int i = (int)self.selectedPhotos.count - 1; i >= 0; i--) {
            FJPhotoModel *photoModel = [self.selectedPhotos objectAtIndex:i];
            if ([photoModel.asset isEqual:ds.photoAsset]) {
                [self.selectedPhotos removeObjectAtIndex:i];
                break;
            }
        }
        if (!self.cropperViewVisible) {
            ds.isHighlighted = ds.isSelected;
        }
    }else {
        // 判断是否是iCloud照片
        UIImage *image = [ds.photoAsset getGeneralTargetImage];
        if (image == nil) {
            [self.view zz_toast:@"iCloud照片正在下载中"];
            return NO;
        }
        // 判断是否超出最大选择数量
        if (self.selectedPhotos.count == self.maxSelectionCount) {
            if (self.userOverLimitationBlock != nil) {
                self.userOverLimitationBlock();
            }else {
                [self.view zz_toast:[NSString stringWithFormat:@"最多可以选择 %lu 张图片", (unsigned long)self.maxSelectionCount] toastType:ZZToastTypeWarning];
            }
            return NO;
        }
        // 选择
        ds.isSelected = YES;
        FJPhotoModel *model = [self _addTemporary:ds.photoAsset];
        [[FJPhotoManager shared] addDistinct:model];
        [self.selectedPhotos zz_arrayAddObject:model];
        
        if (self.cropperViewVisible) {
            // 更新CropperView
            model.needCrop = YES;
            BOOL updateSuccess = [self.cropperView updateModel:model];
            if (updateSuccess == NO) {
                ds.isSelected = NO;
                return NO;
            }
        }else {
            ds.isHighlighted = ds.isSelected;
        }
    }
    [self.collectionView zz_refresh];
    [self _checkNextState];
    return YES;
}

// 拖动CropperView的手势，当cropperViewVisible == YES时有效
- (void)_panAction:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint point = [panGesture translationInView:panGesture.view];
    static CGFloat y = 0;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            y = self.cropperView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            self.cropperView.blurLabel.hidden = YES;
            
            CGRect frame = CGRectMake(0,  y + point.y, self.cropperView.bounds.size.width, self.cropperView.bounds.size.height);
            if (frame.origin.y >= 0) {
                frame.origin.y = 0;
            }else if (frame.origin.y <= -(ZZDevice.zz_screenWidth - PREVIEW_IMAGE_LEAST_HEIGHT)) {
                frame.origin.y = -(ZZDevice.zz_screenWidth - PREVIEW_IMAGE_LEAST_HEIGHT);
            }
            self.cropperView.frame = frame;
            self.collectionView.frame = CGRectMake(0, self.cropperView.frame.origin.y + self.cropperView.bounds.size.height, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT - ZZDevice.zz_screenWidth - self.cropperView.frame.origin.y);
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if ([self.cropperView getUp]) {
                if (self.cropperView.frame.origin.y > - (ZZDevice.zz_screenWidth - PREVIEW_IMAGE_LEAST_HEIGHT - UPDOWN_LEAST_HEIGHT) ) {
                    [self _move:NO];
                }else {
                    [self _move:YES];
                }
            }else {
                if (self.cropperView.frame.origin.y < - UPDOWN_LEAST_HEIGHT ) {
                    [self _move:YES];
                }else {
                    [self _move:NO];
                }
            }
            
            break;
        }
        default:
            break;
    }
}

// 向上向下位移CropperView的方法，当cropperViewVisible == YES时有效
- (void)_move:(BOOL)up {
    
    static BOOL inAnimation = NO;
    if (inAnimation) {
        return;
    }
    
    ZZ_WEAK_SELF
    CGRect frame = CGRectZero;
    if (up) {
        frame = CGRectMake(0,  -(ZZDevice.zz_screenWidth - PREVIEW_IMAGE_LEAST_HEIGHT), weakSelf.cropperView.bounds.size.width, weakSelf.cropperView.bounds.size.height);
    }else {
        frame = CGRectMake(0,  0, weakSelf.cropperView.bounds.size.width, weakSelf.cropperView.bounds.size.height);
    }
    if (up == [self.cropperView getUp] && CGRectEqualToRect(weakSelf.cropperView.frame, frame)) {
        return;
    }
    inAnimation = YES;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.cropperView.frame = frame;
        if (up) {
            weakSelf.collectionView.frame = CGRectMake(0, weakSelf.cropperView.frame.origin.y + weakSelf.cropperView.bounds.size.height, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT - ZZDevice.zz_screenWidth - weakSelf.cropperView.frame.origin.y);
        }else {
            weakSelf.collectionView.frame = CGRectMake(0, weakSelf.cropperView.frame.origin.y + weakSelf.cropperView.bounds.size.height, ZZDevice.zz_screenWidth, weakSelf.collectionView.bounds.size.height);
        }
    } completion:^(BOOL finished) {
        inAnimation = NO;
        weakSelf.collectionView.frame = CGRectMake(0, weakSelf.cropperView.frame.origin.y + weakSelf.cropperView.bounds.size.height, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT - ZZDevice.zz_screenWidth - weakSelf.cropperView.frame.origin.y);
        [weakSelf.cropperView updateUp:up];
    }];
}

- (void)_setAblumSelectionViewHidden:(BOOL)hidden animation:(BOOL)animation {
    
    UIView *view = nil;
    ZZ_WEAK_SELF
    if (_albumSelectionView == nil) {
        
        view = [[UIView alloc] init];
        view.tag = 1000;
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [view addSubview:btn];
        ZZ_WEAK_OBJECT(view)
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakview);
        }];
        [btn addTarget:self action:@selector(_tapBlurView) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint point = CGPointZero;
        _albumSelectionView = [FJPhotoLibraryAlbumSelectionView create:point maxColumn:5 photoAssetCollections:self.photoAssetCollections selectedPhotoAssetCollection:self.currentPhotoAssetColletion assetCollectionChangedBlock:^(PHAssetCollection *currentCollection) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf _setAblumSelectionViewHidden:YES animation:YES];
                [weakSelf.customTitleView collapse];
                if ([weakSelf.currentPhotoAssetColletion isEqual:currentCollection]) {
                    return;
                }
                weakSelf.currentPhotoAssetColletion = currentCollection;
                [weakSelf.customTitleView updateAlbumTitle:currentCollection.localizedTitle];
                [weakSelf _render];
            });
            
        }];
        
        _albumSelectionView.frame = CGRectMake(0, - _albumSelectionView.bounds.size.height, ZZDevice.zz_screenWidth, _albumSelectionView.bounds.size.height);
        [view addSubview:_albumSelectionView];
        
    }else {
        for (UIView *v in self.view.subviews) {
            if ([v isMemberOfClass:[UIView class]] && v.tag == 1000) {
                view = v;
                break;
            }
        }
    }
    
    if (animation) {
        ZZ_WEAK_OBJECT(view)
        if (hidden == YES) {
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.albumSelectionView.frame = CGRectMake(0, - weakSelf.albumSelectionView.bounds.size.height, weakSelf.albumSelectionView.bounds.size.width, weakSelf.albumSelectionView.bounds.size.height);
                weakview.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                weakview.hidden = YES;
            }];
            
        }else {
            view.hidden = NO;
            view.backgroundColor = [UIColor clearColor];
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.albumSelectionView.frame = CGRectMake(0, 0, weakSelf.albumSelectionView.bounds.size.width, weakSelf.albumSelectionView.bounds.size.height);
                weakview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            } completion:^(BOOL finished) {
            }];
        }
    }else {
        if (hidden == YES) {
            view.hidden = YES;
            _albumSelectionView.frame = CGRectMake(0, - _albumSelectionView.bounds.size.height, _albumSelectionView.bounds.size.width, _albumSelectionView.bounds.size.height);
        }else {
            view.hidden = NO;
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            _albumSelectionView.frame = CGRectMake(0, 0, _albumSelectionView.bounds.size.width, _albumSelectionView.bounds.size.height);
        }
    }
}

- (void)_tapBlurView {
    
    [self _setAblumSelectionViewHidden:YES animation:YES];
    [self.customTitleView collapse];
}

- (void)_tapNext:(UIButton *)sender {
    
    if (self.userNextBlock != nil) {
        self.userNextBlock(self.selectedPhotos);
    }else {
        // 推出 FJPhotoEditViewController
        FJPhotoEditViewController *editVC = [[FJPhotoEditViewController alloc] initWithMode:self.mode editController:self.editController];
        editVC.selectedPhotos = self.selectedPhotos;
        editVC.userEditNextBlock = self.userEditNextBlock;
        editVC.mode = self.mode;
        editVC.limitedTagCnt = 3;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (void)_openCamera {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        if (self.userNoCameraPermissionBlock != nil) {
            self.userNoCameraPermissionBlock();
        }else {
            ZZAlertModel *alert = [ZZAlertModel zz_alertModel:@"去开启" action:^{
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success){}];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [self zz_alertView:@"打开相机权限" message:@"打开相机权限后，才能拍照哦" cancel:YES item:alert, nil];
        }
        return;
    }
    ZZ_WEAK_SELF
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController presentViewController:weakSelf.imagePickerController animated:YES completion:nil];
            });
        }else {
            //提醒用户打开开关
            ZZAlertModel *goSettingAlertModel = [ZZAlertModel zz_alertModel:@"去开启" action:^{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            ZZAlertModel *cancelAlertModel = [ZZAlertModel zz_alertModel:@"取消" action:^{
                [weakSelf zz_dismiss];
            }];
            [weakSelf zz_alertView:@"打开相机权限" message:@"打开相机权限后，才能拍照哦" cancel:NO item:goSettingAlertModel,cancelAlertModel, nil];
        }
    }];
}

- (void)_openDraft {
    
    FJPhotoDraftHistoryViewController *draftVC = [[FJPhotoDraftHistoryViewController alloc] init];
    draftVC.uid = self.uid;
    draftVC.userSelectDraftBlock = self.userSelectDraftBlock;
    [self.navigationController pushViewController:draftVC animated:YES];
}

- (void)_checkNextState {
    
    if (self.selectedPhotos.count > 0) {
        [self.nextBtn setTitleColor:@"#FF7725".zz_color forState:UIControlStateNormal];
        // [self.nextBtn setUserInteractionEnabled:YES];
    }else {
        [self.nextBtn setTitleColor:@"#78787D".zz_color forState:UIControlStateNormal];
        // [self.nextBtn setUserInteractionEnabled:NO];
    }
}

- (void)_reloadPhotoAssetCollections {
    
    [self.photoAssetCollections removeAllObjects];
    
    // 系统相机
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in collections) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumMyPhotoStream || collection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumCloudShared) {
            // 屏蔽 iCloud 照片流
        }else {
            [self.photoAssetCollections zz_arrayAddObject:collection];
        }
    }
    
    // 自定义相册
    PHFetchResult<PHAssetCollection *> *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        [self.photoAssetCollections zz_arrayAddObject:collection];
    }
    
    // 个人收藏
    customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    for (PHAssetCollection *collection in customCollections) {
        [self.photoAssetCollections zz_arrayAddObject:collection];
    }
    
    // 去除相册集数量为0的对象
    for (int index = (int)self.photoAssetCollections.count - 1; index >= 0; index--) {
        PHAssetCollection *assetCollection = [self.photoAssetCollections objectAtIndex:index];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        // 过滤小照片
        int removedCnt = 0;
        for (PHAsset *asset in assets) {
            if (asset.pixelWidth < self.filterMinPhotoPixelSize.width || asset.pixelHeight < self.filterMinPhotoPixelSize.height) {
                removedCnt++;
            }
        }
        if (assets == nil || assets.count == 0 || assets.count == removedCnt) {
            [self.photoAssetCollections removeObjectAtIndex:index];
        }
    }
    
    // 默认选择 系统相册
    self.currentPhotoAssetColletion = self.photoAssetCollections.firstObject;
    
    [self.customTitleView updateAlbumTitle:self.currentPhotoAssetColletion.localizedTitle];
    [self _render];
}

- (void)_render {
    
    ZZ_WEAK_SELF
    [self.collectionView zz_removeAllDataSource];
    ZZCollectionSectionObject *sectionObject = [[ZZCollectionSectionObject alloc] init];
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    sectionObject.zzMinimumLineSpacing = 5.0;
    sectionObject.zzMinimumInteritemSpacing = 5.0;
    sectionObject.zzColumns = self.photoListColumn;
    [self.collectionView zz_addDataSource:sectionObject];
    if (self.currentPhotoAssetColletion == nil) {
        self.customTitleView.hidden = YES;
        [self.view bringSubviewToFront:self.noAlbumView];
    }else {
        self.customTitleView.hidden = NO;
        _noAlbumView.hidden = YES;
        // 相机Placeholder
        if (self.takeButtonPosition == FJTakePhotoButtonPositionCell) {
            FJPhotoCollectionViewCellDataSource *placeholer = [[FJPhotoCollectionViewCellDataSource alloc] init];
            placeholer.isCameraPlaceholer = YES;
            [sectionObject.zzCellDataSource zz_arrayAddObject:placeholer];
        }
        
        // 当前选中相册的照片流
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        // 排序（最新排的在前面）
        switch (self.sortType) {
            case FJPhotoSortTypeModificationDateDesc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
                break;
            }
            case FJPhotoSortTypeModificationDateAsc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
                break;
            }
            case FJPhotoSortTypeCreationDateDesc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                break;
            }
            case FJPhotoSortTypeCreationDateAsc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                break;
            }
            default:
                break;
        }
        
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        if (@available(iOS 9.0, *)) {
            option.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
        } else {
        }
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:self.currentPhotoAssetColletion options:option];
        
        // 判断firstPhotoAutoSelected
        // 相片数据
        int i = 0;
        if (self.firstPhotoAutoSelected) {
            i = 1;
            self.firstPhotoAutoSelected = NO;
            PHAsset *firstAsset = [assets firstObject];
            __block FJPhotoCollectionViewCellDataSource *ds = [[FJPhotoCollectionViewCellDataSource alloc] init];
            ds.isMultiSelection = YES;
            if (self.selectedPhotos.count == self.maxSelectionCount) {
                if (self.userOverLimitationBlock != nil) {
                    self.userOverLimitationBlock();
                }else {
                    [self.view zz_toast:[NSString stringWithFormat:@"最多可以选择 %lu 张图片", (unsigned long)self.maxSelectionCount] toastType:ZZToastTypeWarning];
                }
                ds.isSelected = NO;
            }else {
                ds.isSelected = YES;
            }
            ds.photoAsset = firstAsset;
            ds.photoListColumn = self.photoListColumn;
            [sectionObject.zzCellDataSource zz_arrayAddObject:ds];
            
            // 选择
            FJPhotoModel *model = [self _addTemporary:ds.photoAsset];
            if (ds.isSelected) {
                [[FJPhotoManager shared] addDistinct:model];
                [self.selectedPhotos zz_arrayAddObject:model];
            }
            
            if (self.cropperViewVisible) {
                // 更新CropperView
                if (ds.isSelected) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        model.needCrop = YES;
                        [weakSelf.cropperView updateModel:model];
                    });
                }
            }else {
                
            }
            
        }
        for (; i < assets.count; i++) {
            PHAsset *asset = [assets objectAtIndex:i];
            // 过滤小照片
            if (asset.pixelWidth < self.filterMinPhotoPixelSize.width && asset.pixelHeight < self.filterMinPhotoPixelSize.height) {
                continue;
            }
            BOOL isSelected = NO;
            for (FJPhotoModel *selectedPhoto in self.selectedPhotos) {
                if ([selectedPhoto.asset isEqual:asset]) {
                    isSelected = YES;
                    break;
                }
            }
            FJPhotoCollectionViewCellDataSource *ds = [[FJPhotoCollectionViewCellDataSource alloc] init];
            ds.isMultiSelection = YES;
            ds.isSelected = isSelected;
            ds.photoAsset = asset;
            ds.photoListColumn = self.photoListColumn;
            [sectionObject.zzCellDataSource zz_arrayAddObject:ds];
        }
    }
    
    // CollectionView 刷新
    [self.collectionView zz_refresh];
    
    // 检查下一步的有效性
    [self _checkNextState];
}

// 选择或者选择预览图片
- (FJPhotoModel *)_addTemporary:(PHAsset *)asset {
    
    for (FJPhotoModel *model in self.temporaryPhotoModels) {
        if ([model.asset isEqual:asset]) {
            // 已经生产过预览图
            return model;
        }
    }
    // 该照片未添加过
    FJPhotoModel *model = [[FJPhotoModel alloc] initWithAsset:asset];
    model.uuid = self.uuid;
    if (self.cropperViewVisible == NO) {
        model.originalImage = [asset getGeneralTargetImage];
        CGFloat imageW = model.originalImage.size.width;
        CGFloat imageH = model.originalImage.size.height;
        if (imageW > imageH ) {
            // 扁图
            if (imageH / imageW < self.horizontalExtemeRatio) {
                // 超出极限
                CGFloat w = imageH / self.horizontalExtemeRatio;
                model.beginCropPoint = CGPointMake((imageW - w) / (2.0 * imageW), 0);
                model.endCropPoint = CGPointMake((imageW - (imageW - w) / 2.0) / imageW , 1.0);
                model.croppedImage = [model.originalImage zz_imageCropBeginPointRatio:model.beginCropPoint endPointRatio:model.endCropPoint];
            }
        }else {
            // 长图
            if (imageW / imageH < self.verticalExtemeRatio) {
                // 超出极限
                CGFloat h = imageW / self.verticalExtemeRatio;
                model.beginCropPoint = CGPointMake(0, (imageH - h) / (2.0 * imageH));
                model.endCropPoint = CGPointMake(1.0, (imageH - (imageH - h) / 2.0) / imageH);
                model.croppedImage = [model.originalImage zz_imageCropBeginPointRatio:model.beginCropPoint endPointRatio:model.endCropPoint];
            }
        }
    }
    [self.temporaryPhotoModels zz_arrayAddObject:model];
    return model;
}

#pragma mark - UIImagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = info[UIImagePickerControllerOriginalImage];
            if (image == nil) {
                return;
            }
        }
        void *contextInfo = NULL;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), contextInfo);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        [self.view zz_toast:[error description] toastType:ZZToastTypeError];
        return;
    }
    self.firstPhotoAutoSelected = YES;
    [self.imagePickerController zz_dismiss];
    [self _reloadPhotoAssetCollections];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.imagePickerController zz_dismiss];
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
