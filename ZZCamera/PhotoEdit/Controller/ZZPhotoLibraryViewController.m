//
//  ZZPhotoLibraryViewController.m
//  ZZKit
//
//  Created by Fu Jie on 2020/1/20.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "ZZPhotoLibraryViewController.h"
#import "PHAsset+Utility.h"
#import "PHAsset+QuickEdit.h"
#import "ZZPhotoLibrarySelectionView.h"
#import "ZZPhotoLibraryAlbumSelectionView.h"
#import "ZZPhotoCollectionViewCell.h"
#import "ZZPhotoCropperView.h"
#import "ZZTakePhotoButton.h"
#import "ZZPhotoDraftHistoryViewController.h"
#import "ZZPhotoLibraryNoAlbumView.h"
#import "NSString+ZZKit.h"
#import "UIImage+ZZKit.h"
#import "UIViewController+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "UIView+ZZKit_HUD.h"
#import "ZZDevice.h"

#define PREVIEW_IMAGE_LEAST_HEIGHT (48.0)
#define UPDOWN_LEAST_HEIGHT (48.0)

@interface ZZPhotoLibraryViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// -------- UI --------

// CropperView
@property (nonatomic, strong) ZZPhotoCropperView *cropperView;

// CollectionView
@property (nonatomic, strong) ZZCollectionView *collectionView;

// Navigation TitleView
@property (nonatomic, strong) ZZPhotoLibrarySelectionView *customTitleView;

// Image Picker Controller
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

// Next Button
@property (nonatomic, strong) UIButton *nextBtn;

// 选择相册组件
@property (nonatomic, strong) ZZPhotoLibraryAlbumSelectionView *albumSelectionView;

// 拍摄照片Button
@property (nonatomic, strong) ZZTakePhotoButton *takePhotoButton;

// 没有相片的提示图片和文案控件
@property (nonatomic, strong) ZZPhotoLibraryNoAlbumView *noAlbumView;

// -------- Data --------

// 所有相册
@property (nonatomic, strong) NSMutableArray<PHAssetCollection *> *photoAssetCollections;

// 当前相册
@property (nonatomic, strong) PHAssetCollection *currentPhotoAssetColletion;

// 拍照后刷新并自动选中
@property (nonatomic, assign) BOOL pictureTakenAndTicked;

// Temporary photo model array
@property (nonatomic, strong) NSMutableArray<ZZPhotoAsset *> *temporaryPhotoModels;

// SessionId 每次新打开相册随机生成
@property (nonatomic, copy) NSString *sessionId;

@end

@implementation ZZPhotoLibraryViewController

#pragma mark - Properties

- (UIImagePickerController *)imagePickerController {
    
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return _imagePickerController;
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

- (ZZPhotoLibraryNoAlbumView *)noAlbumView {
    
    if (_noAlbumView == nil) {
        _noAlbumView = [ZZPhotoLibraryNoAlbumView create];
        [self.view addSubview:_noAlbumView];
        __weak typeof(self) weakSelf = self;
        [_noAlbumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.takePhotoButton.mas_top);
        }];
    }
    return _noAlbumView;
}

- (NSMutableArray<PHAssetCollection *> *)photoAssetCollections {
    
    if (_photoAssetCollections == nil) {
        _photoAssetCollections = (NSMutableArray<PHAssetCollection *> *)[[NSMutableArray alloc] init];
    }
    return _photoAssetCollections;
}

- (NSMutableArray<ZZPhotoAsset *> *)temporaryPhotoModels {
    
    if (_temporaryPhotoModels == nil) {
        _temporaryPhotoModels = (NSMutableArray<ZZPhotoAsset *> *)[[NSMutableArray alloc] init];
    }
    return _temporaryPhotoModels;
}

#pragma mark - Life Cycle

- (void)dealloc {
    NSLog(@"Dealloc - ZZPhotoLibraryViewController");
}

- (instancetype)init {
    
    NSAssert(NO, @"请使用initWithSessionId:初始化");
    return nil;
}

