//
//  monthModel.m
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "MonthModel.h"

@implementation MonthModel


/**
 *  初始化一个月模型
 *
 *  @param monthNumber 这个星期是那一年的第几月
 *  @param andYearNumber 表示是哪一年
 *
 *  @return 月模型
 */
- (instancetype)initWithmonthNumber:(NSInteger ) monthNumber
                     andYearNumber: (NSInteger ) yearNumber
{
    self = [super init];
    if (self) {
        _monthNumber = monthNumber;
        _yearNumber = yearNumber;
        
        _showDate = [NSString stringWithFormat:@"%ld/%ld月", (long)yearNumber, (long)monthNumber];
    }
    return self;
}

/**
 *  更新汇总信息
 */
- (void) updateInfo
{
    _monthTotalCalories = 0;
    _monthTotalDistance = 0;
    _monthTotalSteps = 0;
}

- (void)updateTotalWithModel:(PedometerModel *)model
{
    NSString *dateString = [[[NSDate date] dateToString] componentsSeparatedByString:@" "][0];

    if ([dateString isEqualToString:model.dateString])
    {
        _todaySteps = model.totalSteps;
        _toadyCalories = model.totalCalories;
        _todayDistance = model.totalDistance;
    }
    else
    {
        _monthTotalSteps += model.totalSteps;
        _monthTotalCalories += model.totalCalories;
        _monthTotalDistance += model.totalDistance;
    }
}

// 表名
+ (NSString *)getTableName
{
    return @"MonthModel";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"monthNumber", @"yearNumber", @"userName", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

