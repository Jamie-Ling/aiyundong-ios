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
    NSArray *array = [RemindModel searchWithWhere:nil orderBy:@"orderIndex" offset:0 count:3];
    
    if (!array || array.count == 0)
    {
        NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 3; i++)
        {
            RemindModel *model = [[RemindModel alloc] init];
            model.orderIndex = i;
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
    [RemindModel updateToDB:self where:nil];
}

- (void)setInterval:(NSString *)interval
{
    _interval = interval;
    [RemindModel updateToDB:self where:nil];
}

- (void)setStartTime:(NSString *)startTime
{
    _startTime = startTime;
    [RemindModel updateToDB:self where:nil];
}

- (void)setEndTime:(NSString *)endTime
{
    _endTime = endTime;
    [RemindModel updateToDB:self where:nil];
}

// 表名
+ (NSString *)getTableName
{
    return @"RemindModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
