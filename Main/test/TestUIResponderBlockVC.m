//
//  TestUIResponderBlockVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/4.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestUIResponderBlockVC.h"
#import "UIView+ZZKit_Blocks.h"
#import "UIControl+ZZKit_Blocks.h"

@interface TestUIResponderBlockVC ()

@property (nonatomic, weak) IBOutlet UIView *blackView;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation TestUIResponderBlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.blackView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        NSLog(@"Tap Black View");
    }];
    
    [self.imageView zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        NSLog(@"Tap Image View");
    }];
    
    [self.label zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        NSLog(@"Tap Label");
    }];
    
    [self.button setTitle:@"测试" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    
    [self.button zz_tapBlock:UIControlEventTouchUpInside block:^(__kindof UIControl * _Nonnull sender) {
        NSLog(@"TouchUpInside Button");
    }];
    
    [self.button zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        NSLog(@"Tap Button");
    }];
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