- (instancetype)initWithSessionId:(nonnull NSString *)sessionId {
    
    self = [super init];
    if (self) {
        self.sessionId = sessionId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 更新草稿箱状态
    if (ZZPhotoManager.shared.config.cameraButtonType == ZZPhotoLibraryCameraButtonTypeBottom && ZZPhotoManager.shared.config.showDraft == YES) {
        if (![ZZPhotoManager.shared isDraftExist:self.uid]) {
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
    [self zz_navigationAddLeftBarButton:@"ZZPhotoLibraryViewController.ic_back".zz_image action:^{
        [weakSelf zz_dismiss];
    }];
    
    [self _buildUI];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

// 创建UI 判断权限等
- (void)_buildUI {
    
    ZZ_WEAK_SELF
    
    // 获取权限
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    if (oldStatus == PHAuthorizationStatusDenied || oldStatus == PHAuthorizationStatusRestricted) {
        if (ZZPhotoManager.shared.config.userNoPhotoLibraryPermissionBlock != nil) {
            ZZPhotoManager.shared.config.userNoPhotoLibraryPermissionBlock();
        }else {
            ZZAlertModel *alert = [ZZAlertModel zz_alertModel:@"开启" action:^{
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success){}];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            ZZAlertModel *cancel = [ZZAlertModel zz_alertModel:@"取消" action:^{
                [weakSelf zz_dismiss];
            }];
            [self zz_alertView:@"" message:@"需要在「设置」中开启相册权限后，才能浏览相册哦" cancel:NO item:alert, cancel, nil];
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
                [weakSelf _buildPhotoAssetCollections];
                [weakSelf _render:YES];
                ZZPhotoCollectionViewCellDataSource *ds = nil;
                ZZCollectionSectionObject *sectionObject = [weakSelf.collectionView.zzDataSource zz_arrayObjectAtIndex:0];
                NSInteger item = 0;
                if (ZZPhotoManager.shared.config.cameraButtonType == ZZPhotoLibraryCameraButtonTypeCell) {
                    item = 1;
                    ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:item];
                }else {
                    item = 0;
                    ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:item];
                }
                if (ds != nil) {
                    [weakSelf _previewOrTick:&ds section:0 item:item enableTick:NO];
                }
            }
        });
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZPhotoManager.shared.config.userInitBlock == nil ? : ZZPhotoManager.shared.config.userInitBlock();
    });
}

// 创建相册UI
- (void)_buildPhotoAssetCollections {
    
    ZZ_WEAK_SELF
    [self zz_navigationAddRightBarCustomView:self.nextBtn action:nil];
    
    if (_customTitleView == nil) {
        self.customTitleView = [ZZPhotoLibrarySelectionView create:@"手机相册"];
        self.navigationItem.titleView = self.customTitleView;
        [self.customTitleView setExtendBlock:^{
            [weakSelf _setAblumSelectionViewHidden:NO animation:YES];
        }];
        [self.customTitleView setCollapseBlock:^{
            [weakSelf _setAblumSelectionViewHidden:YES animation:YES];
        }];
    }
    
    if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeShow) {
        if (_cropperView == nil) {
            _cropperView = [ZZPhotoCropperView create:NO showGrid:YES cropperHorizontalExtemeRatio:ZZPhotoManager.shared.config.cropperHorizontalExtemeRatio cropperVerticalExtemeRatio:ZZPhotoManager.shared.config.cropperVerticalExtemeRatio croppedBlock:^(ZZPhotoAsset *photoModel, CGRect frame) {
                
            } updownBlock:^(BOOL up) {
                [weakSelf _cropperMove:up];
            }];
            _cropperView.frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenWidth);
            [self.view addSubview:_cropperView];
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_cropperPanAction:)];
            [_cropperView addGestureRecognizer:panGesture];
        }
    }
    
    if (_collectionView == nil) {
        
        CGRect frame = CGRectZero;
        if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeShow) {
            frame = CGRectMake(0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZDevice.zz_screenWidth - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT);
        }else {
            frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - ZZ_DEVICE_NAVIGATION_TOP_HEIGHT);
        }
        
        _collectionView = [ZZCollectionView zz_quickAdd:[UIColor whiteColor] onView:self.view frame:frame registerCellsBlock:^NSArray * _Nonnull{
            
            return @[[ZZPhotoCollectionViewCell class]];
        } constraintBlock:nil actionBlock:^(ZZCollectionView *__weak  _Nonnull collectionView, NSInteger section, NSInteger row, ZZCollectionViewCellAction action, __kindof ZZCollectionViewCellDataSource * _Nullable cellData, __kindof ZZCollectionViewCell * _Nullable cell) {
            
            if ([cellData isKindOfClass:[ZZPhotoCollectionViewCellDataSource class]]) {
                ZZPhotoCollectionViewCellDataSource *ds = (ZZPhotoCollectionViewCellDataSource *)cellData;
                if (ds.isCameraPlaceholer) {
                    // 打开相机
                    [weakSelf _openCamera];
                }else {
                    if (action == ZZCollectionViewCellActionCustomTapped) {
                        
                        // 选中
                        [weakSelf _previewOrTick:&ds section:section item:row enableTick:YES];
                    }else if (action == ZZCollectionViewCellActionTapped) {
                        
                        if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeShow) {
                            // 裁切模式
                            [weakSelf _previewOrTick:&ds section:section item:row enableTick:NO];
                        }else {
                            // 非裁切模式
                            [weakSelf _previewOrTick:&ds section:section item:row enableTick:YES];
                        }
                    }
                }
            }
        }];
        
        if (ZZPhotoManager.shared.config.cameraButtonType == ZZPhotoLibraryCameraButtonTypeBottom) {
            _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 48.0, 0);
        }
    }
    
    if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeShow) {
        
        self.collectionView.zzScrollBlock = ^(ZZCollectionView *__weak  _Nonnull collectionView, ZZCollectionViewScrollAction action, CGPoint velocity, CGPoint targetContentOffset, BOOL decelerate) {
            // TODO 图片预览隐藏和展开
        };
    }
    
    // Take Photo Button
    if (ZZPhotoManager.shared.config.cameraButtonType == ZZPhotoLibraryCameraButtonTypeBottom) {
        if (_takePhotoButton == nil) {
            BOOL enableDraft = ZZPhotoManager.shared.config.cameraButtonType == ZZPhotoLibraryCameraButtonTypeBottom && ZZPhotoManager.shared.config.showDraft == YES && [ZZPhotoManager.shared isDraftExist:self.uid];
            _takePhotoButton = [ZZTakePhotoButton createOn:self.view withDraft:enableDraft draftBlock:^{
                [weakSelf _openDraft];
            } takePhotoBlock:^{
                // 打开相机
                [weakSelf _openCamera];
            }];
        }
    }
}

