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
@property (nonatomic, strong) CBPeripheral *peripheral; // 外围设备对象

@property (nonatomic, assign) NSInteger bltElecState;   // 充电状态
@property (nonatomic, assign) BOOL isBinding;

@property (nonatomic, assign) BOOL isLock; // 是否设备了密码，被锁了
@property (nonatomic, assign) BOOL isConnected; // 是否已经连接
@property (nonatomic, assign) BOOL isIgnore; // 是否被忽略

/**
 *  伪造固件信息
 */
- (void)forgeFirmwareInformation;
- (BLTModel *)getCurrentModelFromDB;

@end
