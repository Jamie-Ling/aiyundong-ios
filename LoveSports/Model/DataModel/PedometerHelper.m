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
        // 没有就进行完全创建.
        model = [PedometerHelper pedometerSaveEmptyModelToDBWithDate:date];
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

// 取出趋势图所需要的每天的模型.
+ (NSArray *)getEveryDayTrendDataWithDate:(NSDate *)date
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [DataShare sharedInstance].showCount; i++)
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

// 为模型创建空值的对象
+ (void)creatEmptyDataArrayWithModel:(PedometerModel *)model
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 48; i++)
    {
        [array addObject:@(0)];
    }
    model.detailSteps = [NSArray arrayWithArray:array];
    model.detailCalories = [NSArray arrayWithArray:array];
    model.detailDistans = [NSArray arrayWithArray:array];
    
    array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 288; i++)
    {
        // 4代表不是睡眠.而是运动
        [array addObject:@(4)];
    }
    
    // 测试
    for (int k = 100 + arc4random() % 30; k < 204 + arc4random() % 20; k++)
    {
        [array replaceObjectAtIndex:k withObject:@(arc4random() % 20 % 4)];
    }
    
    model.detailSleeps = [NSArray arrayWithArray:array];
    model.nextDetailSleeps = [NSArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 144)]];
    model.lastDetailSleeps = [NSArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 144)]];
}

// 保存空模型到数据库.
+ (PedometerModel *)pedometerSaveEmptyModelToDBWithDate:(NSDate *)date
{
    PedometerModel *model = [PedometerModel simpleInitWithDate:date];
    
    [model addTargetForModelFromUserInfo];
    
    [PedometerHelper creatEmptyDataArrayWithModel:model];
    [model addSleepStartTimeAndEndTime];

    if (![date isSameWithDate:[NSDate date]])
    {
        model.isSaveAllDay = YES;
    }
    
    [model saveToDB];
    
    return model;
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

    // 当前时间
    NSDate *date = [NSDate date];
    // 取序号
    NSInteger order = (date.hour * 60 + date.minute) / 5;

    NSMutableArray *stepsArray = [NSMutableArray arrayWithArray:model.detailSteps];
    // 上一次保存的当前时序的.
    NSInteger steps = [stepsArray[order / 6] integerValue];
    // 加上当前的步数.
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

    // 时时更新数据库.
    [PedometerModel updateToDB:model where:nil];
    [model savePedometerModelToWeekModelAndMonthModel];

    // 更新界面.
    if (endBlock)
    {
        endBlock(nil, YES);
    }
}

@end











