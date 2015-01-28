//
//  BLTSendData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLTSendData : NSObject


/**
*  设置用户基本信息
*
*  @param scale  公/英制
*  @param hourly 小时制
*  @param lag    时差的绝对值
*/
+ (void)sendBasicSetOfInformationData:(NSInteger)scale
                           withHourly:(NSInteger)hourly
                           withJetLag:(NSInteger)lag;


/**
 *  本地时间，时区等等设定
 *
 *  @param data
 */
+ (void)sendLocalTimeInformationData:(NSData *)data;

/**
 *  设定用户身体信息，体重，步距
 *
 *  @param data
 */
+ (void)sendUserInformationBodyData:(NSData *)data;

/**
 *  手机请求计步器的时间, 查看计步器的时间.
 *
 *  @param data 
 */
+ (void)sendCheckDateOfHardwareData:(NSData *)data;

/**
 *  查询计步器的身体信息.
 *
 *  @param data
 */
+ (void)sendLookBodyInformationData:(NSData *)data;

/**
 *  设定屏幕颜色和待机..
 *
 *  @param data
 */
+ (void)sendSetHardwareScreenData:(NSData *)data;

/**
 *  设定密码保护.
 *
 *  @param data
 */
+ (void)sendPasswordProtectionData:(NSData *)data;

/**
 *  固件启动方式
 *
 *  @param data
 */
+ (void)sendHardwareStartupModeData:(NSData *)data;

/**
 *  智能睡眠提醒设定
 *
 *  @param data
 */
+ (void)sendSleepToRemindData:(NSData *)data;

/**
 *  自定义显示界面, 显示界面.
 *
 *  @param data
 */
+ (void)sendCustomDisplayInterfaceData:(NSData *)data;

//+ (void)sendBasicSetOfInformationData:(NSData *)data;
/**
 *  设定闹钟
 *
 *  @param data 按照蓝牙协议的格式发送.
 */
+ (void)sendAlarmClockData:(NSData *)data;

/**
 *  久坐提醒
 *
 *  @param data 按照蓝牙协议的格式发送. 20个字节。
 */
+ (void)sendSedentaryRemindData:(NSData *)data;

/**
 *  设定出厂模式
 *
 *  @param data
 */
+ (void)sendSetFactoryModelData:(NSData *)data;

/**
 *  修改设备名称
 *
 *  @param data
 */
+ (void)sendModifyDeviceNameData:(NSData *)data;

/**
 *  手机查询计步器当前密码
 *
 *  @param data
 */
+ (void)sendQueryCurrentPasswordData:(NSData *)data;

/**
 *  固件显示当前密码
 *
 *  @param data 
 */
+ (void)sendQShowCurrentPasswordData:(NSData *)data;

/**
 *  智能起床设定
 *
 *  @param data
 */
+ (void)sendIntelligentGetupSetData:(NSData *)data;

/**
 *  发送联系人的名字给设备.
 *
 *  @param data
 */
+ (void)sendNameOfContactData:(NSData *)data;

/**
 *  发送联系人的电话给设备
 *
 *  @param data
 */
+ (void)sendContactTelephoneNumberData:(NSData *)data;
+ (void)sendSetWearingWayData:(NSData *)data;

/**
 *  进入行针校正模式....
 */

/**
 *  行针校正命令
 *
 *  @param data
 */
+ (void)sendCorrectionCommandData:(NSData *)data;

/**
 *  发送指针当前位置给计步器
 *
 *  @param data
 */
+ (void)sendCurrentPositionData:(NSData *)data;

/**
 *  用户同步世界时间. 第二城市时间.
 *
 *  @param data
 */
+ (void)sendSynchronousWorldTimeData:(NSData *)data;

/**
 *  W240 专用
 */

/**
 *  设定佩戴方式
 *
 *  @param data
 */
+ (void)sendSetWearingWayData:(NSData *)data;

/**
 *  W286 专用
 */

/**
 *  开启背光设定
 *
 *  @param data
 */
+ (void)sendOpenBacklightSetData:(NSData *)data;

/**
 *           传输运动数据.
 */

/**
 *  手机请求计步器运动数据
 *
 *  @param data
 */
+ (void)sendRequestDataMovementData:(NSData *)data;

/*
+ (void)sendOpenBacklightSetData:(NSData *)data;
+ (void)sendOpenBacklightSetData:(NSData *)data;
+ (void)sendOpenBacklightSetData:(NSData *)data;
 */

@end
