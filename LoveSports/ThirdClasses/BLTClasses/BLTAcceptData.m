//
//  BLTAcceptData.m
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTAcceptData.h"
#import "BLTManager.h"

@implementation BLTAcceptData

DEF_SINGLETON(BLTAcceptData)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [BLTManager sharedInstance].updateValueBlock = ^(NSData *data) {
            [self acceptData:data];
        };
    }
    
    return self;
}

- (void)acceptData:(NSData *)data
{
    UInt8 val[100] = {0};
    [data getBytes:&val length:data.length];
    
    int order = val[2];
    
    if (val[0] == 0xDE)
    {
        if (val[1] == 0x01)
        {
            if (order == 0x01)
            {
                // 设定基本信息成功.
            }
            else if (order == 0x02)
            {
                if (val[3] == 0xED)
                {
                    // 设定本地时间，时区成功
                }
                else if (val[3] == 0xFB)
                {
                    // 计步器发送时间到手机.
                }
            }
            else if (order == 0x03)
            {
                if(val[3] == 0xED)
                {
                    // 设定本地时间，时区成功
                }
                else if (val[3] == 0x00)
                {
                    // 每天设定已经超过10次.
                }
                else if (val[3] == 0xFB)
                {
                    // 计步器发送身体信息到手机
                }
            }
            else if (order == 0x04)
            {
                // 固件屏幕颜色设定成功
            }
            else if (order == 0x05)
            {
                if (val[3] == 0xED)
                {
                    // 设定密码保护
                }
                else if (val[3] == 0xFB)
                {
                    // 返回设备密码
                }
            }
            else if (order == 0x06)
            {
                
                
                // 设定固件启动方式
            }
            else if (order == 0x07)
            {
                // 智能睡眠提醒
            }
            else if (order == 0x08)
            {
                // 自定义显示界面
            }
            else if (order == 0x09)
            {
                // 自定义闹钟
            }
            else if (order == 0x0A)
            {
                // 进入校正模式.
            }
            else if (order == 0x0B)
            {
                // 设定佩戴方式
            }
            else if (order == 0x0C)
            {
                // 久坐提醒设定
            }
            else if (order == 0x0D)
            {
                // 设定出厂模式.
            }
            else if (order == 0x0E)
            {
                // 修改设备名称
            }
            else if (order == 0x0F)
            {
                // 显示当前密码
            }
            else if (order == 0x10)
            {
                // 校正模式下的当前位置.
                // 非校正模式下智能起床
            }
            else if (order == 0x11)
            {
                // 开始背光设定
            }
            else if (order == 0x12)
            {
                // 收到联系人的名字.
            }
            else if (order == 0x13)
            {
                // 收到联系人的电话号码.
            }
            else if (order == 0x14)
            {
                // 校正模式下的当前位置.
            }
        }
        else if (val[1] == 0x02)
        {
            if (order == 0x01)
            {
                // 请求运动数据完毕.
            }
        }
    }
    else
    {
    
    }
}

@end
