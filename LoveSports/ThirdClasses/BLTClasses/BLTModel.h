//
//  BLTModel.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLTModel : NSObject

// 蓝牙硬件所涉及的数据
@property (nonatomic, strong) NSString *bltName;    // 设备名字
@property (nonatomic, strong) NSString *bltID;      // 设备ID
@property (nonatomic, strong) NSString *bltVersion;   // 硬件版本
@property (nonatomic, strong) NSString *bltElec;      // 电量
@property (nonatomic, strong) NSString *bltRSSI;    // RSSI
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, assign) NSInteger bltElecState;   // 充电状态

/**
 *  伪造固件信息
 */
- (void)forgeFirmwareInformation;

@end
