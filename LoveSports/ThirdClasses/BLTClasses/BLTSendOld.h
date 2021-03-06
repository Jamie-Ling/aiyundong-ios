//
//  BLTSendOld.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTSimpleSend.h"
#import "PedometerOld.h"

@interface BLTSendOld : BLTSimpleSend

@property (nonatomic, strong) NSNumber *dataBytes;
@property (nonatomic, assign) BOOL isSyncing;

AS_SINGLETON(BLTSendOld)

// 设置用户信息
+ (void)sendOldSetUserInfo:(NSDate *)date
              withBirthDay:(NSDate *)birthDay
                withWeight:(NSInteger)weight
           withTargetSteps:(NSInteger)steps
                  withStep:(NSInteger)step
                  withType:(BOOL)type
           withUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 请求用户信息
+ (void)sendOldRequestUserInfoWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 设置闹钟
+ (void)sendOldSetAlarmClockDataWithAlarm:(NSArray *)alarms
                          withUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 请求运动数据长度
+ (void)sendOldRequestDataInfoLengthWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 同步运动数据
+ (void)sendOldRequestSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 设置佩戴方式
+ (void)sendOldSetWearingWayDataWithRightHand:(BOOL)right
                              withUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 传输事件信息
+ (void)sendOldAboutEventWithRemind:(NSArray *)times
                    withUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 删除运动数据 十
+ (void)sendOldDeleteSportDataWithUpdateBlock:(BLTAcceptDataUpdateValue)block;

// 刚链接时设置用户信息并同步
+ (void)setUserInfoToOldDevice;

// 直接删除运动数据 延迟调用
- (void)delaySendOldDeleteSportData;

@end
