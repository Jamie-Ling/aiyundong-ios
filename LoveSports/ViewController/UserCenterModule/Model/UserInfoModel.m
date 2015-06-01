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
        _userName = LS_UserName; //这个不能修改. 目前为单用户使用.
        
        _avatar = @"http://www.woyo.li/statics/users/avatar/46/thumbs/200_200_46.jpg?1422252425";
        _birthDay = @"1990-01-01";
        _isMetricSystem = YES;
        _activePlace = LS_Text(@"Asia/Beijing");
        _activeTimeZone = 8 * 2;
        _height = 172;
        _genderSex = LS_Text(@"Male");

        _weight = 62;
        _step = 50;
        
        _targetSteps = 10000;
        _targetCalories = [self stepsConvertCalories:10000 withWeight:62 withModel:YES];
        _targetDistance = [self StepsConvertDistance:10000 withPace:50] / 1000;
        _targetSleep = 60 * 8;
        
        _nickName = @"";
        _interest = @"";
        _manifesto = @"";
    }
 
    return self;
}

// 恢复到默认设置.
- (void)restoreToDefaultSettings
{
    self.step = 50;
    self.targetSteps = 10000;
}

- (void)setManifesto:(NSString *)manifesto
{
    _manifesto = manifesto;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setInterest:(NSString *)interest
{
    _interest = interest;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setStep:(CGFloat)step
{
    _step = step;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setTargetSleep:(NSInteger)targetSleep
{
    _targetSleep = targetSleep;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setTargetSteps:(NSInteger)targetSteps
{
    _targetSteps = targetSteps;
    _targetCalories = [self stepsConvertCalories:_targetSteps
                                      withWeight:_weight
                                       withModel:_isMetricSystem];
    _targetDistance = [self StepsConvertDistance:_targetSteps
                                        withPace:_step] / 1000;
    
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setGenderSex:(NSString *)genderSex
{
    _genderSex = genderSex;
    [UserInfoModel updateToDB:self where:nil];
}


- (void)setWeight:(CGFloat)weight
{
    _weight = weight;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setActivePlace:(NSString *)activePlace
{
    _activePlace = activePlace;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setActiveTimeZone:(NSInteger)activeTimeZone
{
    _activeTimeZone = activeTimeZone;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setIsMetricSystem:(BOOL)isMetricSystem
{
    _isMetricSystem = isMetricSystem;
    [UserInfoModel updateToDB:self where:nil];
}

- (void)setBirthDay:(NSString *)birthDay
{
    _birthDay = birthDay;
    [UserInfoModel updateToDB:self where:nil];
}

+ (UserInfoModel *)getUserInfoFromDB
{
    NSString *where = [NSString stringWithFormat:@"userName = 'iSport'"];
    UserInfoModel *model = [UserInfoModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[UserInfoModel alloc] init];
        
        [model saveToDB];
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
        return [NSString stringWithFormat:@"%.f cm", _height];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1f in", CMChangeToIN(_height)];
    }
}
        
- (NSString *)showWeight
{
    if (_isMetricSystem)
    {
        return [NSString stringWithFormat:@"%.1f kg", _weight];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1f lb", vChangeToLB(_weight)];
    }
}

- (NSString *)showStep
{
    if (_isMetricSystem)
    {
        return [NSString stringWithFormat:@"%.fcm", _step];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1f in", CMChangeToIN(_step)];
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
    
    [UserInfoModel updateToDB:self where:nil];
}

- (NSString *)showGenderSex
{
    if ([_genderSex isEqualToString:@"Male"] ||
        [_genderSex isEqualToString:@"男"])
    {
        return LS_Text(@"Male");
    }
    else
    {
        return LS_Text(@"Female");
    }
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
