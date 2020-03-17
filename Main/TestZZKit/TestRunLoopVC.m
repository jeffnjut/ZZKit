//
//  TestRunLoopVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/30.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestRunLoopVC.h"

@interface TestRunLoopVC ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSThread *thread;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSPort *port;

@end

@implementation TestRunLoopVC

- (void)dealloc
{
    // TODO 常驻线程导致dealloc失败
    
    [self.thread cancel];
    
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    
    [self.thread cancel];
    
    @autoreleasepool {
        self.thread = nil;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(_timerAction) userInfo:nil repeats:YES];
    
    // 伪模式 NSRunLoopCommonModes
    // UITrackingRunLoopMode
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(_backendProcess) object:nil];
    [self.thread start];
}

- (void)_timerAction {
    
    NSLog(@"------ timer action");
}

-(IBAction)_tap:(id)sender {
    
    NSLog(@"Tap");
    
    [self performSelector:@selector(_test) onThread:self.thread withObject:nil waitUntilDone:YES];
    NSLog(@"Tap end");
}

- (void)_test {
    
    NSLog(@"_test");
    [NSThread sleepForTimeInterval:1];
}

- (void)_backendProcess {
    
    NSLog(@"_backendProcess");
    
    [[NSThread currentThread] setName:@"backendProcess Thread"];
    
    NSLog(@"%@", [NSThread currentThread]);
    
    // 常驻进程
    self.port = [NSPort port];
    [[NSRunLoop currentRunLoop] addPort:self.port forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
}

- (void)_removePort {
    
    NSLog(@"%@", [NSThread currentThread]);
    [[NSRunLoop currentRunLoop] removePort:self.port forMode:NSDefaultRunLoopMode];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self performSelector:@selector(_removePort) onThread:self.thread withObject:nil waitUntilDone:NO];
    
    [super touchesBegan:touches withEvent:event];
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"test"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
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
