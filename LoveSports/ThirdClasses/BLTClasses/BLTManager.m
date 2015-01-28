
//
//  BLTService.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTManager.h"
#import "BLTPeripheral.h"
#import "BLTUUID.h"
#import "BLTSendData.h"

@interface BLTManager () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *discoverPeripheral;
@property (nonatomic, assign) NSInteger RSSI;

@end

@implementation BLTManager

DEF_SINGLETON(BLTManager)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _allWareArray = [[NSMutableArray alloc] initWithCapacity:0];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [BLTPeripheral sharedInstance].updateBlock = ^(NSData *data) {
            [self peripheralUpdate:data];
        };
        [BLTPeripheral sharedInstance].deviceInfoBlock = ^() {
            [self getCurrentDeviceInfo];
        };
        [BLTPeripheral sharedInstance].RSSIBlock = ^(NSInteger RSSI) {
            [self updateRSSI:RSSI];
        };
        
        _model = [[BLTModel alloc] init];
    }
    
    return self;
}

#pragma mark --- 对设备发送命令 ---
// 设备连接完毕
- (void)getCurrentDeviceInfo
{
    // [BLTSendData sendBasicSetOfInformationData:nil];
    
    if (_connectBlock)
    {
        _connectBlock();
    }
}

#pragma mark --- 外围设备数据更新了触发的回调 ---
- (void)peripheralUpdate:(NSData *)data
{
    UInt8 val[100] = {0};
    [data getBytes:&val length:data.length];
 
    if (_updateValueBlock)
    {
        _updateValueBlock(data);
    }
}

- (void)updateRSSI:(NSInteger)RSSI
{
    _model.bltRSSI = [NSString stringWithFormat:@"%ld", (long)RSSI];
    
    if (_updateModelBlock)
    {
        _updateModelBlock(_model);
    }
}

#pragma mark --- 通知界面的更新 ---


#pragma mark --- 操作移动设备的蓝牙链接 ---
- (void)startCan
{
    if (_discoverPeripheral)
    {
        [BLTPeripheral sharedInstance].peripheral = nil;
        _discoverPeripheral.delegate = nil;
        [_centralManager cancelPeripheralConnection:_discoverPeripheral];
        _discoverPeripheral = nil;
    }
    
    [self scan];
}

#pragma mark --- CBCentralManagerDelegate ---
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    [self scan];
}

- (void)scan
{
    if (_centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    [_allWareArray removeAllObjects];
    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"..%@", advertisementData);
    if (peripheral.name == NULL)
    {
        return;
    }
    
    NSCharacterSet *nameCharacters = [[NSCharacterSet
                                       characterSetWithCharactersInString:@"-_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:"] invertedSet];
    NSRange userNameRange = [peripheral.name rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound)
    {
        
        return;
    }
    
    NSArray *uuidArray = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    if (uuidArray.count > 0)
    {
        CBUUID *currentUUID = [uuidArray lastObject];
        if ([currentUUID isEqual:[BLTUUID uartServiceUUID]])
        {
            NSString *idString = [peripheral.identifier UUIDString];
            
            BLTModel *model = [self checkIsAddInAllWareWithID:idString];
            if (model)
            {
                 model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI];
            }
            else
            {
                model = [[BLTModel alloc] init];
                
                model.bltID = [peripheral.identifier UUIDString];
                NSString *adverString = advertisementData[@"kCBAdvDataLocalName"];
                model.bltName = adverString ? adverString : @"";
                model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI];
                model.peripheral = peripheral;
                
                [_allWareArray addObject:model];
            }
            
            
            if (_updateModelBlock)
            {
                _updateModelBlock(_model);
            }
            
            /*
            // 目前是直接连。。。实际上是需要展示的。。。
            if (self.discoverPeripheral != peripheral && !self.discoverPeripheral)
            {
                NSLog(@"开始链接...");
                self.discoverPeripheral = peripheral;
                [self.centralManager connectPeripheral:peripheral options:nil];
                [self.centralManager stopScan];
              
            }
             */
        }
    }
}

- (void)repareConnectedDevice:(BLTModel *)model
{
    NSLog(@"开始链接...");
    self.discoverPeripheral = model.peripheral;
    [self.centralManager connectPeripheral:model.peripheral options:nil];
    [self.centralManager stopScan];
}

- (BLTModel *)checkIsAddInAllWareWithID:(NSString *)idString
{
    for (BLTModel *model in _allWareArray)
    {
        if ([model.bltID isEqualToString:idString])
        {
            return model;
        }
    }
    
    return nil;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral");
    _discoverPeripheral = peripheral;
    _discoverPeripheral.delegate = [BLTPeripheral sharedInstance];
    [_discoverPeripheral discoverServices:@[BLTUUID.uartServiceUUID]];
    
    [BLTPeripheral sharedInstance].peripheral = _discoverPeripheral;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"链接失败");
    [self startCan];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"失去链接");
    [self startCan];
    
    if (_disConnectBlock)
    {
        _disConnectBlock();
    }
}

#pragma mark --- 向外围设备发送数据 ---
- (void)senderDataToPeripheral:(NSData *)data
{
    if (self.discoverPeripheral.state == CBPeripheralStateConnected)
    {
        CBUUID *serviceUUID = BLTUUID.uartServiceUUID;
        CBUUID *charaUUID = BLTUUID.txCharacteristicUUID;
        
        CBService *service = [self searchServiceFromUUID:serviceUUID withPeripheral:self.discoverPeripheral];
        
        if (!service)
        {
            NSLog(@"service有错误...");
            return;
        }
        
        CBCharacteristic *chara = [self searchCharacteristcFromUUID:charaUUID withService:service];
        if (!chara)
        {
            NSLog(@"chara有错误...");
            return;
        }
        
        [self.discoverPeripheral writeValue:data forCharacteristic:chara type:CBCharacteristicWriteWithResponse];
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

- (void)dismissLink
{
    if (_discoverPeripheral)
    {
        [self.centralManager cancelPeripheralConnection:_discoverPeripheral];
    }
}

@end