// 渲染
- (void)_render:(BOOL)reloadPhotoAssetCollections {
    
    if (reloadPhotoAssetCollections) {
        
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
                if (asset.pixelWidth < ZZPhotoManager.shared.config.filterMinPhotoPixelSize.width || asset.pixelHeight < ZZPhotoManager.shared.config.filterMinPhotoPixelSize.height) {
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
    }
    
    ZZ_WEAK_SELF
    [self.collectionView zz_removeAllDataSource];
    ZZCollectionSectionObject *sectionObject = [[ZZCollectionSectionObject alloc] init];
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    sectionObject.zzMinimumLineSpacing = 5.0;
    sectionObject.zzMinimumInteritemSpacing = 5.0;
    sectionObject.zzColumns = ZZPhotoManager.shared.config.column;
    [self.collectionView zz_addDataSource:sectionObject];
    if (self.currentPhotoAssetColletion == nil) {
        self.customTitleView.hidden = YES;
        [self.view bringSubviewToFront:self.noAlbumView];
    }else {
        self.customTitleView.hidden = NO;
        _noAlbumView.hidden = YES;
        // 相机Placeholder
        if (ZZPhotoManager.shared.config.cameraButtonType == ZZPhotoLibraryCameraButtonTypeCell) {
            ZZPhotoCollectionViewCellDataSource *placeholer = [[ZZPhotoCollectionViewCellDataSource alloc] init];
            placeholer.isCameraPlaceholer = YES;
            [sectionObject.zzCellDataSource zz_arrayAddObject:placeholer];
        }
        
        // 当前选中相册的照片流
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        // 排序（最新排的在前面）
        switch (ZZPhotoManager.shared.config.sortType) {
            case ZZPhotoLibrarySortTypeModificationDateDesc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
                break;
            }
            case ZZPhotoLibrarySortTypeModificationDateAsc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
                break;
            }
            case ZZPhotoLibrarySortTypeCreationDateDesc:
            {
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                break;
            }
            case ZZPhotoLibrarySortTypeCreationDateAsc:
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
        
        // 判断pictureTakenAndTicked
        // 相片数据
        int i = 0;
        if (self.pictureTakenAndTicked) {
            i = 1;
            self.pictureTakenAndTicked = NO;
            PHAsset *firstAsset = [assets firstObject];
            __block ZZPhotoCollectionViewCellDataSource *ds = [[ZZPhotoCollectionViewCellDataSource alloc] init];
            ds.isMultiSelection = YES;
            if (ZZPhotoManager.shared.photoQueue.count == ZZPhotoManager.shared.config.maxSelectionCount) {
                if (ZZPhotoManager.shared.config.userOverLimitationBlock != nil) {
                    ZZPhotoManager.shared.config.userOverLimitationBlock(self);
                }else {
                    [self.view zz_toast:[NSString stringWithFormat:@"最多可以选择 %lu 张图片", (unsigned long)ZZPhotoManager.shared.config.maxSelectionCount] toastType:ZZToastTypeWarning];
                }
                ds.isTicked = NO;
            }else {
                ds.isTicked = YES;
            }
            ds.photoAsset = firstAsset;
            ds.column = ZZPhotoManager.shared.config.column;
            [sectionObject.zzCellDataSource zz_arrayAddObject:ds];
            
            // 选择
            ZZPhotoAsset *model = [self _getPhotoAssetFromTemporary:ds.photoAsset];
            if (ds.isTicked) {
                [ZZPhotoManager.shared addPhotoDistinct:model];
            }
            
            if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeShow) {
                // 更新CropperView
                if (ds.isTicked) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        model.needCrop = YES;
                        [weakSelf.cropperView updateModel:model];
                    });
                }
            }
        }
        for (; i < assets.count; i++) {
            PHAsset *asset = [assets objectAtIndex:i];
            // 过滤小照片
            if (asset.pixelWidth < ZZPhotoManager.shared.config.filterMinPhotoPixelSize.width && asset.pixelHeight < ZZPhotoManager.shared.config.filterMinPhotoPixelSize.height) {
                continue;
            }
            BOOL isTicked = NO;
            for (ZZPhotoAsset *selectedPhoto in ZZPhotoManager.shared.photoQueue) {
                if ([selectedPhoto.asset isEqual:asset]) {
                    isTicked = YES;
                    break;
                }
            }
            ZZPhotoCollectionViewCellDataSource *ds = [[ZZPhotoCollectionViewCellDataSource alloc] init];
            ds.isMultiSelection = YES;
            ds.isTicked = isTicked;
            ds.photoAsset = asset;
            ds.column = ZZPhotoManager.shared.config.column;
            [sectionObject.zzCellDataSource zz_arrayAddObject:ds];
        }
    }
    
    // CollectionView 刷新
    [self.collectionView zz_refresh];
    
    // 检查下一步的有效性
    [self _checkNextState];
}

