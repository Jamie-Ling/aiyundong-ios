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
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       [dateString componentsSeparatedByString:@" "][0], [LS_LastWareUUID getObjectValue]];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [PedometerModel simpleInitWithDate:date];
        [model saveToDB];
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
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       [dateString componentsSeparatedByString:@" "][0], [LS_LastWareUUID getObjectValue]];
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

// 实时传输更新ui界面
+ (void)updateContentForPedometerModel:(NSData *)data
                               withEnd:(PedometerModelSyncEnd)endBlock
{
    UInt8 val[20 * 3] = {0};
    [data getBytes:&val length:data.length];
    
    PedometerModel *model = [BLTRealTime sharedInstance].currentDayModel;

    NSInteger tmpSteps      = (val[8]  << 24) | (val[9]  << 16)  | (val[10] << 8) | (val[11]);
    NSInteger tmpCalories   = (val[12] << 24) | (val[13] << 16)  | (val[14] << 8) | (val[15]);
    NSInteger tmpDistans    = (val[16] << 8)  | val[17];
    
    if (tmpSteps < model.totalSteps
        || tmpCalories < model.totalCalories
        || tmpDistans < model.totalDistance)
    {
        return;
    }
    
    NSDate *date = [NSDate date];
    NSInteger order = (date.hour * 60 + date.minute) / 5;

    NSMutableArray *stepsArray = [NSMutableArray arrayWithArray:model.detailSteps];
    NSInteger steps = [stepsArray[order / 6] integerValue];
    steps += tmpSteps - model.totalSteps;
    stepsArray[order / 6] = @(steps);
    model.detailSteps = stepsArray;
    model.totalSteps = tmpSteps;
    
    NSMutableArray *calArray = [NSMutableArray arrayWithArray:model.detailCalories];
    NSInteger calories = [calArray[order / 6] integerValue];
    calories += tmpCalories - model.totalCalories;
    calArray[order / 6] = @(calories);
    model.detailCalories = calArray;
    model.totalCalories = tmpCalories;
    
    NSMutableArray *distansArray = [NSMutableArray arrayWithArray:model.detailDistans];
    NSInteger distans = [distansArray[order / 6] integerValue];
    distans += tmpDistans - model.totalDistance;
    distansArray[order / 6] = @(distans);
    model.detailDistans = distansArray;
    model.totalDistance = tmpDistans;
    
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       model.dateString, [LS_LastWareUUID getObjectValue]];
    [PedometerModel updateToDB:model where:where];
    // [model savePedometerModelToWeekModelAndMonthModel];

    if (endBlock)
    {
        endBlock([NSDate date], YES);
    }
}

@end











