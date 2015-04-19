//
//  WeekModel.m
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "WeekModel.h"

@implementation SubOfPedometerModel

@synthesize _thisDayTotalCalories, _thisDayTotalDistance, _thisDayTotalSteps;

/**
 *  更新此子模型的信息通过传入的pedometerModel模型
 *
 *  @param onePedometerModel 传入的pedometerModel模型
 */
- (void) updateInfoFromAPedometerModel: (PedometerModel *) onePedometerModel
{
    _thisDayTotalSteps = onePedometerModel.totalSteps;
    _thisDayTotalDistance = onePedometerModel.totalDistance;
    _thisDayTotalCalories = onePedometerModel.totalCalories;
}

@end

@implementation WeekModel

/**
 *  初始化一个星期模型
 *
 *  @param weekNumber 这个星期是那一年的第几周
 *  @param andYearNumber 表示是哪一年
 *
 *  @return 星期模型
 */
- (instancetype)initWithWeekNumber:(NSInteger ) weekNumber
                     andYearNumber: (NSInteger ) yearNumber
{
    self = [super init];
    if (self) {
        _weekNumber = weekNumber;
        _yearNumber = yearNumber;
        
        _showDate = [NSString stringWithFormat:@"%ld/%ld周", (long)yearNumber, (long)weekNumber];
    }
    return self;
}


/**
 *  更新汇总信息
 */
- (void) updateInfo
{
    _weekTotalCalories = 0;
    _weekTotalDistance = 0;
    _weekTotalSteps = 0;
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
        _weekTotalSteps += model.totalSteps;
        _weekTotalCalories += model.totalCalories;
        _weekTotalDistance += model.totalDistance;
    }
}

// 表名
+ (NSString *)getTableName
{
    return @"WeekModel";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"weekNumber", @"yearNumber", @"userName", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
