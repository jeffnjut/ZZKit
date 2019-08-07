//
//  TestTagViewVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/7.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestTagViewVC.h"
#import "ZZWidgetTagView.h"
#import "NSString+ZZKit.h"

@interface TestTagViewVC ()

@property (nonatomic, strong) ZZWidgetTagView *tagView;
@property (nonatomic, strong) ZZWidgetTagView *verticalTagView;
@property (nonatomic, strong) ZZWidgetTagView *disabledTagView;
@property (nonatomic, strong) ZZWidgetTagView *wtagView;

@end

@implementation TestTagViewVC

- (void)viewDidLoad {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.25 alpha:1.0];
    
    UILabel *lb = [[UILabel alloc] init];
    [self.view addSubview:lb];
    lb.text = @"Message";
    [lb sizeToFit];
    lb.center = self.view.center;
    
    ZZTagConfig *config = [ZZTagConfig new];
    config.zzEnableMultiTap = YES;
    config.zzTitleFont = [UIFont systemFontOfSize:12.0];
    config.zzTitleColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    config.zzBackgroundColor = [UIColor whiteColor];
    config.zzBorderColor = [UIColor clearColor];
    config.zzBorderWidth = 2.0;
    config.zzCornerRadius = 2.0;
    config.zzItemMinWidth = 100.0;
    config.zzItemMinHeight = 26.0;
    config.zzEdgeInsets = UIEdgeInsetsMake(20.0, 5.0, 20.0, 5.0);
    config.zzItemHorizontalSpace = 18.0;
    config.zzItemVerticalSpace = 16.0;
    config.zzMultiTappedTitleFont = [UIFont systemFontOfSize:12.0];
    config.zzMultiTappedTitleColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    config.zzMultiTappedBackgroundColor = [UIColor lightGrayColor];
    config.zzMultiTappedBorderColor = [UIColor redColor];
    config.zzMultiTappedBorderWidth = 2.0;
    config.zzSelectedImage = @"icon_selected";
    config.zzItemTextPadding = 5.0;
    config.zzDebug = YES;
    [self.tagView zz_addTags:@[[ZZTagModel zz_tagName:@"双肩包/背包" selected:NO],[ZZTagModel zz_tagName:@"手提包" selected:NO],[ZZTagModel zz_tagName:@"挎包" selected:NO],[ZZTagModel zz_tagName:@"旅行包" selected:NO],[ZZTagModel zz_tagName:@"钱包/卡包" selected:YES]] config:config];
    [self.tagView zz_refresh];
    
    
    config = [ZZTagConfig new];
    config.zzTitleFont = [UIFont systemFontOfSize:12.0];
    config.zzTitleColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    config.zzBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0];
    config.zzBorderColor = [UIColor clearColor];
    config.zzBorderWidth = 1;
    config.zzCornerRadius = 2.0;
    config.zzEdgeInsets = UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0);
    config.zzItemMinWidth = 140.0;
    config.zzItemMinHeight = 26.0;
    config.zzItemVerticalSpace = 16.0;
    config.zzMultiTappedTitleFont = [UIFont systemFontOfSize:12.0];
    config.zzMultiTappedTitleColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    config.zzMultiTappedBackgroundColor = [UIColor whiteColor];
    config.zzMultiTappedBorderColor = [UIColor blackColor];
    config.zzMultiTappedBorderWidth = 1;
    config.zzSelectedImage = @"icon_selected";
    config.zzDebug = YES;
    [self.verticalTagView zz_addTags:@[[ZZTagModel zz_tagName:@"双肩包/背包" selected:NO],
                                       [ZZTagModel zz_tagName:@"手提包" selected:YES],
                                       [ZZTagModel zz_tagName:@"挎包" selected:NO],
                                       [ZZTagModel zz_tagName:@"旅行包" selected:NO],
                                       [ZZTagModel zz_tagName:@"钱包/卡包" selected:NO]]
                              config:config];
    [self.verticalTagView zz_refresh];
    
    config = [ZZTagConfig new];
    config.zzEnableMultiTap = NO;
    config.zzTitleFont = [UIFont systemFontOfSize:16.0];
    config.zzTitleColor = @"#272727".zz_color;
    config.zzBackgroundColor = [UIColor whiteColor];
    config.zzBorderColor = @"#C2C2C2".zz_color;
    config.zzBorderWidth = 0.5;
    config.zzCornerRadius = 3.0;
    config.zzItemMinWidth = (UIScreen.mainScreen.bounds.size.width - 40.0 - 16.0 * 3) / 4.0;
    config.zzItemMinHeight = 35.0;
    config.zzEdgeInsets = UIEdgeInsetsZero;
    config.zzItemHorizontalSpace = 16.0;
    config.zzItemVerticalSpace = 16.0;
    config.zzMultiTappedTitleFont = [UIFont systemFontOfSize:16.0];
    config.zzMultiTappedTitleColor = @"#FF4E4E".zz_color;
    config.zzMultiTappedBackgroundColor = [UIColor whiteColor];
    config.zzMultiTappedBorderColor = @"#FF4E4E".zz_color;
    config.zzMultiTappedBorderWidth = 1.0;
    config.zzItemTextPadding = 5.0;
    // config.zzDebug = YES;
    config.zzDisabledTitleColor = @"#C2C2C2".zz_color;
    config.zzDisabledTitleFont = [UIFont systemFontOfSize:16.0];
    config.zzDisabledBackgroundColor = @"#EEEEEE".zz_color;
    config.zzDisabledBorderColor = @"#EEEEEE".zz_color;
    [self.disabledTagView zz_addTags:@[[ZZTagModel zz_tagName:@"$50" selected:YES disabled:NO],
                                       [ZZTagModel zz_tagName:@"$100" selected:NO disabled:NO],
                                       [ZZTagModel zz_tagName:@"$150" selected:NO disabled:YES],
                                       [ZZTagModel zz_tagName:@"$200" selected:NO disabled:YES]]
                              config:config];
    [self.disabledTagView zz_refresh];
    
    
    config = [ZZTagConfig new];
    config.zzTitleFont = [UIFont systemFontOfSize:12.0];
    config.zzTitleColor = @"#4F4F53".zz_color;
    config.zzBackgroundColor = @"#F5F5F5".zz_color;
    config.zzBorderColor = nil;
    config.zzBorderWidth = 0;
    config.zzCornerRadius = 6.0;
    config.zzEdgeInsets = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0);
    config.zzItemMinWidth = 40.0;
    config.zzItemMinHeight = 24.0;
    config.zzItemHorizontalSpace = 16.0;
    config.zzMultiTappedTitleFont = [UIFont systemFontOfSize:12.0];
    config.zzMultiTappedTitleColor = @"#FF804D".zz_color;;
    config.zzMultiTappedBackgroundColor = [@"#FF804D".zz_color colorWithAlphaComponent:0.1];
    config.zzMultiTappedBorderColor = nil;
    config.zzMultiTappedBorderWidth = 0;
    // config.zzSelectedImage = @"icon_selected";
    // config.zzDebug = YES;
    [self.wtagView zz_addTags:@[[ZZTagModel zz_tagName:@"精选" selected:NO],
                                [ZZTagModel zz_tagName:@"关注" selected:YES],
                                [ZZTagModel zz_tagName:@"母婴" selected:NO],
                                [ZZTagModel zz_tagName:@"护肤" selected:NO],
                                [ZZTagModel zz_tagName:@"鞋子" selected:NO]]
                       config:config];
    [self.wtagView zz_refresh];
}

