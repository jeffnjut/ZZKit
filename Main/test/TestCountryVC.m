//
//  TestCountryVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCountryVC.h"
#import "UIViewController+ZZKit.h"
#import "ZZCNRegionController.h"
#import "ZZCityController.h"
#import "ZZCountryController.h"
#import "ZZLBSNavigation.h"

@interface TestCountryVC ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation TestCountryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)_tapCNRegion:(id)sender {
    
    ZZCNRegionController *vc = [[ZZCNRegionController alloc] init];
    [self zz_push:vc animated:NO];
}

- (IBAction)_tapCountry:(id)sender {
    
    ZZCountryController *vc = [[ZZCountryController alloc] init];
    [self zz_push:vc animated:NO];
}

- (IBAction)_tapCity:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    ZZCityController *vc = [[ZZCityController alloc] init];
    vc.zzSelectCityBlock = ^(NSString * _Nonnull cityName) {
        weakSelf.textView.text = cityName;
    };
    [self zz_push:vc animated:NO];
}

- (IBAction)_tapNavigation:(id)sender {
    
    [ZZLBSNavigation zz_startNavigaion:CLLocationCoordinate2DMake(31.2903182415, 121.1571911025) coordinateSystem:ZZLocationCoordinateSystemWGS84 destinationName:@"你爷爷" yourAppScheme:@"zzkit://" controller:self maps:nil block:nil];
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
