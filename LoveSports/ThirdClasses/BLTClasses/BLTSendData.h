//
//  BLTSendData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 暂时不搞的，第一个版本. 1.11-12 1.23-28, 1.43-48 0.1-0.3


#import <Foundation/Foundation.h>
#import "BLTAcceptData.h"
#import "Header.h"
#import "AlarmClockModel.h"
#import "RemindModel.h"

@interface BLTSendData : NSObject
typedef void(^BLTSendDataBackUpdate)(NSDate *date);

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger waitTime;
@property (nonatomic, assign) NSInteger failCount;
@property (nonatomic, assign) BOOL isStopSync;

@property (nonatomic, assign) NSInteger lastSyncOrder;      // 最后同步的时序
@property (nonatomic, strong) NSString *lastSyncDate;       // 最后同步的日期

@property (nonatomic, strong) NSDate *startDate;            // 历史数据保存的开始日期
@property (nonatomic, strong) NSDate *endDate;              // 历史数据保存的结束日期

@property (nonatomic, strong) BLTSendDataBackUpdate backBlock;

AS_SINGLETON(BLTSendData)

/** // 不用写
*  设置用户基本信息
*
*  @param scale  公/英制
*  @param timeZone 经常活动时区
*  @param lag    时差的绝对值
*/
+ (void)sendBasicSetOfInformationData:(NSInteger)scale
                 withActivityTimeZone:(NSInteger)timeZone
                      withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 不用写，每次打开程序会自动发送
 *  本地时间，时区等等设定
 *
 *  @param date
 */
+ (void)sendLocalTimeInformationData:(NSDate *)date
                     withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 你已经写了。是个人信息得
 *  设定用户身体信息，体重，步距
 *
 *  @param date   生日
 *  @param weight 体重
 *  @param target 目标步数
 *  @param step   步距
 */
+ (void)sendUserInformationBodyDataWithBirthDay:(NSDate *)date
                                     withWeight:(NSInteger)weight
                                     withTarget:(NSInteger)target
                                   withStepAway:(NSInteger)step
                                withSleepTarget:(NSInteger)time
                                withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  手机请求计步器的时间, 查看计步器的时间.
 *
 *  @param data 
 */
+ (void)sendCheckDateOfHardwareDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  查询计步器的身体信息.
 *
 *  @param data
 */
+ (void)sendLookBodyInformationDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 2个segement。
 *  设定屏幕颜色和待机..
 *
 *  @param data
 */
+ (void)sendSetHardwareScreenDataWithDisplay:(BOOL)black
                                 withWaiting:(BOOL)noWaiting
                             withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 需要个uialertview
 *  设定密码保护.
 *
 *  @param data
 */
+ (void)sendPasswordProtectionDataWithOpen:(BOOL)open
                          withPassword:(NSString *)password
                       withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 需要界面。
 *  固件启动方式
 *
 *  @param model 启动模式
 *  @param times 启定时动得时间点，传入时间:(分钟)。
 *  @param block 回调
 */
+ (void)sendHardwareStartupModelDataWithModel:(NSInteger)model
                                    withTimes:(NSArray *)times
                              withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 需要界面。
 *  智能睡眠提醒设定
 *
 *  @param open    是否开启
 *  @param plan    计划时间－分钟
 *  @param advance 提前时间－分钟
 *  @param block   回调
 */
+ (void)sendSleepToRemindDataWithOpen:(BOOL)open
                             withPlan:(NSInteger)plan
                          withAdvance:(NSInteger)advance
                      withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 无需实现
 *  自定义显示界面, 显示界面.
 *
 *  @param orders 显示得画面编号数组
 *  @param block  回调
 */
+ (void)sendCustomDisplayInterfaceDataWithOrder:(NSArray *)orders
                                withUpdateBlock:(BLTAcceptDataUpdateValue)block;

//+ (void)sendBasicSetOfInformationData:(NSData *)data;

/** // 需要界面
 *  设定闹钟
 *
 *  @param open   闹铃是否开启
 *  @param alarms AlarmClockModel 数组
 *  @param block  回调
 */
+ (void)sendAlarmClockDataWithAlarm:(NSArray *)alarms
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 需要界面
 *  久坐提醒
 *
 *  @param open  是否开启
 *  @param times RemindModel 数组 , 主要是时和分
 *                  数据组成为开始1-结束1-开始2-结束2-开始3-结束3-静止
 *  @param block 回调
 */
