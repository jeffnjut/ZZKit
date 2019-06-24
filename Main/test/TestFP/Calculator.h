//
//  Calculator.h
//  test
//
//  Created by Fu Jie on 2019/1/7.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

@property (nonatomic, assign) int result;
@property (nonatomic, assign) BOOL isEqual;

- (Calculator *)calculator:(int(^)(int result))calculator;

- (Calculator *)equal:(BOOL(^)(int result))operation;

@end
