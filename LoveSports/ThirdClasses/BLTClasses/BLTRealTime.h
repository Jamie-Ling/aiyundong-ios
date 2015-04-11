//
//  BLTRealTime.h
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendData.h"
#import "PedometerModel.h"

// 实时通道.
@interface BLTRealTime : BLTSendData
typedef void(^BLTRealTimeBackBlock)(BOOL success);

@property (nonatomic, assign) BOOL isAllownRealTime;        // 软件是否允许进入实时状态进行数据传输

@property (nonatomic, strong) PedometerModel *currentDayModel;  // 当天的数据模型，为实时传输准备.
@property (nonatomic, strong) BLTRealTimeBackBlock realTimeBlock; // 是否是事实状态.

AS_SINGLETON(BLTRealTime)

- (void)saveRealTimeDataToDBAndUpdateUI:(NSData *)data;
- (void)startRealTimeTransWithBackBlock:(BLTRealTimeBackBlock)block;
- (void)closeRealTimeTransWithBackBlock:(BLTRealTimeBackBlock)block;

@end
