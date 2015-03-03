//
//  BLTSendData.m
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendData.h"
#import "BLTManager.h"
#import "NSDate+XY.h"
#import "PedometerModel.h"
#import "BraceletInfoModel.h"

@implementation AlarmClockModel

/**
 *  得到一个代表星期几的Uint8
 *
 *  @param weekNumber 0~7，1：代表每周一, 0代表无
 *
 *  @return 得到的Uint8
 */
+ (UInt8) getAUint8FromeWeekNumber: (NSInteger) weekNumber
{
    if (weekNumber == 0 || weekNumber > 7)
    {
        return 00000000;
    }
    UTF8Char repeatCharModel = 00000001;
    return repeatCharModel << weekNumber;

}

/**
 *  设置所有时间（时分秒&重复周期）
 *
 *  @param timeString  格式：23:01 或者  23:01:45
 *  @param repeatUntStringArray 装uint8的字符串数组如【@"1", @"2"】,代表每周一周二重复
 *  @param isFullWeekDay  是否是每天重复（周1至周日全部重复）
 */
- (void) setAllTimeFromTimeString: (NSString *) timeString
         withRepeatUntStringArray: (NSArray *) repeatUntStringArray
                  withFullWeekDay: (BOOL) isFullWeekDay
{
    if ([NSString isNilOrEmpty:timeString])
    {
        NSLog(@"字符串格式不符合要求");
        return;
    }
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    if ([timeArray count] < 2)
    {
        NSLog(@"字符串格式不符合要求");
        return;
    }
    self.hour = [[timeArray objectAtIndex:0] intValue];
    
    self.minutes = [[timeArray objectAtIndex:1] intValue];
    
    if ([timeArray count] == 3)
    {
         self.seconds = [[timeArray objectAtIndex:2] intValue];
    }
    else
    {
        self.seconds = 0;
    }
    
    if (isFullWeekDay)
    {
        self.repeat = 01111111;
        return;
    }
    
    UTF8Char repeatChar = 00000000;
    for (NSString *tempNumberString in repeatUntStringArray)
    {
        UInt8 tempUnt = [AlarmClockModel getAUint8FromeWeekNumber:[tempNumberString integerValue]];
        repeatChar = repeatChar || tempUnt;
    }
    self.repeat = repeatChar;
}

@end

@implementation BLTSendData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 只有同步今天的数据才有时序的分别为了实时传输.
        NSString *nowString = [[[NSDate date] dateToString] componentsSeparatedByString:@" "][0];
        if ([LS_LastSyncDate getObjectValue] && [nowString isEqualToString:[LS_LastSyncDate getObjectValue]])
        {
            _lastSyncOrder = [LS_LastSyncOrder getIntValue];
        }
        else
        {
            _lastSyncOrder = 0;
        }
        
        _startDate = [NSDate date];
        _endDate = [NSDate date];
    }
    
    return self;
}

DEF_SINGLETON(BLTSendData)

+ (UInt8)timeZone
{
    UInt8 sign = [NSDate timeZone] > 0 ? 0 : (0x01 << 7);
    return (UInt8)(sign | abs([NSDate timeZone]));
}

+ (void)sendBasicSetOfInformationData:(NSInteger)scale
                           withHourly:(NSInteger)hourly
                      withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[7] = {0xBE, 0x01, 0x01, 0xFE, scale, hourly, [self timeZone]};
    [self sendDataToWare:&val withLength:7 withUpdate:block];
}

// 设置本地时间，每次开程序都需要。
+ (void)sendLocalTimeInformationData:(NSDate *)date
                     withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[13] = {0xBE, 0x01, 0x02, 0xFE,
                    (UInt8)(date.year >> 8), (UInt8)date.year, date.month, date.day,
                    date.weekday, [self timeZone], date.hour, date.minute, date.second};
    [self sendDataToWare:&val withLength:13 withUpdate:block];
}

