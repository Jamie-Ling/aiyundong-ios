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

@end


@implementation BraceletInfoModel
@synthesize _allHandSetAlarmClock, _is24HoursTime, _isAutomaticAlarmClock, _isLeftHand, _isShowMetricSystem, _longTimeSetRemind, _name, _PreventLossRemind, _showDistance, _showKa, _showSteps, _showTime, _target, _orderID, _deviceID, _deviceElectricity, _deviceVersion, _isHandAlarmClock, _allAutomaticSetAlarmClock;

@synthesize _defaultName;

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
 *  设置名字,id,以及遗传闹钟(手动和自动)等，同时存入DB---因为是通过计算数据库个数来设置，所以不能和Init放一起
 */
- (void) setNameAndSaveToDB;
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
    
    [BraceletInfoModel choiceOneModelShow:self withLastModel:[cacheAllModeArray firstObject]];
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
    _isAutomaticAlarmClock = NO;
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
    [self initAllHandSetAlarmClock: YES];
    [self initAllSetAutomaticAlarmClock: YES];
}

/**
 *  初始化所有手动闹钟
 */
- (void) initAllHandSetAlarmClock: (BOOL) isOpen
{
    [_allHandSetAlarmClock removeAllObjects];
    
    HandSetAlarmClock *oneHandSetAlarmClock1 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock1._setTime = @"7:00";
    oneHandSetAlarmClock1._isOpen = isOpen;
    
    HandSetAlarmClock *oneHandSetAlarmClock2 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock2._setTime = @"23:00";
    oneHandSetAlarmClock2._isOpen = isOpen;
    
    [_allHandSetAlarmClock addObject:oneHandSetAlarmClock1];
    [_allHandSetAlarmClock addObject:oneHandSetAlarmClock2];
}

/**
 *  初始化所有自动闹钟
 */
- (void) initAllSetAutomaticAlarmClock: (BOOL) isOpen
{
    [_allAutomaticSetAlarmClock removeAllObjects];
    
    HandSetAlarmClock *oneHandSetAlarmClock1 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock1._setTime = @"7:00";
    oneHandSetAlarmClock1._isOpen = isOpen;
    
    HandSetAlarmClock *oneHandSetAlarmClock2 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock2._setTime = @"23:00";
    oneHandSetAlarmClock2._isOpen = isOpen;
    
    [_allAutomaticSetAlarmClock addObject:oneHandSetAlarmClock1];
    [_allAutomaticSetAlarmClock addObject:oneHandSetAlarmClock2];
}




/**
 *  设置所有自动闹钟（根据上一个Model）
 *
 */
- (void) setAllAutomaticSetAlarmClockFormLastModel: (BraceletInfoModel *) lastModel
{
    
    [self._allAutomaticSetAlarmClock removeAllObjects];
    [self._allHandSetAlarmClock removeAllObjects];
    
    self._isHandAlarmClock = lastModel._isHandAlarmClock;
    self._isAutomaticAlarmClock = lastModel._isAutomaticAlarmClock;
    
    if ((!lastModel) || ((lastModel._allHandSetAlarmClock.count == 0) && (lastModel._allAutomaticSetAlarmClock.count == 0)))
    {
        [self initAllSetAlarmClock];
        return;
    }
    
    self._allHandSetAlarmClock = [lastModel._allHandSetAlarmClock copy];
   
    NSMutableArray *tempAutomacticSetAlarmClock = [[NSMutableArray alloc] initWithCapacity:32];;
    if (lastModel._isAutomaticAlarmClock && lastModel._isHandAlarmClock)
    {
        [tempAutomacticSetAlarmClock addObjectsFromArray:lastModel._allAutomaticSetAlarmClock];
        [tempAutomacticSetAlarmClock addObjectsFromArray:lastModel._allHandSetAlarmClock];
    }
    else
    {
        if (lastModel._isHandAlarmClock)
        {
            [tempAutomacticSetAlarmClock addObjectsFromArray:lastModel._allHandSetAlarmClock];
        }
        else if (lastModel._isAutomaticAlarmClock)
        {
            [tempAutomacticSetAlarmClock addObjectsFromArray:lastModel._allAutomaticSetAlarmClock];
        }
        else
        {
            [tempAutomacticSetAlarmClock addObjectsFromArray:lastModel._allAutomaticSetAlarmClock];
        }
    }
    
    if (self._allHandSetAlarmClock.count == 0)
    {
        [self initAllHandSetAlarmClock:NO];
    }
    
    //去重
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (HandSetAlarmClock *tempBraceletModel in tempAutomacticSetAlarmClock)
    {
        [dict setObject:tempBraceletModel forKey:tempBraceletModel._setTime];
    }
    NSArray *tempLastArray = [dict allValues];
    
    for (HandSetAlarmClock *tempModel in tempLastArray)
    {
        if (tempModel._isOpen)
        {
            [self._allAutomaticSetAlarmClock addObject:tempModel];
        }
    }
    

//    NSLog(@"%@",[dict allValues]);
    
    if (self._allAutomaticSetAlarmClock.count == 0)
    {
        [self initAllSetAutomaticAlarmClock:YES];
    }
}

/**
 *  选择某个智能手环模型为当前使用模型
 *
 *  @param showModel 选择的模型
 */
+ (void) choiceOneModelShow: (BraceletInfoModel *)showModel
{
    NSArray *cacheAllModeArray = [[BraceletInfoModel getUsingLKDBHelper] search:[BraceletInfoModel class] column:nil where:nil orderBy:@"_orderID" offset:0 count:0];
    if (cacheAllModeArray && cacheAllModeArray.count > 0)
    {
       [BraceletInfoModel choiceOneModelShow:showModel withLastModel:[cacheAllModeArray firstObject]];
    }
    else
    {
       [BraceletInfoModel choiceOneModelShow:showModel withLastModel:nil];
    }
}


+ (void) choiceOneModelShow: (BraceletInfoModel *)showModel withLastModel:(BraceletInfoModel *) lastModel
{
    if (showModel._orderID == 1 || showModel._orderID == 0 || !lastModel )
    {
    }
    else
    {
        lastModel._orderID = [[lastModel._defaultName substringFromIndex:[kBraceletDefaultNamePrefixion length]] integerValue];
        [[BraceletInfoModel getUsingLKDBHelper] insertToDB:lastModel];
    }
    showModel._orderID = 0;
    //存储到DB
    [[BraceletInfoModel getUsingLKDBHelper] insertToDB:showModel];
}

// DB
// 主键
+ (NSString *) getPrimaryKey
{
    return @"_deviceID";
}
// 表名
+ (NSString *) getTableName
{
    return @"BraceletInfoModel";
}
// 表版本
+ (int) getTableVersion
{
    return 1;
}


@end
