//
//  NSDate+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSDate+ZZKit.h"

@implementation NSDate (ZZKit)

#pragma mark - Calendar和DisplayFormatter初始化方法

static NSCalendar      *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)_initial {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
                _calendar = [NSCalendar currentCalendar];
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
                [_displayFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            }
        }
    });
}

#pragma mark - 共享对象

+ (NSCalendar *)sharedCalendar {
    
    [self _initial];
    return _calendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
    
    [self _initial];
    return _displayFormatter;
}

#pragma mark - 类方法

/**
 *  当前NSDate的TimeStampSince1970
 */
+ (NSTimeInterval)zz_dateTimeStampSince1970 {
    
    return [[NSDate date] timeIntervalSince1970];
}

/**
 *  当前NSDate的TimeStampSince1970(MilliSecond)
 */
+ (NSTimeInterval)zz_dateTimeStampMilliSecondSince1970 {
    
    return [NSDate zz_dateTimeStampSince1970] * 1000.0;
}

/**
 *  根据年月获取月的天数
 */
+ (NSInteger)zz_dateNumberAllDays:(NSInteger)year month:(NSInteger)month {
    
    NSAssert(month >= 1 && month <= 12, @"month范围为1到12");
    if( month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        return 31;
    }else if( month == 4 || month == 6 || month == 9 || month == 11 ) {
        return 30;
    }else {
        if( year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            // 闰年
            return 29;
        }else {
            return 28;
        }
    }
}

/**
 *  根据年获取年的天数
 */
+ (NSInteger)zz_dateNumberAllDays:(NSInteger)year {
    
    NSInteger days = 0;
    for (NSInteger month = 1; month <= 12; month++) {
        days += [NSDate zz_dateNumberAllDays:year month:month];
    }
    return days;
}

/**
 *  当前NSDate是今年的第几天
 */
+ (NSInteger)zz_dateNumberWhichDayThisYear {
    
    NSInteger days = 0;
    NSInteger year = [[NSDate zz_dateString:ZZDateFormatYear] integerValue];
    for (NSInteger month = 1 ; month < [[NSDate zz_dateString:ZZDateFormatMonth] integerValue]; month++) {
        days += [NSDate zz_dateNumberAllDays:year month:month];
    }
    days += [[NSDate zz_dateString:ZZDateFormatDay] integerValue];
    return days;
}

/**
 *  当前NSDate是这周的第几天(0~6，Sunday~Saturday)
 */
+ (NSInteger)zz_dateNumberWhichDayOfThisWeek {
    
    NSDate *date = [NSDate date];
    NSDateComponents *weekComp = [[NSDate sharedCalendar] components:NSCalendarUnitWeekday fromDate:date];
    return [weekComp weekday] - 1;
}

/**
 *  timeStamp是当周的第几天(0~6，Sunday~Saturday)
 */
+ (NSInteger)zz_dateNumberWhichDayOfWeekFromTimeStamp:(NSTimeInterval)timeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateComponents *weekComp = [[NSDate sharedCalendar] components:NSCalendarUnitWeekday fromDate:date];
    return [weekComp weekday] - 1;
}

/**
 *  当前NSDate的默认格式化时间字符串
 */
+ (NSString *)zz_dateString {
    
    return [NSDate zz_dateStringFromDate:[NSDate date] format:ZZDateFormatSQLDateWithTime];
}

/**
 *  当前NSDate的format格式化时间字符串
 */
+ (NSString *)zz_dateString:(NSString *)format {
    
    return [NSDate zz_dateStringFromDate:[NSDate date] format:format];
}

/**
 *  给定date的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromDate:(NSDate *)date format:(NSString *)format {
    
    [[NSDate sharedDateFormatter] setDateFormat:format];
    return [[NSDate sharedDateFormatter] stringFromDate:date];
}

/**
 *  给定timeStamp的默认格式化时间字符串
 */
+ (NSString *)zz_dateStringFromTimeStamp:(NSTimeInterval)timeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    [[NSDate sharedDateFormatter] setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [[NSDate sharedDateFormatter] stringFromDate:date];
    return dateString;
}

/**
 *  给定timeStamp的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromTimeStamp:(NSTimeInterval)timeStamp format:(NSString *)format {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString *dateString = [NSDate zz_dateStringFromDate:date format:format];
    return dateString;
}

/**
 *  给定dateString和inputFormat格式化，输出outputFormat格式化时间字符串
 */
