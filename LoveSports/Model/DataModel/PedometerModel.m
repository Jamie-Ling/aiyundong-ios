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
        
        _targetStep = 0.0001;
        _totalCalories = 0.0001;
        _targetDistance = 0.0001;
        _targetSleep = 0.0001;
    }
    
    return self;
}

// 简单初始化并赋值。
+ (PedometerModel *)simpleInitWithDate:(NSDate *)date
{
    PedometerModel *model = [[PedometerModel alloc] init];
    
    model.dateString = [[date dateToString] componentsSeparatedByString:@" "][0];
    
    return model;
}

// 保存数据。
+ (void)saveDataToModel:(NSData *)data withEnd:(PedometerModelSyncEnd)endBlock
{
    UInt8 val[288 * 25] = {0};
    [data getBytes:&val length:data.length];
    PedometerModel *totalModel = [[PedometerModel alloc] init];
    
    // 第一个包
    totalModel.dateString = [NSString stringWithFormat:@"%04d-%02d-%02d", (val[4] << 8) | (val[5]), val[6], val[7]];
    totalModel.totalSteps =     (val[8]  << 24) | (val[9]  << 16)  | (val[10] << 8) | (val[11]);
    totalModel.totalCalories =  (val[12] << 24) | (val[13] << 16)  | (val[14] << 8) | (val[15]);
    totalModel.totalDistance =  (val[16] << 8)  | val[17];
    totalModel.totalSportTime = (val[18] << 8)  | val[19];
    
    // 第二个包
    totalModel.totalSleepTime = (val[20] << 8)  | val[21];
    
    // 第三个包
    totalModel.stepSize =   (val[40] << 8)  | (val[41]);
    totalModel.weight =     (val[42] << 8)  | (val[43]);
    totalModel.targetStep = (val[44] << 16) | (val[45] << 8) | (val[46]);
    totalModel.totalBytes = (val[47] << 8)  | (val[48]);

    //  NSLog(@"dateString = %d..%d..%ld", totalModel.totalSteps, totalModel.totalCalories, (long)totalModel.totalDistance);
    
    // 此处需要判断收到得字节与存储得字节长度。看看是否发生丢包。
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    NSMutableArray *sleeps = [[NSMutableArray alloc] init];

    NSInteger lastOrder = 0;
    int i = 60;
    int signOrder = 0;
    for (; i < totalModel.totalBytes + 60;)
    {
        int state = (val[i + 1] >> 4);
        if (state == 0)
        {
            SportsModel *model = [[SportsModel alloc] init];
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i] + signOrder;
            model.steps = ((val[i + 1] & 0x0F) << 8) | val[i + 2];
            model.calories = [model stepsConvertCalories:model.steps withWeight:totalModel.weight withModel:YES];
            model.distance = [model StepsConvertDistance:model.steps withPace:totalModel.stepSize];
            
            // totalModel.totalSteps += model.steps;
            // totalModel.totalCalories += model.calories;
            NSLog(@"..%d.. %d", totalModel.totalBytes, model.steps);

            [sports addObject:model];
            lastOrder = model.currentOrder;
            i += 3;
        }
        else if (state == 8)
        {
            SleepModel *model = [[SleepModel alloc] init];
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i] + signOrder;
            model.sleepState = val[i + 1] & 0x0F;
            
            NSLog(@"..%d.. %d", totalModel.totalBytes, model.sleepState);
            [sleeps addObject:model];
            lastOrder = model.currentOrder;
            i += 2;
        }
        else
        {
            i += 6;
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
  
    totalModel.sportsArray = sports;
    totalModel.sleepArray = sleeps;
    
    [totalModel setLastSleepData];
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

// 为今天的模型附加上昨天的睡眠模型
- (void)setLastSleepData
{
    NSDate *date =  [NSDate stringToDate:[NSString stringWithFormat:@"%@ 06:00:00", self.dateString]];
    PedometerModel *model = [PedometerModel getModelFromDBWithDate:date];
    
    if (model)
    {
        _lastSleepArray = model.sleepArray;
    }
}

// 取出今天的数据模型
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

// 将一天的数据分为48个阶段详细展示。
- (void)modelToDetailShow
{
    NSMutableArray *detailSteps = [[NSMutableArray alloc] init];
    NSMutableArray *detailSleeps = [[NSMutableArray alloc] init];
    NSMutableArray *detailDistans = [[NSMutableArray alloc] init];
    NSMutableArray *detailCalories = [[NSMutableArray alloc] init];

    for (int i = 0; i < 288; i += 6)
    {
        NSInteger total = [self halfHourData:i withType:SportsModelSteps];
        [detailSteps addObject:@(total)];

        total = [self halfHourData:i withType:SportsModelSleep];
        [detailSleeps addObject:@(total)];
        
        total = [self halfHourData:i withType:SportsModelDistance];
        [detailDistans addObject:@(total)];
        
        total = [self halfHourData:i withType:SportsModelCalories];
        [detailCalories addObject:@(total)];
    }
    
    self.detailSteps = detailSteps;
    self.detailSleeps = detailSleeps;
    self.detailDistans = detailDistans;
    self.detailCalories = detailCalories;
}

// 取出每半个小时的数据
- (NSInteger)halfHourData:(int)index withType:(SportsModelType)type
{
    NSInteger number = 0;
    for (int i = index; i < index + 6; i++)
    {
        number += [self getDataWithIndex:i withType:type];
    }
    
    return number;
}

// 取出当前5分钟的具体数据。
- (NSInteger)getDataWithIndex:(int)index withType:(SportsModelType)type
{
    if (type != SportsModelSleep)
    {
        if (self.sportsArray && self.sportsArray.count > 0)
        {
            for (int i = 0; i < self.sportsArray.count; i++)
            {
                SportsModel *model = self.sportsArray[i];
                if (index <= model.currentOrder)
                {
                    switch (type)
                    {
                        case SportsModelSteps:
                        {
                            return model.steps;
                        }
                            break;
                        case SportsModelCalories:
                        {
                            return model.calories;
                        }
                            break;
                        case SportsModelDistance:
                        {
                            return model.distance;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            
            return 0;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (index < 144)
        {
            if (self.lastSleepArray && self.lastSleepArray.count)
            {
                for (int i = 0; i < self.lastSleepArray.count; i++)
                {
                    SleepModel *model = self.lastSleepArray[i];
                    if (index + 144 <= model.currentOrder)
                    {
                        return model.sleepState;
                    }
                }

                return 3;
            }
            else
            {
                return 3;
            }
        }
        else
        {
            if (self.sleepArray && self.sleepArray.count > 0)
            {
                for (int i = 0; i < self.sleepArray.count; i++)
                {
                    SleepModel *model = self.sleepArray[i];
                    if (index - 144 <= model.currentOrder)
                    {
                        NSLog(@"...今天的睡眠状态：%d...%d", index, model.sleepState);
                        return model.sleepState;
                    }
                }

                return 3;
            }
            else
            {
                return 3;
            }
        }
    }
}

// 设置当前模型的各种目标.
- (void)setTargetDataForModel
{
    self.targetCalories = [self stepsConvertCalories:self.targetStep withWeight:self.weight withModel:YES];
    self.targetDistance = [self StepsConvertDistance:self.targetStep withPace:self.stepSize];
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

