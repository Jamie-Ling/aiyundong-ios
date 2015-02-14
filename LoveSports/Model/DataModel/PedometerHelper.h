//
//  PedometerHelper.h
//  LoveSports
//
//  Created by zorro on 15/2/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerModel.h"

@interface PedometerHelper : PedometerModel

AS_SINGLETON(PedometerHelper)

+ (PedometerModel *)getModelFromDBWithDate:(NSDate *)date;
+ (PedometerModel *)getModelFromDBWithToday;
+ (NSArray *)getEveryDayTrendDataWithDate:(NSDate *)date;
// 当天的数据是不是保存了全天的。
+ (BOOL)queryWhetherCurrentDateDataSaveAllDay:(NSDate *)date;
+ (void)pedometerSaveEmptyModelToDBWithDate:(NSDate *)date;
+ (void)updateContentForPedometerModel:(NSData *)data
                               withEnd:(PedometerModelSyncEnd)endBlock;

@end
