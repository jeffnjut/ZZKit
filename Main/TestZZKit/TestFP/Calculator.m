//
//  Calculator.m
//  test
//
//  Created by Fu Jie on 2019/1/7.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.result = 0;
        self.isEqual = NO;
    }
    return self;
}

- (Calculator *)calculator:(int (^)(int))calculator {
    
    self.result = calculator == nil ? self.result : calculator(self.result);
    return self;
}

- (Calculator *)equal:(BOOL (^)(int))operation {
    
    self.isEqual = operation == nil ? NO : operation(self.result);
    return self;
}

@end
