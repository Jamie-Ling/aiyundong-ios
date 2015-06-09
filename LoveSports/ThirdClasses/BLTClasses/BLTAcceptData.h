//
//  BLTAcceptData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

typedef enum {                                  // 详细的看接口参数。
    BLTAcceptDataTypeUnKnown = 0,               // 无状态
    BLTAcceptDataTypeSetActiveTimeZone = 1,           // 设置基本信息
    BLTAcceptDataTypeSetCurrentTime = 2,            // 为固件设置时间, 时区
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
    BLTAcceptDataTypeRequestHistoryNoData,      // 请求历史运动数据, 无数据
    BLTAcceptDataTypeRequestHistoryDate,        // 请求历史运动数据的保存日期
    BLTAcceptDataTypeDeleteSportsData,          // 删除运动数据
    BLTAcceptDataTypeRequestTodaySportsData,    // 请求当天运动数据
    BLTAcceptDataTypeRequestTodayNoData,        // 请求当天运动数据
    BLTAcceptDataTypeRealTimeTransSportsData,   // 实时传输运动数据
    BLTAcceptDataTypeCloseTransSportsData,      // 关闭实时传输运动数据
    BLTAcceptDataTypeRealTimeTransState,        // 实时传输运动数据的状态
    BLTAcceptDataTypeInfoAboutHardAndFirm,      // 固件信息.
    
    // 旧设备命令通道.
    BLTAcceptDataTypeOldSetUserInfo,            // 设置用户信息
    BLTAcceptDataTypeOldRequestUserInfo,        // 请求用户信息
    BLTAcceptDataTypeOldSetAlarmClock,          // 设置闹钟
    BLTAcceptDataTypeOldRequestDataLength,      // 请求运动数据长度
    BLTAcceptDataTypeOldRequestSportData,       // 请求运动数据
    BLTAcceptDataTypeOldRequestSportEnd,        // 请求后数据同步结束.
    BLTAcceptDataTypeOldRequestSportNoData,     // 请求后没有数据.
    BLTAcceptDataTypeOldSetWearingWay,          // 设置佩戴方式
    BLTAcceptDataTypeOldEventInfo,              // 传输事件信息
    BLTAcceptDataTypeOldDeleteSuccess,          // 数据删除成功

    BLTAcceptDataTypeSuccess,                   // 通讯成功
    BLTAcceptDataTypeError                      // 通讯错误
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
@property (nonatomic, assign) BLTAcceptDataType realTimeType;
@property (nonatomic, strong) NSMutableData *syncData;

@property (nonatomic, strong) NSMutableData *realTimeData;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger dataLength;

AS_SINGLETON(BLTAcceptData)

/**
 *  清空数据。
 */
- (void)cleanMutableData;
- (void)cleanMutableRealTimeData;

/**
 *  提示当次通讯失败
 */
- (void)updateFailInfo;

@end

@protocol BLTAcceptDataDelegate <NSObject>

- (void)acceptDataDelegateWith:(NSData *)data;

@end
