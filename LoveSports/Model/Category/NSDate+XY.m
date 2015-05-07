//
//  NSDate+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#ifndef DUMMY_CLASS
#define DUMMY_CLASS(UNIQUE_NAME) \
@interface DUMMY_CLASS_##UNIQUE_NAME : NSObject @end \
@implementation DUMMY_CLASS_##UNIQUE_NAME @end
#endif

#import "NSDate+XY.h"
#import <objc/runtime.h>

DUMMY_CLASS(NSDate_XY);

#define NSDate_key_stringCache	"NSDate.stringCache"

@implementation NSDate (XY)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;
@dynamic stringCache;

#pragma mark - private
+ (NSCalendar *)AZ_currentCalendar
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar = [dictionary objectForKey:@"AZ_currentCalendar"];
    if (currentCalendar == nil)
    {
        currentCalendar = [NSCalendar currentCalendar];
        [dictionary setObject:currentCalendar forKey:@"AZ_currentCalendar"];
    }
    
    return currentCalendar;
}

#pragma mark -

- (NSInteger)year
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)day
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)hour
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)minute
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)second
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

- (NSInteger)weekday
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [self timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = [NSDate dateFormatterTemp];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:self];
	
#endif
}

- (NSString *)timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 2 * MINUTE)
	{
		return @"1分钟前";
	}
	else if (delta < 45 * MINUTE)
	{
		int minutes = floor((double)delta/MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 90 * MINUTE)
	{
		return @"1小时前";
	}
	else if (delta < 24 * HOUR)
	{
		int hours = floor((double)delta/HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 48 * HOUR)
	{
		return @"昨天";
	}
	else if (delta < 30 * DAY)
	{
		int days = floor((double)delta/DAY);
		return [NSString stringWithFormat:@"%d天前", days];
	}
	else if (delta < 12 * MONTH)
	{
		int months = floor((double)delta/MONTH);
		return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
	}
    
	int years = floor((double)delta/MONTH/12.0);
	return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

+ (long long)timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)dateWithString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@" "];
    
    if (array)
    {
        if (array.count == 1)
        {
            NSString *dateString = [NSString stringWithFormat:@"%@ 00:00:00", string];
            NSDate *date = [NSDate dateWithString:dateString];
            // 加上当前时区
            date = [date dateByAddingTimeInterval:[NSDate timeZone] * 3600];
            
            return date;
        }
        else if (array.count == 2)
        {
            return [NSDate stringToDate:string];
        }
        else
        {
            return [NSDate date];
        }
    }
    
    return [NSDate date];
}

+ (NSDate *)now
{
	return [NSDate date] ;
}

- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return dateAfterDay;
}

- (NSInteger)distanceInDaysToDate:(NSDate *)aDate
{
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:self toDate:aDate options:0];
    return [dateComponents day];
}

///////////////////////////
- (NSString *)stringCache
{
    NSString *str = (NSString *)objc_getAssociatedObject(self, NSDate_key_stringCache);
    if (str == nil)
    {
       return [self resetStringCache];
    }
    
    return str;
}

- (NSString *)resetStringCache
{
    NSDateFormatter * dateFormatter = [NSDate dateFormatterByUTC];
    NSString *str = [dateFormatter stringFromDate:self];
    
    objc_setAssociatedObject(self, NSDate_key_stringCache, str, OBJC_ASSOCIATION_COPY);
    
    return str;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return format;
}

+ (NSDateFormatter *)dateFormatterTemp
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return format;
}

+ (NSDateFormatter *)dateFormatterByUTC
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    return format;
}

- (NSString *)dateToString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 所有得时间都按格林的时间，无需转换。结果一样
    // 如果本身需要具体的时间。可以转换成GMT
    // NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    // [dateFormatter setTimeZone:timeZone];
    
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}

- (NSArray *)dateToArray
{
    return [[self dateToString] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]];
}

- (BOOL)isSameWithDate:(NSDate *)date
{
    return [NSDate twoDateIsSameDay:self second:date];
}

+ (NSDate *)stringToDate:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 所有得时间都按格林的时间，无需转换。结果一样
    // 如果本身需要具体的时间。可以转换成GMT
    // NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    // [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

+ (NSInteger)timeZone
{
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    
    return tz.secondsFromGMT / 3600;
}

+ (NSString *)stringToAge:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval dateDiff = [[dateFormatter dateFromString:dateString] timeIntervalSinceNow];
    
    int age = trunc(dateDiff / (60 * 60 * 24)) / 365;
    return [NSString stringWithFormat:@"%d%@", abs(age), LS_Text(@"Age-year")];
}

- (NSInteger)compareOtherData:(NSDate *)date
{
    NSTimeInterval time1 = [self timeIntervalSince1970];
    NSTimeInterval time2 = [date timeIntervalSince1970];
    if (time1 == time2)
    {
        return 0;
    }
    else if (time2 > time1)
    {
        return 1;
    }
    else
    {
        return -1;
    }
}

/* 判断date_是否在当前星期 */

+ (BOOL)isDateThisWeek:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal =[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&start
                         interval: &extends forDate:today];
    
    if(!success)
    {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isDateThisMonth:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitMonth
                        startDate: &start
                         interval: &extends forDate:today];
    
    if(!success)
    {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)isDateThisYear:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitYear
                        startDate: &start
                         interval: &extends forDate:today];
    
    if(!success)
    {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate_
                   second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components:unit fromDate:secondDate_];
    
    if ([fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)twoDateIsSameMonth:(NSDate *)fistDate_
                    second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components:unit fromDate:secondDate_];
    
    if ([fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate_
                  second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
    NSDateComponents *fistComponets = [calendar components:unit
                                                 fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components:unit
                                                   fromDate:secondDate_];
    
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

+ (NSUInteger)numberDaysInMonthOfDate:(NSDate *)date_
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:date_];
    
    return range.length;
    
}

+ (NSDate *)dateByAddingComponents:(NSDate *)date_
                  offsetComponents:(NSDateComponents *)offsetComponents_
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents_
                                                        toDate:date_
                                                       options:0];
    
    return endOfWorldWar3;
}

+ (NSDate *)startDateInMonthOfDate:(NSDate *)date_
{
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                          startDate:&beginningOfMonth
                           interval:&interval
                            forDate:date_];
    
    if (ok)
    {
        return beginningOfMonth;
    }
    else
    {
        return nil;
    }
}

+ (NSDate *)endDateInMonthOfDate:(NSDate *)date_
{
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                          startDate:&beginningOfMonth
                           interval:&interval
                            forDate:date_];
    
    if (ok)
    {
        NSDate *endDate = [beginningOfMonth dateByAddingTimeInterval:interval];
        
        return endDate;
    }
    else
    {
        return nil;
    }
}

@end








