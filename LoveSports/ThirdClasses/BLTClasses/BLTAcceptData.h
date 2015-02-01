//
//  BLTAcceptData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

typedef enum {                                  // 详细的看接口参数。
    BLTAcceptDataTypeNoData = 0,                // 无状态
    BLTAcceptDataTypeSetBaseInfo = 1,           // 设置基本信息
    BLTAcceptDataTypeSetLocTime = 2,            // 为固件设置时间, 时区
    BLTAcceptDataTypeSetUserInfo = 3,           // 为固件设置用户信息
    BLTAcceptDataTypeCheckWareTime = 4,         // 查看当前固件时间
    BLTAcceptDataTypeCheckWareUserInfo = 5,     // 查看当前固件的用户信息
    BLTAcceptDataTypeSetWareScreenColor = 6,    // 设置固件的屏幕颜色，是否待机。
    BLTAcceptDataTypeSetPassword,               // 为固件设置密码保护
    BLTAcceptDataTypeSetOpenModel,              // 设置固件的启动模式
    BLTAcceptDataTypeSetSleepRemind,            // 设置智能睡眠提醒
    BLTAcceptDataTypeSetCustomDisplay,          // 自定义显示界面
    BLTAcceptDataTypeSetAlarmClock,             // 设定闹钟
    BLTAcceptDataTypeSetSedentaryRemind,        // 设置久坐提醒
    BLTAcceptDataTypeSetFactoryModel,           // 设定出厂模式
    BLTAcceptDataTypeChangeWareName,            // 修改设备名称
    BLTAcceptDataTypeCheckWarePassword,         // 查看固件密码
    BLTAcceptDataTypeShowWarePassword,          // 请求硬件显示当前固件密码
    BLTAcceptDataTypeSetIntelGetup,             // 智能起床设定
    BLTAcceptDataTypeSetContactToWare,          // 发送联系人名字给固件
    BLTAcceptDataTypeSetTelToWare,              // 发送电话给固件
    BLTAcceptDataTypeCorrectionCommand,         // 行针校正命令
    BLTAcceptDataTypeSetPositionToWare,         // 发送当前位置给固件
    BLTAcceptDataTypeSynSencondCityTime,        // 设置第二个城市时间
    BLTAcceptDataTypeSetWearingWay,             // 设置佩戴方式
    BLTAcceptDataTypeSetOpenBackLight,          // 是否开启背光设定
    BLTAcceptDataTypeRequestHistorySportsData,  // 请求历史运动数据
    BLTAcceptDataTypeDeleteSportsData,          // 删除运动数据
    BLTAcceptDataTypeRequestTodaySportsData,    // 请求当天运动数据
    BLTAcceptDataTypeRealTimeTransSportsData,   // 实时传输运动数据
    BLTAcceptDataTypeCloseTransSportsData       // 关闭实时传输运动数据
} BLTAcceptDataType;

#import <Foundation/Foundation.h>
#import "BLTManager.h"

@protocol BLTAcceptDataDelegate;

typedef void(^BLTAcceptDataUpdateValue)(id object, BLTAcceptDataType type);

@interface BLTAcceptData : NSObject

@property (nonatomic, assign) id <BLTAcceptDataDelegate> delegate;

@property (nonatomic, strong) NSString *wareTime;

@property (nonatomic, strong) BLTAcceptDataUpdateValue updateValue;
@property (nonatomic, assign) BLTAcceptDataType type;

AS_SINGLETON(BLTAcceptData)

@end

@protocol BLTAcceptDataDelegate <NSObject>

- (void)acceptDataDelegateWith:(NSData *)data;

@end
