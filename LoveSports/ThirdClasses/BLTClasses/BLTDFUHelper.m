//
//  BLTDFUHelper.m
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTDFUHelper.h"
#import "ViewController.h"

@implementation BLTDFUHelper

DEF_SINGLETON(BLTDFUHelper)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _state = INIT;
    }
    
    return self;
}

- (void)prepareUpdateFirmWare:(BLTDFUHelperPrepareUpdate)updateBlock
{
    _firmData = [BLTDFUBaseInfo getUpdateFirmWareData];
    _interval = _firmData.length / (DFUCONTROLLER_MAX_PACKET_SIZE * DFUCONTROLLER_DESIRED_NOTIFICATION_STEPS);
    _packetSize = _firmData.length;
    if (_firmData)
    {
        if (updateBlock)
        {
            updateBlock();
        }
    }
}

- (void)setControlPointChar:(CBCharacteristic *)controlPointChar
{
    if (controlPointChar != _controlPointChar)
    {
        _controlPointChar = controlPointChar;
        [self checkAllCharacteristicIsExist];
    }
}

- (void)setPacketChar:(CBCharacteristic *)packetChar
{
    if (packetChar != _packetChar)
    {
        _packetChar = packetChar;
        [self checkAllCharacteristicIsExist];
    }
}

- (void)checkAllCharacteristicIsExist
{
    if (_controlPointChar && _packetChar)
    {
        [self didFinishDiscovery];
    }
}

- (void)receiveControlPointInfo:(const void *)bytes
{
    dfu_control_point_data_t *packet = (dfu_control_point_data_t *)bytes;

    if (packet->opcode == RESPONSE_CODE)
    {
        [self didReceiveResponse:packet->response forCommand:packet->original];
    }
    else if (packet->opcode == RECEIPT)
    {
        [self didReceiveReceipt];
    }
}

- (void)setState:(DFUControllerState)newState
{
    @synchronized(self)
    {
        _state = newState;
        
        if (newState == INIT)
        {
            _firmDataSend = 0;
        }
        else if (newState == IDLE)
        {
            [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(updateFirmWareDelay) userInfo:nil repeats:NO];
        }
    }
}

- (NSString *)stringFromState:(DFUControllerState)state
{
    switch (state)
    {
        case INIT:
            return @"Init";
            
        case DISCOVERING:
            return @"Discovering";
            
        case IDLE:
            return @"Ready";
            
        case SEND_NOTIFICATION_REQUEST:
        case SEND_START_COMMAND:
        case SEND_RECEIVE_COMMAND:
        case SEND_FIRMWARE_DATA:
        case WAIT_RECEIPT:
            return @"Uploading";
            
        case SEND_VALIDATE_COMMAND:
        case SEND_RESET:
            return @"Finishing";
            
        case FINISHED:
            return @"Finished";
            
        case CANCELED:
            return @"Canceled";
    }
    
    return nil;
}

- (void)updateFirmWareDelay
{
    [self startTransfer];
}

- (void)startTransfer
{
    self.state = SEND_NOTIFICATION_REQUEST;
    
    dfu_control_point_data_t data;
    data.opcode = REQUEST_RECEIPT;
    data.n_packets = _interval;
    
    NSData *commandData = [NSData dataWithBytes:&data length:3];
    [self senderDataToPeripheralForUpdata:commandData];
}

// 升级时给外围设备发送数据
- (void)senderDataToPeripheralForUpdata:(NSData *)data
{
    if (_updatePeripheral.state == CBPeripheralStateConnected)
    {
        [_updatePeripheral writeValue:data forCharacteristic:_controlPointChar type:CBCharacteristicWriteWithResponse];
    }
}

- (void)didFinishDiscovery
{
    NSLog(@"didFinishDiscovery");
    if (self.state == DISCOVERING)
    {
        self.state = IDLE;
    }
}

