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
#import <Typeset/Typeset.h>

@interface TestWidgetVC ()

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
    
    ZZWidgetProgressView *progressView = [ZZWidgetProgressView zz_quickAdd:[UIColor blueColor] onView:self.view frame:CGRectMake(10, 300, 300, 50) progressFillColor:[UIColor redColor] progressBorderColor:[UIColor whiteColor] borderWidth:8.0 borderColor:[UIColor blackColor] margin:0];
    // [self.view addSubview:progressView];
    [progressView setProgress:0.5];
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