+ (NSString *)zz_dateStringFromDateString:(NSString *)inputDateString inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat {
    
    NSDate *date = [NSDate zz_dateFromDateString:inputDateString format:inputFormat];
    NSString *outputDateString = [NSDate zz_dateStringFromDate:date format:outputFormat];
    return outputDateString;
}

/**
 *  给定timeStamp的微信风格格式化时间字符串
 */
+ (NSString *)zz_dateStringWechatStyleFromTimeStamp:(NSTimeInterval)timeStamp {
    
    NSTimeInterval now = [NSDate zz_dateTimeStampSince1970];
    NSTimeInterval result = now - timeStamp;
    NSInteger day, hour, minute;
    NSString *postTime = [NSDate zz_dateStringFromTimeStamp:timeStamp format:@"yyyy-MM-dd HH:mm"];
    day = result / 86400;
    if ( day >= 7 ) {
        // 2015-08-25 18:00
        postTime = [NSDate zz_dateStringFromTimeStamp:timeStamp format:@"yyyy-MM-dd HH:mm"];
    }else if ( day >= 2){
        // 大于48小时 小于7天
        postTime = [NSString stringWithFormat:@"%ld天前", day];
    }else if ( day >= 1){
        // 昨天
        postTime =@"昨天";
    }else {
        // 今天
        hour = (result - (day * 86400))/ 3600;
        if (hour>=1) {// 一小时前
            postTime = [NSString stringWithFormat:@"%ld小时前", hour];
        }else {// 一小时以内
            minute = (result - (day*86400) - (hour*3600))/60;
            postTime = [NSString stringWithFormat:@"%ld分钟前", minute];
        }
    }
    return postTime;
}

/**
 *  给定date的Display风格格式化时间字符串（默认无prefix）
 */
+ (NSString *)zz_dateStringDisplayFromDate:(NSDate *)date {
    
    return [self zz_dateStringDisplayFromDate:date prefixed:NO];
}

/**
 *  给定date的Display风格格式化时间字符串（prefix）
 */
