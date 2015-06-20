//
//  BLTSimpleSend.h
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 数据转发的逻辑处理中心

#import "BLTSendData.h"
typedef void(^BLTSimpleSendShowMessage)();

// 实时传输的时候不要有信息提示。非实时传输才有。
void showMessage(BLTSimpleSendShowMessage showBlock);

/**
 *  发送实例数据的模型，专门负责逻辑运算的。BLTSendData只负责硬件命令接口。
 */
@interface BLTSimpleSend : BLTSendData

AS_SINGLETON(BLTSimpleSend)

/** // 无需实现
 *  同步数据, 无论今天还是历史。
 */
- (void)synHistoryDataWithBackBlock:(BLTSendDataBackUpdate)block;

// 进入前台同步数据
- (void)synHistoryDataEnterForeground;

/**
 *  连接手环后发送连续的指令
 */
- (void)sendContinuousInstruction;

// 更新界面...
- (void)endSyncData:(NSDate *)date;
//同步失败
- (void)endSyncFail;

- (void)startTimer;
- (void)stopTimer;

@end
