//
//  UserInfoHelp.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoHelp.h"
#import "BLTSendData.h"
#import "BLTSendOld.h"

@implementation UserInfoHelp

DEF_SINGLETON(UserInfoHelp)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _userModel = [UserInfoModel getUserInfoFromDB];
    }
    
    return self;
}

- (BLTModel *)braceModel
{
    BLTModel *model = [BLTManager sharedInstance].model;
    if (model)
    {
        return model;
    }
    else
    {
        NSString *where = [NSString stringWithFormat:@"bltID = '%@'", [LS_LastWareUUID getObjectValue]];
        model = [BLTModel searchSingleWithWhere:where orderBy:nil];
        
        if (model)
        {
            return model;
        }
        else
        {
            model = [BLTModel initWithUUID:@""];
            
            return model;
        }
    }
}

/**
 *  更新用户信息（实时获取最新的用户信息给到--》这个类的userModel）
 *
 *  @param userIngModel 正在用的Model(因为不会实时存到数据库），如果没有，可以传入nil
 *
 *  @return 最新的用户信息
 */
- (UserInfoModel *) updateUserInfo: (BraceletInfoModel *) userIngModel;
{
    if (!_userModel)
    {
        _userModel = [[UserInfoModel alloc] init];
    }
    
    NSDictionary *userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];  //最早是放userdefaults（因为Key名的不确定性）中，所以后面没有再花时间去修改了。这里直接转换到下面的模型里面
    if (!userInfoDictionary)
    {
        NSLog(@"没有用户存在");
        return nil;
    }
    
    _userModel.userName = @"用户名待完善";
    _userModel.password = @"密码待完善";
    _userModel.nickName = [userInfoDictionary objectForKey:kUserInfoOfNickNameKey];
    _userModel.avatar = [userInfoDictionary objectForKey:kUserInfoOfHeadPhotoKey];
    _userModel.birthDay = @"没多大用，暂未存储";
    _userModel.gender = [userInfoDictionary objectForKey:kUserInfoOfSexKey];
    _userModel.age = [[userInfoDictionary objectForKey:kUserInfoOfAgeKey] integerValue];
    _userModel.height = [[userInfoDictionary objectForKey:kUserInfoOfHeightKey] floatValue];
    _userModel.weight = [[userInfoDictionary objectForKey:kUserInfoOfWeightKey] floatValue];
    _userModel.step = [[userInfoDictionary objectForKey:kUserInfoOfStepLongKey] integerValue];
    
    if (!_userModel.braceletModel)
    {
        if (userIngModel)
        {
            _userModel.braceletModel = userIngModel;
        }
        else
        {
            BraceletInfoModel   *showModel = [[BraceletInfoModel getUsingLKDBHelper] searchSingle:[BraceletInfoModel class] where:nil orderBy:@"_orderID"];
            _userModel.braceletModel = showModel;
            
        }
    }
    
    _userModel.targetSteps = _userModel.braceletModel._stepNumber;
    //    _userModel.targetCalories = 1; //@"没有设置这一项了，得去算";
    //    _userModel.targetDistance = 1; //@"没有设置这一项了，得去算";
    //    _userModel.targetSleep = 1; //@"没有设置这一项了，得去算";
    
    //***注意是否是公制这个参数，存储时未做转换（多次切换时会有误差，所以直接存的是设置单位对应的数值）
    //   参数在这里： _userModel.braceletModel._isShowMetricSystem
    _userModel.isMetricSystem = _userModel.braceletModel._isShowMetricSystem;
    
    return _userModel;
}

- (void)sendSetUserInfo:(NSObjectSimpleBlock)backBlock
{
    if (![self checkDeviceIsConnect])
    {
        return;
    }
    
    NSDate *birthDay = [NSDate stringToDate:_userModel.birthDay];
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        [BLTSendData sendUserInformationBodyDataWithBirthDay:birthDay
                                                  withWeight:_userModel.weight
                                                  withTarget:_userModel.targetSteps
                                                withStepAway:_userModel.step
                                             withSleepTarget:_userModel.targetSleep
                                             withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                                 [self notifyViewWithBackBlock:backBlock
                                                                   withSuccess:type == BLTAcceptDataTypeSetUserInfo];
                                                 
                                             }];
        
    }
    else
    {
        [self sendOldDeviceUserInfo:backBlock];
    }
}

