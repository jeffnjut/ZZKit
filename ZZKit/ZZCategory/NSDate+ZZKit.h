//
//  NSDate+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZZDateFormatFullDateWithTime    @"MMM d, yyyy h:mm a"
#define ZZDateFormatFullDate            @"MMM d, yyyy"
#define ZZDateFormatShortDateWithTime   @"MMM d h:mm a"
#define ZZDateFormatShortDate           @"MMM d"
#define ZZDateFormatWeekday             @"EEEE"
#define ZZDateFormatWeekdayWithTime     @"EEEE h:mm a"
#define ZZDateFormatTime                @"h:mm a"
#define ZZDateFormatTimeWithPrefix      @"'at' h:mm a"
#define ZZDateFormatSQLDate             @"yyyy-MM-dd"
#define ZZDateFormatSQLTime             @"HH:mm:ss"
#define ZZDateFormatSQLDateWithTime     @"yyyy-MM-dd HH:mm:ss"
#define ZZDateFormatYear                @"yyyy"
#define ZZDateFormatMonth               @"MM"
#define ZZDateFormatDay                 @"dd"
#define ZZDateFormatHour24System        @"HH"
#define ZZDateFormatHour12System        @"hh"
#define ZZDateFormatISO8601             @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZZKit)

#pragma mark - 共享对象

+ (NSCalendar *)sharedCalendar;

+ (NSDateFormatter *)sharedDateFormatter;

#pragma mark - 类方法

/**
 *  当前NSDate的TimeStampSince1970
 */
+ (NSTimeInterval)zz_dateTimeStampSince1970;

/**
 *  当前NSDate的TimeStampSince1970(MilliSecond)
 */
+ (NSTimeInterval)zz_dateTimeStampMilliSecondSince1970;

/**
 *  根据年月获取月的天数
 */
+ (NSInteger)zz_dateNumberAllDays:(NSInteger)year month:(NSInteger)month;

/**
 *  根据年获取年的天数
 */
+ (NSInteger)zz_dateNumberAllDays:(NSInteger)year;

/**
 *  当前NSDate是今年的第几天
 */
+ (NSInteger)zz_dateNumberWhichDayThisYear;

/**
 *  当前NSDate是这周的第几天(0~6，Sunday~Saturday)
 */
+ (NSInteger)zz_dateNumberWhichDayOfThisWeek;

/**
 *  timeStamp是当周的第几天(0~6，Sunday~Saturday)
 */
+ (NSInteger)zz_dateNumberWhichDayOfWeekFromTimeStamp:(NSTimeInterval)timeStamp;

/**
 *  当前NSDate的TimeStampSince1970的字符串
 */
+ (NSString *)zz_dateStringTimeStampSince1970;

/**
 *  当前NSDate的默认格式化时间字符串
 */
+ (NSString *)zz_dateString;

/**
 *  当前NSDate的format格式化时间字符串
 */
+ (NSString *)zz_dateString:(NSString *)format;

/**
 *  给定date的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromDate:(NSDate *)date format:(NSString *)format;

/**
 *  给定timeStamp的默认格式化时间字符串
 */
+ (NSString *)zz_dateStringFromTimeStamp:(NSTimeInterval)timeStamp;

/**
 *  给定timeStamp的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromTimeStamp:(NSTimeInterval)timeStamp format:(NSString *)format;

/**
 *  给定dateString和inputFormat格式化，输出outputFormat格式化时间字符串
 */
+ (NSString *)zz_dateStringFromDateString:(NSString *)inputDateString inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat;

/**
 *  给定timeStamp的微信风格格式化时间字符串
 */
+ (NSString *)zz_dateStringWechatStyleFromTimeStamp:(NSTimeInterval)timeStamp;

/**
 *  给定date的Display风格格式化时间字符串（默认无prefix）
 */
+ (NSString *)zz_dateStringDisplayFromDate:(NSDate *)date;

/**
 *  给定date的Display风格格式化时间字符串（prefix）
 */
+ (NSString *)zz_dateStringDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

