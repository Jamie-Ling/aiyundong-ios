//
//  BLTRealTime.m
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTRealTime.h"
#import "BLTPeripheral.h"

@interface BLTRealTime ()

@end

@implementation BLTRealTime

DEF_SINGLETON(BLTRealTime)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _currentDayModel = [PedometerHelper getModelFromDBWithDate:[NSDate date]];
        
        self.isAllownRealTime = NO;
    }
    
    return self;
}

- (PedometerModel *)currentDayModel
{
    if ([[NSDate date] isSameWithDate:[NSDate dateWithString:_currentDayModel.dateString]])
    {
        return _currentDayModel;
    }
    
    return [PedometerHelper getModelFromDBWithDate:[NSDate date]];
}

- (void)startRealTimeTransWithBackBlock:(BLTRealTimeBackBlock)block
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        [BLTSendData sendRealtimeTransmissionSportDataWithUpdateBlock:^(id object, BLTAcceptDataType type) {
            if (type == BLTAcceptDataTypeRealTimeTransSportsData)
            {
                [UserInfoHelp sharedInstance].braceModel.isRealTime = YES;
                
                if (block)
                {
                    block(YES);
                }
            }
            else
            {
                [UserInfoHelp sharedInstance].braceModel.isRealTime = NO;

                if (block)
                {
                    block(NO);
                }
            }
        }];
    }
    else
    {
        SHOWMBProgressHUD(LS_Text(@"No connect"), nil, nil, NO, 2.0);
        
        // add by jamie
        if (block)
        {
            block(NO);
        }
    };
}

- (void)closeRealTimeTransWithBackBlock:(BLTRealTimeBackBlock)block
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        [BLTSendData sendCloseTransmissionSportDataWithUpdateBlock:^(id object, BLTAcceptDataType type) {
            if (type == BLTAcceptDataTypeCloseTransSportsData)
            {
                // SHOWMBProgressHUD(@"实时传输关闭成功.", nil, nil, NO, 2.0);
                [UserInfoHelp sharedInstance].braceModel.isRealTime = NO;
                
                if (block)
                {
                    block(YES);
                }
            }
            else
            {
                [UserInfoHelp sharedInstance].braceModel.isRealTime = YES;

                if (block)
                {
                    block(NO);
                }
            }
        }];
    }
    else
    {
        SHOWMBProgressHUD(LS_Text(@"No connect"), nil, nil, NO, 2.0);
        
        // add by jamie
        if (block)
        {
            block(NO);
        }
    }
}

// 保存数据到数据库
- (void)saveRealTimeDataToDBAndUpdateUI:(NSData *)data
{
    [UserInfoHelp sharedInstance].braceModel.isRealTime = YES;
    
    if (_realTimeBlock)
    {
        _realTimeBlock(YES);
    }
    
    NSData *tmpData = [NSData dataWithData:data];
    [[BLTAcceptData sharedInstance] cleanMutableRealTimeData];

    [self performSelectorInBackground:@selector(syncInBackGround:) withObject:tmpData];
}

// 后台进行数据存储，存储完毕后进行回调.
- (void)syncInBackGround:(NSData *)data
{
    // 保存数据后的回调
    [PedometerHelper updateContentForPedometerModel:data withEnd:^(NSDate *date, BOOL success) {
        [self performSelectorOnMainThread:@selector(endSyncData:) withObject:date waitUntilDone:NO];
    }];
}

// 同步数据结束
- (void)endSyncData:(NSDate *)date
{
    /*
    if (self.backBlock)
    {
        self.backBlock(date);
        self.backBlock = nil;
    }
     */
    
    [[BLTSimpleSend sharedInstance] endSyncData:date];
}

@end