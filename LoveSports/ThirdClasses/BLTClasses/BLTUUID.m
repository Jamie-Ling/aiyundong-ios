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
    return [CBUUID UUIDWithString:@"00000a60-0000-1000-8000-00805f9b34fb"];
}

// 写
+ (CBUUID *)txCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"00000a66-0000-1000-8000-00805f9b34fb"];
}

// 读
+ (CBUUID *)rxCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"00000a67-0000-1000-8000-00805f9b34fb"];
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

@end
