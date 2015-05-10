//
//  BLTPeripheral.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTPeripheral.h"
#import "BLTUUID.h"

@interface BLTPeripheral ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableData *receiveData;

@property (nonatomic, assign) CBCharacteristicWriteType writeType;

@end

@implementation BLTPeripheral

DEF_SINGLETON(BLTPeripheral)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _writeType = CBCharacteristicWriteWithResponse;

        _receiveData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)setPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral;
    
    if (peripheral)
    {
        // 不刷新rssi
        // [self startUpdateRSSI];
    }
    else
    {
       // [self stopUpdateRSSI];
    }
}

- (void)startUpdateRSSI
{
    [self stopTimer];
    
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
    }
}

- (void)updateRSSI
{
    if (_peripheral)
    {
        [_peripheral readRSSI];
    }
}

- (void)stopUpdateRSSI
{
    [self stopTimer];
}

- (void)stopTimer
{
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

#pragma mark --- CBPeripheralDelegate ---
// 发现该设备所持有的所有服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"发生错误.");
        [[BLTManager sharedInstance] dismissLink];
    }
    
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:BLTUUID.uartServiceUUID])
        {
            // self.blService = service;
            // [_peripheral discoverCharacteristics:nil forService:service];
            [_peripheral discoverCharacteristics:@[BLTUUID.txCharacteristicUUID,
                                                   BLTUUID.rxCharacteristicUUID,
                                                   BLTUUID.realTimeCharacteristicUUID]
                                      forService:service];
        }
        else if ([service.UUID isEqual:BLTUUID.deviceInformationServiceUUID])
        {
            [_peripheral discoverCharacteristics:@[BLTUUID.hardwareRevisionStringUUID] forService:service];
        }
        else if ([service.UUID isEqual:BLTUUID.updateServiceUUID])
        {
            [_peripheral discoverCharacteristics:@[BLTUUID.controlPointCharacteristicUUID, BLTUUID.packetCharacteristicUUID] forService:service];
        }
        else if ([service.UUID isEqual:BLTUUID.batteryServiceUUID])
        {
            [_peripheral discoverCharacteristics:@[BLTUUID.batteryCharacteristicUUID] forService:service];
        }
    }
}

// 发现该服务所持有的所有特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"特征错误...");
        [[BLTManager sharedInstance] dismissLink];
    }
    
    for (CBCharacteristic *charac in service.characteristics)
    {
        if ([charac.UUID isEqual:BLTUUID.rxCharacteristicUUID])
        {
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
            
            [[BLTSimpleSend sharedInstance] sendContinuousInstruction];
            
            if (_connectBlock)
            {
                _connectBlock();
            }
        }
        else if ([charac.UUID isEqual:BLTUUID.txCharacteristicUUID])
        {
            // 读取属性.
            [self readBluetoothWrittenWay:charac.properties];
            
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        else if ([charac.UUID isEqual:BLTUUID.realTimeCharacteristicUUID])
        {
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        else if ([charac.UUID isEqual:BLTUUID.controlPointCharacteristicUUID])
        {
            [BLTDFUHelper sharedInstance].controlPointChar = charac;
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        else if ([charac.UUID isEqual:BLTUUID.packetCharacteristicUUID])
        {
            [BLTDFUHelper sharedInstance].packetChar = charac;
        }
        else if ([charac.UUID isEqual:BLTUUID.batteryCharacteristicUUID])
        {
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
            // [_peripheral readValueForCharacteristic:charac];
            
            char batteryLevel;
            [charac.value getBytes:&batteryLevel length:1];
            
            NSLog(@".charac.value = .%@...%d..%d", charac, batteryLevel, (NSUInteger)batteryLevel);
            [BLTManager sharedInstance].elecQuantity = (NSUInteger)batteryLevel;
        }
    }
}

#pragma mark --- CBPeripheralDelegate 数据更新 ---
// 时时更新信号强度
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    if (_RSSIBlock)
    {
        NSInteger rssi = ABS([RSSI integerValue]);
        _RSSIBlock(rssi);
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_RSSIBlock)
    {
        NSInteger rssi = ABS([peripheral.RSSI integerValue]);
        _RSSIBlock(rssi);
    }
}

// 向设备写数据时会触发该代理...
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"写数据时发生错误...%@", error);
        
        [self dismissAndRepeatConnect];

        if (_failBlock)
        {
            _failBlock();
        }
    }
    else
    {
        NSLog(@"写入成功。");
    }
    
    if ([BLTManager sharedInstance].isUpdateing)
    {
        if (characteristic == [BLTDFUHelper sharedInstance].controlPointChar)
        {
            [[BLTDFUHelper sharedInstance] didWriteControlPoint];
        }
    }
}

