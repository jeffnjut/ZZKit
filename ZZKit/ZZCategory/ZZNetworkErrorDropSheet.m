//
//  NetworkErrorDropSheet.m
//  ZZErrorReloader
//
//  Created by WWHT on 2017/5/13.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "ZZNetworkErrorDropSheet.h"
#import "ZZNetworkErrorDescViewController.h"
#import "UIControl+ZZKit_Blocks.h"

@interface ZZNetworkErrorDropSheet()

@property (nonatomic, weak) IBOutlet UIButton *btnTap;
@property (nonatomic, weak) UIViewController  *viewController;

@end

@implementation ZZNetworkErrorDropSheet

+ (ZZNetworkErrorDropSheet *)zz_networkErrorDropSheet:(UIViewController *)viewController {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    ZZNetworkErrorDropSheet *networkErrorDropSheet = [[bundle loadNibNamed:@"ZZNetworkErrorDropSheet" owner:nil options:nil] lastObject];
    networkErrorDropSheet.viewController = viewController;
    
    __weak ZZNetworkErrorDropSheet *weakSelf = networkErrorDropSheet;
    [networkErrorDropSheet.btnTap zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof UIControl * _Nonnull sender) {
        ZZNetworkErrorDescViewController *networkErrorDescViewController = [[ZZNetworkErrorDescViewController alloc] init];
        if (weakSelf.viewController.navigationController != nil && [weakSelf.viewController.navigationController.viewControllers count] > 0) {
            [weakSelf.viewController.navigationController pushViewController:networkErrorDescViewController animated:YES];
        }else{
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:networkErrorDescViewController];
            [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
        }
    }];
    return networkErrorDropSheet;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