+ (void)sendUserInformationBodyDataWithBirthDay:(NSDate *)date
                                     withWeight:(NSInteger)weight
                                     withTarget:(NSInteger)target
                                   withStepAway:(NSInteger)step
                                withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[15] = {0xBE, 0x01, 0x03, 0xFE,
        (UInt8)(date.year >> 8), (UInt8)date.year, date.month, date.day,
        (UInt8)(weight >> 8), (UInt8)weight, (UInt8)(target >> 16), (UInt8)(target >> 8),
        (UInt8)target, (UInt8)(step >> 8) ,(UInt8)step};
    [self sendDataToWare:&val withLength:15 withUpdate:block];
}

+ (void)sendCheckDateOfHardwareDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x01, 0x02, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

+ (void)sendLookBodyInformationDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x01, 0x03, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

+ (void)sendSetHardwareScreenDataWithDisplay:(BOOL)black
                                 withWaiting:(BOOL)noWaiting
                             withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[6] = {0xBE, 0x01, 0x04, 0xED, black, noWaiting};
    [self sendDataToWare:&val withLength:6 withUpdate:block];
}

+ (void)sendPasswordProtectionDataWithOpen:(BOOL)open
                          withPassword:(NSString *)password
                       withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    NSInteger number = [password integerValue];
    UInt8 val[7] = {0xBE, 0x01, 0x05, 0xED, open, (UInt8)(number >> 8), (UInt8)number};
    [self sendDataToWare:&val withLength:7 withUpdate:block];
}

+ (void)sendHardwareStartupModelDataWithModel:(NSInteger)model
                                    withTimes:(NSArray *)times
                              withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[20] = {0xBE, 0x01, 0x06, 0xFE, model};
    
    int count = 4;
    if (times)
    {
        for (NSString *time in times)
        {
            count++;
            if (count > 19)
            {
                break;
            }

            NSInteger index = [time integerValue];
            val[count] = index / 10;
        }
    }
    
    if (count < 20)
    {
        for (int i = count + 1; i < 20; i++)
        {
            val[count] = 0xFF;
        }
    }
    
    [self sendDataToWare:&val withLength:20 withUpdate:block];
}

+ (void)sendSleepToRemindDataWithOpen:(BOOL)open
                             withPlan:(NSInteger)plan
                          withAdvance:(NSInteger)advance
                      withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[9] = {0xBE, 0x01, 0x07, 0xFE, open, plan / 60, plan % 60, advance / 60, advance % 60};
    [self sendDataToWare:&val withLength:9 withUpdate:block];
}

+ (void)sendCustomDisplayInterfaceDataWithOrder:(NSArray *)orders
                                withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[20] = {0xBE, 0x01, 0x08, 0xFE};
    
    int count = 3;
    if (orders)
    {
        for (NSString *order in orders)
        {
            count++;
            if (count > 19)
            {
                break;
            }
            
            val[count] = [order integerValue];
        }
    }
    
    if (count < 20)
    {
        for (int i = count + 1; i < 20; i++)
        {
            val[count] = 0xFF;
        }
    }
    
    [self sendDataToWare:&val withLength:20 withUpdate:block];
}

+ (void)sendAlarmClockDataWithOpen:(UInt8)open
                         withAlarm:(NSArray *)alarms
                   withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[20] = {0xBE, 0x01, 0x09, 0xFE, open};
    
    int count = 3;
    if (alarms)
    {
        for (AlarmClockModel *model in alarms)
        {
            count++;
            if (count > 19)
            {
                break;
            }
            
            val[count] = model.hour;
            count++;
            val[count] = model.minutes;
            count++;
            val[count] = model.repeat;
        }
    }
    
    if (count < 20)
    {
        for (int i = count + 1; i < 20; i++)
        {
            val[count] = 0x00;
        }
    }
    
    [self sendDataToWare:&val withLength:20 withUpdate:block];
}

