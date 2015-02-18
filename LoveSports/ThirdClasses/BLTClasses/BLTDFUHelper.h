//
//  BLTDFUHelper.h
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 固件更新

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLTDFUBaseInfo.h"
#import "Header.h"

typedef void(^BLTDFUHelperPrepareUpdate)();
typedef void(^BLTDFUHelperEnd)(BOOL success);

@interface BLTDFUHelper : NSObject

@property (nonatomic, assign) DFUControllerState state;
@property (nonatomic, strong) BLTDFUHelperEnd endBlock;

@property (nonatomic, strong) CBPeripheral *updatePeripheral;  //  正在更新的外围设备
@property (nonatomic, strong) NSData *firmData;                //  升级的数据包。
@property (nonatomic, assign) NSInteger interval;
@property (nonatomic, assign) NSInteger packetSize;
@property (nonatomic, assign) NSInteger firmDataSend;
@property (nonatomic, strong) CBCharacteristic *controlPointChar;
@property (nonatomic, strong) CBCharacteristic *packetChar;

AS_SINGLETON(BLTDFUHelper)

- (void)prepareUpdateFirmWare:(BLTDFUHelperPrepareUpdate)updateBlock;

// 接受来自控制中心的信息.
- (void)receiveControlPointInfo:(const void *)bytes;
- (void)didWriteControlPoint;

@end
