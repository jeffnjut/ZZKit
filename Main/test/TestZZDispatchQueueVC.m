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
    
    // [self testZZBarrier];
    // [self testOriginalBarrier];
    [self testZZDispatchQueue];
}

- (void)testOriginalBarrier {
    
    dispatch_queue_t queue = dispatch_queue_create("test1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
        sleep(arc4random() % 3);
        NSLog(@"1 end");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2");
        sleep(arc4random() % 3);
        NSLog(@"2 end");
    });
    
    dispatch_async(queue, dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        NSLog(@"barrier");
        sleep(3);
        NSLog(@"barrier end");
    }));
    
    dispatch_async(queue, ^{
        NSLog(@"3");
        sleep(arc4random() % 3);
        NSLog(@"3 end");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4");
        sleep(arc4random() % 3);
        NSLog(@"4 end");
    });
}

- (void)testZZBarrier {
    
    dispatch_queue_t queue = dispatch_queue_create("test2", DISPATCH_QUEUE_CONCURRENT);
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:NO async:YES barrier:NO key:@"1" block:^{
        NSLog(@"1");
        sleep(arc4random() % 3);
        NSLog(@"1 end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:NO async:YES barrier:NO key:@"1" block:^{
        NSLog(@"2");
        sleep(arc4random() % 3);
        NSLog(@"2 end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:NO async:YES barrier:YES key:@"barrier" block:^{
        NSLog(@"barrier");
        sleep(3);
        NSLog(@"barrier end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:NO async:YES barrier:NO key:@"1" block:^{
        NSLog(@"3");
        sleep(arc4random() % 3);
        NSLog(@"3 end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:NO async:YES barrier:NO key:@"1" block:^{
        NSLog(@"4");
        sleep(arc4random() % 3);
        NSLog(@"4 end");
    }];
}

- (void)testZZDispatchQueue {
    
    NSLog(@"testZZDispatchQueue --- %@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"testZZDispatchQueue --- begin ---");
    
    dispatch_queue_t queue = NULL;
    queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    // queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    // queue = NULL;
    BOOL barrier = NO;
    BOOL async = YES;
    BOOL onMainThread = NO;
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:onMainThread async:async barrier:barrier key:@"1" block:^{
        for (int i = 0 ; i < 2; i++) {
            NSLog(@"111---%@\n\n",[NSThread currentThread]);
            sleep(1);
        }
        NSLog(@"111 end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:onMainThread async:async barrier:barrier key:@"2" block:^{
        for (int i = 0 ; i < 2; i++) {
            NSLog(@"222---%@\n\n",[NSThread currentThread]);
            sleep(1);
        }
        NSLog(@"222 end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:onMainThread async:async barrier:barrier key:@"3" block:^{
        for (int i = 0 ; i < 2; i++) {
            NSLog(@"333---%@\n\n",[NSThread currentThread]);
            sleep(1);
        }
        NSLog(@"333 end");
    }];

    [ZZKit.Queue dispatchAfter:0.5 queue:queue onMainThread:onMainThread async:async barrier:barrier key:@"4" block:^{
        for (int i = 0 ; i < 2; i++) {
            NSLog(@"444---%@\n\n",[NSThread currentThread]);
            sleep(1);
        }
        NSLog(@"444 end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:onMainThread async:async barrier:YES key:@"barrier" block:^{
        for (int i = 0 ; i < 2; i++) {
            NSLog(@"barrier---%@\n\n",[NSThread currentThread]);
            sleep(2);
        }
        NSLog(@"barrier end");
    }];
    
    [ZZKit.Queue dispatchAfter:0 queue:queue onMainThread:onMainThread async:async barrier:barrier key:@"5" block:^{
        for (int i = 0 ; i < 2; i++) {
            NSLog(@"555---%@\n\n",[NSThread currentThread]);
            sleep(1);
        }
        NSLog(@"555 end");
    }];
    
    NSLog(@"testZZDispatchQueue --- end ---");
    
    [ZZKit.Queue dispatchAfter:0 queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0) onMainThread:NO async:YES barrier:NO key:nil block:^{
        [ZZKit.Queue dispatchCancelKey:@"4"];
        [ZZKit.Queue dispatchCancelKey:@"5"];
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
