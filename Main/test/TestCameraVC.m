//
//  TestCameraVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/11/7.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCameraVC.h"
#import "NSString+ZZKit.h"
#import "ZZPhotoLibraryViewController.h"
#import "ZZAVCaptureViewController.h"
#import "ZZTakePhotoView.h"
#import "UIImage+ZZKit.h"

@interface TestCameraVC ()

@end

@implementation TestCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tapPhotoLibrary:(id)sender {
    
    [ZZPhotoManager presentPhotoLibraryController:self configureBlock:^(ZZPhotoLibraryConfig * _Nullable config) {
        
        config.mode = ZZPhotoEditModeFilter | ZZPhotoEditModeTag | ZZPhotoEditModeCropprer | ZZPhotoEditModeTuning;
        
        config.cameraButtonType = ZZPhotoLibraryCameraButtonTypeNone;
        
        config.showDraft = YES;
        
        config.sortType = ZZPhotoLibrarySortTypeModificationDateDesc;
        
        config.maxSelectionCount = 2;
        
        config.cropperType = ZZPhotoLibraryCropperTypeShow;
        
        config.userEditSelectTagBlock = ^ZZPhotoSelectTagBaseViewController * _Nonnull(ZZPhotoEditViewController * _Nonnull controller) {
            
            return nil;
        };
        
        config.userPhotoEditNextBlock = ^(UINavigationController * _Nonnull navigationController, NSArray<ZZPhotoAsset *> * _Nonnull photoQueue) {
            NSLog(@"%@", photoQueue);
            
            NSArray *arr = photoQueue.zz_images;
            UIImage *image = [arr objectAtIndex:0];
            
            [image zz_debugShow:CGRectMake(10, 10, 200, 200)];
        };
    }];
}

- (IBAction)tapAVCapture:(id)sender {
    
    ZZAVInputSettingConfig *inputConfig = [[ZZAVInputSettingConfig alloc] init];
    ZZAVCaptureViewController *avCaptureVC = [[ZZAVCaptureViewController alloc] initWithAVInputSettingConfig:inputConfig outputExtension:ZZAVFileTypeMP4];
    ZZCaptureConfig *config = [[ZZCaptureConfig alloc] init];
    config.enableSwitch = YES;
    config.enableLightSupplement = YES;
    config.enableFlashLight = YES;
    config.enableAutoFocusAndExposure = YES;
    config.widgetUsingImageTopView = YES;
    config.widgetUsingImageBottomView = YES;
    config.enablePreviewAll = YES;
    config.enableConfirmPreview = NO;
    config.captureType = ZZCaptureTypeAll;
    avCaptureVC.config = config;
    avCaptureVC.mediasTakenBlock = ^(NSArray *medias) {
        NSLog(@"mediasTakenBlock callback");
        NSLog(@"%@", medias);
    };
    [self.navigationController pushViewController:avCaptureVC animated:YES];
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
