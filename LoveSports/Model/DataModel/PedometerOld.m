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
    NSData *data = array[0];
    UInt8 val[1024 * 64] = {0};
    [data getBytes:&val length:data.length];
    PedometerModel *model = [[PedometerModel alloc] init];
    
    // 第一个包
    model.totalSteps = val[1] | (val[2]  << 8) | (val[3]  << 16) | (val[4]  << 24);
    model.totalSteps = val[5] | (val[6]  << 8) | (val[7]  << 16) | (val[8]  << 24);
    model.totalSteps = val[9] | (val[10] << 8) | (val[11] << 16) | (val[12] << 24);
    
    int currentDay = 0;
    NSDate *date = [NSDate date];
    NSInteger timeIndex = (date.hour * 60 + date.minute) / 5; //当前5分钟内。数据时前5分钟开始的。
    
    // 去除2个校验码。i是数据包的第一个数据时不计数.
    PedometerModel *currentModel = [[PedometerModel alloc] init];
    currentModel.dateString = [[[date dateAfterDay:currentDay] dateToString] componentsSeparatedByString:@" "][0];
    for (int i = 12; i < length - 2; i = i + 6)
    {
        if (i/20 == 0)
        {
            i--;
        }
        else
        {
            NSInteger step =        val[i]   | (val[i+1] << 8);
            NSInteger cal =         val[i+2] | (val[i+3] << 8);
            NSInteger distance =    val[i+4] | (val[i+5] << 8);
            [self updateDataForArray:model with:@[@(step), @(cal), @(distance)] withTimeIndex:timeIndex];
            
            [currentModel savePedometerModelToWeekModelAndMonthModel];
            NSString *where = [NSString stringWithFormat:@"dateString = '%@'", currentModel.dateString];
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
                currentModel = [[PedometerModel alloc] init];
                currentModel.dateString = [[[date dateAfterDay:currentDay] dateToString] componentsSeparatedByString:@" "][0];
            }

            timeIndex--;
        }
    }
    
    [model showMessage];
    
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
    NSInteger steps = [stepsArray[order / 6] integerValue];
    steps += stepNumber;
    stepsArray[order / 6] = @(steps);
    model.detailSteps = stepsArray;
    model.totalSteps += stepNumber;
    
    NSInteger calNumber = [numberArray[1] integerValue];
    NSMutableArray *calArray = [NSMutableArray arrayWithArray:model.detailCalories];
    NSInteger calories = [calArray[order / 6] integerValue];
    calories += calNumber;
    calArray[order / 6] = @(calories);
    model.detailCalories = calArray;
    model.totalCalories += calNumber;
    
    NSInteger distanceNumber = [numberArray[2] integerValue];
    NSMutableArray *distansArray = [NSMutableArray arrayWithArray:model.detailDistans];
    NSInteger distans = [distansArray[order / 6] integerValue];
    distans += distanceNumber;
    distansArray[order / 6] = @(distans);
    model.detailDistans = distansArray;
    model.totalDistance += distanceNumber;
    
    NSInteger sleepNumber = [numberArray[2] integerValue];
    NSMutableArray *sleepArray = [NSMutableArray arrayWithArray:model.detailSleeps];
    sleepArray[order] = @(sleepNumber);
    model.detailCalories = sleepArray;
}

@end
