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
