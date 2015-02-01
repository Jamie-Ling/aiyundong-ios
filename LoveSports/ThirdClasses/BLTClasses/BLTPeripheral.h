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
typedef void(^BLTPeripheralGetDeviceInfo)();
typedef void(^BLTPeripheralRSSI)(NSInteger RSSI);
typedef void(^BLTPeripheralUpdateBIgdata)(NSData *data);

@property (nonatomic, strong) BLTPeripheralUpdate updateBlock;
@property (nonatomic, strong) BLTPeripheralUpdateBIgdata updateBigDataBlock;
@property (nonatomic, strong) BLTPeripheralGetDeviceInfo deviceInfoBlock;
@property (nonatomic, strong) BLTPeripheralRSSI RSSIBlock;

@property (nonatomic, strong) CBPeripheral *peripheral;

AS_SINGLETON(BLTPeripheral)

- (void)startUpdateRSSI;
- (void)stopUpdateRSSI;

@end
