//
//  NSObject+Calc.h
//  test
//
//  Created by Fu Jie on 2019/1/4.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcMarker.h"

@interface NSObject (Calc)

+ (int)make:(void(^)(CalcMarker *marker))block;

@end
