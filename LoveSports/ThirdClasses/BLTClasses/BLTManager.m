
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
            [LS_BindingID setObjectValue:@[]];
        }
        
        if (![LS_LastWareUUID getObjectValue])
        {
            [LS_LastWareUUID setObjectValue:@""];
        }
        
        if (![LS_LastSyncDate getObjectValue])
        {
            [LS_LastSyncDate setObjectValue:[[NSDate date] dateToString]];
        }
        
        _connectState = BLTManagerNoConnect;
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
        
        _containNames = @[@"W240N", @"W240", @"ActivityTracker", @"MillionPedometer", @"W285", @"P118S"];
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
- (void)setElecQuantity:(NSInteger)elecQuantity
{
    _elecQuantity = elecQuantity;
    
    if (_elecQuantityBlock)
    {
        _elecQuantityBlock();
    }
}

#pragma mark --- 操作移动设备的蓝牙链接 ---
- (void)startCan
{
    [self resetDiscoverPeripheral];

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
    // 延迟链接
   // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkScanedAllWareDevice) object:nil];
   // [self performSelector:@selector(checkScanedAllWareDevice) withObject:nil afterDelay:4.0];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"advertisementData. ＝ .%@..", advertisementData);
    NSString *name = peripheral.name;
    if (![_containNames containsObject:name])
    {
       // return;
    }
    
    if (!_isUpdateing)
    {
        NSString *idString = [peripheral.identifier UUIDString];
        
        // 检查是否已经添加到设备数组了.
        BLTModel *model = [self checkIsAddInAllWareWithID:idString];
        
        if (model)
        {
            model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI ? RSSI : @"未知"];
        }
        else
        {
            model = [[BLTModel alloc] init];
            
            model.bltID = idString ? idString : @"";
            model.bltName = name;
            model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI ? RSSI : @"未知"];
            model.peripheral = peripheral;
            
            BLTModel *DBModel = [model getCurrentModelFromDB];
            if (!DBModel)
            {
                [_allWareArray addObject:model];
            }
            else
            {
                // 没有被忽略就加入到设备组。
                if (!DBModel.isIgnore)
                {
                    [_allWareArray addObject:model];
                }
            }
        }
       
        BOOL binding = [model checkBindingState];
        if (binding && _connectState != BLTManagerConnected)
        {
            // 如果该设备已经绑定并且没有连接设备时就直接连接.
            [self repareConnectedDevice:model];
        }
                
        if (_updateModelBlock)
        {
            _updateModelBlock(_model);
        }
    }
    else if (_isUpdateing)
    {
        NSString *idString = [peripheral.identifier UUIDString];
        if ([idString isEqualToString:_updateModel.bltID])
        {
            [self repareConnectedDevice:_updateModel];
        }
    }
}

- (void)checkScanedAllWareDevice
{
    NSInteger count = 0;
    BLTModel *bindModel = nil;
    for (BLTModel *model in _allWareArray)
    {
        for (NSString  *uuid in [LS_BindingID getObjectValue])
        {
            if ([model.bltID isEqualToString:uuid])
            {
                count ++;
                bindModel = model;
                if (count > 1)
                {
                    break;
                }
            }
        }
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkScanedAllWareDevice) object:nil];
    if (count == 1)
    {
        [self repareConnectedDevice:bindModel];
    }
    else
    {
        if (self.connectState != BLTManagerConnected)
        {
            [self performSelector:@selector(checkScanedAllWareDevice) withObject:nil afterDelay:4.0];
        }
    }
}

- (void)repareConnectedDevice:(BLTModel *)model
{
    NSLog(@".111model...%@", model.bltName);

    if (self.discoverPeripheral != model.peripheral)
    {
        [self dismissLink];
        _connectState = BLTManagerConnecting;
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
    NSLog(@"...正在连接...");
    _isConnectNext = NO;
    _connectState = BLTManagerConnected;
    _discoverPeripheral = peripheral;
    _discoverPeripheral.delegate = [BLTPeripheral sharedInstance];
    [BLTPeripheral sharedInstance].peripheral = _discoverPeripheral;
    
    if (!_isUpdateing)
    {
        [_discoverPeripheral discoverServices:@[BLTUUID.uartServiceUUID]];
    }
    else
    {
        if ([BLTDFUHelper sharedInstance].state == INIT)
        {
            [BLTDFUHelper sharedInstance].state = DISCOVERING;
            [_discoverPeripheral discoverServices:@[BLTUUID.updateServiceUUID]];
            [BLTDFUHelper sharedInstance].updatePeripheral = _discoverPeripheral;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    _isConnectNext = NO;
    _connectState = BLTManagerConnectFail;
    NSLog(@"链接失败");
    [self startCan];
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    _connectState = BLTManagerNoConnect;
    NSLog(@"失去链接..%@", error);
    
    if (_disConnectBlock)
    {
        _disConnectBlock();
    }
    
    [[BLTPeripheral sharedInstance] errorMessage];
    
    if (!_isConnectNext)
    {
        [self startCan];
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
    [self resetDiscoverPeripheral];
}

// 重置外围设备.
- (void)resetDiscoverPeripheral
{
    if (_discoverPeripheral)
    {
        _discoverPeripheral.delegate = nil;
        [_centralManager cancelPeripheralConnection:_discoverPeripheral];
        _discoverPeripheral = nil;
        [BLTPeripheral sharedInstance].peripheral = nil;
    }
    
    _model = nil;
}

/**
 *  准备固件更新.
 */
- (void)prepareUpdateFirmWare
{
    if (self.discoverPeripheral.state == CBPeripheralStateConnected)
    {
        [[BLTDFUHelper sharedInstance] prepareUpdateFirmWare:^{
            [self checkIsAllownUpdateFirmWare];
        }];
    }
    else
    {
        SHOWMBProgressHUD(@"设备没有链接.", nil, nil, NO, 2.0);
    }
}

- (void)checkIsAllownUpdateFirmWare
{
    _isUpdateing = YES;
    _updateModel = _model;
    [BLTSendData sendUpdateFirmware];
    
    [BLTDFUHelper sharedInstance].endBlock = ^(BOOL success) {
        [self firmWareUpdateEnd:success];
    };
    
    SHOWMBProgressHUD(@"固件升级中...", nil, nil, NO, 120);
}

- (void)firmWareUpdateEnd:(BOOL)success
{
    _isUpdateing = NO;
    _updateModel = nil;
    _connectState = BLTManagerNoConnect;
    [self startCan];
    
    if (success)
    {
        SHOWMBProgressHUD(@"固件更新成功", nil, nil, NO, 2.0);
    }
    else
    {
        SHOWMBProgressHUD(@"升级失败.", nil, nil, NO, 2.0);
    }
}

@end
