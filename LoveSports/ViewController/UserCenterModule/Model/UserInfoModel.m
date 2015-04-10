//
//  UserInfoModel.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
/*
 @"http://www.woyo.li/statics/users/avatar/46/thumbs/200_200_46.jpg?1422252425", kUserInfoOfHeadPhotoKey,
 @"1990-01-01", kUserInfoOfAgeKey,
 @"+8:00 北京", kUserInfoOfAreaKey,
 @"", kUserInfoOfDeclarationKey,
 @"172", kUserInfoOfHeightKey,
 @"75", kUserInfoOfStepLongKey,
 @"", kUserInfoOfInterestingKey,
 @"", kUserInfoOfNickNameKey,
 @"男", kUserInfoOfSexKey,
 @"62", kUserInfoOfWeightKey,
 @"1", kUserInfoOfIsMetricSystemKey,
 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _userName = @"iSport"; //这个不能修改. 目前为单用户使用.
        
        _avatar = @"http://www.woyo.li/statics/users/avatar/46/thumbs/200_200_46.jpg?1422252425";
        _birthDay = @"1990-01-01";
        _isMetricSystem = YES;
        _activePlace = @"亚洲/北京";
        _activeTimeZone = 8 * 2;
        _height = 172;
        _weight = 62;
        
        _gender = @"男";
        
        _targetSteps= 10000;
        _targetSleep = 60 * 8;
 
        _step = 50;
 
        _nickName = @"我是运动达人";
        _interest = @"爱运动";
        _manifesto = @"我要成为运动达人!";
    }
 
    return self;
}

- (void)setManifesto:(NSString *)manifesto
{
    _manifesto = manifesto;
    [self updateToDB];
}

- (void)setInterest:(NSString *)interest
{
    _interest = interest;
    [self updateToDB];
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    [self updateToDB];
}

- (void)setStep:(CGFloat)step
{
    _step = step;
    [self updateToDB];
}

- (void)setTargetSleep:(NSInteger)targetSleep
{
    _targetSleep = targetSleep;
    [self updateToDB];
}

- (void)setTargetSteps:(NSInteger)targetSteps
{
    _targetSteps = targetSteps;
    
    _targetCalories = [self stepsConvertCalories:_targetSteps
                                      withWeight:_weight
                                       withModel:_isMetricSystem];
    _targetDistance = [self StepsConvertDistance:_targetSteps
                                        withPace:_step];
    
    [self updateToDB];
}

- (void)setGender:(NSString *)gender
{
    _gender = gender;
    [self updateToDB];
}

- (void)setWeight:(CGFloat)weight
{
    _weight = weight;
    [self updateToDB];
}


- (void)setHeight:(CGFloat)height
{
    _height = height;
    [self updateToDB];
}

- (void)setActivePlace:(NSString *)activePlace
{
    _activePlace = activePlace;
    [self updateToDB];
}

- (void)setActiveTimeZone:(NSInteger)activeTimeZone
{
    _activeTimeZone = activeTimeZone;
    [self updateToDB];
}

- (void)setIsMetricSystem:(BOOL)isMetricSystem
{
    _isMetricSystem = isMetricSystem;
    [self updateToDB];
}

- (void)setBirthDay:(NSString *)birthDay
{
    _birthDay = birthDay;
    [self updateToDB];
}

+ (UserInfoModel *)getUserInfoFromDB
{
    NSString *where = [NSString stringWithFormat:@"userName = 'iSport'"];
    UserInfoModel *model = [UserInfoModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[UserInfoModel alloc] init];
    }
    
    return model;
}

- (NSString *)showTimeZone
{
    return [self activeConvertToString];
}

- (NSString *)showHeight
{
    if (_isMetricSystem)
    {
        return [NSString stringWithFormat:@"%.fcm", _height];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fft", vChangeToFT(_height)];
    }
}
        
- (NSString *)showWeight
{
    if (_isMetricSystem)
    {
        return [NSString stringWithFormat:@"%.fkg", _weight];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fft", vChangeToLB(_height)];
    }
}

- (NSString *)activeConvertToString
{
    NSInteger totalMin = _activeTimeZone * 3600 / 2 / 60;
    NSInteger hour = totalMin / 60;
    NSInteger min = totalMin % 60;
    NSString *string = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)min];
    NSString *timeZone = [NSString stringWithFormat:@"%@%@ %@", (_activeTimeZone >= 0) ? @"＋" : @"",
                           string, _activePlace];
    
    return timeZone;
}

- (void)updateTimeZone:(ShowTimeZone *)timeZone
{
    _activePlace = timeZone.showPlace;
    _activeTimeZone = timeZone.timeZone;
    
    [self updateToDB];
}

// 表名
+ (NSString *)getTableName
{
    return @"UserInfoModel";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
