
//
//  BLTManager.m
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
            // 这个已经没用到了.
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
        
        // MillionPedometer == P118 W240=ActivityTracker
        _containNames = @[@"W240N", @"W240", @"ActivityTracker", @"MillionPedometer",
                          @"W286", @"P118S", @"W194"];
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
    
    if (_elecQuantity != 0)
    {
        [LS_ElecQuantity setIntValue:_elecQuantity];
    }
    
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
    
    // 先停止扫描然后继续扫描.
    [_centralManager stopScan];

    [_allWareArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BLTModel *model = obj;
        if (model.peripheral.state != CBPeripheralStateConnected)
        {
            [_allWareArray removeObject:model];
        }
    }];
    
    [self notifyViewUpdateModelState];
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
    NSString *name = peripheral.name;
    if (!name)
    {
        name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    }
    if (!name || ![_containNames containsObject:name])
    {
        return;
    }

    NSString *idString = [peripheral.identifier UUIDString];
    if (!idString)
    {
        return;
    }
    
    // NSLog(@"..%@..%@", advertisementData, [advertisementData objectForKey:@"kCBAdvDataLocalName"]);

    if (!_isUpdateing)
    {
        // 检查是否已经添加到设备数组了.
        BLTModel *model = [self checkIsAddInAllWareWithID:idString];
        
        if (model)
        {
            model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI ? RSSI : @""];
            model.peripheral = peripheral;
        }
        else
        {
            model = [BLTModel getModelFromDBWtihUUID:idString];
            
            model.bltName = name;
            model.bltRSSI = [NSString stringWithFormat:@"%@", RSSI ? RSSI : @""];
            model.peripheral = peripheral;
            
            // 没有被忽略就加入到设备组。
            // if (!model.isIgnore)
            {
                [_allWareArray addObject:model];
            }
        }
       
        model.isInitiative = NO;
        model.isRepeatConnect = NO;
        if (model.isBinding && !_model)
        {
            // 如果该设备已经绑定并且没有连接设备时就直接连接.
            [self repareConnectedDevice:model];
        }
        
        [self notifyViewUpdateModelState];
    }
    else if (_isUpdateing)
    {
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
    // 扫描时自动连接或者是切换设备.
    if (model.peripheral.state != CBPeripheralStateConnected)
    {
        if (_model)
        {
            // 将当前连接的模型干掉...
            [self initiativeDismissCurrentModel:_model];
        }
        
        _connectState = BLTManagerConnecting;
        
        // model有实际更新时。全局的也跟着更新.
        _model = model;
        _discoverPeripheral = _model.peripheral;
        [self.centralManager connectPeripheral:_model.peripheral options:nil];
        
        [UserInfoHelp sharedInstance].braceModel = _model;
        [_centralManager stopScan];
    }
}

- (void)removeModelFromAllWare:(BLTModel *)model
{
    [_allWareArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BLTModel *tmpModel = obj;
        if (tmpModel == model)
        {
            [_allWareArray removeObject:model];
        }
    }];
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
    _connectState = BLTManagerConnected;
    _discoverPeripheral = peripheral;
    _discoverPeripheral.delegate = [BLTPeripheral sharedInstance];
    [BLTPeripheral sharedInstance].peripheral = _discoverPeripheral;
    
    [self notifyViewUpdateModelState];

    if (!_isUpdateing)
    {
        [_discoverPeripheral discoverServices:@[BLTUUID.uartServiceUUID, BLTUUID.batteryServiceUUID]];
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
    [_centralManager connectPeripheral:peripheral options:nil];
    
    [self notifyViewUpdateModelState];
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
    
    // 主动解除断开的就不需要扫描连接.
    BLTModel *model = [self findModelWithPeripheral:peripheral];
    if (model)
    {
        if (!model.isInitiative)
        {
            if (model.isRepeatConnect)
            {
                [_centralManager connectPeripheral:peripheral options:nil];
            }
            else
            {
                [self startCan];
            }
        }
        else
        {
            // 主动断开的.
            model.isInitiative = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startCan) object:nil];
            [self performSelector:@selector(startCan) withObject:nil afterDelay:8.0];
        }
    }
    else
    {
        [self startCan];
    }
    
    [self notifyViewUpdateModelState];
}

// 只要外围设备发生变化了就通知刷新
- (void)notifyViewUpdateModelState
{
    if (_updateModelBlock)
    {
        _updateModelBlock(nil);
    }
}

- (void)dismissLink
{
    [self resetDiscoverPeripheral];
}

- (void)dismissLinkWithModel:(BLTModel *)model
{
    if (model == _model)
    {
        [self dismissLink];
    }
}

- (void)initiativeDismissCurrentModel:(BLTModel *)model
{
    model.isInitiative = YES;
    [_centralManager cancelPeripheralConnection:model.peripheral];
}

- (void)repeatConnectThenDismissCurrentModel:(BLTModel *)model
{
    model.isRepeatConnect = YES;
    [_centralManager cancelPeripheralConnection:model.peripheral];
}

// 从连接的设备组里面移除掉某个设备.
- (void)removeModelWithPeripheral:(CBPeripheral *)peripheral withArray:(NSMutableArray *)array
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BLTModel *model = obj;
        if (model.peripheral == peripheral)
        {
            [array removeObject:model];
            *stop = YES;
        }
    }];
}

// 在所有准备连接的数组中 根据设备寻找模型.
- (BLTModel *)findModelWithPeripheral:(CBPeripheral *)peripheral
{
    for (BLTModel *model in _allWareArray)
    {
        if (model.peripheral == peripheral)
        {
            return model;
        }
    }
    
    return nil;
}

// 重置外围设备.
- (void)resetDiscoverPeripheral
{
    if (_discoverPeripheral)
    {
        _discoverPeripheral.delegate = nil;
        [_centralManager cancelPeripheralConnection:_discoverPeripheral];
        _discoverPeripheral = nil;
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
        [BLTDFUHelper sharedInstance].endBlock = ^(BOOL success) {
            [self firmWareUpdateEnd:success];
        };
        
        [[BLTDFUHelper sharedInstance] prepareUpdateFirmWare:^{
            [self checkIsAllownUpdateFirmWare];
        }];
    }
    else
    {
        SHOWMBProgressHUD(LS_Text(@"No connect"), nil, nil, NO, 2.0);
    }
}

- (void)checkIsAllownUpdateFirmWare
{
    _isUpdateing = YES;
    _model.isRealTime = NO;
    _updateModel = _model;
    [BLTSendData sendUpdateFirmware];
    
    SHOWMBProgressHUD(LS_Text(@"Ready to update"), nil, nil, NO, 5.0);
}

- (void)firmWareUpdateEnd:(BOOL)success
{
    _isUpdateing = NO;
    _updateModel = nil;
    _discoverPeripheral.delegate = nil;
    _discoverPeripheral = nil;
    _connectState = BLTManagerNoConnect;
    [self startCan];
    
    if (success)
    {
        SHOWMBProgressHUD(LS_Text(@"Update successful"), nil, nil, NO, 2.0);
    }
    else
    {
        SHOWMBProgressHUD(LS_Text(@"Update failed"), nil, nil, NO, 2.0);
    }
}

@end
