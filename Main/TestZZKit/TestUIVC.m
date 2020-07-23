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
#import "ZZStorage.h"
#import "UIImage+ZZKit.h"
#import "NSData+ZZKit.h"
#import "UIView+ZZKit_HUD.h"
#import "ZZWidgetPinCodeView.h"
#import "ZZWidgetMaskView.h"
#import "TestPopupView.h"
#import "UIViewController+ZZKit_ErrorPlaceholder.h"
#import "ZZWidgetSwitch.h"

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

@property (nonatomic, weak) IBOutlet UIView *testSpinnerView;
@property (nonatomic, weak) IBOutlet UIButton *testSpinnerButton;

@end

@implementation TestUIVC

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    
    
    for (int i = 0; i < 2000; i++) {
        NSLog(@"%@", [@"" zz_randomNickName]);
    }
    
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
        make.top.equalTo(superView.mas_top).offset(550.0);
        make.width.mas_equalTo(300.0);
        make.height.mas_equalTo(renderedSize.height);
        return YES;
    }];
    
    [ZZStorage zz_plistSave:@"Jeff" forKey:@"a"];
    id a = [ZZStorage zz_plistFetch:@"a"];
    
    [ZZStorage zz_plistSave:@100 forKey:@"b"];
    id b = [ZZStorage zz_plistFetch:@"b"];
    
    
    [ZZStorage zz_plistSave:@"Jeff2"];
    id _NSString = [ZZStorage zz_plistFetch:@"__NSCFConstantString"];
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5"];
    [ZZStorage zz_plistSave:array forKey:@"c"];
    id c = [ZZStorage zz_plistFetch:[NSArray class] forKey:@"c"];
    
    NSDictionary *dict = @{@"A":@"AA",@"B":@"BB"};
    [ZZStorage zz_plistSave:dict forKey:@"d"];
    id d = [ZZStorage zz_plistFetch:[NSDictionary class] forKey:@"d"];
    
    TestObject *object = [TestObject new];
    object.name = @"Hello";
    object.code = 1111;
    object.dict = dict;
    object.array = array;
    NSDictionary *_dict = @{@"string":@"Jeff",@"object":object, @"dict":dict,@"array":array};
    
    [ZZStorage zz_plistSave:_dict forKey:@"e"];
    id e = [ZZStorage zz_plistFetch:[NSDictionary class] forKey:@"e"];
    
    NSString *jsonString = [_dict zz_toJSONString];
    NSLog(@"%@", jsonString);
    
    NSArray *_array = @[array, @"Jeff", @(100), _dict, object];
    [ZZStorage zz_plistSave:_array forKey:@"f"];
    id f = [ZZStorage zz_plistFetch:[NSArray<NSString *> class] forKey:@"f"];
    
    jsonString = [_array zz_toJSONString];
    NSLog(@"%@", jsonString);
    
    NSString *cookieStr = @"Hm_lpvt_12423ecbc0e2ca965d84259063d35238=1562658360; Hm_lvt_12423ecbc0e2ca965d84259063d35238=1562657844,1562657876,1562657902,1562658360; plus_cv=1::m:49a3f4a6; H_WISE_SIDS=133613_126887_127758_131440_133850_130511_128069_131888_133721_120154_131601_133017_132910_133041_131246_122155_132439_130762_132378_131518_118882_118858_118855_118824_118788_132840_132604_107320_133159_132783_130120_133351_129655_132250_124637_132538_133837_133472_131906_128891_133847_132551_133695_132674_133838_132543_132494_129643_131423_133412_133005_133863_133917_133938_110085_131574_133893_127969_123289_131299_127315_127416_131545; rsv_i=942b8yVe%2B%2FyCtmGPQ2cUlgFrJraSSFjQxg7x9NNyY%2F4tLmiaJPPeuj%2BfTXcouajtvyomUel6YnsbhLTsBVP9%2BL21KqM8GfU; plus_lsv=2d21860f0bf6b85c; BDSVRTM=292; customCookieName=Jeff; BDORZ=AE84CDB3A529C0F8A2B9DCDD1D18B695; SE_LAUNCH=5%3A26044276_0%3A26044276; reload=lsDiff:_0_2d21860f0bf6b85c_null; BAIDUID=64D65F39794654FAE25B853449317C7D:FG=1";
    NSDictionary *cookieDict = [cookieStr zz_cookieToDictionary];
    NSDictionary *property = [cookieStr zz_cookieProperties];
    NSHTTPCookie *cookie = [cookieStr zz_cookie];
    NSLog(@"%@ %@ %@", property, cookieDict, cookie);
    
    ZZWidgetPinCodeView *pinCodeView = [ZZWidgetPinCodeView zz_createPinCodeTextView:CGRectMake(10, 400 , 300, 40) itemNumber:6 itemGap:30 pinTextColor:[UIColor redColor] pinTextFont:[UIFont systemFontOfSize:20.0] normalUnderLineColor:[UIColor blackColor] normalUnderLineWidth:2.0 highlightedUnderLineColor:[UIColor redColor] highlightedUnderLineWidth:2.0];
    [self.view addSubview:pinCodeView];
    
    
    ZZWidgetMaskView *mask1 = [[ZZWidgetMaskView alloc] initWithRevalView:self.testSpinnerView layoutType:ZZWidgetMaskViewLayoutTypeUP];
    mask1.des = @"这是SpinnerView";
    
    ZZWidgetMaskView *mask2 = [[ZZWidgetMaskView alloc] initWithRevalView:self.testSpinnerButton layoutType:ZZWidgetMaskViewLayoutTypeDown];
    mask2.des = @"这是SpinnerButton哦！";
    
    ZZWidgetMaskQueue *queue = [[ZZWidgetMaskQueue alloc] init];
    [queue addPromptMaskView:mask1];
    [queue addPromptMaskView:mask2];
    [queue showMasksInView:self.view];
    
    ZZWidgetSwitch *swicthView = [ZZWidgetSwitch create:CGRectMake(16, 300, 32.0, 20)
                                                   isOn:NO
                                     offBackgroundColor:@"#D8D8D8".zz_color
                                      onBackgroundColor:@"#FF7A00".zz_color
                                             roundColor:@"#FFFFFF".zz_color
                                roundToBackgroundMargin:2.0
                                              animation:NO
                                      beforeSwitchBlock:nil
                                            switchBlock:^(BOOL isOn) {
        NSLog(@"%d", isOn);
    }];
    [self.view addSubview:swicthView];
}

