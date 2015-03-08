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

+ (void)addBindingDeviceWithUUID:(NSString *)string
{
    if (string)
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[LS_BindingID getObjectValue]];
        
        if (![array containsObject:string])
        {
            [array addObject:string];
            [LS_BindingID setObjectValue:array];
        }
    }
}

+ (void)removeBindingDeviceWithUUID:(NSString *)string
{
    if (string)
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[LS_BindingID getObjectValue]];
        
        if ([array containsObject:string])
        {
            [array removeObject:string];
            [LS_BindingID setObjectValue:array];
        }
    }
}

- (void)checkBindingState
{
    if ([[LS_BindingID getObjectValue] containsObject:self.bltID])
    {
        self.isBinding = YES;
    }
    else
    {
        self.isBinding = NO;
    }
}

+ (void)updateDeviceName:(NSString *)name
{
    [BLTManager sharedInstance].model.bltName = name;
    
    for (BLTModel *model in [BLTManager sharedInstance].allWareArray)
    {
        if (model == [BLTManager sharedInstance].model)
        {
            model.bltName = name;
        }
    }
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
