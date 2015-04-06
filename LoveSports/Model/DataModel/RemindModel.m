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

+ (NSArray *)getRemindFromDB
{
    NSArray *array = [RemindModel searchWithWhere:nil orderBy:@"orderIndex" offset:0 count:3];
    
    if (!array || array.count == 0)
    {
        NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 3; i++)
        {
            RemindModel *model = [[RemindModel alloc] init];
            model.orderIndex = i;
            
            [model saveToDB];
            [alarmArray addObject:model];
        }
        
        return alarmArray;
    }
    
    return array;
}

// 表名
+ (NSString *)getTableName
{
    return @"RemindModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
