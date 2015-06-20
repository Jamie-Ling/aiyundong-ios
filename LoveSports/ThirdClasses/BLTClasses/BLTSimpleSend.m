//
//  BLTSimpleSend.m
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSimpleSend.h"
#import "BLTManager.h"
#import "NSDate+XY.h"
#import "PedometerModel.h"
#import "BraceletInfoModel.h"
#import "BLTSendOld.h"

@implementation BLTSimpleSend

DEF_SINGLETON(BLTSimpleSend)

// 新设备的同步方法.
- (void)synNewDeviceHistoryDataWithBackBlock:(BLTSendDataBackUpdate)block
{
    if (block)
    {
        self.backBlock = block;
    }
    
    self.waitTime = 0;
    self.failCount = 0;
    [[BLTAcceptData sharedInstance] cleanMutableData];
    
    if ([self.startDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970])
    {
        self.startDate = [NSDate date];
        
        return;
    }

    if ([PedometerHelper queryWhetherCurrentDateDataSaveAllDay:self.startDate])
    {
        // 如果已经进行过完整的保存就不要再down了。
        self.startDate = [self.startDate dateAfterDay:1];
        [self startSyncHistoryData];
        
        return;
    }
    
    // SHOWMBProgressHUDIndeterminate(@"同步中...", nil, YES);
    [BLTSendData sendRequestHistorySportDataWithDate:self.startDate
                                           withOrder:0
                                     withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                         [self stopTimer];
                                         
                                         if (type == BLTAcceptDataTypeRequestHistorySportsData)
                                         {
                                             self.startDate = [self.startDate dateAfterDay:1];
                                             [self performSelector:@selector(startSyncHistoryData) withObject:nil afterDelay:0.3];
                                             if (object && self.startDate)
                                             {
                                                 [self performSelectorInBackground:@selector(syncInBackGround:) withObject:@[object, self.startDate]];
                                             }
                                         }
                                         else if (type == BLTAcceptDataTypeError)
                                         {
                                             NSLog(@"...失败。。。");
                                             SHOWMBProgressHUD(LS_Text(@"Data sync failed"), nil, nil, NO, 2.0);
                                             [self endSyncFail];
                                         }
                                         else if (type == BLTAcceptDataTypeRequestHistoryNoData)
                                         {
                                             NSString *dateString = [[self.startDate dateToString] componentsSeparatedByString:@" "][0];
                                             NSString *alertString = [NSString stringWithFormat:@"%@%@", dateString, LS_Text(@"No data")];
                                             SHOWMBProgressHUD(alertString, nil, nil, NO, 2.0);
                                             
                                             [PedometerHelper pedometerSaveEmptyModelToDBWithDate:self.startDate
                                                                                     isSaveAllDay:YES];
                                             self.startDate = [self.startDate dateAfterDay:1];
                                             [self performSelector:@selector(startSyncHistoryData) withObject:nil afterDelay:0.3];
                                         }
                                     }];
    [self startTimer];

}

// 开始同步数据。新设备.
- (void)startSyncHistoryData
{
    [self synHistoryDataWithBackBlock:self.backBlock];
}

/*
// 信息提示
void showMessage(BLTSimpleSendShowMessage showBlock)
{
    // 换了传输通道。02不用管实时
    if (![BLTRealTime sharedInstance].isRealTime || 1)
    {
        if (showBlock)
        {
            showBlock();
        }
    }
}*/

// 后台进行数据存储，存储完毕后进行回调.
- (void)syncInBackGround:(NSArray *)array
{
    // 保存数据后的回调
    [PedometerModel saveDataToModel:array withTimeOrder:0 withEnd:^(NSDate *date, BOOL success){
        if (success)
        {
            [self performSelectorOnMainThread:@selector(endSyncData:) withObject:date waitUntilDone:NO];
        }
        else
        {
            // 此处删除错误数据
            [self endSyncFail];
        }
    }];
}

//同步失败
- (void)endSyncFail
{
    if (self.backBlock)
    {
        self.backBlock(nil);
    }
}

// 同步数据结束
- (void)endSyncData:(NSDate *)date
{
    if (self.backBlock)
    {
        self.backBlock(date);
    }
}