// ZZTagViewPatternFixedWidthDynamicHeight
- (ZZWidgetTagView *)tagView {
    if (_tagView == nil) {
        
        _tagView = [[ZZWidgetTagView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 20) pattern:ZZTagViewPatternFixedWidthDynamicHeight];
        [self.view addSubview:_tagView];
        _tagView.zzTagMultiTappedBlock = ^(__kindof ZZTagModel *tag, BOOL selected) {
            NSLog(@"%@ %@", tag, selected?@"选中":@"未选中");
        };
    }
    return _tagView;
}

// ZZTagViewPatternFixedWidthFixedHeightVertical
- (ZZWidgetTagView *)verticalTagView {
    if (_verticalTagView == nil) {
        
        _verticalTagView = [[ZZWidgetTagView alloc] initWithFrame:CGRectMake(100, 120, 140, 340) pattern:ZZTagViewPatternFixedWidthFixedHeightVertical];
        [self.view addSubview:_verticalTagView];
    }
    return _verticalTagView;
}

// ZZTagViewPatternFixedWidthDynamicHeight
- (ZZWidgetTagView *)disabledTagView {
    
    if (_disabledTagView == nil) {
        _disabledTagView = [[ZZWidgetTagView alloc] initWithFrame:CGRectMake(20, 480, UIScreen.mainScreen.bounds.size.width - 40, 20) pattern:ZZTagViewPatternFixedWidthDynamicHeight];
        [self.view addSubview:_disabledTagView];
    }
    return _disabledTagView;
}

// ZZTagViewPatternFixedHeightDynamicWidth
- (ZZWidgetTagView *)wtagView {
    
    if (_wtagView == nil) {
        _wtagView = [[ZZWidgetTagView alloc] initWithFrame:CGRectMake(0, 530, 20, 60) pattern:ZZTagViewPatternFixedHeightDynamicWidth];
        [self.view addSubview:_wtagView];
    }
    return _wtagView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
