//
//  UserInfoHelp.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoHelp.h"

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
        
    }
}

- (void)setStep:(BOOL)step
{
    _step = step;
    
    if (_step)
    {
        
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
        
    }
}

@end