- (void)sendSetUserInfoAndActiveTimeZone:(NSObjectSimpleBlock)backBlock
{
    if (![self checkDeviceIsConnect])
    {
        return;
    }
    
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        [BLTSendData sendBasicSetOfInformationData:!_userModel.isMetricSystem
                              withActivityTimeZone:_userModel.activeTimeZone
                                   withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                       [self notifyViewWithBackBlock:backBlock
                                                         withSuccess:type == BLTAcceptDataTypeSetActiveTimeZone];
                                   }];
    }
    else
    {
        [self sendOldDeviceUserInfo:backBlock];
    }
}

- (void)sendOldDeviceUserInfo:(NSObjectSimpleBlock)backBlock
{
    NSDate *birthDay = [NSDate stringToDate:_userModel.birthDay];

    // type 0代表公制, 1代表英制
    [BLTSendOld sendOldSetUserInfo:[NSDate date]
                      withBirthDay:birthDay
                        withWeight:_userModel.weight
                   withTargetSteps:_userModel.targetSteps
                          withStep:_userModel.step
                          withType:!_userModel.isMetricSystem
                   withUpdateBlock:^(id object, BLTAcceptDataType type) {
                       [self notifyViewWithBackBlock:backBlock
                                         withSuccess:type == BLTAcceptDataTypeOldSetUserInfo];
                   }];
}

// 设置佩戴方式
- (void)sendSetAdornType:(NSObjectSimpleBlock)backBlock
{
    if (![self checkDeviceIsConnect])
    {
        return;
    }
    
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        [BLTSendData sendSetWearingWayDataWithRightHand:!_braceModel.isLeftHand
                                        withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                            [self notifyViewWithBackBlock:backBlock
                                                              withSuccess:type == BLTAcceptDataTypeSetWearingWay];
        }];
    }
    else
    {
        [BLTSendOld sendSetWearingWayDataWithRightHand:!_braceModel.isLeftHand
                                       withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                           [self notifyViewWithBackBlock:backBlock
                                                             withSuccess:type == BLTAcceptDataTypeOldSetWearingWay];
                                       }];
    }
}

- (void)sendSetSedentariness:(NSObjectSimpleBlock)backBlock
{
    if (![self checkDeviceIsConnect])
    {
        return;
    }
    
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        [BLTSendData sendSedentaryRemindDataWithRemind:_braceModel.remindArray withUpdateBlock:^(id object, BLTAcceptDataType type) {
            [self notifyViewWithBackBlock:backBlock
                              withSuccess:type == BLTAcceptDataTypeSetSedentaryRemind];
        }];
    }
    else
    {
        [BLTSendOld sendOldAboutEventWithRemind:_braceModel.remindArray withUpdateBlock:^(id object, BLTAcceptDataType type) {
            [self notifyViewWithBackBlock:backBlock
                              withSuccess:type == BLTAcceptDataTypeOldEventInfo];
        }];
    }
}

- (void)sendSetAlarmClock:(NSObjectSimpleBlock)backBlock
{
    if (![self checkDeviceIsConnect])
    {
        return;
    }
    
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        NSLog(@"._braceModel.alarmArray.%@", _braceModel.alarmArray);
        [BLTSendData sendAlarmClockDataWithAlarm:_braceModel.alarmArray withUpdateBlock:^(id object, BLTAcceptDataType type) {
            [self notifyViewWithBackBlock:backBlock
                              withSuccess:type == BLTAcceptDataTypeSetAlarmClock];
        }];
    }
    else
    {
        [BLTSendOld sendOldSetAlarmClockDataWithAlarm:_braceModel.alarmArray withUpdateBlock:^(id object, BLTAcceptDataType type) {
            [self notifyViewWithBackBlock:backBlock
                              withSuccess:type == BLTAcceptDataTypeOldSetAlarmClock];
        }];
    }
}

- (void)notifyViewWithBackBlock:(NSObjectSimpleBlock)backBlock withSuccess:(BOOL)success
{
    if (success)
    {
        if (backBlock) {
            backBlock(@(YES));
        }
    }
    else
    {
        if (backBlock) {
            backBlock(@(NO));
        }
    }
}

- (BOOL)checkDeviceIsConnect
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        return YES;
    }
    
    SHOWMBProgressHUD(@"设备没有连接.", nil, nil, NO, 2.0);
    return NO;
}

@end
