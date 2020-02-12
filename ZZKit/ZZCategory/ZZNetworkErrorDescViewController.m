//
//  ZZNetworkErrorDescViewController.m
//  ZZErrorReloader
//
//  Created by WWHT on 2017/5/13.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "ZZNetworkErrorDescViewController.h"
#import <Masonry/Masonry.h>
#import "Typeset.h"

#define LINK_COLOR [UIColor colorWithRed:0 green:0.733 blue:0.985 alpha:1.0]
#define TEXT_COLOR [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]

@interface ZZNetworkErrorDescViewController ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation ZZNetworkErrorDescViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        // TODO
        self.view = [[bundle loadNibNamed:@"ZZNetworkErrorDescViewController" owner:self options:nil] lastObject];
        self.navigationItem.title = @"没有网络";
        
        self.textView.delegate = self;
        
        NSString *authStr = nil;
        if ([[UIDevice currentDevice].systemVersion intValue] >= 10) {
            authStr = [NSString stringWithFormat:@"打开【设置】，找到【%@】-【无线数据】，勾选【无线局域网与蜂窝移动网络】即可，点此检查", self.appName.length > 0 ? self.appName : @"App名称"];
        }else{
            authStr = [NSString stringWithFormat:@"打开【设置】，找到【%@】-【使用蜂窝移动数据】，设置ON即可，点此检查", self.appName.length > 0 ? self.appName : @"App名称"];
        }
        NSMutableAttributedString *attributeString = authStr.typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).color(TEXT_COLOR).match(@"点此检查").color(LINK_COLOR).string;
        
        [attributeString addAttribute:NSLinkAttributeName value:@"open://setting" range:[[attributeString string] rangeOfString:@"点此检查"]];
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName : LINK_COLOR,
                                         NSUnderlineColorAttributeName  : LINK_COLOR,
                                         NSUnderlineStyleAttributeName  : @(NSUnderlineStyleSingle)
                                         };
        self.textView.attributedText = attributeString;
        self.textView.linkTextAttributes = linkAttributes;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)) {
    
    if ([[URL absoluteString] isEqualToString:@"open://setting"]) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
        }
        return YES;
    }
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL absoluteString] isEqualToString:@"open://setting"]) {
        if (@available(iOS 8.0, *)) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            return YES;
        }
    }
    return NO;
}


- (void)setupBackButton {
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32.0, 24.0)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)backAction {
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
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