// 预览或者勾选照片（NO:勾选不成功，比如iCloud下载中，YES:勾选成功）
- (BOOL)_previewOrTick:(ZZPhotoCollectionViewCellDataSource **)cellData section:(NSInteger)section item:(NSInteger)item enableTick:(BOOL)enableTick {
    
    ZZPhotoCollectionViewCellDataSource *ds = *cellData;
    if (ds.isTicked) {
        if (enableTick) {
            /// - Tick
            if ([self _tick:cellData section:section item:item tick:NO] == NO) {
                return NO;
            }
        }
    }else if (ds.isHighlighted) {
        if (enableTick) {
            /// + Tick
            if ([self _tick:cellData section:section item:item tick:YES] == NO) {
                return NO;
            }
        }
    }else {
        
        // 判断是否是iCloud照片
        UIImage *image = [ds.photoAsset getGeneralTargetImage];
        if (image == nil) {
            [self.view zz_toast:@"iCloud照片正在下载中"];
            return NO;
        }
        
        if (enableTick) {
            /// + Tick
            if ([self _tick:cellData section:section item:item tick:YES] == NO) {
                return NO;
            }
        }
        
        /// + Highlighted
        ZZCollectionSectionObject *sectionObject = [self.collectionView.zzDataSource zz_arrayObjectAtIndex:0];
        for (ZZPhotoCollectionViewCellDataSource *data in sectionObject.zzCellDataSource) {
            if ([data isEqual:ds]) {
                data.isHighlighted = YES;
            }else {
                data.isHighlighted = NO;
            }
        }
        ZZPhotoCollectionViewCell *cell = (ZZPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
        for (ZZPhotoCollectionViewCell *_cell in [self.collectionView visibleCells]) {
            if ([_cell isEqual:cell]) {
                [_cell updateHighlighted:YES];
            }else {
                [_cell updateHighlighted:NO];
            }
        }
        
        /// 更新CropperView
        if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeShow) {
            /// 更新CropperView
            ZZPhotoAsset *model = [self _getPhotoAssetFromTemporary:ds.photoAsset];
            model.needCrop = YES;
            [self.cropperView updateModel:model];
        }
    }
    [self.collectionView zz_refresh];
    [self _checkNextState];
    return YES;
}

