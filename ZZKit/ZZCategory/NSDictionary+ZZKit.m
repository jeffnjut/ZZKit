//
//  NSDictionary+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/13.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSDictionary+ZZKit.h"
#import <YYModel/YYModel.h>
#import "NSArray+ZZKit.h"

@implementation NSDictionary (ZZKit)

/**
 *  字典转JSON字符串
 */
- (NSString*)zz_toJSONString {
    
    return [self zz_toJSONString:ZZASCIISortTypeASC];
}

/**
 *  字典转JSON字符串，按ASCII升降序排序
 *
 */
- (NSString*)zz_toJSONString:(ZZASCIISortType)type {
    
    if (self.count == 0) {
        return nil;
    }
    __block NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"{"];
    // 按照Key原序排列输出
    if (type == ZZASCIISortTypeOriginal) {
        [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            id appendData = nil;
            if ([object isKindOfClass:[NSString class]]) {
                appendData = [NSString stringWithFormat:@"\"%@\"",object];
            }else if ([object isKindOfClass:[NSNumber class]]) {
                appendData = object;
            }else if ([object isKindOfClass:[NSArray class]]) {
                appendData = [(NSArray *)object zz_toJSONString];
            }else if ([object isKindOfClass:[NSDictionary class]]) {
                appendData = [(NSDictionary *)object zz_toJSONString];
            }else {
                appendData = [object yy_modelToJSONString];
            }
            [jsonString appendFormat:@"\"%@\":%@,", key, appendData];
        }];
    }else {
        NSArray *sortedKeys = nil;
        if (type == ZZASCIISortTypeASC) {
            sortedKeys = [[self allKeys] zz_arraySort:YES];
        }else if (type == ZZASCIISortTypeDESC) {
            sortedKeys = [[self allKeys] zz_arraySort:NO];
        }
        for (NSString *key in sortedKeys) {
            id object = [self objectForKey:key];
            id appendData = nil;
            if ([object isKindOfClass:[NSString class]]) {
                appendData = [NSString stringWithFormat:@"\"%@\"",object];
            }else if ([object isKindOfClass:[NSNumber class]]) {
                appendData = object;
            }else if ([object isKindOfClass:[NSArray class]]) {
                appendData = [(NSArray *)object zz_toJSONString];
            }else if ([object isKindOfClass:[NSDictionary class]]) {
                appendData = [(NSDictionary *)object zz_toJSONString];
            }else {
                appendData = [object yy_modelToJSONString];
            }
            [jsonString appendFormat:@"\"%@\":%@,", key, appendData];
        }
    }
    [jsonString replaceCharactersInRange:NSMakeRange(jsonString.length - 1, 1) withString:@"}"];
    return jsonString;
}

/**
 *  系统方法字典转JSON字符串（不能转换包含自定义对象的字典）
 *  不推荐使用
 */
- (NSString *)zz_toJSONStringBySystemAPI {
    
    NSString *jsonString = nil;
    NSError *error;
    // options : Pass 0 if you don't care about the readability of the generated string
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
