//
//  TestZZLinkedMapVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/23.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZLinkedMapVC.h"
#import "ZZLinkedMap.h"
#import "ZZLRUCache.h"

@interface TestZZLinkedMapVC ()

@property (nonatomic, strong) ZZLinkedMap *map;
@property (nonatomic, weak) IBOutlet UITextField *tfKey;
@property (nonatomic, weak) IBOutlet UITextField *tfValue;
@property (nonatomic, weak) IBOutlet UITextField *tfCost;

@property (nonatomic, weak) IBOutlet UITextField *tfBringHead;
@property (nonatomic, weak) IBOutlet UITextField *tfSendTail;

@end

@implementation TestZZLinkedMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.map = [ZZLinkedMap new];
}

- (IBAction)insertHead:(id)sender {
    
    ZZLinkedMapNode *node = [ZZLinkedMapNode new];
    node->_key = self.tfKey.text;
    node->_value = self.tfValue.text;
    node->_cost = [self.tfCost.text intValue];
    [self.map insertHead:node];
    [self _print];
    [self _autoIncrease];
}

- (IBAction)bringHead:(id)sender {
    
    NSString *key = self.tfBringHead.text;
    ZZLinkedMapNode *node = [self.map objectForKey:key];
    [self.map bringHead:node];
    [self _print];
}

- (IBAction)insertTail:(id)sender {
    
    ZZLinkedMapNode *node = [ZZLinkedMapNode new];
    node->_key = self.tfKey.text;
    node->_value = self.tfValue.text;
    node->_cost = [self.tfCost.text intValue];
    [self.map insertTail:node];
    [self _print];
    [self _autoIncrease];
}

- (IBAction)sendTail:(id)sender {
    
    NSString *key = self.tfSendTail.text;
    ZZLinkedMapNode *node = [self.map objectForKey:key];
    [self.map sendTail:node];
    [self _print];
}

- (IBAction)removeNode:(id)sender {
    
    NSString *key = self.tfBringHead.text;
    ZZLinkedMapNode *node = [self.map objectForKey:key];
    [self.map removeNode:node];
    [self _print];
}

- (IBAction)removeHead:(id)sender {
    
    [self.map removeHead];
    [self _print];
}

- (IBAction)removeTail:(id)sender {
    
    [self.map removeTail];
    [self _print];
}

- (IBAction)removeAll:(id)sender {
    
    [self.map removeAll];
    [self _print];
}

- (void)_print {
    
    NSLog(@"----------Link:");
    ZZLinkedMapNode *node = self.map->_head;
    while (node) {
        NSLog(@"Key:%@ Value:%@", node->_key, node->_value);
        node = node->_next;
    }
    NSLog(@"\n\n");
}

- (void)_autoIncrease {
    
    self.tfKey.text = [NSString stringWithFormat:@"%d", self.tfKey.text.intValue + 1];
    self.tfValue.text = [NSString stringWithFormat:@"%d", self.tfValue.text.intValue + 1];
}

- (IBAction)testZZLRUCacheBenchmark:(id)sender {
    
    ZZLRUCache *cache = [[ZZLRUCache alloc] init];
    cache.countLimit = 1;
    cache.costLimit = 1;
    // cache.safeThread = NO;
    NSMutableArray *keys = [NSMutableArray new];
    NSMutableArray *values = [NSMutableArray new];
    int count = 20000;
    for (int i = 0; i < count; i++) {
        NSObject *key;
        key = @(i); // avoid string compare
        //key = @(i).description; // it will slow down NSCache...
        //key = [NSUUID UUID].UUIDString;
        NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
        [keys addObject:key];
        [values addObject:value];
    }
    NSTimeInterval begin, end, time;
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            printf("ZZLRUCache:  %d\n", i);
            [cache setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("ZZLRUCache:  %8.2f\n", time * 1000);
    
    for (id key in keys) [cache removeObjectForKey:key]; // slow than 'removeAllObjects'
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [cache setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("ZZLRUCache:  %8.2f\n", time * 1000);
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [cache objectForKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("ZZLRUCache:  %8.2f\n", time * 1000);
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [cache objectForKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("ZZLRUCache:  %8.2f\n", time * 1000);
    
    
    for (int i = 0; i < count; i++) {
        NSObject *key;
        key = @(i + count); // avoid string compare
        [keys addObject:key];
    }
    
    for (NSUInteger i = keys.count; i > 1; i--) {
        [keys exchangeObjectAtIndex:(i - 1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [cache objectForKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("ZZLRUCache:  %8.2f\n", time * 1000);
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
