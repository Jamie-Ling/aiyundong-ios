//
//  BLTUUID.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTUUID.h"

@implementation BLTUUID

#pragma mark --- 设备所包含的所有UUID ---
// 服务特征
+ (CBUUID *)uartServiceUUID
{
    return [CBUUID UUIDWithString:@"D0A2FF00-2996-D38B-E214-86515DF5A1DF"];
}

// 写
+ (CBUUID *)txCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"D0A2FF01-2996-D38B-E214-86515DF5A1DF"];
}

// 读
+ (CBUUID *)rxCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"D0A2FF02-2996-D38B-E214-86515DF5A1DF"];
}

// 实时传输通道04
+ (CBUUID *)realTimeCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"D0A2FF04-2996-D38B-E214-86515DF5A1DF"];
}

// 硬件绑定的特征
+ (CBUUID *)hardwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2A27"];
}

// 设备信息服务
+ (CBUUID *)deviceInformationServiceUUID
{
    return [CBUUID UUIDWithString:@"180A"];
}

// 升级服务UUID : 00001530-1212-EFDE-1523-785FEABCD123

// 升级时的服务
+ (CBUUID *)updateServiceUUID
{
    return [CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"];
}

// 控制中心.
+ (CBUUID *)controlPointCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"00001531-1212-EFDE-1523-785FEABCD123"];
}

// 数据传输通道
+ (CBUUID *)packetCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"00001532-1212-EFDE-1523-785FEABCD123"];
}

@end
