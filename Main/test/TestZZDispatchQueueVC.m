//
//  TestZZDispatchQueueVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZDispatchQueueVC.h"
#import "ZZKit.h"

@interface TestZZDispatchQueueVC ()

@end

@implementation TestZZDispatchQueueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    // dispatch_queue_t queue = dispatch_get_main_queue();
    
    /*
    dispatch_async(queue, ^{
        NSLog(@"1");
        sleep(1);
    });

    dispatch_async(queue, ^{
        NSLog(@"2");
        sleep(1);
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"2.1");
        sleep(1);
    });

    dispatch_barrier_async(queue, ^{
        NSLog(@"333_1");
        sleep(1);
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), queue, dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
                NSLog(@"333_000");
                sleep(1);
    }));
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:YES key:"3" block:^{
        NSLog(@"333_2");
    }];
    
    dispatch_async(queue, dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        NSLog(@"333_3");
        sleep(1);
    }));

    dispatch_async(queue, ^{
        NSLog(@"4");
        sleep(1);
    });
    
    return;
    */
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:YES key:"1" block:^{
        NSLog(@"111");
        NSLog(@"%@",[NSThread currentThread]);
        sleep(1);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"main");
        NSLog(@"%@",[NSThread currentThread]);
        sleep(1);
    });
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:YES key:"2" block:^{
        NSLog(@"222");
        NSLog(@"%@",[NSThread currentThread]);
        sleep(1);
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:YES key:"3" block:^{
        NSLog(@"333");
        NSLog(@"%@",[NSThread currentThread]);
        sleep(1);
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:YES key:"4" block:^{
        NSLog(@"444");
        NSLog(@"%@",[NSThread currentThread]);
        sleep(1);
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:YES key:"5" block:^{
        NSLog(@"555");
        NSLog(@"%@",[NSThread currentThread]);
        sleep(1);
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
