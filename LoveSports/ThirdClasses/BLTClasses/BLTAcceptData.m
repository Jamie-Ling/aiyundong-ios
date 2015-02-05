//
//  BLTAcceptData.m
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTAcceptData.h"
#import "PedometerModel.h"

@implementation BLTAcceptData

DEF_SINGLETON(BLTAcceptData)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _syncData = [[NSMutableData alloc] init];
        // 直接启动蓝牙
        [BLTManager sharedInstance];
        
        /**
         *  普通数据得更新
         *
         *  @param data 传入得数据data
         *
         *  @return
         */
        [BLTPeripheral sharedInstance].updateBlock = ^(NSData *data) {
            [self acceptData:data];
        };
        
        /**
         *  同步时传入得大数据。
         *
         *  @param data 
         *
         *  @return
         */
        [BLTPeripheral sharedInstance].updateBigDataBlock = ^(NSData *data) {
            [self updateBigData:data];
        };
    }
    
    return self;
}

- (void)acceptData:(NSData *)data
{
    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    
    id object = nil;
    int order = val[2];
    NSLog(@"--------%0x, %0x, %0x, %0x", val[0], val[1], val[2], val[3]);
    
    if (val[0] == 0xDE)
    {
        if (val[1] == 0x01)
        {
            if (order == 0x01)
            {
                SHOWMBProgressHUD(@"设置成功...", nil, nil, NO, 2);
                [LS_SettingBaseInfo setBOOLValue:YES];
                NSLog(@"设置成功.%d",  [LS_SettingBaseInfo getBOOLValue]);

                // 设定时区英制基本信息成功.
                _type = BLTAcceptDataTypeSetBaseInfo;
            }
            else if (order == 0x02)
            {
                if (val[3] == 0xED)
                {
                    // 设定本地时间，时区成功
                    _type = BLTAcceptDataTypeSetLocTime;
                }
                else if (val[3] == 0xFB)
                {
                    _type = BLTAcceptDataTypeCheckWareTime;
                    
                    for (int i = 0; i < 16; i++)
                    {
                        NSLog(@"....%d", val[i]);
                    }
                    
                    NSString *string = [NSString stringWithFormat:@"当前设备时间: \n%d月%d日 %d:%d \n时区:%d", val[6], val[7], val[10], val[11], val[9]];
                    
                    NSLog(@"%d", (val[4] << 8) | (val[5]));
                    object = string;
                    // 计步器发送时间到手机.
                }
            }
            else if (order == 0x03)
            {
                if(val[3] == 0xED)
                {
                    // 设定用户身体信息成功
                    _type = BLTAcceptDataTypeSetUserInfo;
                }
                else if (val[3] == 0x00)
                {
                    // 每天设定已经超过10次.
                    _type = BLTAcceptDataTypeSetUserInfo;
                }
                else if (val[3] == 0xFB)
                {
                    // 计步器发送身体信息到手机
                    _type = BLTAcceptDataTypeCheckWareUserInfo;
                }
            }
            else if (order == 0x04)
            {
                // 固件屏幕颜色设定成功
                _type = BLTAcceptDataTypeSetWareScreenColor;
            }
            else if (order == 0x05)
            {
                if (val[3] == 0xED)
                {
                    // 设定密码保护
                    _type = BLTAcceptDataTypeSetPassword;
                }
                else if (val[3] == 0xFB)
                {
                    // 返回设备密码
                    _type = BLTAcceptDataTypeSetPassword;
                }
            }
            else if (order == 0x06)
            {
                // 设定固件启动方式
                _type = BLTAcceptDataTypeSetOpenModel;
            }
            else if (order == 0x07)
            {
                // 智能睡眠提醒
                _type = BLTAcceptDataTypeSetSleepRemind;
            }
            else if (order == 0x08)
            {
                // 自定义显示界面
                _type = BLTAcceptDataTypeCheckWareTime;
            }
            else if (order == 0x09)
            {
                // 自定义闹钟
                _type = BLTAcceptDataTypeSetAlarmClock;
            }
            else if (order == 0x0A)
            {
                // 进入校正模式.
                _type = BLTAcceptDataTypeCorrectionCommand;
            }
            else if (order == 0x0B)
            {
                // 设定佩戴方式
                _type = BLTAcceptDataTypeSetWearingWay;
            }
            else if (order == 0x0C)
            {
                // 久坐提醒设定
                _type = BLTAcceptDataTypeCheckWareTime;
            }
            else if (order == 0x0D)
            {
                // 设定出厂模式.
                _type = BLTAcceptDataTypeSetFactoryModel;
            }
            else if (order == 0x0E)
            {
                // 修改设备名称
                _type = BLTAcceptDataTypeChangeWareName;
            }
            else if (order == 0x0F)
            {
                // 显示当前密码
                _type = BLTAcceptDataTypeShowWarePassword;
            }
            else if (order == 0x10)
            {
                // 校正模式下的当前位置.
                // 非校正模式下智能起床
                _type = BLTAcceptDataTypeSetIntelGetup;
            }
            else if (order == 0x11)
            {
                // 开始背光设定
                _type = BLTAcceptDataTypeSetOpenBackLight;
            }
            else if (order == 0x12)
            {
                // 收到联系人的名字.
                _type = BLTAcceptDataTypeSetContactToWare;
            }
            else if (order == 0x13)
            {
                // 收到联系人的电话号码.
                _type = BLTAcceptDataTypeSetTelToWare;
            }
            else if (order == 0x14)
            {
                // 校正模式下的当前位置.
                _type = BLTAcceptDataTypeSetPositionToWare;
            }
        }
        else if (val[1] == 0x02)
        {
            if (order == 0x01)
            {
                if (val[3] == 0xED)
                {
                    // 请求历史运动数据完毕.
                    _type = BLTAcceptDataTypeRequestHistorySportsData;
                    
                    
                }
                else if (val[3] == 0x06)
                {
                    // 无数据
                    _type = BLTAcceptDataTypeRequestHistorySportsData;
                }
            }
            else if (order == 0x02)
            {
                if (val[3] == 0xED)
                {
                    // 删除运动数据
                    _type = BLTAcceptDataTypeDeleteSportsData;
                }
            }
            else if (order == 0x03)
            {
                if (val[3] == 0xED)
                {
                    // 请求当天数据完毕
                    _type = BLTAcceptDataTypeRequestTodaySportsData;
                }
            }
            else if (order == 0x04)
            {
                if (val[3] == 0xED)
                {
                    // 计步器收到开始实时传输数据的命令
                    _type = BLTAcceptDataTypeRealTimeTransSportsData;
                }
            }
            else if (order == 0x05)
            {
                if (val[3] == 0xED)
                {
                    // 计步器收到关闭实时传输数据的命令
                    _type = BLTAcceptDataTypeCloseTransSportsData;
                }
            }
        }
    }
    else
    {
    
    }
    
    if (_updateValue)
    {
        _updateValue(object, _type);
    }
}

- (void)updateBigData:(NSData *)data
{
    _type = BLTAcceptDataTypeRequestHistorySportsData;

    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    
    if (_updateValue)
    {
        _updateValue(_syncData, _type);
    }
}

- (void)saveSyncDataToModel
{
}

#pragma mark --- syncData 数据清空 ---
- (void)cleanMutableData
{
    [_syncData resetBytesInRange:NSMakeRange(0, _syncData.length)];
    [_syncData setLength:0];
}


@end
