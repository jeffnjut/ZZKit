//
//  NSObject+Calc.m
//  test
//
//  Created by Fu Jie on 2019/1/4.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "NSObject+Calc.h"

@implementation NSObject (Calc)

+ (int)make:(void(^)(CalcMarker *marker))block {
    
    CalcMarker *maker = [CalcMarker new];
    block(maker);
    return maker.result;

}

@end
