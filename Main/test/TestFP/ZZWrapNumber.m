//
//  ZZWrapNumber.m
//  test
//
//  Created by Fu Jie on 2019/1/4.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "ZZWrapNumber.h"

@interface ZZWrapNumber ()

@property (nonatomic, assign) float value;

@end

@implementation ZZWrapNumber

+ (ZZWrapNumber *)numberWithString:(NSString *)str {
    
    ZZWrapNumber *number = [[ZZWrapNumber alloc] init];
    number.value = [str floatValue];
    return number;
}

- (ZZWrapNumber * (^)(float value))add {
    
    __weak typeof(self) weakSelf = self;
    return ^ZZWrapNumber *(float value) {
        weakSelf.value += value;
        return weakSelf;
    };
}

- (ZZWrapNumber * (^)(float value))delete {
    
    __weak typeof(self) weakSelf = self;
    return ^ZZWrapNumber *(float value) {
        weakSelf.value -= value;
        return weakSelf;
    };
}

@end
