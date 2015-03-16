//
//  UserInfoModel.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _targetSteps= 5000;
        _targetCalories = 10000;
        _targetDistance = 10 * 100;
        _targetSleep = 60 * 8;
    }
    
    return self;
}

// 表名
+ (NSString *)getTableName
{
    return @"UserInfoModel";
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
