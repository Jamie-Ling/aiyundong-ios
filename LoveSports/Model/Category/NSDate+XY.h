//
//  NSDate+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

#import <Foundation/Foundation.h>

@interface NSDate (XY)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)timeAgo;

+ (long long)timeStamp;

// 优先使用这个转换，字符串转日期
+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)now;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

// 时间字符串转年龄
+ (NSString *)stringToAge:(NSString *)dateString;

// 返回距离aDate有多少天
- (NSInteger)distanceInDaysToDate:(NSDate *)aDate;

// UTC时间string缓存
@property (nonatomic, copy, readonly) NSString *stringCache;
// 重置缓存
- (NSString *)resetStringCache;
- (NSString *)dateToString;
+ (NSDate *)stringToDate:(NSString *)timeString;
- (NSArray *)dateToArray;
- (BOOL)isSameWithDate:(NSDate *)date;
+ (CGFloat)timeZone;
- (NSInteger)compareOtherData:(NSDate *)date;
+ (BOOL)isDateThisWeek:(NSDate *)date;
+ (BOOL)isDateThisMonth:(NSDate *)date_;

@end