// 外围设备数据有更新时会触发该方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"数据更新错误...");
        
        [self dismissAndRepeatConnect];

        if (_failBlock)
        {
            _failBlock();
        }
    }
    else
    {
        // NSLog(@"数据更新%@...%@\n", characteristic.value, characteristic.UUID);
        if ([characteristic.UUID isEqual:BLTUUID.txCharacteristicUUID])
        {
           // [self cleanMutableData:_receiveData];
           // [_receiveData appendData:characteristic.value];
            
            if (_updateBlock)
            {
                _updateBlock(characteristic.value);
            }
        }
        else if ([characteristic.UUID isEqual:BLTUUID.rxCharacteristicUUID])
        {
            [self cleanMutableData:_receiveData];
            [_receiveData appendData:characteristic.value];
            
            if (_updateBigDataBlock)
            {
                _updateBigDataBlock(_receiveData);
            }
        }
        else if ([characteristic.UUID isEqual:BLTUUID.realTimeCharacteristicUUID])
        {
            if (_realTimeBlock)
            {
                _realTimeBlock(characteristic.value);
            }
        }
        else if ([characteristic.UUID isEqual:BLTUUID.controlPointCharacteristicUUID])
        {
            [[BLTDFUHelper sharedInstance] receiveControlPointInfo:characteristic.value.bytes];
        }
        else if ([characteristic.UUID isEqual:BLTUUID.batteryCharacteristicUUID])
        {
            char batteryLevel;
            [characteristic.value getBytes:&batteryLevel length:1];
            
            [BLTManager sharedInstance].elecQuantity = (NSUInteger)batteryLevel;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        [self dismissAndRepeatConnect];

        NSLog(@"数据更新错误...");
    }
    else
    {
        if ([characteristic.UUID isEqual:BLTUUID.batteryCharacteristicUUID])
        {
            char batteryLevel;
            [characteristic.value getBytes:&batteryLevel length:1];
            
            [BLTManager sharedInstance].elecQuantity = (NSUInteger)batteryLevel;
        }
    }

}

#pragma mark --- 向外围设备发送数据 ---
- (void)senderDataToPeripheral:(NSData *)data
{
    if (_peripheral.state == CBPeripheralStateConnected)
    {
        CBUUID *serviceUUID = BLTUUID.uartServiceUUID;
        CBUUID *charaUUID = BLTUUID.txCharacteristicUUID;
        
        CBService *service = [self searchServiceFromUUID:serviceUUID withPeripheral:_peripheral];
        
        if (!service)
        {
            [self dismissAndRepeatConnect];
            NSLog(@"service有错误...");
            return;
        }
        
        CBCharacteristic *chara = [self searchCharacteristcFromUUID:charaUUID withService:service];
        if (!chara)
        {
            [self dismissAndRepeatConnect];
            NSLog(@"chara有错误...");
            return;
        }
        
        NSLog(@"..发送数据.....");
        [_peripheral writeValue:data forCharacteristic:chara type:_writeType];
    }
}

// 匹配相应的服务
- (CBService *)searchServiceFromUUID:(CBUUID *)uuid withPeripheral:(CBPeripheral *)peripheral
{
    for (int i = 0; i < peripheral.services.count; i++)
    {
        CBService *service = peripheral.services[i];
        if ([service.UUID isEqual:uuid])
        {
            return service;
        }
    }
    
    return  nil;
}

// 匹配相应的具体特征
- (CBCharacteristic *)searchCharacteristcFromUUID:(CBUUID *)uuid withService:(CBService *)service
{
    for (int i = 0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *chara = service.characteristics[i];
        if ([chara.UUID isEqual:uuid])
        {
            return chara;
        }
    }
    
    return nil;
}

- (void)readBluetoothWrittenWay:(NSInteger)properties
{
    NSInteger val[8] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};
    for (int i = 7; i >= 0; i--)
    {
        if (properties >= val[i])
        {
            if (val[i] >= 0x04)
            {
                if (val[i] == 0x08)
                {
                    NSLog(@"...响应式回复.");
                    _writeType = CBCharacteristicWriteWithResponse;
                    break;
                }
                else if (val[i] == 0x04)
                {
                    NSLog(@"...非响应式回复.");
                    _writeType = CBCharacteristicWriteWithoutResponse;
                    break;
                }
                else
                {
                    NSInteger tmp = properties - val[i];
                    if (tmp > 0x08)
                    {
                        [self readBluetoothWrittenWay:val[i]];
                    }
                    else
                    {
                        [self readBluetoothWrittenWay:tmp];
                    }
                    break;
                }
            }
            else
            {
                break;
            }
        }
    }
}

- (void)dismissAndRepeatConnect
{
    [[BLTManager sharedInstance] repeatConnectThenDismissCurrentModel:[BLTManager sharedInstance].model];
}

#pragma mark --- receiveData 数据清空 ---
- (void)cleanMutableData:(NSMutableData *)data
{
    [data resetBytesInRange:NSMakeRange(0, data.length)];
    [data setLength:0];
}

// 错误信息提示
- (void)errorMessage
{
    if (_failBlock)
    {
        _failBlock();
    }
}

@end
