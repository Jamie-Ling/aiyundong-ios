//
//  BLTPeripheral.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLTPeripheral : NSObject <CBPeripheralDelegate>

typedef CBPeripheral *(^BLTPeripheralPeripheral)();
typedef void(^BLTPeripheralUpdate)(NSData *data);
typedef void(^BLTPeripheralDidConnect)();
typedef void(^BLTPeripheralRSSI)(NSInteger RSSI);
typedef void(^BLTPeripheralUpdateBIgdata)(NSData *data);
typedef void(^BLTPeripheralUpdateRealTimedata)(NSData *data);
typedef void(^BLTPeripheralFail)();

@property (nonatomic, strong) BLTPeripheralUpdate updateBlock;
@property (nonatomic, strong) BLTPeripheralUpdateBIgdata updateBigDataBlock;
@property (nonatomic, strong) BLTPeripheralUpdateRealTimedata realTimeBlock;
@property (nonatomic, strong) BLTPeripheralDidConnect connectBlock;
@property (nonatomic, strong) BLTPeripheralRSSI RSSIBlock;
@property (nonatomic, strong) BLTPeripheralFail failBlock;

@property (nonatomic, strong) CBPeripheral *peripheral;

AS_SINGLETON(BLTPeripheral)

- (void)errorMessage;
- (void)startUpdateRSSI;
- (void)stopUpdateRSSI;

/**
 *  发送数据给固件
 *
 *  @param data 二进制数据
 */
- (void)senderDataToPeripheral:(NSData *)data;

@end
