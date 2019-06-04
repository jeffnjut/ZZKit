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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