+ (NSString *)zz_dateStringDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    
    return [NSDate zz_dateStringDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

/**
 *  给定date的Display风格格式化时间字符串
 */
+ (NSString *)zz_dateStringDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    
    NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    NSDate *midnight = [[NSDate sharedCalendar] dateFromComponents:offsetComponents];
    NSString *displayString = nil;
    // comparing against midnight
    NSComparisonResult midnight_result = [date compare:midnight];
    if (midnight_result == NSOrderedDescending) {
        if (prefixed) {
            [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatTimeWithPrefix]; // at 11:30 am
        } else {
            [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatTime]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [[NSDate sharedCalendar] dateByAddingComponents:componentsToSubtract toDate:today options:0];
#if !__has_feature(objc_arc)
        [componentsToSubtract release];
#endif
        NSComparisonResult lastweek_result = [date compare:lastweek];
        if (lastweek_result == NSOrderedDescending) {
            if (displayTime) {
                [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatWeekdayWithTime];
            } else {
                [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatWeekday]; // Tuesday
            }
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            NSDateComponents *dateComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                if (displayTime) {
                    [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatShortDateWithTime];
                }
                else {
                    [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatShortDate];
                }
            } else {
                if (displayTime) {
                    [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatFullDateWithTime];
                }else {
                    [[NSDate sharedDateFormatter] setDateFormat:ZZDateFormatFullDate];
                }
            }
        }
        if (prefixed) {
            NSString *dateFormat = [[NSDate sharedDateFormatter] dateFormat];
            NSString *prefix = @"'on' ";
            [[NSDate sharedDateFormatter] setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    // use display formatter to return formatted date string
    displayString = [[NSDate sharedDateFormatter] stringFromDate:date];
    return displayString;
}

/**
 *  当前NSDate的偏移天数的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromOffsetDays:(NSInteger)days format:(NSString *)format {
    
    return [NSDate zz_dateStringFromOffsetMinutes:24 * 60 * days format:format];
}

/**
 *  当前NSDate的偏移小时数的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromOffsetHours:(NSInteger)hours format:(NSString *)format {
    
    return [NSDate zz_dateStringFromOffsetMinutes:60 * hours format:format];
}

/**
 *  当前NSDate的偏移分钟数的format格式化时间字符串
 */
+ (NSString *)zz_dateStringFromOffsetMinutes:(NSInteger)minutes format:(NSString *)format {
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    timeInterval += 60 * minutes;
    date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [NSDate zz_dateStringFromDate:date format:format];
    return dateString;
}

/**
 *  根据dateString和format格式化获取NSDate
 */
+ (NSDate *)zz_dateFromDateString:(NSString *)dateString format:(NSString *)format {
    
    [[NSDate sharedDateFormatter] setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [[NSDate sharedDateFormatter] setDateFormat:format];
    return [[NSDate sharedDateFormatter] dateFromString:dateString];
}

/**
 *  根据二十四小时制小时、分、秒获取NSDate
 */
+ (NSDate *)zz_dateFromHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    return [NSDate zz_dateFromOffsetDays:0 hour:hour minute:minute second:second];
}

/**
 *  根据偏移天数、二十四小时制小时、分、秒获取NSDate
 */
+ (NSDate *)zz_dateFromOffsetDays:(NSInteger)offsetDays hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSDateComponents *components = [[NSDate sharedCalendar] components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    [components setHour:-[components hour] + hour + offsetDays * 24];
    [components setMinute:-[components minute] + minute];
    [components setSecond:-[components second] + second];
    NSDate *someDate = [[NSDate sharedCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    return someDate;
}

/**
 *  根据年、月、日、二十四小时制小时、分、秒获取NSDate
 */
+ (NSDate *)zz_dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSDateComponents *components = [[NSDate sharedCalendar] components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  ) fromDate:[NSDate date]];
    [components setHour:-[components hour]+hour];
    [components setMinute:-[components minute]+minute];
    [components setSecond:-[components second]+second];
    NSDate *today = [[NSDate sharedCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    [[NSDate sharedDateFormatter] setDateFormat:@"HH:mm:ss"];
    NSString *currentStr = [[NSDate sharedDateFormatter] stringFromDate:today];
    [[NSDate sharedDateFormatter] setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSMutableString *newDateStr = [[NSMutableString alloc] init];
    [newDateStr appendString:[NSString stringWithFormat:@"%ld/%ld/%ld %@", year, month, day, currentStr]];
    return [[NSDate sharedDateFormatter] dateFromString:newDateStr];
}

/**
 *  日期date是否是days天之前
 */
+ (BOOL)zz_dateBoolDate:(NSDate *)date passedby:(NSInteger)days {
    
    NSDate *now = [NSDate date];
    // one day = 60 * 60 * 24 (seconds)
    // date passed by N days
    NSInteger seconds = 60 * 60 * 24 * days;
    NSDate *dateAfterDays = [NSDate dateWithTimeInterval:seconds sinceDate:date];
    if ([dateAfterDays timeIntervalSinceDate:now] < 0.0f) {
        // date是N天以前
        return YES;
    }
    // date不是N天以前
    return NO;
}

#pragma mark - 实例方法

/**
 *  当前NSDate的TimeStampSince1970
 */
- (NSTimeInterval)zz_timeStampUTC {
    
    return lround(floor([self timeIntervalSince1970]));
}

/**
 *  当前NSDate的多少天前（正数为过去，负数为未来）
 */
- (NSInteger)zz_numberDaysAgo {
    
    NSDateComponents *components = [[NSDate sharedCalendar] components:(NSCalendarUnitDay) fromDate:self toDate:[NSDate date] options:0];
    return [components day];
}

/**
 *  当天Midnight的多少天前（正数为过去，负数为未来）
 */
- (NSInteger)zz_numberDaysAgoAgainstMidnight {
    
    NSDateFormatter *mdf = [NSDate sharedDateFormatter];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    return [midnight timeIntervalSinceNow] / ( 60 * 60 * 24) * -1;
}

/**
 *  当前NSDate的年
 */
- (NSInteger)zz_numberYear {
    
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitYear) fromDate:self];
    return [weekdayComponents year];
}

/**
 *  当前NSDate的月
 */
- (NSInteger)zz_numberMonth {
    
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitMonth) fromDate:self];
    return [weekdayComponents month];
}

/**
 *  当前NSDate的日
 */
- (NSInteger)zz_numberDay {
    
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitDay) fromDate:self];
    return [weekdayComponents day];
}

/**
 *  当前NSDate的时
 */
- (NSInteger)zz_numberHour {
    
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitHour) fromDate:self];
    return [weekdayComponents hour];
}

/**
 *  当前NSDate的分
 */