- (IBAction)_tapZZTabbarController:(id)sender {
    
    self.rootViewController = [UIWindow zz_keyWindow].rootViewController;
    
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
    
    [UIWindow zz_keyWindow].rootViewController = tabVC;
    
    ZZ_WEAK_SELF
    [vc1.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZZ_STRONG_SELF
            [UIWindow zz_keyWindow].rootViewController = strongSelf.rootViewController;
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

- (IBAction)_tapFile:(id)sender {
    
    double size = [ZZStorage zz_sandboxSize:[ZZStorage zz_documentDirectory]];
    
    UIImage *image = @"KN".zz_image;
    [ZZStorage zz_sandboxSaveData:[image zz_imageData] name:@"A"];
    
    size = [ZZStorage zz_sandboxSize:[ZZStorage zz_documentDirectory]];
    
    NSData *data = [ZZStorage zz_sandboxFetchData:@"B"];
    
    data = [ZZStorage zz_sandboxFetchData:@"A"];
    [[data zz_image] zz_debugShow:CGRectMake(100, 100, 200, 200)];
    
    [ZZStorage zz_sandboxRemove:@"A"];
    
     size = [ZZStorage zz_sandboxSize:[ZZStorage zz_documentDirectory]];
    
    data = [ZZStorage zz_sandboxFetchData:@"A"];
}

- (IBAction)_tapHUD:(id)sender {
    
    // [self.navigationController.view zz_startLoading];
    
    // [self.navigationController.view zz_showHUD:@"据国家发改委价格监测中心监测，本轮成品油调价周期内（5月27日—6月10日），国际油价大幅下降!!iOS导航栏背景颜色,背景图片,标题字体颜色大小,透明度渐变,去除导航栏下划线等一...然后图片是根据颜色值生成的 核心代码"];
    
    // [self.navigationController.view zz_toast:@"据国家发改委价格监测中心监测，本轮成品油调价周期内（5月27日—6月10日），国际油价大幅下降!!iOS导航栏背景颜色,背景图片,标题字体颜色大小,透明度渐变,去除导航栏下划线等一...然后图片是根据颜色值生成的 核心代码"];
    
    // [self.view zz_dropSheet:@"据国家发改委价格监测中心监测，本轮成品油调价周期内（5月27日—6月10日），国际油价大幅下降!!iOS导航栏背景颜色,背景图片,标题字体颜色大小,透明度渐变,去除导航栏下划线等一...然后图片是根据颜色值生成的 核心代码"];
    
    // [self.testSpinnerView zz_startSpinning:ZZSpinnerLoadingStyleWhite];
    // [self.testSpinnerButton zz_startSpinning:@"加载" style:ZZSpinnerLoadingStyleWhite];
    
    TestPopupView *testPopupView = ZZ_LOAD_NIB(@"TestPopupView");
    testPopupView.zzPopupAppearAnimation = ZZPopupViewAnimationPopCenter;
    testPopupView.zzPopupDisappearAnimation = ZZPopupViewAnimationPopBottom;
    [ZZ_KEY_WINDOW zz_popup:testPopupView blurColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] userInteractionEnabled:YES springs:@[@(0.2), @(0.6), @(2.0)] actionBlock:^(id  _Nonnull value) {
        NSLog(@"%@", value);
    }];
}

- (IBAction)_tapStopHUD:(id)sender {
    
    // [self.view zz_stopLoading];
    
    [self.testSpinnerView zz_stopSpinning];
    [self.testSpinnerButton zz_stopSpinning];
}

- (IBAction)_tapNetworkError:(id)sender {

    ZZ_WEAK_SELF
    [self zz_showNetworkError:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf zz_hideError];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf zz_reShowError];
            });
        });
    }];
}

- (IBAction)_tapNetworkErrorDropSheet:(id)sender {
    
    [self zz_showNetworkErrorDropSheet];
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