// 勾选照片（NO:勾选不成功，比如iCloud下载中，YES:勾选成功）
- (BOOL)_tick:(ZZPhotoCollectionViewCellDataSource **)cellData section:(NSInteger)section item:(NSInteger)item tick:(BOOL)tick {
    
    ZZPhotoCollectionViewCellDataSource *ds = *cellData;
    
    // 判断是否是iCloud照片
    UIImage *image = [ds.photoAsset getGeneralTargetImage];
    if (image == nil) {
        [self.view zz_toast:@"iCloud照片正在下载中"];
        return NO;
    }
    
    if (tick) {
        // 判断是否超出最大选择数量
        if (ZZPhotoManager.shared.photoQueue.count == ZZPhotoManager.shared.config.maxSelectionCount) {
            if (ZZPhotoManager.shared.config.userOverLimitationBlock != nil) {
                ZZPhotoManager.shared.config.userOverLimitationBlock(self);
            }else {
                [self.view zz_toast:[NSString stringWithFormat:@"最多可以选择 %lu 张图片", (unsigned long)ZZPhotoManager.shared.config.maxSelectionCount] toastType:ZZToastTypeWarning];
            }
            return NO;
        }
        
        // 选中图片
        ds.isTicked = YES;
        ZZPhotoAsset *model = [self _getPhotoAssetFromTemporary:ds.photoAsset];
        // 添加数据
        [ZZPhotoManager.shared addPhotoDistinct:model];
    }else {
        ds.isTicked = NO;
        [ZZPhotoManager.shared removePhoto:ds.photoAsset];
        for (int i = (int)ZZPhotoManager.shared.photoQueue.count - 1; i >= 0; i--) {
            ZZPhotoAsset *photoModel = [ZZPhotoManager.shared.photoQueue objectAtIndex:i];
            if ([photoModel.asset isEqual:ds.photoAsset]) {
                [ZZPhotoManager.shared.photoQueue removeObjectAtIndex:i];
                break;
            }
        }
    }
    return YES;
}

// 获取Temporary图片列表中的PhotoAsset
- (ZZPhotoAsset *)_getPhotoAssetFromTemporary:(PHAsset *)asset {
    
    for (ZZPhotoAsset *model in self.temporaryPhotoModels) {
        if ([model.asset isEqual:asset]) {
            // 已经生产过预览图
            return model;
        }
    }
    // 该照片未添加过
    ZZPhotoAsset *model = [[ZZPhotoAsset alloc] initWithAsset:asset];
    model.sessionId = self.sessionId;
    if (ZZPhotoManager.shared.config.cropperType == ZZPhotoLibraryCropperTypeHiddenLimited) {
        model.originalImage = [asset getGeneralTargetImage];
        CGFloat imageW = model.originalImage.size.width;
        CGFloat imageH = model.originalImage.size.height;
        if (imageW > imageH ) {
            // 扁图
            if (imageH / imageW < ZZPhotoManager.shared.config.cropperHorizontalExtemeRatio) {
                // 超出极限
                CGFloat w = imageH / ZZPhotoManager.shared.config.cropperHorizontalExtemeRatio;
                model.beginCropPoint = CGPointMake((imageW - w) / (2.0 * imageW), 0);
                model.endCropPoint = CGPointMake((imageW - (imageW - w) / 2.0) / imageW , 1.0);
                model.croppedImage = [model.originalImage zz_imageCropBeginPointRatio:model.beginCropPoint endPointRatio:model.endCropPoint];
            }
        }else {
            // 长图
            if (imageW / imageH < ZZPhotoManager.shared.config.cropperVerticalExtemeRatio) {
                // 超出极限
                CGFloat h = imageW / ZZPhotoManager.shared.config.cropperVerticalExtemeRatio;
                model.beginCropPoint = CGPointMake(0, (imageH - h) / (2.0 * imageH));
                model.endCropPoint = CGPointMake(1.0, (imageH - (imageH - h) / 2.0) / imageH);
                model.croppedImage = [model.originalImage zz_imageCropBeginPointRatio:model.beginCropPoint endPointRatio:model.endCropPoint];
            }
        }
    }
    [self.temporaryPhotoModels zz_arrayAddObject:model];
    return model;
}

