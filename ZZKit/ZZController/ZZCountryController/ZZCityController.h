//
//  ZZCityController.h
//  ZZKit
//
//  Created by Fu Jie on 2019/7/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCityController : UIViewController

@property (nonatomic, copy) void(^zzSelectCityBlock)(NSString *cityName);

@end

NS_ASSUME_NONNULL_END
