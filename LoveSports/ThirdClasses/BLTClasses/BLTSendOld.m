//
//  BLTSendOld.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendOld.h"

@implementation BLTSendOld

DEF_SINGLETON(BLTSendOld)

// 一
+ (void)sendOldSetUserInfo:(NSDate *)date
              withBirthDay:(NSDate *)birthDay
                withWeight:(NSInteger)weight
           withTargetSteps:(NSInteger)steps
                  withStep:(NSInteger)step
                  withType:(BOOL)type
           withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[20] = {01, 01, 00,
        (UInt8)date.year, date.month, date.day,
        (UInt8)(birthDay.year >> 8), (UInt8)birthDay.year, birthDay.month,
        (UInt8)(weight >> 8), (UInt8)weight,
        (UInt8)(steps >> 24), (UInt8)(steps >> 16), (UInt8)(steps >> 8), (UInt8)steps,
        (UInt8)step, type,
         date.hour, date.minute, date.second};
    [self sendDataToWare:&val withLength:20 withUpdate:block];
}

// 三
+ (void)sendOldRequestUserInfoWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[3] = {03, 01, 00};
    [self sendDataToWare:&val withLength:3 withUpdate:block];
}

// 四
+ (void)sendOldSetAlarmClockDataWithOpen:(UInt8)open
                               withAlarm:(NSArray *)alarms
                         withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[16] = {0x0A, 0x01, 0x00, open};
    
    int count = 3;
    if (alarms)
    {
        for (AlarmClockModel *model in alarms)
        {
            count++;
            if (count > 15)
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
    
    if (count < 16)
    {
        for (int i = count + 1; i < 16; i++)
        {
            val[count] = 0x00;
        }
    }
    
    [self sendDataToWare:&val withLength:16 withUpdate:block];
}

// 请求数据长度 五
+ (void)sendOldRequestDataInfoLengthWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[3] = {06, 01, 00};
    [self sendDataToWare:&val withLength:3 withUpdate:block];
}

// 同步运动数据 六
+ (void)sendOldRequestSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[3] = {07, 01, 00};
    [self sendDataToWare:&val withLength:3 withUpdate:block];
}

+ (void)sendOldSetWearingWayDataWithRightHand:(BOOL)right
                              withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    UInt8 val[3] = {right ? 0x0C : 0x0B, 0x01, 0x00};
    [self sendDataToWare:&val withLength:3 withUpdate:block];
}

+ (void)sendOldAboutEventWithTimes:(NSArray *)alarms
                          withOpen:(BOOL)open
                   withUpdateBlock:(BLTAcceptDataUpdateValue)block
{
    AlarmClockModel *start = alarms[0];
    AlarmClockModel *end = alarms[1];

    UInt8 val[10] = {0x0D, 0x01, 0x00,
                    start.hour, start.minutes, start.seconds,
                    end.hour, end.minutes, end.seconds, open};
    [self sendDataToWare:&val withLength:10 withUpdate:block];
}

- (void)synHistoryDataWithBackBlock:(BLTSendDataBackUpdate)block
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        if (block)
        {
            self.backBlock = block;
        }
        
        [self requestSportDataLength];
    }
}

- (void)requestSportDataLength
{
    [BLTSendOld sendOldRequestDataInfoLengthWithUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeOldRequestDataLength)
        {
            _dataBytes = object;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSyncSportData) object:nil];
            [self performSelector:@selector(startSyncSportData) withObject:nil afterDelay:0.3];
        }
    }];
}

- (void)startSyncSportData
{
    self.waitTime = 0;
    self.failCount = 0;
    [[BLTAcceptData sharedInstance] cleanMutableData];
    [BLTSendOld sendOldRequestSportDataWithUpdateBlock:^(id object, BLTAcceptDataType type) {
        [self stopTimer];
        
        if (type == BLTAcceptDataTypeOldRequestSportEnd)
        {
            if (object)
            {
                [self performSelectorInBackground:@selector(syncInBackGround:) withObject:@[object, _dataBytes]];
            }
        }
        else if (type == BLTAcceptDataTypeError)
        {
            SHOWMBProgressHUD(@"同步数据失败...", nil, nil, NO, 2.0);
        }
        else if (type == BLTAcceptDataTypeRequestHistoryNoData)
        {
            SHOWMBProgressHUD(@"没有数据.", nil, nil, NO, 2.0);
        }
    }];
    
    [self startTimer];
}

// 后台进行数据存储，存储完毕后进行回调.
- (void)syncInBackGround:(NSArray *)array
{
    // 保存数据后的回调
    [PedometerOld saveDataToModelFromOld:array withEnd:^(NSDate *date, BOOL success){
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
    if (self.backBlock)
    {
        self.backBlock(date);
    }
}

+ (void)setUserInfoToOldDevice
{
    // type 0代表公制, 1代表英制
    [BLTSendOld sendOldSetUserInfo:[NSDate date]
                      withBirthDay:[NSDate dateWithString:@"1985-03-21"]
                        withWeight:170
                   withTargetSteps:10000
                          withStep:50
                          withType:0
                   withUpdateBlock:^(id object, BLTAcceptDataType type) {
                       if (type == BLTAcceptDataTypeOldSetUserInfo)
                       {
                           [[BLTSendOld sharedInstance] performSelector:@selector(requestSportDataLength) withObject:nil afterDelay:0.3];
                       }
                   }];
}

@end



/*
 20:
 <00000000 00000000 00000000 00000000 00000000>
 <81000000 00000000 00000000 00000000 00000000>
 
 14:
 <80000000 00000000 00000000 00800000 00000000>
 
 32:
 00 770100008d02000013000000 5700b1000400 20
 8101dc010f00 0000-0000-0000 b403-0000-0000 0000
 
 14:
 80770100 008d0200 00130000 009a0100 00000000
 
 38:
 00770100 008d0200 00130000 00000000 00000000
 81000000 00000000 00000000 00000000 00009b01
 
 20:
 00 8d010000-8d020000-14000000 1600-0000-0100 48
 81010000 00000000 00000000 00000000 00000000
 
 kCBAdvDataIsConnectable = 1;
 kCBAdvDataLocalName = MillionPedometer;
 kCBAdvDataManufacturerData = <00800080>;
 
 */