// 新设备命令通道. 刚连接时
- (void)newDeviceChannel
{
    if (![BLTManager sharedInstance].model.isHaveActivePlace)
    {
        // 优先发送时区命令
        [[UserInfoHelp sharedInstance] sendSetUserInfoAndActiveTimeZone:^(id object) {
            if ([object boolValue])
            {
                [BLTManager sharedInstance].model.isHaveActivePlace = YES;
            }
        }];
    }
     
    // 设置当前时间.
    [self performSelector:@selector(sendCurrentTime) withObject:nil afterDelay:0.3];
    // 请求硬件信息.
    // [self performSelector:@selector(sendRequestHardInfo) withObject:nil afterDelay:0.6];
    // 发送用户个人信息。 体重 目标
    [self performSelector:@selector(sendRequestWeight) withObject:nil afterDelay:0.6];
    
    // 请求历史数据.
    [self performSelector:@selector(sendRequestHistoryDataSaveDate) withObject:nil afterDelay:0.9];

    /*
    if (![UserInfoHelp sharedInstance].braceModel.isClickBindSetting)
    {
        [self performSelector:@selector(sendRequestHistoryDataSaveDate) withObject:nil afterDelay:0.9];
    }
    else
    {
        [UserInfoHelp sharedInstance].braceModel.isClickBindSetting = NO;
    }
     */
}

- (void)testFirm
{
    [BLTSendData sendSetWearingWayDataWithRightHand:arc4random() % 2
                                    withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                    }];
}

// 设置当前时间
- (void)sendCurrentTime
{
    [BLTSendData sendLocalTimeInformationData:[NSDate date] withUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeSetCurrentTime )
        {
            // SHOWMBProgressHUD(@"设置时间成功", nil, nil, NO, 2);
        }
    }];
}

// 请求硬件信息
- (void)sendRequestHardInfo
{
    [BLTSendData sendAccessInformationAboutCurrentHardwareAndFirmware:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeInfoAboutHardAndFirm)
        {
            NSData *data = (NSData *)object;
            UInt8 val[20] = {0};
            [data getBytes:&val length:data.length];
            
            // 从固件获取设备的名字.
            [BLTManager sharedInstance].model.bltName =
            [NSString stringWithFormat:@"%c%c%c%c%c%c",
             val[4], val[5], val[6], val[7], val[8], val[9]];
            [BLTManager sharedInstance].model.hardVersion = val[10];
            [BLTManager sharedInstance].model.firmVersion = val[11];
            [BLTManager sharedInstance].model.isRealTime = (val[16] == 1) ? YES : NO;
            [BLTManager sharedInstance].elecQuantity = val[17];
            
            // 检查是否复位 复位了重新发送时制.
            if (!val[18])
            {
                [BLTManager sharedInstance].model.isHaveActivePlace = NO;
            }

            // 保存最后设备是新的还是旧的
            [LS_LastDeviceType setBOOLValue:[BLTManager sharedInstance].model.isNewDevice];

            NSLog(@"固件版本信息...%@..%ld..%ld..%@。。%d..%d", [BLTManager sharedInstance].model.bltName,
                  (long)[BLTManager sharedInstance].model.hardVersion,
                  (long)[BLTManager sharedInstance].model.firmVersion, data, val[16], val[17]);
        }
    }];
}

- (void)sendRequestWeight
{
    [[UserInfoHelp sharedInstance] sendSetUserInfo:nil];
}

- (void)sendRequestHistoryDataSaveDate
{
    [BLTSendData sendHistoricalDataStorageDateWithUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeRequestHistoryDate)
        {
            if ([object isKindOfClass:[NSArray class]] && ((NSArray *)object).count == 2)
            {
                self.startDate = [NSDate dateWithString:object[0]];
                if ([self.startDate timeIntervalSince1970] < 0
                    || [self.startDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]
                    || !self.startDate)
                {
                    self.startDate = [NSDate date];
                }
                else if ([self.startDate timeIntervalSince1970] > 0
                         && ([[NSDate date] timeIntervalSince1970] - [self.startDate timeIntervalSince1970]) > 15 * 24 * 3600)
                {
                    // 只能保存15天的数据.
                    self.startDate = [[NSDate date] dateAfterDay:-15];
                }
                
                self.endDate = [NSDate dateWithString:object[1]];
                if ([self.endDate timeIntervalSince1970] < 0
                    || [self.endDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]
                    || !self.endDate)
                {
                    self.endDate = [NSDate date];
                }
            }
            
            NSLog(@"..%@..%@", self.startDate, self.endDate);
            // self.startDate = [self.startDate dateAfterDay:-2];
            [self performSelector:@selector(startSyncHistoryData) withObject:nil afterDelay:0.3];
        }
    }];
}

