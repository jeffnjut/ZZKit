//
//  ZZLock.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZLock.h"
#import <pthread.h>

@interface ZZLock ()
{
    pthread_mutex_t _lock;
}

@end

@implementation ZZLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

/**
 *  加锁
 */
- (void)lock {
    
    pthread_mutex_lock(&_lock);
}

/**
 *  解锁
 */
- (void)unlock {
    
    pthread_mutex_unlock(&_lock);
}

@end
