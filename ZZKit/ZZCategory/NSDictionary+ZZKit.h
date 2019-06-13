//
//  NSDictionary+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZASCIISortType) {
    ZZASCIISortTypeOriginal,   // 原序
    ZZASCIISortTypeASC,        // 升序
    ZZASCIISortTypeDESC        // 降序
};

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZZKit)

/**
 *  字典转JSON字符串
 */
- (NSString*)zz_toJSONString;

/**
 *  字典转JSON字符串，按ASCII升降序排序
 */
- (NSString*)zz_toJSONString:(ZZASCIISortType)type;

/**
 *  系统方法字典转JSON字符串（不能转换包含自定义对象的字典）
 *  不推荐使用
 */
- (NSString *)zz_toJSONStringBySystemAPI;

@end

NS_ASSUME_NONNULL_END