// 如果开启了实时传输就发送实时传输
- (void)sendRealTime
{
    [BLTSendData sendRealtimeTransmissionSportDataWithUpdateBlock:nil];
}

/**
 *   ---------------------------------   定时器操作中心   --------------------------------------
 */
- (void)startTimer
{
    self.waitTime = 0;

    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(supervisionSync) userInfo:nil repeats:YES];
    }
}

// 监察同步状态
- (void)supervisionSync
{
    self.waitTime ++;
    
    // 10秒内没有新的数据, 那么表示当次数据同步失败.
    NSInteger waitTime = [BLTManager sharedInstance].model.isNewDevice ? 10 : 10;
    
    if (self.waitTime > waitTime)
    {
        // 停止同步数据因意外情况
        [self stopTimer];
        [self endSyncFail];
        dispatch_async(dispatch_get_main_queue(), ^{
            SHOWMBProgressHUD(LS_Text(@"Data sync failed"), nil, nil, NO, 2.0);
        });
    }
}

- (void)stopTimer
{
    if (self.timer)
    {
        if ([self.timer isValid])
        {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

/**
 *   ---------------------------------   调用旧设备的命令   --------------------------------------
 */
// 旧设备命令通道. 刚连接时设置用户信息
- (void)oldDeviceChannel
{
    [BLTSendOld setUserInfoToOldDevice];
}

// 旧设备的同步方法.
- (void)synOldDeviceHistoryDataWithBackBlock:(BLTSendDataBackUpdate)block
{
    [BLTSendOld sharedInstance].backBlock = block;
    [[BLTSendOld sharedInstance] startSyncHistoryData];
}

/**
 *   ---------------------------------   外部调用的命令   --------------------------------------
 */

#pragma mark --- 蓝牙连接后发送连续的指令 ---
- (void)sendContinuousInstruction
{
    // 纪录最后一次连的设备的uuid。
    [LS_LastWareUUID setObjectValue:[BLTManager sharedInstance].model.bltID];
    
    // 请求硬件信息.
    [self performSelector:@selector(sendRequestHardInfo) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(startSendCommandToInitialize) withObject:nil afterDelay:0.6];
}

- (void)startSendCommandToInitialize
{
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        [self newDeviceChannel];
    }
    else
    {
        [self oldDeviceChannel];
    }
    
    // 保存最后设备是新的还是旧的
    [LS_LastDeviceType setBOOLValue:[BLTManager sharedInstance].model.isNewDevice];
}

// 同步历史数据.目前可以统一用历史接口而不单独使用同步今天的接口
- (void)synHistoryDataWithBackBlock:(BLTSendDataBackUpdate)block
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        if ([BLTManager sharedInstance].model.isNewDevice)
        {
            [self synNewDeviceHistoryDataWithBackBlock:block];
        }
        else
        {
            [self synOldDeviceHistoryDataWithBackBlock:block];
        }
    }
    else
    {
        // SHOWMBProgressHUD(@"设备没有链接.", @"无法同步数据.", nil, NO, 2.0);
    }
}

// 程序进入到前台时的同步方法.
- (void)synHistoryDataEnterForeground
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        if ([BLTManager sharedInstance].model.isNewDevice)
        {
            if ([BLTManager sharedInstance].model.isRealTime)
            {
                [[BLTRealTime sharedInstance] startRealTimeTransWithBackBlock:nil];
            }
            else
            {
                [[BLTSimpleSend sharedInstance] synHistoryDataWithBackBlock:[BLTSimpleSend sharedInstance].backBlock];
            }
        }
        else
        {
            [[BLTSimpleSend sharedInstance] synHistoryDataWithBackBlock:[BLTSimpleSend sharedInstance].backBlock];
        }
    }
    else
    {
        // SHOWMBProgressHUD(@"设备没有链接.", @"无法同步数据.", nil, NO, 2.0);
    }
}

// 空中升级。
- (void)sendUpdateFirmware
{
    [BLTSendData sendUpdateFirmware];
}

@end