// 拖动CropperView的手势，当cropperEnabled == YES时有效
- (void)_cropperPanAction:(UIPanGestureRecognizer *)panGesture {
    
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
                    [self _cropperMove:NO];
                }else {
                    [self _cropperMove:YES];
                }
            }else {
                if (self.cropperView.frame.origin.y < - UPDOWN_LEAST_HEIGHT ) {
                    [self _cropperMove:YES];
                }else {
                    [self _cropperMove:NO];
                }
            }
            
            break;
        }
        default:
            break;
    }
}

// 向上向下位移CropperView的方法，当cropperEnabled == YES时有效
- (void)_cropperMove:(BOOL)up {
    
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

// 点击选择切换相册的控件
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
        [btn addTarget:self action:@selector(_tapAlbumSelectionBlurView) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint point = CGPointZero;
        _albumSelectionView = [ZZPhotoLibraryAlbumSelectionView create:point maxColumn:5 photoAssetCollections:self.photoAssetCollections selectedPhotoAssetCollection:self.currentPhotoAssetColletion assetCollectionChangedBlock:^(PHAssetCollection *currentCollection) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf _setAblumSelectionViewHidden:YES animation:YES];
                [weakSelf.customTitleView collapse];
                if ([weakSelf.currentPhotoAssetColletion isEqual:currentCollection]) {
                    return;
                }
                weakSelf.currentPhotoAssetColletion = currentCollection;
                [weakSelf.customTitleView updateAlbumTitle:currentCollection.localizedTitle];
                [weakSelf _render:NO];
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

// 点击相册选择有色透明背景
- (void)_tapAlbumSelectionBlurView {
    
    [self _setAblumSelectionViewHidden:YES animation:YES];
    [self.customTitleView collapse];
}

// 点击下一步
- (void)_tapNext:(UIButton *)sender {
    
    if (ZZPhotoManager.shared.config.userPhotoLibraryNextBlock != nil) {
        ZZPhotoManager.shared.config.userPhotoLibraryNextBlock(self.navigationController, ZZPhotoManager.shared.photoQueue);
    }else {
        // 推出 ZZPhotoEditViewController
        ZZPhotoEditViewController *editVC = [[ZZPhotoEditViewController alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

// 打开相机
- (void)_openCamera {
    
    ZZ_WEAK_SELF
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        if (ZZPhotoManager.shared.config.userNoCameraPermissionBlock != nil) {
            ZZPhotoManager.shared.config.userNoCameraPermissionBlock();
        }else {
            ZZAlertModel *alert = [ZZAlertModel zz_alertModel:@"开启" action:^{
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success){}];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            ZZAlertModel *cancel = [ZZAlertModel zz_alertModel:@"取消" action:^{
                [weakSelf zz_dismiss];
            }];
            [self zz_alertView:@"" message:@"需要在「设置」中开启相机权限后，才能拍照哦" cancel:NO item:alert, cancel, nil];
        }
        return;
    }
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

// 打开草稿箱
- (void)_openDraft {
    
    ZZPhotoDraftHistoryViewController *draftVC = [[ZZPhotoDraftHistoryViewController alloc] init];
    draftVC.uid = self.uid;
    draftVC.userSelectDraftBlock = ZZPhotoManager.shared.config.userSelectDraftBlock;
    [self.navigationController pushViewController:draftVC animated:YES];
}

// 检查Next Button的可点击状态
- (void)_checkNextState {
    
    if (ZZPhotoManager.shared.photoQueue.count > 0) {
        [self.nextBtn setTitleColor:@"#FF7725".zz_color forState:UIControlStateNormal];
    }else {
        [self.nextBtn setTitleColor:@"#78787D".zz_color forState:UIControlStateNormal];
    }
}

#pragma mark - UIImagePickerViewController Delegate - 拍摄照片

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
    self.pictureTakenAndTicked = YES;
    [self.imagePickerController zz_dismiss];
    [self _render:YES];
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
