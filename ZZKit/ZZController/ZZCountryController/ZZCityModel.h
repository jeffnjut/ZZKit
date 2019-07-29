//
//  ZZCityModel.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCityModel : NSObject

// 索引名称
@property (nonatomic, strong) NSString *title;

// 城市列表
@property (nonatomic, strong) NSArray<NSString *> *cities;

@end

NS_ASSUME_NONNULL_END
