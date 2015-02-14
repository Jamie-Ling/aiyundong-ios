//
//  BLTUUID.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLTUUID : NSObject

+ (CBUUID *)uartServiceUUID;
+ (CBUUID *)txCharacteristicUUID;
+ (CBUUID *)rxCharacteristicUUID;
+ (CBUUID *)realTimeCharacteristicUUID;

+ (CBUUID *)hardwareRevisionStringUUID;
+ (CBUUID *)deviceInformationServiceUUID;

@end