+ (void)sendSedentaryRemindDataWithOpen:(BOOL)open
                              withTimes:(NSArray *)times
                        withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[19] = {0xBE, 0x01, 0x0C, 0xFE, open};
    
    int count = 4;
    if (times)
    {
        for (AlarmClockModel *model in times)
        {
            count++;
            if (count > 18)
            {
                break;
            }
            
            val[count] = model.hour;
            count++;
            val[count] = model.minutes;
        }
    }
    
    [self sendDataToWare:&val withLength:19 withUpdate:block];
}

+ (void)sendSetFactoryModelDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x01, 0x0D, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

+ (void)sendModifyDeviceNameDataWithName:(NSString *)name
                         withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[20] = {0xBE, 0x01, 0x0E, 0xFE, name.length};
    
    for (int i = 5; i < 20; i++)
    {
        val[i] = [name characterAtIndex:i];
    }

    [self sendDataToWare:&val withLength:20 withUpdate:block];
    
    if (name.length > 14)
    {
        usleep(5000);
        name = [name substringFromIndex:14];
        [self sendModifyDeviceNameDataWithName:name withUpdateBlock:block];
    }
}

+ (void)sendQueryCurrentPasswordDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x01, 0x05, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

+ (void)sendQShowCurrentPasswordDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x01, 0x0F, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

/**
 *  行针校正命令
 *
 */
+ (void)sendCorrectionCommandDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x01, 0x0A, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

+ (void)sendCurrentPositionDataWithHour:(NSInteger)hour
                             withMinute:(NSInteger)minute
                             withSecond:(NSInteger)second
                        withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[7] = {0xBE, 0x01, 0x10, 0xFE, hour, minute, second};
    [self sendDataToWare:&val withLength:7 withUpdate:block];
}

+ (void)sendSynchronousWorldTimeData:(NSDate *)date
                          withHourly:(NSInteger)hourly
                     withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[13] = {0xBE, 0x01, 0x14, 0xFE,
        (UInt8)(date.year >> 8), (UInt8)date.year, date.month, date.day,
        date.weekday, 8, date.hour, date.minute, date.second};
    [self sendDataToWare:&val withLength:13 withUpdate:block];
}

/**
 *  W240 专用
 */
+ (void)sendSetWearingWayDataWithRightHand:(BOOL)right
                           withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[5] = {0xBE, 0x01, 0x0B, 0xED, right};
    [self sendDataToWare:&val withLength:5 withUpdate:block];
}

/**
 *  W286 专用
 */
+ (void)sendOpenBacklightSetDataWithOpen:(BOOL)open
                               withTimes:(NSArray *)times
                         withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[9] = {0xBE, 0x01, 0x11, 0xFE, open};
    
    int count = 4;
    if (times)
    {
        for (AlarmClockModel *model in times)
        {
            count++;
            if (count > 8)
            {
                break;
            }
            
            val[count] = model.hour;
            count++;
            val[count] = model.minutes;
        }
    }
    
    [self sendDataToWare:&val withLength:9 withUpdate:block];
}

/**
 *           传输运动数据.
 */

+ (void)sendRequestHistorySportDataWithDate:(NSDate *)date
                           withOrder:(NSInteger)order
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[10] = {0xBE, 0x02, 0x01, 0xFE,
        (UInt8)(date.year >> 8), (UInt8)date.year,
        date.month, date.day, (UInt8)(order >> 8), (UInt8)order};
    
    for (int i = 0; i < 10; i++)
    {
        NSLog(@"%x", val[i]);
    }
    [self sendDataToWare:&val withLength:10 withUpdate:block];
}

// 请求保存历史数据的日期.
+ (void)sendHistoricalDataStorageDateWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x02, 0x05, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

// 删除某天的历史数据.
+ (void)sendDeleteSportDataWithDate:(NSDate *)date
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    NSInteger order = (date.hour * 60 + date.minute) / 5;
    UInt8 val[10] = {0xBE, 0x02, 0x02, 0xFE,
        (UInt8)(date.year >> 8), (UInt8)date.year,
        date.month, date.day, (UInt8)(order >> 8), (UInt8)order};
    
    for (int i = 0; i < 10; i++)
    {
        NSLog(@"%x", val[i]);
    }
    [self sendDataToWare:&val withLength:10 withUpdate:block];
}

