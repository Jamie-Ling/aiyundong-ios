//
//  StepDataRecord.m
//  LoveSports
//
//  Created by zorro on 15/5/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "StepDataRecord.h"

@implementation StepDataRecord

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _userName = [UserInfoHelp sharedInstance].userModel.userName;
        _wareUUID = [LS_LastWareUUID getObjectValue];
    }
    
    return self;
}

+ (StepDataRecord *)getStepDataRecordFromDB
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@' and wareUUID = '%@'",
                       [UserInfoHelp sharedInstance].userModel.userName, [LS_LastWareUUID getObjectValue]];
    StepDataRecord *model = [StepDataRecord searchSingleWithWhere:where orderBy:nil];

    if (!model)
    {
        model = [[StepDataRecord alloc] init];
        
        [model saveToDB];
    }
    
    return model;
}

+ (void)addDateToStepDataRecord:(NSString *)dateString
{
    StepDataRecord *model = [DataShare sharedInstance].stepRecord;
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:model.dateArray];
    
    [array addObject:dateString];
    model.dateArray = array;
}

- (void)setDateArray:(NSArray *)dateArray
{
    _dateArray = dateArray;
    
    NSString *where = [NSString stringWithFormat:@"userName = '%@' and wareUUID = '%@'",
                       [UserInfoHelp sharedInstance].userModel.userName, [LS_LastWareUUID getObjectValue]];
    [StepDataRecord updateToDB:self where:where];
}

+ (BOOL)isHaveDate:(NSString *)dateString
{
    StepDataRecord *model = [DataShare sharedInstance].stepRecord;
    
    if (model.dateArray)
    {
        if ([model.dateArray containsObject:dateString])
        {
            return YES;
        }
    }
    
    return NO;
}

// 表名
+ (NSString *)getTableName
{
    return @"StepDataRecord";
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
