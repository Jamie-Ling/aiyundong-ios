
//
//  BLTService.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTManager.h"
#import "BLTUUID.h"
#import "BLTAcceptData.h"

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
        if (![LS_BindingID getObjectValue])
        {
            [LS_BindingID setObjectValue:@""];
        }
        
        if (![LS_LastSyncDate getObjectValue])
        {
            [LS_LastSyncDate setObjectValue:[NSDate date]];
        }
        
        _allWareArray = [[NSMutableArray alloc] initWithCapacity:0];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
     
        [BLTPeripheral sharedInstance].connectBlock = ^() {
            if (_connectBlock)
            {
                _connectBlock();
            }
        };
        [BLTPeripheral sharedInstance].RSSIBlock = ^(NSInteger RSSI) {
            [self updateRSSI:RSSI];
        };
        
        _model = [[BLTModel alloc] init];
    }
    
    return self;
}

#pragma mark --- 外围设备信号更新触发的回调 ---
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
        _discoverPeripheral.delegate = nil;
        [_centralManager cancelPeripheralConnection:_discoverPeripheral];
        _discoverPeripheral = nil;
        [BLTPeripheral sharedInstance].peripheral = nil;
    }
    
    _model = nil;
    [self scan];
}

- (void)checkOtherDevices
{
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
    
    [_allWareArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BLTModel *model = obj;
        if (_model != model)
        {
            [_allWareArray removeObject:model];
        }
    }];
    
    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:nil];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"..%@", advertisementData);
    
    NSArray *uuidArray = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    if (uuidArray.count > 0)
    {
        CBUUID *currentUUID = [uuidArray lastObject];
        if ([currentUUID isEqual:[BLTUUID uartServiceUUID]] || 1)
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
                
                model.bltID = [peripheral.identifier UUIDString] ? [peripheral.identifier UUIDString] : @"";
                NSString *adverString = advertisementData[@"kCBAdvDataLocalName"];
                model.bltName = adverString ? adverString : @"";
                model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI];
                model.peripheral = peripheral;
                
                BLTModel *DBModel = [model getCurrentModelFromDB];
                if (!DBModel)
                {
                    [_allWareArray addObject:model];
                }
                else
                {
                    if (!DBModel.isIgnore)
                    {
                        [_allWareArray addObject:model];
                    }
                }
            }
            
            if ([idString isEqualToString:[LS_BindingID getObjectValue]])
            {
                [self repareConnectedDevice:model];
            }
            
            if (_updateModelBlock)
            {
                _updateModelBlock(_model);
            }
        }
    }
}

- (void)repareConnectedDevice:(BLTModel *)model
{
    NSLog(@"开始链接...");
    
    if (self.discoverPeripheral != model.peripheral)
    {
        _model = model;
        self.discoverPeripheral = model.peripheral;
        [self.centralManager connectPeripheral:model.peripheral options:nil];
        [self.centralManager stopScan];
    }
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

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    _discoverPeripheral = peripheral;
    _discoverPeripheral.delegate = [BLTPeripheral sharedInstance];
    [_discoverPeripheral discoverServices:@[BLTUUID.uartServiceUUID]];
    
    [BLTPeripheral sharedInstance].peripheral = _discoverPeripheral;
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    NSLog(@"链接失败");
    [self startCan];
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    NSLog(@"失去链接..%@", error);
    [self startCan];
    
    if (_disConnectBlock)
    {
        _disConnectBlock();
    }
    
    [[BLTPeripheral sharedInstance] errorMessage];
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
        
        NSLog(@"..发送数据.....");
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
