//
//  BLTSendData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTAcceptData.h"

@interface AlarmClockModel : NSObject

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) UInt8 repeat;


/**
 *  得到一个代表星期几的Uint8
 *
 *  @param weekNumber 0~7，1：代表每周一, 0代表无
 *
 *  @return 得到的Uint8
 */
+ (UInt8) getAUint8FromeWeekNumber: (NSInteger) weekNumber;


/**
 *  设置所有时间（时分秒&重复周期）
 *
 *  @param timeString  格式：23:01 或者  23:01:45
 *  @param repeatUntStringArray 装uint8的字符串数组如【@"1", @"2"】,代表每周一周二重复
 *  @param isFullWeekDay  是否是每天重复（周1至周日全部重复）
 */
- (void) setAllTimeFromTimeString: (NSString *) timeString
         withRepeatUntStringArray: (NSArray *) repeatUntStringArray
                  withFullWeekDay: (BOOL) isFullWeekDay;

@end

@interface BLTSendData : NSObject

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger waitTime;
@property (nonatomic, assign) NSInteger failCount;
@property (nonatomic, assign) BOOL isStopSync;

AS_SINGLETON(BLTSendData)

/**
*  设置用户基本信息
*
*  @param scale  公/英制
*  @param hourly 小时制
*  @param lag    时差的绝对值
*/
+ (void)sendBasicSetOfInformationData:(NSInteger)scale
                           withHourly:(NSInteger)hourly
                           withJetLag:(NSInteger)lag
                      withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  本地时间，时区等等设定
 *
 *  @param date
 */
+ (void)sendLocalTimeInformationData:(NSDate *)date
                          withHourly:(NSInteger)hourly
                     withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
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
                                withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  手机请求计步器的时间, 查看计步器的时间.
 *
 *  @param data 
 */
+ (void)sendCheckDateOfHardwareDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  查询计步器的身体信息.
 *
 *  @param data
 */
+ (void)sendLookBodyInformationDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  设定屏幕颜色和待机..
 *
 *  @param data
 */
+ (void)sendSetHardwareScreenDataWithDisplay:(BOOL)black
                                 withWaiting:(BOOL)noWaiting
                             withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  设定密码保护.
 *
 *  @param data
 */
+ (void)sendPasswordProtectionDataWithOpen:(BOOL)open
                          withPassword:(NSString *)password
                       withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  固件启动方式
 *
 *  @param model 启动模式
 *  @param times 启定时动得时间点，传入时间:(分钟)。
 *  @param block 回调
 */
+ (void)sendHardwareStartupModelDataWithModel:(NSInteger)model
                                    withTimes:(NSArray *)times
                              withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
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

/**
 *  自定义显示界面, 显示界面.
 *
 *  @param orders 显示得画面编号数组
 *  @param block  回调
 */
+ (void)sendCustomDisplayInterfaceDataWithOrder:(NSArray *)orders
                                withUpdateBlock:(BLTAcceptDataUpdateValue)block;

//+ (void)sendBasicSetOfInformationData:(NSData *)data;

/**
 *  设定闹钟
 *
 *  @param open   闹铃是否开启
 *  @param alarms AlarmClockModel 数组
 *  @param block  回调
 */
+ (void)sendAlarmClockDataWithOpen:(UInt8)open
                         withAlarm:(NSArray *)alarms
                   withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  久坐提醒
 *
 *  @param open  是否开启
 *  @param times AlarmClockModel 数组 , 主要是时和分
 *                  数据组成为开始1-结束1-开始2-结束2-开始3-结束3-静止
 *  @param block 回调
 */
+ (void)sendSedentaryRemindDataWithOpen:(BOOL)open
                              withTimes:(NSArray *)times
                        withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  设定出厂模式
 *
 *  @param data
 */
+ (void)sendSetFactoryModelDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  修改设备名称
 *
 *  @param name  将修改得名字
 *  @param block 回调
 */
+ (void)sendModifyDeviceNameDataWithName:(NSString *)name
                         withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
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
 *  行针校正命令
 *
 */
+ (void)sendCorrectionCommandDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
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

/**
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

/**
 *  设定佩戴方式
 *
 *  @param right 默认为左手。右手为YES
 */
+ (void)sendSetWearingWayDataWithRightHand:(BOOL)right
                           withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  W286 专用
 */

/**
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
 *  手机请求计步器历史运动数据
 *
 *  @param date  日期
 *  @param block 回调
 */
+ (void)sendRequestHistorySportDataWithDate:(NSDate *)date
                           withOrder:(NSInteger)order
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  删除运动数据
 *
 *  @param date  开始日期
 *  @param block 回调
 */
+ (void)sendDeleteSportDataWithDate:(NSDate *)date
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  请求当天的运动数据。
 *
 *  @param order 时间序号
 *  @param block 回调
 */
+ (void)sendRequestTodaySportDataWithOrder:(NSInteger)order
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  开始实时传输运动数据
 *
 *  @param block 回调
 */
+ (void)sendRealtimeTransmissionSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/**
 *  关闭实时传输运动数据
 *
 *  @param block 回调
 */
+ (void)sendCloseTransmissionSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

/*
+ (void)sendOpenBacklightSetData:(NSData *)data;
+ (void)sendOpenBacklightSetData:(NSData *)data;
+ (void)sendOpenBacklightSetData:(NSData *)data;
 */

/**
 *  同步数据, 无论今天还是历史。
 */
- (void)synHistoryData;

@end
