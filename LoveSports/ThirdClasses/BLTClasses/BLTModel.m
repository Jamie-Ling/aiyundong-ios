//
//  BLTModel.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTModel.h"
#import "AlarmClockModel.h"
#import "RemindModel.h"

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

+ (instancetype)initWithUUID:(NSString *)uuid
{
    BLTModel *model = [[BLTModel alloc] init];
    
    model.bltID = uuid;
    [model setAlarmArrayAndRemindArrayWithUUID:uuid];
    
    return model;
}

- (void)setAlarmArrayAndRemindArrayWithUUID:(NSString *)uuid
{
    _alarmArray = [AlarmClockModel getAlarmClockFromDBWithUUID:uuid];
    _remindArray = [RemindModel getRemindFromDBWithUUID:uuid];
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
    
    if (!model)
    {
        model = [BLTModel initWithUUID:self.bltID];
        
        [model saveToDB];
    }
    else
    {
        [model setAlarmArrayAndRemindArrayWithUUID:self.bltID];
    }

    return model;
}

+ (BLTModel *)getModelFromDBWtihUUID:(NSString *)uuid
{
    NSString *where = [NSString stringWithFormat:@"bltID = '%@'", uuid];
    BLTModel *model = [BLTModel searchSingleWithWhere:where orderBy:nil];

    if (!model)
    {
        model = [BLTModel initWithUUID:uuid];
        
        [model saveToDB];
    }
    else
    {
        [model setAlarmArrayAndRemindArrayWithUUID:uuid];
    }
    
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

- (BOOL)checkBindingState
{
    if ([[LS_BindingID getObjectValue] containsObject:self.bltID])
    {
        self.isBinding = YES;
        
        return YES;
    }
    else
    {
        self.isBinding = NO;
        
        return NO;
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

- (NSString *)imageForsignalStrength
{
    NSInteger rssi = [_bltRSSI integerValue];
    
    if (rssi < 55)
    {
        return @"signal_4_5.png";
    }
    else if (rssi < 80)
    {
        return @"signal_3_5.png";
    }
    else if (rssi < 110)
    {
        return @"signal_2_5.png";
    }
    else
    {
        return @"signal_1_5.png";
    }
}

// 数据库存储
- (void)setIsRealTime:(BOOL)isRealTime
{
    _isRealTime = isRealTime;
    // 保存这个到数据库容易引发崩溃。 原因未知
    NSString *where = [NSString stringWithFormat:@"bltID = '%@'", self.bltID];
    [BLTModel updateToDB:self where:where];
}

- (void)setIsLeftHand:(BOOL)isLeftHand
{
    _isLeftHand = isLeftHand;
    [BLTModel updateToDB:self where:nil];
}

- (void)setIsBinding:(BOOL)isBinding
{
    _isBinding = isBinding;
    [BLTModel updateToDB:self where:nil];
}

// 主键
+ (NSString *) getPrimaryKey
{
    return @"bltID";
}

/*
// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateString", @"wareUUID"];
}
 */

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

+ (void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    [self removePropertyWithColumnName:@"peripheral"];
}

@end
