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
    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    
    NSInteger index = 0;
    if ((val[1] >> 4) == 8)
    {
        index += 4;
    }
    else if ((val[1] >> 4) == 9)
    {
        index += 4;

    }
    else if ((val[1] >> 4) == 0)
    {
        index += 2;
    }
    
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

