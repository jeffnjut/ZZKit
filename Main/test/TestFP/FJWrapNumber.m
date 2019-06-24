//
//  FJWrapNumber.m
//  test
//
//  Created by Fu Jie on 2019/1/4.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "FJWrapNumber.h"

@interface FJWrapNumber ()

@property (nonatomic, assign) float value;

@end

@implementation FJWrapNumber

+ (FJWrapNumber *)numberWithString:(NSString *)str {
    
    FJWrapNumber *number = [[FJWrapNumber alloc] init];
    number.value = [str floatValue];
    return number;
}

- (FJWrapNumber * (^)(float value))add {
    
    __weak typeof(self) weakSelf = self;
    return ^FJWrapNumber *(float value) {
        weakSelf.value += value;
        return weakSelf;
    };
}

- (FJWrapNumber * (^)(float value))delete {
    
    __weak typeof(self) weakSelf = self;
    return ^FJWrapNumber *(float value) {
        weakSelf.value -= value;
        return weakSelf;
    };
}

@end
