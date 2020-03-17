//
//  TestWidgetVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/25.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestWidgetVC.h"
#import "ZZWidgetTimerView.h"
#import "ZZWidgetProgressView.h"
#import "ZZMacro.h"
#import "UIView+ZZKit_Blocks.h"
#import <Typeset/Typeset.h>

@interface TestWidgetVC ()

@property (nonatomic, strong) ZZWidgetProgressView *progressView;


@end

@implementation TestWidgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ZZWidgetTimerView *timerView = [ZZWidgetTimerView zz_quickAdd:YES time:101 onView:self.view backgroundColor:[[UIColor redColor] colorWithAlphaComponent:1.0] borderWidth:1.0 borderColor:[UIColor blackColor] circleLineWidth:10.0 circleLineColor:[UIColor whiteColor] circleLineFillColor:[UIColor blackColor] circleLineMargin:10.0 frame:CGRectMake(50, 50, 100, 100) tapBlock:^(ZZWidgetTimerView * _Nonnull zzWidgetTimerView) {
        NSLog(@"Tap TimerView");
    } completionBlock:^(ZZWidgetTimerView * _Nonnull zzWidgetTimerView) {
        NSLog(@"Timer Completed");
    }];
    
    timerView.zzSkipText = @"Skip".typeset.font([UIFont systemFontOfSize:14.0].fontName, 14.0).color([UIColor yellowColor]).kern(1.0).string;
    timerView.zzSkipTextOffset = UIOffsetMake(0, - 5.0);
    timerView.zzFormattedTimeText = @"剩余:%d";
    timerView.zzTimeTextOffset = UIOffsetMake(0, 5.0);
    timerView.zzTimeTextAttibutes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0]};
    [timerView zz_start];
    
    self.progressView = [ZZWidgetProgressView zz_quickAdd:self.view frame:CGRectMake(10, 300, 300, 60) progressTintColor:[UIColor whiteColor] progressedTintColor:[UIColor greenColor] progressBorderWidth:5.0 progressBorderColor:[UIColor redColor] containerBorderWidth:2.0 containerBorderColor:[UIColor blueColor] round:NO progress:0];
    
    ZZ_WEAK_SELF
    [self.view zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progressView zz_updateProgress:weakSelf.progressView.zz_progress + 0.1];
        });
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
