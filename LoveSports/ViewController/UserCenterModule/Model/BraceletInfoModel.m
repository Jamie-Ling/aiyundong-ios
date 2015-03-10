//
//  BraceletInfoModel.m
//  LoveSports
//
//  Created by jamie on 15/1/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BraceletInfoModel.h"

@interface BraceletInfoModel()
{
    NSDictionary *_userInfoDictionary;
}

@end


@implementation HandSetAlarmClock

@synthesize _isOpen, _setTime, _weekDayArray;

#define vChangeToFT(A)  ((A / 30.48) + 1)   //CM - >转换为英尺
#define vChangeToLB(A)  (A * 2.2046226)  //KG - >转换为磅


#define vBackToCM(A)  ((A - 1) * 30.48)   //CM - >转换为英尺
#define vBackToKG(A)  (A / 2.2046226)  //KG - >转换为磅


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
        return [NSString stringWithFormat:@"下午 %ld:%@", (long)hour - 12, [timeArray lastObject]];
    }
    return [NSString stringWithFormat:@"上午 %@",_setTime];
}



@end

@interface BraceletInfoModel()

@end


@implementation BraceletInfoModel
@synthesize _allHandSetAlarmClock, _is24HoursTime, _isAutomaticAlarmClock, _isLeftHand, _isShowMetricSystem, _longTimeSetRemind, _name, _PreventLossRemind, _showDistance, _showKa, _showSteps, _showTime, _target, _orderID, _deviceID, _deviceElectricity, _deviceVersion, _isHandAlarmClock, _allAutomaticSetAlarmClock;

@synthesize _defaultName;

@synthesize _timeAbsoluteValue, _timeZone, _stepNumber;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allHandSetAlarmClock = [[NSMutableArray alloc] initWithCapacity:32];
        _allAutomaticSetAlarmClock = [[NSMutableArray alloc] initWithCapacity:32];
        
        _userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
        
        if (!_userInfoDictionary)
        {
            [UIView showAlertView:@"请先登录" andMessage:nil];
            NSLog(@"用户信息出错");
            return nil;
        }
        
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
    
    _isAutomaticAlarmClock = NO;
    _is24HoursTime = YES;
    _longTimeSetRemind = YES;
    _PreventLossRemind = YES;
    _isHandAlarmClock = NO;
    _stepNumber = 10000;
    
    _isShowMetricSystem = YES;
    
    
    if ([[_userInfoDictionary objectForKey:kUserInfoOfIsMetricSystemKey] isEqualToString:@"0"])
    {
        _isShowMetricSystem = NO;
    }
    
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
    oneHandSetAlarmClock1._weekDayArray = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", nil];
    
    
    HandSetAlarmClock *oneHandSetAlarmClock2 = [[HandSetAlarmClock alloc] init];
    oneHandSetAlarmClock2._setTime = @"23:00";
    oneHandSetAlarmClock2._isOpen = isOpen;
    oneHandSetAlarmClock2._weekDayArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    
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

/**
 *  更新给另一个Model(蓝牙交互和图表显示model)
 *
 *  @param theModel 蓝牙交互和图表显示model,如果为空，就是全局的model:[BLTManager sharedInstance].model
 */
+ (void) updateToBLTModel: (BLTModel *) theModel
{
// 步距 // 目标步数  // 体重 // 生日
    
    BraceletInfoModel *newestModel = [[BraceletInfoModel getUsingLKDBHelper] searchSingle:[BraceletInfoModel class] where:nil orderBy:@"_orderID"];
    
    if (!newestModel)
    {
        [UIView showAlertView:@"读取当前手环数据模型出错" andMessage:nil];
        return;
    }
    
    NSDictionary *userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
    
    if (!userInfoDictionary)
    {
        [UIView showAlertView:@"读取用户信息出错" andMessage:nil];
        return;
    }
    
    BLTModel *tempModel;
    if (theModel)
    {
        tempModel = theModel;
    }
    else
    {
        tempModel =  [BLTManager sharedInstance].model;
    }
    
    tempModel.stepSize = [[userInfoDictionary objectForKey:kUserInfoOfStepLongKey] integerValue];
    tempModel.targetStep = newestModel._stepNumber;
    tempModel.weight = [[userInfoDictionary objectForKey:kUserInfoOfWeightKey] integerValue];
    tempModel.birthDay = [[userInfoDictionary objectForKey:kUserInfoOfAgeKey] integerValue];
}



#pragma mark ---------------- 蓝牙对接 -----------------
/**
 *  更新个人信息到蓝牙设备
 *
 *  @param userInfoDic 用户基本信息， 如果为nil ,自动获取最新的用户信息
 *  @param theModel    上次选中的手环模型信息，如果为nil ,自动获取最新的手环模型信息
 *  @param resultBack  返回的结果Block
 */
+ (void) updateUserInfoToBLTWithUserInfo: (NSDictionary *) userInfoDic
                         withnewestModel: (BraceletInfoModel *) theModel
                             WithSuccess: (void (^)(bool success))resultBack
{
    BraceletInfoModel *newestModel;
    NSDictionary *userInfoDictionary;
    
    if (theModel)
    {
        newestModel = theModel;
    }
    else
    {
        newestModel = [[BraceletInfoModel getUsingLKDBHelper] searchSingle:[BraceletInfoModel class] where:nil orderBy:@"_orderID"];
        
        if (!newestModel)
        {
            [UIView showAlertView:@"读取当前手环数据模型出错" andMessage:nil];
            return;
        }

    }
    
    if (userInfoDic)
    {
        userInfoDictionary = userInfoDic;
    }
    else
    {
        userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
        
        if (!userInfoDictionary)
        {
            [UIView showAlertView:@"读取用户信息出错" andMessage:nil];
            return;
        }
    }

    //生日
    NSDate *theDate = [NSDate date];
    NSString *birthdayString = [userInfoDictionary objectForKey:kUserInfoOfAgeKey];
    if (![NSString isNilOrEmpty:birthdayString ])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:timeZone];
        theDate = [dateFormatter dateFromString:birthdayString];
    }
    
    BOOL isMetricSystem = YES;
    if ([[userInfoDictionary objectForKey:kUserInfoOfIsMetricSystemKey] isEqualToString:@"0"])
    {
        isMetricSystem = NO;
    }
    
    //体重
    NSString *weight = [userInfoDictionary objectForKey:kUserInfoOfWeightKey];
    
  
    
    if ([NSString isNilOrEmpty:weight])
    {
        weight = @"50";
    }
    else
    {
        if (!isMetricSystem)
        {
            weight = [NSString stringWithFormat:@"%d", (int) vBackToKG([weight integerValue]) ];
        }
    }
    
    //步长
    NSString *stepLong = [userInfoDictionary objectForKey:kUserInfoOfStepLongKey];
    
  
    if ([NSString isNilOrEmpty:stepLong])
    {
        stepLong = @"50";
    }
    else
    {
        if (!isMetricSystem)
        {
            stepLong = [NSString stringWithFormat:@"%d", (int) vBackToCM([stepLong integerValue]) ];
        }
    }
    
    //步数
    NSInteger targetSums = newestModel._stepNumber;
    
    [BLTSendData sendUserInformationBodyDataWithBirthDay:theDate withWeight:[weight integerValue] * 100 withTarget:targetSums withStepAway:[stepLong integerValue] withSleepTarget:8*60 withUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeSetUserInfo)
        {
            NSLog(@"更新个人相关信息成功");
            resultBack(YES);
        }
        else
        {
            NSLog(@"更新个人相关信息失败");
            resultBack(NO);
        }
    }];
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