// 请求今天数据的接口，已经关闭。
+ (void)sendRequestTodaySportDataWithOrder:(NSInteger)order
                           withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    NSLog(@"%d..%d", (UInt8)(order >> 8), (UInt8)order);
    UInt8 val[6] = {0xBE, 0x02, 0x03, 0xFE, (UInt8)(order >> 8), (UInt8)order};
    [self sendDataToWare:&val withLength:6 withUpdate:block];
}

// 该方法已经被取消。
+ (void)sendRealtimeTransmissionSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x02, 0x03, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

// 关闭实时传输.
+ (void)sendCloseTransmissionSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x02, 0x04, 0xED};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

// 升级指令
+ (void)sendUpdateFirmware
{
    UInt8 val[10] = {0xBE, 0xFE, 0x44, 0x46, 0x55, 0x01, 0x02, 0x00, 0xF0, 0x02};
    [self sendDataToWare:&val withLength:10 withUpdate:nil];
}

// 获取当前硬件以及固件的信息
+ (void)sendAccessInformationAboutCurrentHardwareAndFirmware:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[4] = {0xBE, 0x06, 0x09, 0xFB};
    [self sendDataToWare:&val withLength:4 withUpdate:block];
}

#pragma mark --- 命令转发中心 ---
+ (void)sendDataToWare:(void *)val withLength:(NSInteger)length withUpdate:(BLTAcceptDataUpdateValue)block
{
    [BLTAcceptData sharedInstance].updateValue = block;
    [BLTAcceptData sharedInstance].type = BLTAcceptDataTypeUnKnown;
    
    NSData *sData = [[NSData alloc] initWithBytes:val length:length];
    [[BLTManager sharedInstance] senderDataToPeripheral:sData];
}

