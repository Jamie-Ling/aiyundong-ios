//
//  BraceletInfoModel.m
//  LoveSports
//
//  Created by jamie on 15/1/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BraceletInfoModel.h"


@implementation HandSetAlarmClock

@synthesize _isOpen, _setTime;

@end

@interface BraceletInfoModel()
{
    NSString *_defaultName;
}

@end


@implementation BraceletInfoModel
@synthesize _allHandSetAlarmClock, _is24HoursTime, _isAutomaticAlarmClock, _isLeftHand, _isShowMetricSystem, _longTimeSetRemind, _name, _PreventLossRemind, _showDistance, _showKa, _showSteps, _showTime, _target, _orderID, _deviceID, _deviceElectricity, _deviceVersion;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allHandSetAlarmClock = [[NSMutableArray alloc] initWithCapacity:32];
        [self initAllSet];
    }
    return self;
}

/**
 *  //取仓库已有的智能手环，计算个数,设置名字及id
 */
- (void) setDefaultNameAndOrderID
{
    NSArray *cacheAllModeArray = [[BraceletInfoModel getUsingLKDBHelper] search:[BraceletInfoModel class] column:nil where:nil orderBy:nil offset:0 count:0];
    if (cacheAllModeArray && cacheAllModeArray.count > 0)
    {
        _defaultName = [NSString stringWithFormat:@"%@%lu", kBraceletDefaultNamePrefixion, (unsigned long)cacheAllModeArray.count + 1];
        _orderID = cacheAllModeArray.count + 1;
    }
    else
    {
        _defaultName = [NSString stringWithFormat:@"%@1", kBraceletDefaultNamePrefixion];
        _orderID = 1;
    }
    
    _name = _defaultName;
}

/**
 *  还原所有设置
 */
- (void) initAllSet
{
    _name = _defaultName;
    _target = @"0";   //10000步
    _isLeftHand = YES;
    _showTime = YES;
    _showSteps = YES;
    _showKa = NO;
    _showDistance = NO;
    _isShowMetricSystem = YES;
    _isAutomaticAlarmClock = YES;
    _is24HoursTime = YES;
    _longTimeSetRemind = YES;
    _PreventLossRemind = YES;
    
    [_allHandSetAlarmClock removeAllObjects];
    
    HandSetAlarmClock *oneHandSetAlarmClock1 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock1._setTime = @"7:00";
    oneHandSetAlarmClock1._isOpen = YES;
    
    HandSetAlarmClock *oneHandSetAlarmClock2 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock2._setTime = @"23:00";
    oneHandSetAlarmClock2._isOpen = YES;
    
    [_allHandSetAlarmClock addObject:oneHandSetAlarmClock1];
    [_allHandSetAlarmClock addObject:oneHandSetAlarmClock2];
}


// DB
// 主键
+(NSString *)getPrimaryKey
{
    return @"_deviceID";
}
// 表名
+(NSString *)getTableName
{
    return @"BraceletInfoModel";
}
// 表版本
+(int)getTableVersion
{
    return 1;
}


@end
