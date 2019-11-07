//
//  TestCameraVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/11/7.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCameraVC.h"
#import "NSString+ZZKit.h"
#import "FJPhotoLibraryViewController.h"
#import "FJPhotoLibraryCropperViewController.h"
#import "FJAVCaptureViewController.h"
#import "FJTakePhotoView.h"

@interface TestCameraVC ()

@end

@implementation TestCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tapPhotoLibrary:(id)sender {
    
    FJPhotoLibraryViewController *photoLibVC = [[FJPhotoLibraryViewController alloc] initWithMode:FJPhotoEditModeAll editController:^__kindof FJPhotoUserTagBaseViewController *(FJPhotoEditViewController *controller) {
        return nil;
    }];
    [self.navigationController pushViewController:photoLibVC animated:YES];
}

- (IBAction)tapINSPhotoLibrary:(id)sender {
    
    FJPhotoLibraryCropperViewController *photoLibVC = [[FJPhotoLibraryCropperViewController alloc] initWithMode:FJPhotoEditModeFilter | FJPhotoEditModeTag editController:^__kindof FJPhotoUserTagBaseViewController *(FJPhotoEditViewController *controller) {
        return nil;
    }];
    photoLibVC.maxSelectionCount = 3;
    photoLibVC.photoListColumn = 5;
    photoLibVC.takeButtonPosition = FJTakePhotoButtonPositionBottomWithDraft;
    [self.navigationController pushViewController:photoLibVC animated:YES];
}

- (IBAction)tapAVCapture:(id)sender {
    
    FJAVInputSettingConfig *inputConfig = [[FJAVInputSettingConfig alloc] init];
    FJAVCaptureViewController *avCaptureVC = [[FJAVCaptureViewController alloc] initWithAVInputSettingConfig:inputConfig outputExtension:FJAVFileTypeMP4];
    FJCaptureConfig *config = [[FJCaptureConfig alloc] init];
    config.enableSwitch = YES;
    config.enableLightSupplement = YES;
    config.enableFlashLight = YES;
    config.enableAutoFocusAndExposure = YES;
    config.widgetUsingImageTopView = YES;
    config.widgetUsingImageBottomView = YES;
    config.enablePreviewAll = YES;
    config.enableConfirmPreview = NO;
    config.captureType = FJCaptureTypeAll;
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
