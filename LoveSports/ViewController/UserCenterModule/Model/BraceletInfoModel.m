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



/**
 *  得到显示时间（根据是否是24小时制）
 *
 *  @param _is24HoursTime 是否是24小时置
 *
 *  @return 返回的显示时间
 */
- (NSString *) getShowTimeWithIs24HoursTime: (BOOL) _is24HoursTime
{
    if (_is24HoursTime)
    {
        return _setTime;
    }
    NSArray *timeArray = [_setTime componentsSeparatedByString:@":"];
    NSInteger hour = [[timeArray objectAtIndex:0] integerValue];
    
    if (hour > 13)
    {
        return [NSString stringWithFormat:@"下午 %ld:%@", (long)hour, [timeArray lastObject]];
    }
    return [NSString stringWithFormat:@"上午 %@",_setTime];
}

@end

@interface BraceletInfoModel()
{
    NSString *_defaultName;
}

@end


@implementation BraceletInfoModel
@synthesize _allHandSetAlarmClock, _is24HoursTime, _isAutomaticAlarmClock, _isLeftHand, _isShowMetricSystem, _longTimeSetRemind, _name, _PreventLossRemind, _showDistance, _showKa, _showSteps, _showTime, _target, _orderID, _deviceID, _deviceElectricity, _deviceVersion, _isHandAlarmClock, _allAutomaticSetAlarmClock;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allHandSetAlarmClock = [[NSMutableArray alloc] initWithCapacity:32];
        _allAutomaticSetAlarmClock = [[NSMutableArray alloc] initWithCapacity:32];
        [self initAllSet];
    }
    return self;
}

/**
 *  设置名字,id,以及遗传闹钟(手动和自动)---因为是通过计算数据库个数来设置，所以不能和Init放一起
 */
- (void) setDefaultNameAndOrderID
{
    NSArray *cacheAllModeArray = [[BraceletInfoModel getUsingLKDBHelper] search:[BraceletInfoModel class] column:nil where:nil orderBy:@"_orderID" offset:0 count:0];
    if (cacheAllModeArray && cacheAllModeArray.count > 0)
    {
        _defaultName = [NSString stringWithFormat:@"%@%lu", kBraceletDefaultNamePrefixion, (unsigned long)cacheAllModeArray.count + 1];
        _orderID = cacheAllModeArray.count + 1;
        
        [self setAllAutomaticSetAlarmClockFormLastModel:[cacheAllModeArray firstObject]];
    }
    else
    {
        _defaultName = [NSString stringWithFormat:@"%@1", kBraceletDefaultNamePrefixion];
        _orderID = 1;
        [self setAllAutomaticSetAlarmClockFormLastModel:nil];
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
    _isHandAlarmClock = NO;
    
    [self initAllSetAlarmClock];
    
}

/**
 *  初始化所有手动和自动闹钟
 */
- (void) initAllSetAlarmClock
{
    [_allHandSetAlarmClock removeAllObjects];
    [_allAutomaticSetAlarmClock removeAllObjects];
    
    HandSetAlarmClock *oneHandSetAlarmClock1 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock1._setTime = @"7:00";
    oneHandSetAlarmClock1._isOpen = YES;
    
    HandSetAlarmClock *oneHandSetAlarmClock2 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock2._setTime = @"23:00";
    oneHandSetAlarmClock2._isOpen = YES;
    
    [_allHandSetAlarmClock addObject:oneHandSetAlarmClock1];
    [_allHandSetAlarmClock addObject:oneHandSetAlarmClock2];
    
    [_allAutomaticSetAlarmClock addObject:oneHandSetAlarmClock1];
    [_allAutomaticSetAlarmClock addObject:oneHandSetAlarmClock2];
    [_allAutomaticSetAlarmClock addObject:oneHandSetAlarmClock2];
}




/**
 *  设置所有自动闹钟（根据上一个Model）
 *
 */
- (void) setAllAutomaticSetAlarmClockFormLastModel: (BraceletInfoModel *) lastModel
{
    
    if (!lastModel || lastModel._allAutomaticSetAlarmClock.count == 0)
    {
        [self initAllSetAlarmClock];
        return;
    }
    
    _allAutomaticSetAlarmClock = lastModel._allAutomaticSetAlarmClock;
    _allHandSetAlarmClock = lastModel._allHandSetAlarmClock;

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
