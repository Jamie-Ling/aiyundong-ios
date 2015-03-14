//
//  PedometerOld.m
//  LoveSports
//
//  Created by zorro on 15/3/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerOld.h"
#import "BLTSendOld.h"

@implementation PedometerOld

+ (void)saveDataToModelFromOld:(NSArray *)array withEnd:(PedometerModelSyncEnd)endBlock
{
    NSInteger length = [array[1] integerValue];
    NSData *originalData = array[0];
    UInt8 val[1024 * 64] = {0};
    [originalData getBytes:&val length:originalData.length];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    // 将每个数据包的第一个byte清除.
    for (int i = 0; i < originalData.length; i++)
    {
        if (!(i % 20 == 0))
        {
            [data appendBytes:&val[i] length:1];
        }
    }
    
    [data getBytes:&val length:data.length];
    
    int currentDay = 0;
    NSDate *date = [NSDate date];
    NSString *dateString = [[[date dateAfterDay:currentDay] dateToString] componentsSeparatedByString:@" "][0];
    NSInteger timeIndex = (date.hour * 60 + date.minute) / 5; //当前5分钟内。数据时前5分钟开始的。
    
    // 去除2个校验码。i是数据包的第一个数据时不计数.
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       dateString, [LS_LastWareUUID getObjectValue]];

    PedometerModel *currentModel = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    if (!currentModel)
    {
        currentModel = [PedometerModel simpleInitWithDate:date];
        [PedometerOld creatEmptyDataArrayWithModel:currentModel];
        [currentModel saveToDB];
    }
    
    // 第一个包
    currentModel.totalSteps    = val[0] | (val[1]  << 8) | (val[2]  << 16) | (val[3]  << 24);
    currentModel.totalCalories = val[4] | (val[5]  << 8) | (val[6]  << 16) | (val[7]  << 24);
    currentModel.totalDistance = val[8] | (val[9]  << 8) | (val[10] << 16) | (val[11] << 24);
    
    NSLog(@"..%d..%d..%d", currentModel.totalSteps, currentModel.totalCalories, currentModel.totalDistance);
    [PedometerModel updateToDB:currentModel where:where];

    NSLog(@"...%@", [NSDate date]);

    for (int i = 12; i < length - 2; i += 6)
    {
        NSLog(@"length..%d", i);
        NSInteger state = (UInt8)(val[i + 1] >> 4);
        if (state == 8)
        {
            NSInteger sleepX = val[i]   | ((val[i+1] & 0x0F) << 8);
            NSInteger sleepY = val[i+2] | ((val[i+3] & 0x0F) << 8);
            NSInteger sleepZ = val[i+4] | ((val[i+5] & 0x0F) << 8);
            NSInteger sleep = sleepX + sleepY + sleepZ;
            NSInteger sleepState = 0;
            if (sleep < 800)
            {
                sleepState = 0;
            }
            else if (sleep > 801 && sleep < 1600)
            {
                sleepState = 1;
            }
            else if (sleep > 1601 && sleep < 3500)
            {
                sleepState = 2;
            }
            else
            {
                sleepState = 3;
            }
            [self updateDataForSleep:currentModel withNumber:sleepState withTimeIndex:timeIndex];
        }
        else
        {
            NSInteger step =        val[i]   | (val[i+1] << 8);
            NSInteger cal =         val[i+2] | (val[i+3] << 8);
            NSInteger distance =    val[i+4] | (val[i+5] << 8);
            [self updateDataForArray:currentModel with:@[@(step), @(cal), @(distance)] withTimeIndex:timeIndex];
        }
        
        [currentModel savePedometerModelToWeekModelAndMonthModel];
        NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                           currentModel.dateString, [LS_LastWareUUID getObjectValue]];
        PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
        if (model)
        {
            [PedometerModel updateToDB:currentModel where:where];
        }
        else
        {
            [currentModel saveToDB];
        }
        
        if (timeIndex == 0)
        {
            // 到了下一天。创建新的模型.
            timeIndex = 288;
            currentDay--;
            NSDate *nextDate = [date dateAfterDay:currentDay];
            NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                              [[nextDate dateToString] componentsSeparatedByString:@" "][0], [LS_LastWareUUID getObjectValue]];
            currentModel = [PedometerModel searchSingleWithWhere:where orderBy:nil];
            if (!currentModel)
            {
                currentModel = [PedometerModel simpleInitWithDate:nextDate];
                [PedometerOld creatEmptyDataArrayWithModel:currentModel];
            }
        }
        
        timeIndex--;
    }
    NSLog(@"...%@", [NSDate date]);

    [currentModel showMessage];
    
    if (endBlock)
    {
        endBlock([NSDate date], YES);
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
        [array addObject:@(0)];
    }
    model.detailSleeps = [NSArray arrayWithArray:array];
}

// 将所有的值放入数组中.
+ (void)updateDataForArray:(PedometerModel *)model with:(NSArray *)numberArray withTimeIndex:(NSInteger)order
{
    NSInteger stepNumber = [numberArray[0] integerValue];
    NSMutableArray *stepsArray = [NSMutableArray arrayWithArray:model.detailSteps];
    [self fixMutableArray:stepsArray withCount:48];
    NSInteger steps = [stepsArray[order / 6] integerValue];
    steps += stepNumber;
    stepsArray[order / 6] = @(steps);
    model.detailSteps = stepsArray;
    model.totalSteps += stepNumber;
    
    NSInteger calNumber = [numberArray[1] integerValue];
    NSMutableArray *calArray = [NSMutableArray arrayWithArray:model.detailCalories];
    [self fixMutableArray:calArray withCount:48];
    NSInteger calories = [calArray[order / 6] integerValue];
    calories += calNumber;
    calArray[order / 6] = @(calories);
    model.detailCalories = calArray;
    model.totalCalories += calNumber;
    
    NSInteger distanceNumber = [numberArray[2] integerValue];
    NSMutableArray *distansArray = [NSMutableArray arrayWithArray:model.detailDistans];
    [self fixMutableArray:distansArray withCount:48];
    NSInteger distans = [distansArray[order / 6] integerValue];
    distans += distanceNumber;
    distansArray[order / 6] = @(distans);
    model.detailDistans = distansArray;
    model.totalDistance += distanceNumber;
}

+ (void)updateDataForSleep:(PedometerModel *)model withNumber:(NSInteger)number withTimeIndex:(NSInteger)order
{
    NSMutableArray *sleepArray = [NSMutableArray arrayWithArray:model.detailSleeps];
    [self fixMutableArray:sleepArray withCount:288];
    sleepArray[order] = @(number);
    model.detailSleeps = sleepArray;
}

+ (void)fixMutableArray:(NSMutableArray *)array withCount:(int)count
{
    for (NSInteger i = array.count; i < count; i++)
    {
        [array addObject:@(0)];
    }
}

@end
