//
//  TestUIimageVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/4.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestUIimageVC.h"
#import "UIControl+ZZKit_Blocks.h"
#import "UIImage+ZZKit.h"
#import "UIView+ZZKit_Blocks.h"

@interface TestUIimageVC ()


@end

@implementation TestUIimageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)_tapImageCropRect:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"test"];
    image = [image zz_imageCropRect:CGRectMake(image.size.width * 0.3, image.size.height * 0.3, image.size.width * 0.7, image.size.height * 0.7)];
    [image zz_debugShow:CGRectMake(100, 200, 300, 300)];
    [[UIImage imageNamed:@"test"] zz_debugShow:CGRectMake(100, 550, 200, 200)];
}

- (IBAction)_tapImageCropBeginPointRatioEndPointRatio:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"test"];
    image = [image zz_imageCropBeginPointRatio:CGPointMake(0.1, 0.1) endPointRatio:CGPointMake(0.9, 0.9)];
    [image zz_debugShow:CGRectMake(100, 200, 300, 300)];
    [[UIImage imageNamed:@"test"] zz_debugShow:CGRectMake(100, 550, 200, 200)];
}

- (IBAction)_tapImageCaptureView:(id)sender {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 300, 350)];
    view.backgroundColor = [UIColor blueColor];
    [view zz_tapBlock:^(__kindof UIView * _Nonnull sender) {
        [sender removeFromSuperview];
    }];
    
    [self.view addSubview:view];
    
    UILabel *label = [UILabel new];
    // label.textColor = [UIColor blackColor];
    label.text = @"测试是大大三大队2342341好 人群玩二翁绕弯儿无若无若翁热 二维无";
    label.frame = CGRectMake(0, 0, 300, 30);
    [view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    imageView.frame = CGRectMake(10, 30, 280, 300);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    UIImage *image = [UIImage zz_imageCaptureView:view];
    [image zz_debugShow:CGRectMake(100, 650, 200, 200)];
}

- (IBAction)_tapImageCompress:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"test"];
    [image zz_debugShow:CGRectMake(10, 100, 150, 150)];
    
    UIImage *cImage = nil;
    // cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 2, image.size.height * 2) scale:3 cropped:NO];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 1.0, image.size.height * 1.0) scale:3 cropped:NO];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 2, image.size.height * 4) scale:3 cropped:NO];
    [cImage zz_debugShow:CGRectMake(200, 100, 150, 150)];
    
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 2, image.size.height * 2) scale:3 cropped:YES];  // 和NO一样
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 1.0, image.size.height * 1.0) scale:3 cropped:YES];  // 和NO一样
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 0.5, image.size.height * 1.0) scale:3.0 cropped:YES];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 1.0, image.size.height * 2.0) scale:3.0 cropped:YES];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 2.0, image.size.height * 10.0) scale:3.0 cropped:YES];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 1.0, image.size.height * 0.5) scale:3.0 cropped:YES];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 2.0, image.size.height * 1.0) scale:3.0 cropped:YES];
    cImage = [image zz_imageAdjustSize:CGSizeMake(image.size.width * 6.0, image.size.height * 2.0) scale:3.0 cropped:YES];
    cImage = [image zz_imageAdjustScale:12.0];
    [cImage zz_debugShow:CGRectMake(10, 300, 150, 150)];

    CGFloat orgSize = [[image zz_imageData] length];
    CGFloat expanedSize = [[cImage zz_imageData] length];
    // UIImageWriteToSavedPhotosAlbum(cImage, nil, nil, nil);
    
    NSString *base64 = [[UIImage imageNamed:@"testsmall"] zz_image2Base64:YES];
    
    cImage = [image zz_imageTuningScale:3.0 orientation:UIImageOrientationRight];
    [cImage zz_debugShow:CGRectMake(200, 300, 150, 150)];
    
    
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