- (NSInteger)zz_numberMinute {
    
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitMinute) fromDate:self];
    return [weekdayComponents minute];
}

/**
 *  当前NSDate的秒
 */
- (NSInteger)zz_numberSecond {
    
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(NSCalendarUnitSecond) fromDate:self];
    return [weekdayComponents second];
}

/**
 *  当前NSDate的Weekday
 */
- (NSInteger)zz_numberWeekday {
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitNanosecond |
    NSCalendarUnitCalendar |
    NSCalendarUnitTimeZone;
    NSDateComponents *weekdayComponents = [[NSDate sharedCalendar] components:(unitFlags) fromDate:self];
    return ([weekdayComponents weekday] + 5 ) % 7;
}

/**
 *  当前NSDate的WeekOfMonth
 */
- (NSInteger)zz_numberWeekOfMonth {
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitNanosecond |
    NSCalendarUnitCalendar |
    NSCalendarUnitTimeZone;
    NSDateComponents *dateComponents = [[NSDate sharedCalendar] components:(unitFlags) fromDate:self];
    return [dateComponents weekOfMonth];
}

/**
 *  当前NSDate的WeekOfYear
 */
- (NSInteger)zz_numberWeekOfYear {
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitNanosecond |
    NSCalendarUnitCalendar |
    NSCalendarUnitTimeZone;
    NSDateComponents *dateComponents = [[NSDate sharedCalendar] components:(unitFlags) fromDate:self];
    return [dateComponents weekOfYear];
}

/**
 *  当前NSDate的默认格式化的时间字符串
 */
- (NSString *)zz_string {
    
    return [self zz_stringWithFormat:ZZDateFormatSQLDateWithTime];
}

/**
 *  当前NSDate的ISO8601格式化的时间字符串
 */
- (NSString *)zz_stringWithFormatISO8601 {
    
    return [self zz_stringWithFormat:ZZDateFormatISO8601];
}

/**
 *  当前NSDate的format格式化的时间字符串
 */
- (NSString *)zz_stringWithFormat:(NSString *)format {
    
    [[NSDate sharedDateFormatter] setDateFormat:format];
    NSString *timestampStr = [[NSDate sharedDateFormatter] stringFromDate:self];
    return timestampStr;
}

/**
 *  当前NSDate，以dateStyle的Date格式化的，timeStyle的Time格式化输出的时间字符串
 */
- (NSString *)zz_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    
    [[NSDate sharedDateFormatter] setDateStyle:dateStyle];
    [[NSDate sharedDateFormatter] setTimeStyle:timeStyle];
    NSString *outputString = [[NSDate sharedDateFormatter] stringFromDate:self];
    return outputString;
}

/**
 *  当前NSDate的多少天前（正数为过去，负数为未来）
 */
- (NSString *)zz_stringDaysAgo {
    
    return [self zz_stringDaysAgoAgainstMidnight:NO];
}

/**
 *  当天Midnight的多少天前（正数为过去，负数为未来）
 */
- (NSString *)zz_stringDaysAgoAgainstMidnight {
    
    return [self zz_stringDaysAgoAgainstMidnight:NO];
}

/**
 *  是否Midnight或当前NSDate的多少天前（正数为过去，负数为未来）
 */
- (NSString *)zz_stringDaysAgoAgainstMidnight:(BOOL)flag {
    
    NSUInteger daysAgo = (flag) ? [self zz_numberDaysAgoAgainstMidnight] : [self zz_numberDaysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = NSLocalizedString(@"Today", nil);
            break;
        case 1:
            text = NSLocalizedString(@"Yesterday", nil);
            break;
        default:
            text = [NSString stringWithFormat:@"%ld days ago", daysAgo];
    }
    return text;
}

/**
 *  当前NSDate的当天起始时间（Midnight）
 */
- (NSDate *)zz_dateBeginningOfDay {
    
    NSCalendar *calendar = [NSDate sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [calendar dateFromComponents:components];
}

/**
 *  当前NSDate的当周第一天（Midnight）
 */
- (NSDate *)zz_dateBeginningOfWeek {
    
    NSCalendar *calendar = [NSDate sharedCalendar];
    NSDate *beginningOfWeek = nil;
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginningOfWeek interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];
}

/**
 *  当前NSDate的当周最后一天（非Midnight）
 */
- (NSDate *)zz_dateEndOfWeek {
    
    NSCalendar *calendar = [NSDate sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return endOfWeek;
}

@end
