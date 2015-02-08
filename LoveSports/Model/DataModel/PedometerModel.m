//
//  PedometerModel.m
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerModel.h"

@implementation StepsModel

+ (StepsModel *)simpleInit
{
    StepsModel *model = [[StepsModel alloc] init];
    
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dateDay = @"";
    }
    
    return self;
}

// 表名
+ (NSString *)getTableName
{
    return @"StepsTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateDay", @"timeOrder"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

@implementation SportsModel

// 表名
+ (NSString *)getTableName
{
    return @"SportsTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateDay", @"currentOrder"];
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
    return @[@"userName", @"dateDay", @"currentOrder"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

@implementation PedometerModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *dateString = [[NSDate date] dateToString];
        _dateString= [dateString componentsSeparatedByString:@" "][0];
    }
    
    return self;
}

+ (PedometerModel *)simpleInitWithDate:(NSDate *)date
{
    PedometerModel *model = [[PedometerModel alloc] init];
    
    model.dateString = [[date dateToString] componentsSeparatedByString:@" "][0];
    
    return model;
}

+ (void)saveDataToModel:(NSData *)data withEnd:(PedometerModelSyncEnd)endBlock
{
    UInt8 val[288 * 25] = {0};
    [data getBytes:&val length:data.length];
    PedometerModel *totalModel = [[PedometerModel alloc] init];
    
    totalModel.dateString = [NSString stringWithFormat:@"%04d-%02d-%02d", (val[0] << 8) | (val[1]), val[2], val[3]];
    totalModel.totalSteps =    (val[4]  << 24) | (val[5]  << 16)  | (val[6]  << 8) | (val[7]);
    totalModel.totalCalories = (val[8]  << 24) | (val[9]  << 16)  | (val[10] << 8) | (val[11]);
    totalModel.totalDistance = (val[12] << 24) | (val[13] << 16)  | (val[14] << 8) | (val[15]);
    totalModel.totalBytes =    (val[16] << 8)  | (val[17]);

    NSLog(@"dateString = %d..%d..%ld", totalModel.totalSteps, totalModel.totalCalories, (long)totalModel.totalDistance);
    
    // 此处需要判断收到得字节与存储得字节长度。看看是否发生丢包。
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    NSMutableArray *sleeps = [[NSMutableArray alloc] init];
    NSMutableArray *stepSizes = [[NSMutableArray alloc] init];

    NSInteger lastOrder = 0;
    int i = 18;
    int signOrder = 0;
    for (; i < totalModel.totalBytes + 18;)
    {
        int state = (val[i + 1] >> 4);
        if ((state == 8 || state == 9))
        {
            SportsModel *model = [[SportsModel alloc] init];
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i] + signOrder;
            model.steps = ((val[i + 1] & 0x0F) << 8) | val[i + 2];
            model.calories = val[i + 3] + ((state == 8) ? 0 : 256);
            
            NSLog(@"steps = ..%d..%d", model.steps, model.calories);
           // totalModel.totalSteps += model.steps;
           // totalModel.totalCalories += model.calories;
            
            [sports addObject:model];
            lastOrder = model.currentOrder;
            i += 4;
        }
        else if (state == 0)
        {
            SleepModel *model = [[SleepModel alloc] init];
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i] + signOrder;
            model.sleepState = val[i + 1];
            
            [sports addObject:model];
            lastOrder = model.currentOrder;
            i += 2;
        }
        else
        {
            i += 4;
        }
        
        if (lastOrder == 255)
        {
            signOrder = 255;
        }
        
        if (i >= data.length - 1)
        {
            break;
        }
    }
  
    int setting = i + val[i] + 1;
    totalModel.settingBytes = val[i];
    i = i + 1;
    
    for (; i < setting; i += 4)
    {
        NSLog(@"%d..%d..%d..%d", val[i], val[i+1], val[i+2],val[i+3]);
        StepsModel *model = [[StepsModel alloc] init];
        
        model.dateDay = totalModel.dateString;
        totalModel.stepSize = (val[i] << 8) | (val[i + 1]);
        // model.timeOrder = (val[i + 2] << 8) | (val[i + 3]);
    }
    
    totalModel.sportsArray = sports;
    totalModel.sleepArray = sleeps;
    
    [totalModel modelToDetailShow];
    [totalModel setTargetDataForModel];
    
    NSString *where = [NSString stringWithFormat:@"dateString = '%@'", totalModel.dateString];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (model)
    {
        [PedometerModel updateToDB:totalModel where:where];
    }
    else
    {
        [totalModel saveToDB];
    }
    
    if (endBlock)
    {
        endBlock();
    }
}

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

+ (PedometerModel *)getModelFromDBWithToday
{
    PedometerModel *model = [PedometerModel getModelFromDBWithDate:[NSDate date]];
    
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

- (void)modelToDetailShow
{
    NSMutableArray *detailSteps = [[NSMutableArray alloc] init];
    NSMutableArray *detailSleeps = [[NSMutableArray alloc] init];
    NSMutableArray *detailDistans = [[NSMutableArray alloc] init];
    NSMutableArray *detailCalories = [[NSMutableArray alloc] init];

    for (int i = 0; i < 288; i += 6)
    {
        NSInteger total = [self halfHourData:i withTotals:self.sportsArray];
        [detailSteps addObject:@(total)];
        
        total = [self halfHourData:i withTotals:self.sleepArray];
        [detailSleeps addObject:@(total)];
        
        total = [self halfHourData:i withTotals:self.sportsArray];
        [detailDistans addObject:@(total)];
        
        total = [self halfHourData:i withTotals:self.sportsArray];
        [detailCalories addObject:@(total)];
    }
    
    self.detailSteps = detailSteps;
    self.detailSleeps = detailSleeps;
    self.detailDistans = detailDistans;
    self.detailCalories = detailCalories;
}

- (NSInteger)halfHourData:(int)index withTotals:(NSArray *)array
{
    NSInteger number = 0;
    for (int i = index; i < index + 6; i++)
    {
        number += [self getDataWithIndex:i withTotals:array];
    }
    
    return number;
}

- (NSInteger)getDataWithIndex:(int)index withTotals:(NSArray *)array
{
    if (array && array.count > 0)
    {
        NSObject *object = array[0];
        if ([object isKindOfClass:[SportsModel class]])
        {
            for (int i = 0; i < array.count; i++)
            {
                SportsModel *model = array[i];
                if (index <= model.currentOrder)
                {
                    return model.steps;
                }
            }
            
            return 0;
        }
        else if ([object isKindOfClass:[SleepModel class]])
        {
            for (int i = 0; i < array.count; i++)
            {
                SleepModel *model = array[i];
                if (index <= model.currentOrder)
                {
                    return model.sleepState;
                }
            }
            
            return 0;
        }
        else
        {
            return 0;
        }
        
        return 0;
    }
    else
    {
        return 0;
    }
}

// 设置当前模型的各种目标
- (void)setTargetDataForModel
{
    self.targetStep = [BLTManager sharedInstance].model.targetStep;
    self.targetCalories = [BLTManager sharedInstance].model.targetStep;
    self.targetDistance = [BLTManager sharedInstance].model.targetStep;
}

+ (NSArray *)getEveryDayTrendDataWithDate:(NSDate *)date
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++)
    {
        NSDate *curDate = [date dateAfterDay:i];
        PedometerModel *model = [PedometerModel getModelFromDBWithDate:curDate];
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

// 表名
+ (NSString *)getTableName
{
    return @"PedometerTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateString"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