+ (void)sendSedentaryRemindDataWithRemind:(NSArray *)times
                          withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击
 *  设定出厂模式
 *
 *  @param data
 */
+ (void)sendSetFactoryModelDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // uialertview
 *  修改设备名称
 *
 *  @param name  将修改得名字
 *  @param block 回调
 */
+ (void)sendModifyDeviceNameDataWithName:(NSString *)name
                         withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 需要uilabel显示。
 *  手机查询计步器当前密码
 *
 *  @param data
 */
+ (void)sendQueryCurrentPasswordDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  手机请求硬件显示当前密码
 *
 *  @param data 
 */
+ (void)sendQShowCurrentPasswordDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 无需实现
 *  智能起床设定
 *
 *  @param data
 */
+ (void)sendIntelligentGetupSetData:(NSData *)data;

/** // 无需实现
 *  发送联系人的名字给设备.
 *
 *  @param data
 */
+ (void)sendNameOfContactData:(NSData *)data;

/** // 无需实现
 *  发送联系人的电话给设备
 *
 *  @param data
 */
+ (void)sendContactTelephoneNumberData:(NSData *)data;
+ (void)sendSetWearingWayData:(NSData *)data;

/** // 只需点击事件
 *  行针校正命令
 *
 */
+ (void)sendCorrectionCommandDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  发送指针当前位置给计步器
 *
 *  @param hour   指针时
 *  @param minute 指针分
 *  @param second 指针秒
 *  @param block  回调
 */
+ (void)sendCurrentPositionDataWithHour:(NSInteger)hour
                            withMinute:(NSInteger)minute
                             withSecond:(NSInteger)second
                        withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  用户同步世界时间. 第二城市时间.
 *
 *  @param date   日期
 *  @param hourly 时区
 *  @param block  回调
 */
+ (void)sendSynchronousWorldTimeData:(NSDate *)date
                          withHourly:(NSInteger)hourly
                     withUpdateBlock:(BLTAcceptDataUpdateValue)block;
/**
 *  W240 专用
 */

/** // 需要界面。
 *  设定佩戴方式
 *
 *  @param right 默认为左手。右手为YES
 */
+ (void)sendSetWearingWayDataWithRightHand:(BOOL)right
                           withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  W286 专用
 */

/** // 需要界面。
 *  开启背光设定
 *  @param open  是否开启
 *  @param times AlarmClockModel 数组 , 主要是时和分
 *                  数据组成为开始-结束
 *  @param block 回调
 */
+ (void)sendOpenBacklightSetDataWithOpen:(BOOL)open
                               withTimes:(NSArray *)times
                         withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *           传输运动数据.
 */

/**
 *           传输运动数据.
 */

/**
 *           传输运动数据.
 */

/** // 无需界面
 *  手机请求计步器历史运动数据
 *
 *  @param date  日期
 *  @param block 回调
 */
+ (void)sendRequestHistorySportDataWithDate:(NSDate *)date
                           withOrder:(NSInteger)order
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;


/**
 *  请求硬件里保存的数据的日期。
 *
 *  @param block 回调
 */
+ (void)sendHistoricalDataStorageDateWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  删除运动数据
 *
 *  @param date  开始日期
 *  @param block 回调
 */
+ (void)sendDeleteSportDataWithDate:(NSDate *)date
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 无需实现  该方法已经被取消。
 *  请求当天的运动数据。
 *
 *  @param order 时间序号
 *  @param block 回调
 */
+ (void)sendRequestTodaySportDataWithOrder:(NSInteger)order
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  开始实时传输运动数据
 *
 *  @param block 回调
 */
+ (void)sendRealtimeTransmissionSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/** // 只需点击事件
 *  关闭实时传输运动数据
 *
 *  @param block 回调
 */
+ (void)sendCloseTransmissionSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 升级指令
+ (void)sendUpdateFirmware;
/*
+ (void)sendOpenBacklightSetData:(NSData *)data;
+ (void)sendOpenBacklightSetData:(NSData *)data;
+ (void)sendOpenBacklightSetData:(NSData *)data;
 */

/**
 *  获取硬件设备信息
 *
 *  @param block 回调
 */
+ (void)sendAccessInformationAboutCurrentHardwareAndFirmware:(BLTAcceptDataUpdateValue)block;

// 命令转发通道
+ (void)sendDataToWare:(void *)val
            withLength:(NSInteger)length
            withUpdate:(BLTAcceptDataUpdateValue)block;

@end
