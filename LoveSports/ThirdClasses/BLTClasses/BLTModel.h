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
@property (nonatomic, strong) NSString *bltName;        // 设备名字
@property (nonatomic, strong) NSString *bltID;          // 设备UUID
@property (nonatomic, strong) NSString *bltVersion;     // 固件版本----已被取消
@property (nonatomic, strong) NSString *bltElec;        // 电量
@property (nonatomic, strong) NSString *bltRSSI;        // RSSI
@property (nonatomic, strong) CBPeripheral *peripheral; // 外围设备对象

@property (nonatomic, assign) NSInteger bltElecState;   // 充电状态

@property (nonatomic, assign) BOOL isLock;              // 是否设备了密码，被锁了
@property (nonatomic, assign) BOOL isConnected;         // 是否已经连接
@property (nonatomic, assign) BOOL isIgnore;            // 是否被忽略
@property (nonatomic, assign) BOOL isBinding;           // 是否绑定了
@property (nonatomic, assign, readonly) BOOL isNewDevice;         // 是否是新设备
@property (nonatomic, assign) BOOL isHaveActivePlace;   // 是否设置过活动时区

@property (nonatomic, assign) BOOL isClickBindSetting;       // 是否是绑定设置. 是的话就不要同步.

@property (nonatomic, strong) NSString *hardType;       // 硬件型号
@property (nonatomic, assign) NSInteger hardVersion;    // 硬件版本
@property (nonatomic, assign) NSInteger firmVersion;    // 固件版本

@property (nonatomic, assign) BOOL isInitiative;        // 是否主动断开的.

@property (nonatomic, assign) BOOL isLeftHand;  // 佩戴方式

@property (nonatomic, strong) NSArray *alarmArray; //闹钟
@property (nonatomic, strong) NSArray *remindArray; //久坐提醒.

@property (nonatomic, assign) BOOL isRealTime; // 是否时时同步
@property (nonatomic, assign) BOOL isRepeatConnect; // 是否重链接


+ (instancetype)initWithUUID:(NSString *)uuid;

/**
 *  伪造固件信息
 */
- (void)forgeFirmwareInformation;
- (BLTModel *)getCurrentModelFromDB;
//根据uuid创造模型.
+ (BLTModel *)getModelFromDBWtihUUID:(NSString *)uuid;

+ (void)addBindingDeviceWithUUID:(NSString *)string;
+ (void)removeBindingDeviceWithUUID:(NSString *)string;
- (BOOL)checkBindingState;
+ (void)updateDeviceName:(NSString *)name;
- (NSString *)imageForsignalStrength;

@end