/**
 *  给定date的Display风格格式化时间字符串
 */
+ (NSString *)zz_dateStringDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;

/**
 *  当前NSDate的偏移天数的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromOffsetDays:(NSInteger)days format:(NSString *)format;

/**
 *  当前NSDate的偏移小时数的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromOffsetHours:(NSInteger)hours format:(NSString *)format;

/**
 *  当前NSDate的偏移分钟数的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromOffsetMinutes:(NSInteger)minutes format:(NSString *)format;

/**
 *  根据dateString和format格式化获取NSDate
 */
+ (NSDate *)zz_dateFromDateString:(NSString *)dateString format:(NSString *)format;

/**
 *  根据二十四小时制小时、分、秒获取NSDate
 */
+ (NSDate *)zz_dateFromHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/**
 *  根据偏移天数、二十四小时制小时、分、秒获取NSDate
 */
+ (NSDate *)zz_dateFromOffsetDays:(NSInteger)offsetDays hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/**
 *  根据年、月、日、二十四小时制小时、分、秒获取NSDate
 */
+ (NSDate *)zz_dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/**
 *  日期date是否是days天之前
 */
+ (BOOL)zz_dateBoolDate:(NSDate *)date passedby:(NSInteger)days;

#pragma mark - 实例方法

/**
 *  当前NSDate的TimeStampSince1970
 */
- (NSTimeInterval)zz_timeStampUTC;

/**
 *  当前NSDate的多少天前（正数为过去，负数为未来）
 */
- (NSInteger)zz_numberDaysAgo;

/**
 *  当天Midnight的多少天前（正数为过去，负数为未来）
 */
- (NSInteger)zz_numberDaysAgoAgainstMidnight;

/**
 *  当前NSDate的年
 */
- (NSInteger)zz_numberYear;

/**
 *  当前NSDate的月
 */
- (NSInteger)zz_numberMonth;

/**
 *  当前NSDate的日
 */
- (NSInteger)zz_numberDay;

/**
 *  当前NSDate的时
 */
- (NSInteger)zz_numberHour;

/**
 *  当前NSDate的分
 */
- (NSInteger)zz_numberMinute;

/**
 *  当前NSDate的秒
 */
- (NSInteger)zz_numberSecond;

/**
 *  当前NSDate的Weekday
 */
- (NSInteger)zz_numberWeekday;

/**
 *  当前NSDate的WeekOfMonth
 */
- (NSInteger)zz_numberWeekOfMonth;

/**
 *  当前NSDate的WeekOfYear
 */
- (NSInteger)zz_numberWeekOfYear;

/**
 *  当前NSDate的默认格式化的时间字符串
 */
- (NSString *)zz_string;

/**
 *  当前NSDate的ISO8601格式化的时间字符串
 */
- (NSString *)zz_stringWithFormatISO8601;

/**
 *  当前NSDate的format格式化的时间字符串
 */
- (NSString *)zz_stringWithFormat:(NSString *)format;

/**
 *  当前NSDate，以dateStyle的Date格式化的，timeStyle的Time格式化输出的时间字符串
 */
- (NSString *)zz_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

/**
 *  当前NSDate的多少天前（正数为过去，负数为未来）
 */
- (NSString *)zz_stringDaysAgo;

/**
 *  当天Midnight的多少天前（正数为过去，负数为未来）
 */
- (NSString *)zz_stringDaysAgoAgainstMidnight;

/**
 *  是否Midnight或当前NSDate的多少天前（正数为过去，负数为未来）
 */
- (NSString *)zz_stringDaysAgoAgainstMidnight:(BOOL)flag;

/**
 *  当前NSDate的当天起始时间（Midnight）
 */
- (NSDate *)zz_dateBeginningOfDay;

/**
 *  当前NSDate的当周第一天（Midnight）
 */
- (NSDate *)zz_dateBeginningOfWeek;

/**
 *  当前NSDate的当周最后一天（非Midnight）
 */
- (NSDate *)zz_dateEndOfWeek;

@end

NS_ASSUME_NONNULL_END
