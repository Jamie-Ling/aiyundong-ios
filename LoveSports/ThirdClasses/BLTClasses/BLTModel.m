//
//  BLTModel.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTModel.h"

@implementation BLTModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bltName = @"";
        _bltID = @"";
        _bltVersion = @"";
        _bltElec = @"";
        _bltRSSI = @"";
        _isBinding = NO;
    }
    
    return self;
}

- (void)forgeFirmwareInformation
{
    _bltName = [NSString stringWithFormat:@"Device %d", arc4random() % 100];
    _bltID = @"sjdfkjsdfjskdfsdfsdfsdfsdf";
    _bltVersion = @"45";
    _bltElec = @"30";
    _bltRSSI = @"888";
}

- (BLTModel *)getCurrentModelFromDB
{
    NSString *where = [NSString stringWithFormat:@"bltID = '%@'", self.bltID];
    BLTModel *model = [BLTModel searchSingleWithWhere:where orderBy:nil];
    
    return model;
}

// 主键
+ (NSString *) getPrimaryKey
{
    return @"bltID";
}

// 表名
+ (NSString *) getTableName
{
    return @"HardwareInfo";
}

// 表版本
+ (int) getTableVersion
{
    return 1;
}

@end
