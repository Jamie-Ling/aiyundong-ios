//
//  RemindModel.m
//  LoveSports
//
//  Created by zorro on 15/4/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "RemindModel.h"

@implementation RemindModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isOpen = NO;
        _interval = @"0";
        _startTime = @"12:00";
        _endTime = @"12:00";
    }
    
    return self;
}

+ (NSArray *)getRemindFromDBWithUUID:(NSString *)uuid
{
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@'", uuid];
    NSArray *array = [RemindModel searchWithWhere:where orderBy:@"orderIndex" offset:0 count:3];
    
    if (!array || array.count == 0)
    {
        NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 3; i++)
        {
            RemindModel *model = [[RemindModel alloc] init];
            model.orderIndex = i + 1;
            model.wareUUID = uuid;
            
            [model saveToDB];
            [alarmArray addObject:model];
        }
        
        return alarmArray;
    }
    
    return array;
}

// 数据库存储.
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@' AND orderIndex = %ld", _wareUUID, (long)_orderIndex];
    [RemindModel updateToDB:self where:where];}

- (void)setInterval:(NSString *)interval
{
    _interval = interval;
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@' AND orderIndex = %ld", _wareUUID, (long)_orderIndex];
    [RemindModel updateToDB:self where:where];}

- (void)setStartTime:(NSString *)startTime
{
    _startTime = startTime;
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@' AND orderIndex = %ld", _wareUUID, (long)_orderIndex];
    [RemindModel updateToDB:self where:where];}

- (void)setEndTime:(NSString *)endTime
{
    _endTime = endTime;
    NSString *where = [NSString stringWithFormat:@"wareUUID = '%@' AND orderIndex = %ld", _wareUUID, (long)_orderIndex];
    [RemindModel updateToDB:self where:where];
}

- (NSString *)showStartTimeString
{
    if ([RemindModel isHasAMPMTimeSystem])
    {
        NSArray *array = [_startTime componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minutes = [array[1] integerValue];
        
        if (hour <= 12)
        {
            return [NSString stringWithFormat:@"%@ %@", LS_Text(@"AM"), _startTime];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %02d:%02d", LS_Text(@"PM"), hour - 12, minutes];
        }
    }
    else
    {
        return _startTime;
    }
}

- (NSString *)showEndTimeString
{
    if ([RemindModel isHasAMPMTimeSystem])
    {
        NSArray *array = [_endTime componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minutes = [array[1] integerValue];
        
        if (hour <= 12)
        {
            return [NSString stringWithFormat:@"%@ %@", LS_Text(@"AM"), _endTime];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %02d:%02d", LS_Text(@"PM"), hour - 12, minutes];
        }
    }
    else
    {
        return _endTime;
    }
}

// 表名
+ (NSString *)getTableName
{
    return @"RemindModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"wareUUID", @"orderIndex"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
