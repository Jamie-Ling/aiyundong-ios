//
//  BLTSendData.m
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendData.h"
#import "BLTManager.h"

@implementation BLTSendData

+ (void)sendBasicSetOfInformationData:(NSData *)data
{
    //UInt8 val[7] = {0xBe, 0x01, 0x01, 0xFE, 0x00, 0x00, ((0x01 << 7) | 16)};
    UInt8 val[4] = {0xBE, 0x01, 0x02, 0xED};
    NSData *sData = [[NSData alloc] initWithBytes:&val length:4];
    [[BLTManager sharedInstance] senderDataToPeripheral:sData];
}

+ (void)sendBasicSetOfInformationData:(NSInteger)scale
                           withHourly:(NSInteger)hourly
                           withJetLag:(NSInteger)lag
{
    UInt8 val[7] = {0xBe, 0x01, 0x01, 0xFE, scale, hourly, ((0x01 << 7) | (lag * 2))};
    [self sendDataToWare:&val withLength:7];
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
