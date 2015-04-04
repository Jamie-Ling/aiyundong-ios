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
        _userModel = [[UserInfoModel alloc] init];
    }
    
    return self;
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


- (void)setTarget:(BOOL)target
{
    _target = target;
    if (_target)
    {
        [self sendSetUserInfo:nil];
    }
}


- (void)setStep:(BOOL)step
{
    _step = step;
    if (_step)
    {
        [self sendSetUserInfo:nil];
    }
}

- (void)setSedentariness:(BOOL)sedentariness
{
    _sedentariness = sedentariness;
    if (_sedentariness)
    {
        
    }
}

- (void)setAdorn:(BOOL)adorn
{
    _adorn = adorn;
    if (_adorn)
    {
        
    }
}

- (void)setAlarm:(BOOL)alarm
{
    _alarm = alarm;
    if (_alarm)
    {
        
    }
}

- (void)setUserInfo:(BOOL)userInfo
{
    _userInfo = userInfo;
    if (_userInfo)
    {
        [self sendSetUserInfo:nil];
    }
}

- (void)sendSetUserInfo:(NSObjectSimpleBlock)backBlock
{
    NSDate *birthDay = [NSDate stringToDate:_userModel.birthDay];
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        [BLTSendData sendUserInformationBodyDataWithBirthDay:birthDay
                                                  withWeight:_userModel.weight
                                                  withTarget:_userModel.targetSteps
                                                withStepAway:_userModel.step
                                             withSleepTarget:_userModel.targetSleep
                                             withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                                 if (type == BLTAcceptDataTypeSetUserInfo)
                                                 {
                                                     SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0)
                                                 }
                                                 else
                                                 {
                                                     SHOWMBProgressHUD(@"设置失败.", nil, nil, NO, 2.0);
                                                     usleep(5000);
                                                     [self sendSetUserInfo:^(id object) {
                                                     }];
                                                 }
                                             }];
        
    }
    else
    {
        // type 0代表公制, 1代表英制
        [BLTSendOld sendOldSetUserInfo:[NSDate date]
                          withBirthDay:birthDay
                            withWeight:_userModel.weight
                       withTargetSteps:_userModel.targetSteps
                              withStep:_userModel.step
                              withType:0
                       withUpdateBlock:^(id object, BLTAcceptDataType type) {
                           if (type == BLTAcceptDataTypeOldSetUserInfo)
                           {
                               SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0)
                           }
                           else
                           {
                               SHOWMBProgressHUD(@"设置失败.", nil, nil, NO, 2.0);
                               usleep(5000);
                               [self sendSetUserInfo:^(id object) {
                               }];
                           }
                       }];
    }
}

- (void)sendSetAdornType:(NSObjectSimpleBlock)backBlock
{
    
}

- (void)sendSetSedentariness:(NSObjectSimpleBlock)backBlock
{
    
}

- (void)sendSetAlarmClock:(NSObjectSimpleBlock)backBlock
{
    
}

@end
