//
//  DataShare.m
//  LoveSports
//
//  Created by zorro on 15/3/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DataShare.h"

@implementation DataShare

DEF_SINGLETON(DataShare)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _showCount = 8;
        _isPad = NO;
        _isIp4s = NO;
        _isIp5 = NO;
        _isIp6 = NO;
        _isIp6P = NO;
        
        _currentDate = [NSDate date];
    }
    
    return self;
}

- (void)checkDeviceModel
{
    if ([XYSystemInfo isDevicePad])
    {
        _isPad = YES;
    }
    else if ([XYSystemInfo isPhoneRetina35])
    {
        _isIp4s = YES;
    }
    else if ([XYSystemInfo isPhoneRetina4])
    {
        _isIp5 = YES;
    }
    else if ([XYSystemInfo isPhoneSix])
    {
        _isIp6 = YES;
    }
    else if ([XYSystemInfo isPhoneSixPlus])
    {
        _isIp6P = YES;
    }
    else
    {
        _isIp5 = YES;
    }
}

+ (BOOL)isPad
{
    return [DataShare sharedInstance].isPad;
}

+ (BOOL)isIpFour
{
    return [DataShare sharedInstance].isIp4s;
}

+ (BOOL)isIpFive
{
    return [DataShare sharedInstance].isIp5;
}

+ (BOOL)isIpSix
{
    return [DataShare sharedInstance].isIp6;
}

+ (BOOL)isIpSixP
{
    return [DataShare sharedInstance].isIp6P;
}

- (UIImage *)getHeadImage
{
    NSString *headFold = [[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_HeadImage];
    NSString *filePath = [headFold stringByAppendingPathComponent:DS_HeadImage];
    
    if ([self completePathDetermineIsThere:filePath])
    {
        return [UIImage imageWithFile:filePath];
    }
    else
    {
        return UIImageNamed(@"头像@2x.png");
    }
}

// 对完整的文件路径进行判断,isDirectory 如果是文件夹返回YES, 如果不是返回NO.
- (BOOL)completePathDetermineIsThere:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path];
    
    return existed;
}

- (StepDataRecord *)stepRecord
{
    if (!_stepRecord)
    {
        _stepRecord = [StepDataRecord getStepDataRecordFromDB];
    }
    
    return _stepRecord;
}

@end
