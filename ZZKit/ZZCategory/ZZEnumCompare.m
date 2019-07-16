//
//  ZZEnumCompare.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZEnumCompare.h"

@interface ZZEnumCompare ()

@property (nonatomic, assign) NSInteger status;

@end

@implementation ZZEnumCompare

/**
 *  获取status
 */
- (NSInteger)zz_status {
    
    return self.status;
}

/**
 *  type类型是否在status中存在
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType全部包含在status中返回true；否则为false
 */
- (BOOL)zz_hasType:(NSInteger)type {
    
    return (_status & type) == type;
}

/**
 *  type类型是否在status中存在某个子subType或全部
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType任意一个包含在status中返回true；否则为false
 */
- (BOOL)zz_hasAnySubType:(NSInteger)type {
    
    return _status & type;
}

/**
 *  添加type到status
 */
- (void)zz_addType:(NSInteger)type {
    
    _status |= type;
}

/**
 *  从status中移除type
 */
- (void)zz_removeType:(NSInteger)type {
    
    _status = _status & ~type;
}

/**
 *  设置status为type
 */
- (void)zz_setType:(NSInteger)type {
    
    self.status = type;
}

/**
 *  type类型是否在status中存在
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType全部包含在status中返回true；否则为false
 */
+ (BOOL)zz_has:(NSInteger)type aType:(NSInteger)aType {
    
    return (type & aType) == aType;
}

/**
 *  type类型是否在status中存在某个子subType或全部
 *  type类型由A|B|...|N等限定枚举类型的任意一个或多个subType组成，
 *  组成type的subType任意一个包含在status中返回true；否则为false
 */
+ (BOOL)zz_has:(NSInteger)type anySubType:(NSInteger)anySubType {
    
    return type & anySubType;
}

@end
