//
//  ComplexDemoVC.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/5.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ComplexDemoVC.h"
#import "ZZSegmentView.h"
#import "ChildListVC.h"
#import "ComplexChildListVC.h"

@interface ComplexDemoVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *segmentBgView;
@property (nonatomic, strong) ZZSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ComplexDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _buildUI];
}

- (void)_buildUI {
    
    // 网络
    ChildListVC *vc1 = [[ChildListVC alloc] init];
    ComplexChildListVC *vc2 = [[ComplexChildListVC alloc] init];
    ChildListVC *vc3 = [[ChildListVC alloc] init];
    ChildListVC *vc4 = [[ChildListVC alloc] init];
    ChildListVC *vc5 = [[ChildListVC alloc] init];
    vc1.id = @"1";
    vc2.id = @"2";
    vc2.headViewHeight = ZZ_DEVICE_NAVIGATION_TOP_HEIGHT;
    vc3.id = @"3";
    vc4.id = @"4";
    vc5.id = @"5";
    [self _build:@[@"关注", @"最新", @"热榜", @"专区", @"国内"] vcs:@[vc1, vc2, vc3, vc4, vc5]];
}

- (void)_build:(NSArray *)titles vcs:(NSArray *)vcs {
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZZDevice.zz_screenWidth, ZZ_DEVICE_NAVIGATION_TOP_HEIGHT)];
    self.headView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:self.headView];
    
    self.segmentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.zzHeight, ZZDevice.zz_screenWidth, 56.0)];
    self.segmentBgView.backgroundColor = UIColor.whiteColor;
    self.segmentView = [ZZSegmentView create:CGRectMake(0, 12.0, ZZDevice.zz_screenWidth, 32.0) fixedItems:@(5) fixedItemWidth:nil fixedPadding:nil normalTextFont:nil normalTextColor:nil highlightedTextFont:nil highlightedTextColor:nil indicatorColor:nil titles:titles selectedBlock:^(NSString * _Nonnull selectedTitle) {
    }];
    [self.segmentBgView addSubview:self.segmentView];
    [self.view addSubview:self.segmentBgView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segmentBgView.frame.origin.y + self.segmentBgView.frame.size.height, ZZDevice.zz_screenWidth, ZZDevice.zz_screenHeight - self.segmentBgView.frame.origin.y - self.segmentBgView.frame.size.height - ZZ_DEVICE_TAB_BAR_HEIGHT)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * vcs.count, self.scrollView.frame.size.height);
    for (int i = 0; i < vcs.count; i++) {
        UIViewController *vc = [vcs objectAtIndex:i];
        [self.scrollView addSubview:vc.view];
        vc.view.backgroundColor = [UIColor zz_randomColor];
        vc.view.frame = CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    
    // 调整位置
    [self.view bringSubviewToFront:self.scrollView];
    [self.view bringSubviewToFront:self.segmentBgView];
    [self.view bringSubviewToFront:self.headView];
    
    ZZComplexChildBaseVC *vc = [vcs zz_arrayObjectAtIndex:1];
    if ([vc respondsToSelector:@selector(hiddenSegmentView)]) {
        vc.hiddenSegmentView = self.segmentBgView;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
