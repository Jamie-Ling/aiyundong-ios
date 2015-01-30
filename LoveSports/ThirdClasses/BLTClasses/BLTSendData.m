//
//  BLTSendData.m
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendData.h"
#import "BLTManager.h"
#import "NSDate+XY.h"

@implementation BLTSendData

+ (void)sendBasicSetOfInformationData:(NSInteger)scale
                           withHourly:(NSInteger)hourly
                           withJetLag:(NSInteger)lag
{
    UInt8 val[7] = {0xBE, 0x01, 0x01, 0xFE, scale, hourly, ((0x01 << 7) | (lag * 2))};
    [self sendDataToWare:&val withLength:7];
}

+ (void)sendLocalTimeInformationData:(NSDate *)date withHourly:(NSInteger)hourly
{
    UInt8 val[13] = {0xBE, 0x01, 0x02, 0xFE,
                    date.year >> 8, date.year, date.month, date.day,
                    date.weekday, 8, date.hour, date.minute, date.second};
    [self sendDataToWare:&val withLength:13];
}

+ (void)sendUserInformationBodyDataWithBirthDay:(NSDate *)date
                                     withWeight:(NSInteger)weight
                                     withTarget:(NSInteger)target
                                   withStepAway:(NSInteger)step
{
    UInt8 val[15] = {0xBE, 0x01, 0x03, 0xFE,
        date.year >> 8, date.year, date.month, date.day,
        weight >> 8, weight, target >> 16, target >> 8,
        target, step >> 8 ,step};
    [self sendDataToWare:&val withLength:15];
}

+ (void)sendCheckDateOfHardwareData
{
    UInt8 val[4] = {0xBE, 0x01, 0x02, 0xED};
    [self sendDataToWare:&val withLength:4];
}

+ (void)sendAlarmClockData:(NSData *)data
{
    [[BLTManager sharedInstance] senderDataToPeripheral:data];
}

+ (void)sendDataToWare:(void *)val withLength:(NSInteger)length
{
    NSData *sData = [[NSData alloc] initWithBytes:val length:length];
    [[BLTManager sharedInstance] senderDataToPeripheral:sData];
}

@end
