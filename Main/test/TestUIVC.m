//
//  TestUIVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/12.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestUIVC.h"
#import "UIView+ZZKit.h"
#import "ZZTabBarController.h"
#import "UIViewController+ZZKit.h"
#import "UIWindow+ZZKit.h"
#import "NSString+ZZKit.h"
#import "UIView+ZZKit_Blocks.h"
#import "ZZMacro.h"
#import "UITabBar+ZZKit.h"
#import "NSDictionary+ZZKit.h"
#import "NSArray+ZZKit.h"
#import "NSMutableArray+ZZKit.h"
#import "CalcMarker.h"
#import "Calculator.h"
#import "NSObject+Calc.h"

@interface TestObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dict;

@end

@implementation TestObject
@end

@interface TestUIVC ()

@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation TestUIVC

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view zz_quickAddLine:nil frame:CGRectMake(10, 200, 400, 0.5) constraintBlock:nil];
    
    [self.view zz_quickAddLine:[UIColor redColor] frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.leftMargin.equalTo(superView.mas_left).offset(100.0);
        make.rightMargin.equalTo(superView.mas_right).offset(-100.0);
        make.topMargin.equalTo(superView.mas_top).offset(300.0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.view zz_quickAddButton:@"测试" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium] backgroundColor:[UIColor blackColor] frame:CGRectMake(200, 100, 120, 36) constraintBlock:nil touchupInsideBlock:^(UIButton * _Nonnull sender) {
        NSLog(@"Tapped");
    }];
    
    NSString *text = @"据国家发改委价格监测中心监测，本轮成品油调价周期内（5月27日—6月10日），国际油价大幅下降，伦敦布伦特、纽约WTI油价最低分别降至每桶61和52美元，回落至近五个月来的低位。平均来看，两市油价比上轮调价周期下降9.94%，受此影响，国内汽油、柴油零售价格随之大幅下调。";
    [self.view zz_quickAddLabel:text font:[UIFont systemFontOfSize:14.0] textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentLeft perLineHeight:20.0 kern:1.0 space:0 lineBreakmode:NSLineBreakByWordWrapping attributedText:nil needCalculateTextFrame:YES backgroundColor:[UIColor grayColor] frame:CGRectMake(100, 350, 300, 400) constraintBlock:^BOOL(UIView * _Nonnull superView, CGSize renderedSize, MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(superView.mas_left).offset(10.0);
        make.top.equalTo(superView.mas_top).offset(350.0);
        make.width.mas_equalTo(300.0);
        make.height.mas_equalTo(renderedSize.height);
        return YES;
    }];
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5"];
    NSDictionary *dict = @{@"A":@"AA",@"B":@"BB"};
    TestObject *object = [TestObject new];
    object.name = @"Hello";
    object.code = 1111;
    object.dict = dict;
    object.array = array;
    NSDictionary *_dict = @{@"string":@"Jeff",@"object":object, @"dict":dict,@"array":array};
    
    NSString *jsonString = [_dict zz_toJSONString];
    NSLog(@"%@", jsonString);
    
    NSArray *_array = @[array, @"Jeff", @(100), _dict, object];
    jsonString = [_array zz_toJSONString];
    NSLog(@"%@", jsonString);
}

- (IBAction)_tapZZTabbarController:(id)sender {
    
    self.rootViewController = [UIWindow zz_window].rootViewController;
    
    ZZTabBarController *tabVC = [[ZZTabBarController alloc] init];
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor blueColor];
    [tabVC zz_addChildViewController:vc1 tabName:@"第一页" tabUnselectedImage:@"tab_notice".zz_image tabSelectedImage:@"tab_notice_selected".zz_image tabUnselectedTextAttrs:nil tabSelectedTextAttrs:nil imageEdgeInsets:UIEdgeInsetsZero textOffset:UIOffsetZero navigationControllerClass:nil];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor redColor];
    [tabVC zz_addChildViewController:vc2 tabName:@"第二页" tabUnselectedImage:@"tab_me".zz_image tabSelectedImage:@"tab_me_selected".zz_image tabUnselectedTextAttrs:nil tabSelectedTextAttrs:nil imageEdgeInsets:UIEdgeInsetsZero textOffset:UIOffsetZero navigationControllerClass:nil];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor greenColor];
    [tabVC zz_addChildViewController:vc3 tabName:@"第三页" tabUnselectedImage:@"tab_offers".zz_image tabSelectedImage:@"tab_offers_selected".zz_image tabUnselectedTextAttrs:nil tabSelectedTextAttrs:nil imageEdgeInsets:UIEdgeInsetsZero textOffset:UIOffsetZero navigationControllerClass:nil];
    
    [UIWindow zz_window].rootViewController = tabVC;
    
    ZZ_WEAK_SELF
    [vc1.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZZ_STRONG_SELF
            [UIWindow zz_window].rootViewController = strongSelf.rootViewController;
        });
    }];
    
    [vc2.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // ZZ_STRONG_SELF
            // [UIWindow zz_window].rootViewController = strongSelf.rootViewController;
            [tabVC.tabBar zz_setBadge:1 pointColor:[UIColor redColor] badgeSize:CGSizeMake(6.0, 6.0) offset:UIOffsetZero];
            [tabVC.tabBar zz_setBadge:0 value:21 badgeSize:CGSizeMake(20, 20) badgeBackgroundColor:[UIColor whiteColor] textColor:[UIColor redColor] textFont:[UIFont systemFontOfSize:14.0] offset:UIOffsetMake(0, 0)];
            
            
        });
    }];
    
    [vc3.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // ZZ_STRONG_SELF
            // [UIWindow zz_window].rootViewController = strongSelf.rootViewController;
            [tabVC.tabBar zz_setSystemBadge:2 value:9999 color:[UIColor blackColor]];
            
            
        });
    }];
}

- (void)_testFP {
    
    int t = 0;
    t = [NSObject make:^(CalcMarker *marker) {
        marker.add(1).add(10).delete(5);
    }];
    NSLog(@"%d", t);
    
    
    Calculator *calculator = [[Calculator alloc] init];
    BOOL equal = [[calculator calculator:^int(int result) {
        result += 2;
        result += 5;
        return result;
    }] equal:^BOOL(int result) {
        
        return result == 7;
    }].isEqual;
    NSLog(@"%d", equal);
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
