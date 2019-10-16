//
//  ZZMacro.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#ifndef ZZMacro_h
#define ZZMacro_h

// Block Helper
#pragma mark - Block Helper

#if NS_BLOCKS_AVAILABLE
#define ZZ_BLOCK_CALL(b)                         (b == nil ? : b())
#define ZZ_BLOCK_CALL_1P(b, p)                   (b == nil ? : b(p) )
#define ZZ_BLOCK_CALL_2P(b, p1, p2)              (b == nil ? : b(p1, p2))
#define ZZ_BLOCK_CALL_3P(b, p1, p2 , p3)         (b == nil ? : b(p1, p2, p3))
#define ZZ_BLOCK_CALL_4P(b, p1, p2 , p3, p4)     (b == nil ? : b(p1, p2, p3, p4))
#define ZZ_BLOCK_CALL_5P(b, p1, p2 , p3, p4, p5) (b == nil ? : b(p1, p2, p3, p4, p5))
#endif

// String Helper
#pragma mark - String Helper

#define ZZ_STR_NULL_OR_EMPTY(str)             (str == nil || ((NSString *)str).length == 0)
#define ZZ_STR_NULL_OR_EMPTY_TRIMSPACE(str)   (str == nil || ((NSString *)str).length == 0 || [((NSString *)str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
#define ZZ_STR_FORMAT_OBJECT(object)          (object == nil ? @"" : [NSString stringWithFormat:@"%@",object])
#define ZZ_STR_FORMAT_INTEGER(num)            [NSString stringWithFormat:@"%ld",(long)(num)]
#define ZZ_STR_FORMAT_FLOAT_0_DECIMAL(num)    [NSString stringWithFormat:@"%f",num]
#define ZZ_STR_FORMAT_FLOAT_1_DECIMAL(num)    [NSString stringWithFormat:@"%.1f",num]
#define ZZ_STR_FORMAT_FLOAT_2_DECIMAL(num)    [NSString stringWithFormat:@"%.2f",num]
#define ZZ_STR_FORMAT_FLOAT_3_DECIMAL(num)    [NSString stringWithFormat:@"%.3f",num]
#define ZZ_STR_FORMAT_FLOAT_4_DECIMAL(num)    [NSString stringWithFormat:@"%.4f",num]
#define ZZ_STR_FORMAT_FLOAT_5_DECIMAL(num)    [NSString stringWithFormat:@"%.5f",num]
#define ZZ_STR_MERGE(a,b)                     [NSString stringWithFormat:@"%@%@",a,b]
#define ZZ_STR_TO_FLOAT_ACCURACY_1(num)       [NSString stringWithFormat:@"%.1f",num]
#define ZZ_STR_TO_FLOAT_ACCURACY_2(num)       [NSString stringWithFormat:@"%.2f",num]
#define ZZ_STR_TO_FLOAT_ACCURACY_3(num)       [NSString stringWithFormat:@"%.3f",num]
#define ZZ_STR_TO_FLOAT_ACCURACY_4(num)       [NSString stringWithFormat:@"%.4f",num]

// Object Helper
#define ZZ_OBJECT_NIL_TO_EMPTY(object)        (object == nil ? @"" : [NSString stringWithFormat:@"%@",object])
#define ZZ_OBJECT_ZERO(object)                (object == nil ? NO : object.intValue == 0)
#define ZZ_OBJECT_IS_KIND(object, class)      [object isKindOfClass:class]
#define ZZ_OBJECT_IS_MEMBER(object, class)    [object isMemberOfClass:class]

// Resouce Loading Helper
#pragma mark - Resouce Loading Helper

#define ZZ_LOAD_NIB(x)    [[[NSBundle bundleForClass:NSClassFromString(x)] loadNibNamed:x owner:nil options:nil] objectAtIndex:0]

// Log Helper
#pragma mark - Log Helper

#if DEBUG
#define ZZLog(...)          NSLog(@"### Macro Logging: %@", [NSString stringWithFormat:__VA_ARGS__]);
#else
#define ZZLog(...)
#endif

#define ZZ_LOG_FUNC_BEGIN   ZZLog(@"### Macro Begin:%s --- %s\n",__func__,__FILE__);
#define ZZ_LOG_FUNC_END     ZZLog(@"### Macro End  :%s --- %s\n",__func__,__FILE__);

#define ZZ_PERFORMANCE_INIT(f) \
long long pf_t = [[NSDate date] timeIntervalSince1970] * 1000; \
long long pf_d, pf_l = pf_t; \
NSString *pf_s = [NSString stringWithFormat:@"### Macro PERFORMANCE [%@] +++ Start\n", f]; \
NSLog(@"%@", pf_s);

#define ZZ_PERFORMANCE_LOG(f) \
pf_d = [[NSDate date] timeIntervalSince1970] * 1000; \
pf_s = [NSString stringWithFormat:@"### Macro PERFORMANCE [%@] +++ 耗时%lld(毫秒)  累计%lld(毫秒)\n", f, pf_d - pf_l, pf_d - pf_t]; \
NSLog(@"%@", pf_s); \
pf_l = pf_d;

// Weak、Strong Reference Helper
#pragma mark - Weak、Strong Reference Helper

#define ZZ_WEAK_SELF                    __weak typeof(self) weakSelf = self;
#define ZZ_STRONG_SELF                  __strong typeof(weakSelf) strongSelf = weakSelf;
#define ZZ_WEAK_OBJECT(o)               __weak typeof(o) weak##o = o;
#define ZZ_STRONG_OBJECT(o)             __strong typeof(o) strong##o = o;

// Info.plist Helper
#pragma mark - Info.plist Helper

#define ZZ_APP_NAME          ZZ_OBJECT_NIL_TO_EMPTY([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
#define ZZ_APP_VERSION       ZZ_OBJECT_NIL_TO_EMPTY([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define ZZ_BUNDLE_VERSION    ZZ_OBJECT_NIL_TO_EMPTY([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

// Window
#pragma mark - Window

#define ZZ_KEY_WINDOW                           [UIApplication sharedApplication].delegate.window

#define ZZ_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define ZZ_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#endif /* ZZMacro_h */