- (void) didWriteControlPoint
{
    NSLog(@"didWriteControlPoint, state %d", self.state);
    
    switch (self.state)
    {
        case SEND_NOTIFICATION_REQUEST:
            self.state = SEND_START_COMMAND;
            [self sendStartCommand:(int)_firmData.length];
            break;
            
        case SEND_RECEIVE_COMMAND:
            self.state = SEND_FIRMWARE_DATA;
            [self sendFirmwareChunk];
            break;
            
        case SEND_RESET:
            self.state = FINISHED;
            _firmDataSend = 0;
            _updatePeripheral = nil;
            _controlPointChar = nil;
            _packetChar = nil;
            self.state = INIT;
            
            if (_endBlock)
            {
                _endBlock(YES);
            }
            // [self repeatLinkHardWare:nil];
            // _showAlert(@"升级成功.");
            break;
            
        case CANCELED:
            // _showAlert(@"取消升级.");
            
            if (_endBlock)
            {
                _endBlock(NO);
            }
            
            break;
            
        default:
            break;
    }
}

- (void) sendStartCommand:(int) firmwareLength
{
    NSLog(@"sendStartCommand");
    dfu_control_point_data_t data;
    data.opcode = START_DFU;
    
    NSData *commandData = [NSData dataWithBytes:&data length:1];
    [_updatePeripheral writeValue:commandData forCharacteristic:_controlPointChar type:CBCharacteristicWriteWithResponse];
    
    NSData *sizeData = [NSData dataWithBytes:&firmwareLength length:sizeof(firmwareLength)];
    [_updatePeripheral writeValue:sizeData forCharacteristic:_packetChar type:CBCharacteristicWriteWithoutResponse];
}

- (void)sendFirmwareChunk
{
    NSLog(@"sendFirmwareData");
    int currentDataSent = 0;
    
    for (int i = 0; i < _interval && _firmDataSend < _firmData.length; i++)
    {
        unsigned long length = (_firmData.length - _firmDataSend) > DFUCONTROLLER_MAX_PACKET_SIZE ? DFUCONTROLLER_MAX_PACKET_SIZE : _firmData.length - _firmDataSend;
        NSRange currentRange = NSMakeRange(_firmDataSend, length);
        NSData *currentData = [_firmData subdataWithRange:currentRange];
        
        usleep(5000);
        [_updatePeripheral writeValue:currentData forCharacteristic:_packetChar type:CBCharacteristicWriteWithoutResponse];
        _firmDataSend += length;
        currentDataSent += length;
    }
    
    [self didWriteDataPacket];
    
    NSLog(@"Sent %d bytes, total %ld.", currentDataSent, (long)_firmDataSend);
}

- (void)didWriteDataPacket
{
    NSLog(@"didWriteDataPacket");
    
    if (self.state == SEND_FIRMWARE_DATA)
    {
        self.state = WAIT_RECEIPT;
    }
}

- (void)didReceiveResponse:(DFUTargetResponse)response forCommand:(DFUTargetOpcode)opcode
{
    NSLog(@"didReceiveResponse, %d, in state %d", response, self.state);
    switch (self.state)
    {
        case SEND_START_COMMAND:
            if (response == SUCCESS)
            {
                self.state = SEND_RECEIVE_COMMAND;
                
                dfu_control_point_data_t data;
                data.opcode = RECEIVE_FIRMWARE_IMAGE;
                
                NSData *commandData = [NSData dataWithBytes:&data length:1];
                [_updatePeripheral writeValue:commandData forCharacteristic:_controlPointChar type:CBCharacteristicWriteWithResponse];
            }
            break;
            
        case SEND_VALIDATE_COMMAND:
            if (response == SUCCESS)
            {
                self.state = SEND_RESET;
                if (_controlPointChar)
                {
                    dfu_control_point_data_t data;
                    data.opcode = ACTIVATE_RESET;
                    
                    NSData *commandData = [NSData dataWithBytes:&data length:1];
                    [_updatePeripheral writeValue:commandData forCharacteristic:_controlPointChar type:CBCharacteristicWriteWithResponse];
                }
            }
            break;
            
        case WAIT_RECEIPT:
            if (response == SUCCESS && opcode == RECEIVE_FIRMWARE_IMAGE)
            {
                self.state = SEND_VALIDATE_COMMAND;
                dfu_control_point_data_t data;
                data.opcode = VALIDATE_FIRMWARE;
                
                NSData *commandData = [NSData dataWithBytes:&data length:1];
                [_updatePeripheral writeValue:commandData forCharacteristic:_controlPointChar type:CBCharacteristicWriteWithResponse];
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveReceipt
{
    NSLog(@"didReceiveReceipt");
    
    if (self.state == WAIT_RECEIPT)
    {
        self.state = SEND_FIRMWARE_DATA;
        [self sendFirmwareChunk];
    }
}

@end
