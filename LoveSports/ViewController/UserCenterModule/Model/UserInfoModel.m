//
//  UserInfoModel.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

// 表名
+ (NSString *)getTableName
{
    return @"PedometerTable";
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
