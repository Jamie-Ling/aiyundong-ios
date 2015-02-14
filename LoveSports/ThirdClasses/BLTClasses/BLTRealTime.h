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

@property (nonatomic, assign) BOOL isRealTime;              // 硬件是否实时状态
@property (nonatomic, assign) BOOL isAllownRealTime;        // 软件是否允许进入实时状态进行数据传输

@property (nonatomic, strong) PedometerModel *currentDayModel;  // 当天的数据模型，为实时传输准备.

AS_SINGLETON(BLTRealTime)

- (void)saveRealTimeDataToDBAndUpdateUI:(NSData *)data;
- (void)startRealTimeTrans;
- (void)closeRealTimeTrans;

@end
