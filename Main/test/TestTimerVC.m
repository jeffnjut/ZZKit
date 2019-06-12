//
//  TestTimerVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestTimerVC.h"
#import "ZZTimer.h"
#import "ZZKit.h"
#import "NSObject+ZZKit_Timer.h"

@interface TestTimerVC ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, strong) ZZTimer *timer;

@end

@implementation TestTimerVC

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.timer = [[ZZTimer alloc] initWithOwner:self countdown:24 * 60 * 60 + 60 interval:2.0 callback:^(id  _Nonnull owner, NSUInteger days, NSUInteger hours, NSUInteger minutes, NSUInteger seconds, NSUInteger totalSeconds) {
        [ZZKit.Queue zz_dispatchAfter:0 queue:nil onMainThread:YES async:YES barrier:NO key:nil block:^{
            TestTimerVC *vc = owner;
            vc.label.text = [NSString stringWithFormat:@"%ld天  %ld小时  %ld分钟  %ld秒  %ld总秒数",days, hours, minutes, seconds, totalSeconds];
        }];
    }];
    
    [self zz_startCountdown:62 interval:2.0 callback:^(id  _Nonnull owner, NSUInteger days, NSUInteger hours, NSUInteger minutes, NSUInteger seconds, NSUInteger totalSeconds) {
        [ZZKit.Queue zz_dispatchAfter:0 queue:nil onMainThread:YES async:YES barrier:NO key:nil block:^{
            TestTimerVC *vc = owner;
            vc.label.text = [NSString stringWithFormat:@"%ld天  %ld小时  %ld分钟  %ld秒  %ld总秒数",days, hours, minutes, seconds, totalSeconds];
        }];
    }];
    [self printStatus:self.zz_countdownStatus];
}

- (IBAction)_tapStart:(id)sender {
    
    // [self.timer zz_start];
    [self zz_startCountdown];
    [self printStatus:self.zz_countdownStatus];
}

- (IBAction)_tapRestart:(id)sender {
    
    // [self.timer zz_reStart];
    [self zz_reStartCountdown];
    [self printStatus:self.zz_countdownStatus];
}

- (IBAction)_tapSuspend:(id)sender {
    
    // [self.timer zz_suspend];
    [self zz_suspendCountdown];
    [self printStatus:self.zz_countdownStatus];
}

- (IBAction)_tapResume:(id)sender {
    
    // [self.timer zz_resume];
    [self zz_resumeCountdown];
    [self printStatus:self.zz_countdownStatus];
}

- (IBAction)_tapStop:(id)sender {
    
    // [self.timer zz_stop];
    [self zz_stopCountdown];
    [self printStatus:self.zz_countdownStatus];
    [self zz_removeCountdown];
    [self printStatus:self.zz_countdownStatus];
}

- (void)printStatus:(ZZTimerStatus)status {
    
    switch (status) {
        case ZZTimerStatusPaused:
        {
            NSLog(@"ZZTimerStatusPaused");
        }
            break;
        case ZZTimerStatusStarting:
        {
            NSLog(@"ZZTimerStatusStarting");
        }
            break;
        case ZZTimerStatusStopped:
        {
            NSLog(@"ZZTimerStatusStopped");
        }
            break;
        case ZZTimerStatusRaw:
        {
            NSLog(@"ZZTimerStatusRaw");
        }
            break;
        case ZZTimerStatusReady:
        {
            NSLog(@"ZZTimerStatusReady");
        }
            break;
            
        default:
            break;
    }
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