// 逻辑方面的数据发送全部转移.
/*
// 同步历史数据.目前可以统一用历史接口而不单独使用同步今天的接口
- (void)synHistoryDataWithBackBlock:(BLTSendDataBackUpdate)block
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        if (block)
        {
            _backBlock = block;
        }
        
        _waitTime = 0;
        _failCount = 0;
        [[BLTAcceptData sharedInstance] cleanMutableData];
        // NSDate *date = [[NSDate dateWithString:[LS_LastSyncDate getObjectValue]] dateAfterDay:1];
        // _startDate = [_startDate dateAfterDay:1];
        
        // date = [NSDate dateWithTimeIntervalSinceNow:0];
        // date = [NSDate dateWithString:@"2015-02-02"];
        // NSLog(@".date = .%@", date);
        if ([_startDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970])
        {
            _startDate = [NSDate date];
            return;
        }
        
        NSInteger timeOrder = 0;
        if ([_startDate isSameWithDate:[NSDate date]])
        {
            timeOrder = _lastSyncOrder;
        }
        
        SHOWMBProgressHUDIndeterminate(@"同步中...", nil, YES);
        [BLTSendData sendRequestHistorySportDataWithDate:_startDate
                                               withOrder:timeOrder
                                         withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                             [self stopTimer];
                                             if (type == BLTAcceptDataTypeRequestHistorySportsData)
                                             {
                                                 _startDate = [_startDate dateAfterDay:1];
                                                 [self performSelector:@selector(startSyncHistoryData) withObject:nil afterDelay:0.5];
                                                 if (object && _startDate)
                                                 {
                                                     [self performSelectorInBackground:@selector(syncInBackGround:) withObject:@[object, _startDate]];
                                                 }
                                             }
                                             else if (type == BLTAcceptDataTypeError)
                                             {
                                                 NSLog(@"...失败。。。");
                                                 SHOWMBProgressHUD(@"同步数据失败...", nil, nil, NO, 2.0);
                                             }
                                             else if (type == BLTAcceptDataTypeRequestHistoryNoData)
                                             {
                                                 SHOWMBProgressHUD(@"没有最新的数据.", nil, nil, NO, 2.0);
                                             }
                                         }];
        [self startTimer];
    }
    else
    {
        SHOWMBProgressHUD(@"设备没有链接.", @"无法同步数据.", nil, NO, 2.0);
    }
}

- (void)syncInBackGround:(NSArray *)array
{
    NSInteger timeOrder = 0;
    if ([_startDate isSameWithDate:[NSDate date]])
    {
        timeOrder = _lastSyncOrder;
    }
    
    // 保存数据后的回调
    [PedometerModel saveDataToModel:array withTimeOrder:timeOrder withEnd:^(NSDate *date, BOOL success){
        if (success)
        {
            [self performSelectorOnMainThread:@selector(endSyncData:) withObject:date waitUntilDone:NO];
        }
        else
        {
            // 此处删除错误数据
        }
    }];
}

// 同步数据结束
- (void)endSyncData:(NSDate *)date
{
    if (_backBlock)
    {
        _backBlock(date);
        _backBlock = nil;
    }
}

- (void)startTimer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(supervisionSync) userInfo:nil repeats:YES];
    }
}

// 监察同步状态
- (void)supervisionSync
{
    _waitTime ++;
    
    if (_waitTime > 10 || _failCount > 10)
    {
        // 停止同步数据因意外情况
        [self stopTimer];
        SHOWMBProgressHUD(@"同步数据失败...", nil, nil, NO, 2.0);
    }
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

#pragma mark --- 蓝牙连接后发送连续的指令 ---
- (void)sendContinuousInstruction
{
    [BLTSendData sendLocalTimeInformationData:[NSDate date] withUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeSetLocTime)
        {
            SHOWMBProgressHUD(@"设置时间成功", nil, nil, NO, 2);
        }
    }];
    
    [self performSelector:@selector(sendRequestWeight) withObject:nil afterDelay:0.3];
    
    // 如果已经设定过时区信息才获取历史纪录。测试demo版
    if ([LS_SettingBaseTimeZoneInfo getBOOLValue])
    {
        [self performSelector:@selector(sendRequestHistoryDataSaveDate) withObject:nil afterDelay:0.6];
    }
}

- (void)sendUpdateFirmware
{
    [BLTSendData sendUpdateFirmware];
}

- (void)sendRequestWeight
{
    [BraceletInfoModel updateToBLTModel:[BLTManager sharedInstance].model];
    [BraceletInfoModel updateUserInfoToBLTWithUserInfo:nil withnewestModel:nil WithSuccess:^(bool success) {
        
    }];
}

- (void)sendRequestHistoryDataSaveDate
{
    [BLTSendData sendHistoricalDataStorageDateWithUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeRequestHistoryDate)
        {
            if ([object isKindOfClass:[NSArray class]] && ((NSArray *)object).count == 2)
            {
                _startDate = [NSDate dateWithString:object[0]];
                if ([_startDate timeIntervalSince1970] < 0
                    || [_startDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]
                    || !_startDate)
                {
                    _startDate = [NSDate date];
                }
                else if ([_startDate timeIntervalSince1970] > 0 && ([[NSDate date] timeIntervalSince1970] - [_startDate timeIntervalSince1970]) > 60 * 24 * 3600)
                {
                    _startDate = [[NSDate date] dateAfterDay:-60];
                }
                
                _endDate = [NSDate dateWithString:object[1]];
                if ([_endDate timeIntervalSince1970] < 0
                    || [_endDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]
                    || !_endDate)
                {
                    _endDate = [NSDate date];
                }
            }
            
            [self performSelector:@selector(startSyncHistoryData) withObject:nil afterDelay:0.3];
        }
    }];
}

- (void)startSyncHistoryData
{
    [self synHistoryDataWithBackBlock:_backBlock];
}
*/

@end
