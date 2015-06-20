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

+ (void)creatEmptyDataArrayWithModel:(PedometerModel *)model;

// save 是否进行完全保存 不在从设备拉取数据.
+ (PedometerModel *)pedometerSaveEmptyModelToDBWithDate:(NSDate *)date isSaveAllDay:(BOOL)save;
+ (void)updateContentForPedometerModel:(NSData *)data
                               withEnd:(PedometerModelSyncEnd)endBlock;

@end
