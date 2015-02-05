//
//  PedometerModel.m
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerModel.h"

@implementation SportsModel

// 表名
+ (NSString *)getTableName
{
    return @"SportsTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateDay", @"dateHour"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

@implementation SleepModel

// 表名
+ (NSString *)getTableName
{
    return @"SleepTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateDay", @"dateHour"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

@implementation PedometerModel

- (void)saveDataToModel:(NSData *)data
{
    UInt8 val[288 * 25] = {0};
    [data getBytes:&val length:data.length];
    PedometerModel *totalModel = [[PedometerModel alloc] init];
    
    totalModel.dateString = [NSString stringWithFormat:@"%d-%d-%d", (val[0] << 8) | (val[1]), val[2], val[3]];
    totalModel.totalBytes = (val[4] << 8) | (val[5]);
    
    // 此处需要判断收到得字节与存储得字节长度。看看是否发生丢包。
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    NSMutableArray *sleeps = [[NSMutableArray alloc] init];
    NSInteger lastOrder = 0;
    for (int i = 6; i < data.length + 5;)
    {
        int state = (val[i + 1] >> 4);
        if (state == 8 || state == 9)
        {
            SportsModel *model = [[SportsModel alloc] init];
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i];
            model.steps = ((val[i + 1] & 0x0F) << 8) | val[i + 2];
            model.calories = val[i + 3] + ((state == 8) ? 0 : 256);
            totalModel.totalSteps += model.steps;
            totalModel.totalCalories += model.calories;
            
            [sports addObject:model];
            lastOrder = model.currentOrder;
            i += 4;
        }
        else if (state == 0)
        {
            SleepModel *model = [[SleepModel alloc] init];
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i];
            model.sleepState = val[i + 1];
            
            [sports addObject:model];
            lastOrder = model.currentOrder;
            i += 2;
        }
        
        if (i >= data.length)
        {
            break;
        }
    }
    
    totalModel.sportsArray = sports;
    totalModel.sleepArray = sleeps;
    [totalModel saveToDB];
}

- (void)setTotalSteps
{
    NSInteger total = 0;
    if (_sportsArray)
    {
        for (SportsModel *model in _sportsArray)
        {
            total = total + (model.currentOrder - model.lastOrder) * model.steps;
        }
    }
    
    _totalSteps = total;
}

- (void)setTotalCalories
{
    NSInteger total = 0;
    if (_sportsArray)
    {
        for (SportsModel *model in _sportsArray)
        {
            total = total + (model.currentOrder - model.lastOrder) * model.calories;
        }
    }
    
    _totalCalories = total;
}

// 表名
+ (NSString *)getTableName
{
    return @"PedometerTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"PedometerTable"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

