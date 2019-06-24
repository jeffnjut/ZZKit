//
//  CalcMarker.m
//  test
//
//  Created by Fu Jie on 2019/1/4.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "CalcMarker.h"

@interface CalcMarker()

@end

@implementation CalcMarker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.result = 0;
    }
    return self;
}

- (CalcMarker *(^)(int))add {
    
    __weak typeof(self) weakSelf = self;
    return ^CalcMarker *(int value) {
        weakSelf.result += value;
        return weakSelf;
    };
}

- (CalcMarker *(^)(int))delete {
    
    __weak typeof(self) weakSelf = self;
    return ^CalcMarker *(int value) {
        weakSelf.result -= value;
        return weakSelf;
    };
}

@end
