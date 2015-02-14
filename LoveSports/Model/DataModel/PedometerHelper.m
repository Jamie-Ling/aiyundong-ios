//
//  PedometerHelper.m
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerHelper.h"

@implementation PedometerHelper

DEF_SINGLETON(PedometerHelper)

// 根据日期取出模型。
+ (PedometerModel *)getModelFromDBWithDate:(NSDate *)date
{
    NSString *dateString = [date dateToString];
    NSLog(@"..%@", dateString);
    NSString *where = [NSString stringWithFormat:@"dateString = '%@'", [dateString componentsSeparatedByString:@" "][0]];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [PedometerModel simpleInitWithDate:date];
    }
    
    return model;
}

// 取出今天的数据模型
+ (PedometerModel *)getModelFromDBWithToday
{
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
    
    if (model)
    {
        return model;
    }
    else
    {
        model = [[PedometerModel alloc] init];
        
        return model;
    }
}

+ (NSArray *)getEveryDayTrendDataWithDate:(NSDate *)date
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < LS_TrendChartShowCount; i++)
    {
        NSDate *curDate = [date dateAfterDay:i];
        PedometerModel *model = [PedometerHelper getModelFromDBWithDate:curDate];
        if (model)
        {
            [array addObject:model];
        }
        else
        {
            [array addObject:[PedometerModel simpleInitWithDate:curDate]];
        }
    }
    
    return array;
}

+ (BOOL)queryWhetherCurrentDateDataSaveAllDay:(NSDate *)date
{
    NSString *dateString = [date dateToString];
    NSString *where = [NSString stringWithFormat:@"dateString = '%@'", [dateString componentsSeparatedByString:@" "][0]];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (model && model.isSaveAllDay)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 保存空模型到数据库.
+ (void)pedometerSaveEmptyModelToDBWithDate:(NSDate *)date
{
    PedometerModel *model = [PedometerModel simpleInitWithDate:date];
    
    if (![date isSameWithDate:[NSDate date]])
    {
        model.isSaveAllDay = YES;
    }
    
    [model saveToDB];
}

@end
