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
 */
- (BOOL)zz_hasType:(NSInteger)type {
    
    return (_status & type) == type;
}

/**
 *  status是否是包含type类型
 *  type类型由A|B|...|N等subType组成，包含任意一个subType返回true；否则为false
 */
- (BOOL)zz_hasAnySubType:(NSInteger)type {
    
    return (_status & type) == type;
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

@end
