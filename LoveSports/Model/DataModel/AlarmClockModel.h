//
//  AlarmClockModel.h
//  LoveSports
//
//  Created by zorro on 15/4/4.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define ACM_WeekFont 12
#import <Foundation/Foundation.h>

@interface AlarmClockModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSString *alarmTime;
@property (nonatomic, strong) NSArray *weekArray;

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) UInt8 repeat;

@property (nonatomic, assign) CGFloat height;   // 如果选了7天可能需要2行。
@property (nonatomic, assign) NSInteger orderIndex;

/**
 *  得到一个代表星期几的Uint8
 *
 *  @param weekNumber 0~7，1：代表每周一, 0代表无
 *
 *  @return 得到的Uint8
 */
+ (UInt8) getAUint8FromeWeekNumber: (NSInteger) weekNumber;

/**
 *  设置所有时间（时分秒&重复周期）
 *
 *  @param timeString  格式：23:01 或者  23:01:45
 *  @param repeatUntStringArray 装uint8的字符串数组如【@"1", @"2"】,代表每周一周二重复
 *  @param isFullWeekDay  是否是每天重复（周1至周日全部重复）
 */
- (void) setAllTimeFromTimeString: (NSString *) timeString
         withRepeatUntStringArray: (NSArray *) repeatUntStringArray
                  withFullWeekDay: (BOOL) isFullWeekDay;

+ (NSArray *)getAlarmClockFromDBWithUUID:(NSString *)uuid;
- (NSString *)weekArrayToString;
- (NSArray *)sortByNumberWithArray:(NSArray *)array withSEC:(BOOL)sec;
- (NSString *)showStringForWeekDay;
- (void)convertToBLTNeed;

@end
