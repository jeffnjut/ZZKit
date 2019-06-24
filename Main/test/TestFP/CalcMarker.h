//
//  CalcMarker.h
//  test
//
//  Created by Fu Jie on 2019/1/4.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcMarker : NSObject

@property (nonatomic, assign) int result;

- (CalcMarker *(^)(int))add;
- (CalcMarker *(^)(int))delete;

@end
