//
//  PedometerModel.m
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerModel.h"
#import "BLTSendData.h"
#import "ShowManage.h"
#import "PedometerHelper.h"
#import "UserInfoHelp.h"
#import "StepDataRecord.h"

@implementation SportsModel

// 表名
+ (NSString *)getTableName
{
    return @"SportsTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateDay", @"currentOrder", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

@implementation SleepModel

// 表名
+ (NSString *)getTableName
{
    return @"SleepTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateDay", @"currentOrder", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

@implementation PedometerModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *dateString = [[NSDate date] dateToString];
        _dateString= [dateString componentsSeparatedByString:@" "][0];
        
        _targetStep = 10000;
        _targetCalories = [self stepsConvertCalories:10000 withWeight:62 withModel:YES];
        _targetDistance = [self StepsConvertDistance:10000 withPace:50] / 1000;
        _targetSleep = 60 * 8;
        
        // _totalSleepTime = 300 + arc4random() % 60;
        _sleepNextStartTime = 143;
        _sleepTodayStartTime = 143;
        _sleepTodayEndTime = 143;
        
        _userName = [UserInfoHelp sharedInstance].userModel.userName;
    }
    
    return self;
}

// 简单初始化并赋值。
+ (PedometerModel *)simpleInitWithDate:(NSDate *)date
{
    PedometerModel *model = [[PedometerModel alloc] init];
    
    model.wareUUID = [LS_LastWareUUID getObjectValue];
    model.dateString = [[date dateToString] componentsSeparatedByString:@" "][0];
    
    return model;
}

- (void)saveAllTotalInfo:(UInt8 *)val
{
    self.totalSteps       = (val[8]  << 24) | (val[9]  << 16)  | (val[10] << 8) | (val[11]);
    self.totalCalories    = (val[12] << 24) | (val[13] << 16)  | (val[14] << 8) | (val[15]);
    self.totalDistance    = (val[16] << 8)  | val[17];
    self.totalSportTime   = val[18] * 60 + val[19];
    
    // 第二个包
    self.totalSleepTime = val[20] * 60 + val[21];
    self.totalStillTime = val[22] * 60 + val[23];
    self.walkTime       = val[24] * 60 + val[25];
    self.slowWalkTime   = val[26] * 60 + val[27];
    self.midWalkTime    = val[28] * 60 + val[29];
    self.fastWalkTime   = val[30] * 60 + val[31];
    self.slowRunTime    = val[32] * 60 + val[33];
    self.midRunTime     = val[34] * 60 + val[35];
    self.fastRunTime    = val[36] * 60 + val[37];
    [BLTManager sharedInstance].elecQuantity = val[38];
    
    // 第三个包
    self.stepSize     = (val[40] << 8)  | (val[41]) / 100;
    self.weight       = ((val[42] << 8) + (val[43])) / 100;
    self.targetStep   = (val[44] << 16) | (val[45] << 8) | (val[46]);
    self.targetSleep  = val[47] * 60 + val[48];
    self.totalBytes   = (val[49] << 8)  | (val[50]);
}

- (void)showMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *alertString = [NSString stringWithFormat:@"%@", self.dateString];
        SHOWMBProgressHUD(alertString, LS_Text(@"Data sync complete"), nil, NO, 2.0);
    });
}


// 这里准备大修大改....  降低解析难度.

// 保存数据。
+ (void)saveDataToModel:(NSArray *)array
          withTimeOrder:(NSInteger)timeOrder
                withEnd:(PedometerModelSyncEnd)endBlock
{
    NSData *data = array[0];
    UInt8 val[288 * 25] = {0};
    [data getBytes:&val length:data.length];
    
    // 取模型     // 从第一个包
    NSString *dateString = [NSString stringWithFormat:@"%04d-%02d-%02d", (val[4] << 8) | (val[5]), val[6], val[7]];
    NSDate *tmpDate = [NSDate dateWithString:dateString];

    PedometerModel *totalModel = [PedometerHelper getModelFromDBWithDate:tmpDate];
    
    totalModel.dateString = dateString;
    
    if (!tmpDate || [tmpDate timeIntervalSince1970] < 0
        || ([tmpDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970]) > 3600 * 24)
    {
        // SHOWMBProgressHUD(@"数据出现问题.", nil, nil, NO, 2.0);
        if (endBlock)
        {
            endBlock(array[1], NO);
        }
        return;
    }
    
    [totalModel showMessage];
    [totalModel saveAllTotalInfo:val];

    //  NSLog(@"dateString = %d..%d..%ld", totalModel.totalSteps, totalModel.totalCalories, (long)totalModel.totalDistance);
    
    // 此处需要判断收到得字节与存储得字节长度。看看是否发生丢包。
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    NSMutableArray *sleeps = [[NSMutableArray alloc] init];

    NSInteger lastOrder = 0;
    int i = 60;
    int signOrder = 0;
    
    // 卡路里与行程的浮点数精度.
    CGFloat caloriesPrecision = 0.0;
    CGFloat distancePrecision = 0.0;
    
    for (; i < data.length && i < (3 * 288 + 64);)
    {
        int state = (val[i + 1] >> 4);
        if (state == 0)
        {
            SportsModel *model = [[SportsModel alloc] init];
            model.wareUUID = [BLTManager sharedInstance].model.bltID;
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i] + signOrder;
            model.steps = ((val[i + 1] & 0x0F) << 8) | val[i + 2];
            
            CGFloat tmpCalories = [model stepsConvertCalories:model.steps
                                                   withWeight:totalModel.weight
                                                    withModel:YES] + caloriesPrecision;
            model.calories = (NSInteger)tmpCalories;
            caloriesPrecision = tmpCalories - (NSInteger)tmpCalories;
            
            CGFloat tmpDistance = [model StepsConvertDistance:model.steps
                                                     withPace:totalModel.stepSize] + distancePrecision;
            model.distance = (NSInteger)tmpDistance;
            distancePrecision = tmpDistance - (NSInteger)tmpDistance;
            
            // totalModel.totalSteps += model.steps;
            // totalModel.totalCalories += model.calories;

            [sports addObject:model];
            lastOrder = model.currentOrder;
            i += 3;
        }
        else if (state == 8)
        {
            SleepModel *model = [[SleepModel alloc] init];
            model.wareUUID = [BLTManager sharedInstance].model.bltID;
            model.dateDay = totalModel.dateString;
            model.lastOrder = lastOrder;
            model.currentOrder = val[i] + signOrder;
            model.sleepState = val[i + 1] & 0x0F;
            
            [sleeps addObject:model];
            lastOrder = model.currentOrder;
            i += 2;
        }
        else
        {
            i += 6;
        }
        
        if (lastOrder == 255)
        {
            signOrder = 255;
        }
        
        if (i >= data.length - 1)
        {
            break;
        }
    }
    
    /*
    // 保存最后的同步日期和时序
    [BLTSimpleSend sharedInstance].lastSyncDate = totalModel.dateString;
    [LS_LastSyncDate setObjectValue:[BLTSimpleSend sharedInstance].lastSyncDate];
    
    // 只有今天的才需要保存时序.也只有是今天的数据才需要保存时序
    if ([[NSDate dateWithString:totalModel.dateString] isSameWithDate:[NSDate date]])
    {
        [BLTRealTime sharedInstance].lastSyncOrder = lastOrder;
        [LS_LastSyncOrder setIntValue:[BLTRealTime sharedInstance].lastSyncOrder];
    }
     */

    totalModel.sportsArray = sports;
    totalModel.sleepArray = sleeps;
    
    // 将数据保存到周－月表
    [totalModel savePedometerModelToWeekModelAndMonthModel];
    // 将压缩的数据进行每5分钟的详细的转化.
    [totalModel modelToDetailShowWithTimeOrder:(int)lastOrder];
    
    if ([[NSDate date] isSameWithDate:[NSDate dateWithString:totalModel.dateString]])
    {
        totalModel.isSaveAllDay = NO;
        [BLTRealTime sharedInstance].currentDayModel = totalModel;
        [totalModel setNextSleepDataForNextModel];
    }
    else
    {
        totalModel.isSaveAllDay = YES;
    }
    
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       totalModel.dateString, totalModel.wareUUID];
    PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
    
    if (model)
    {
        /*
        totalModel.detailSteps = model.detailSteps;
        totalModel.detailSleeps = model.detailSleeps;
        totalModel.detailCalories = model.detailCalories;
        totalModel.detailDistans = model.detailDistans;
        
        [totalModel modelToDetailShowWithTimeOrder:(int)timeOrder];
         */
        
        [PedometerModel updateToDB:totalModel where:where];
    }
    else
    {
        [totalModel saveToDB];
    }
    
    // 如果有数据就保存到record
    if (totalModel.totalSteps > 0)
    {
        [StepDataRecord addDateToStepDataRecord:totalModel.dateString];
    }
    
    if (endBlock)
    {
        endBlock([NSDate dateWithString:totalModel.dateString], YES);
    }
}

- (void)savePedometerModelToWeekModelAndMonthModel
{
    [YearModel initOrUpdateTheWeekAndMonthModelFromAPedometerModel:self];
}

// 整个睡眠的数据有问题。因为换了数据库。重写.
// 为今天的模型附上今天睡觉结束的时间和明天开始睡觉的时间.
- (void)setStartAndEndForSleepTime
{
    // 取出昨天的数据。
    NSDate *tmpDate = [NSDate dateWithString:self.dateString];
    NSDate *lastdate = [tmpDate dateAfterDay:-1];
 
    PedometerModel *lastModel = [PedometerHelper getModelFromDBWithDate:lastdate];
    if (lastModel)
    {
        self.sleepTodayStartTime = lastModel.sleepNextStartTime;
    }
    else
    {
        self.sleepTodayStartTime = 144;
    }
    
    if (self.sleepArray.count > 0)
    {
        // 今天睡眠结束的时间就是运动开始的时间。
        if (self.sportsArray.count > 0)
        {
            SportsModel *model = self.sportsArray[0];
            self.sleepTodayEndTime = model.currentOrder > 144 ? 144 : model.currentOrder + 144;
        }
        else
        {
            self.sleepTodayEndTime = 144;
        }
        
        // 第二天睡眠开始的时间就是今天晚上睡眠开始的时间
        for (int i = 0; i < self.sleepArray.count; i++)
        {
            SleepModel *model = self.sleepArray[i];
            if (model.currentOrder > 144)
            {
                self.sleepNextStartTime = model.currentOrder - 144;
                break;
            }
        }
    }
    else
    {
        // 如果没有数据。说明没有睡眠时间.
        self.sleepTodayEndTime = 144;
        self.sleepNextStartTime = 144;
    }
}

// 加上睡眠开始和结束的时间。// detailSleeps已经是实际的睡眠了.
- (void)addSleepStartTimeAndEndTime
{
    for (int i = 143; i >= 0; i--)
    {
        NSInteger state = [_detailSleeps[i] integerValue];
        if (state == 4)
        {
            _sleepTodayStartTime = i;
            break;
        }
    }
    
    for (int i = 287; i >= 143; i--)
    {
        NSInteger state = [_detailSleeps[i] integerValue];
        if (state != 4)
        {
            _sleepTodayEndTime = i;
            break;
        }
    }
}

// 为当前的模型附加上昨天的睡眠模型, 数据
- (void)setLastSleepDataForCurrentModel
{
    // 取出昨天的模型.
    NSDate *date = [[NSDate dateWithString:self.dateString] dateAfterDay:-1];
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:date];
    
    if (model)
    {
        _lastDetailSleeps = model.nextDetailSleeps;
    }
}

// 为明天附上今天晚上的数据.
- (void)setNextSleepDataForNextModel
{
    // 取出明天的模型.
    NSDate *date = [[NSDate dateWithString:self.dateString] dateAfterDay:1];
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:date];
    
    if (model)
    {
        NSMutableArray *sleepArray = [[NSMutableArray alloc] initWithCapacity:0];
        [sleepArray addObjectsFromArray:[_currentDaySleeps subarrayWithRange:NSMakeRange(144, 144)]];
        [sleepArray addObjectsFromArray:[model.detailSleeps subarrayWithRange:NSMakeRange(144, 144)]];

        model.detailSleeps = sleepArray;
        [PedometerModel updateToDB:model where:nil];
    }
}

// 将一天的数据分为48个阶段详细展示。
- (void)modelToDetailShowWithTimeOrder:(int)lastOrder
{
    // 为当前的模型附加上昨天的睡眠模型, 数据
    [self setLastSleepDataForCurrentModel];
    
    NSMutableArray *detailSteps    = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *detailSleeps   = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *detailDistans  = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *detailCalories = [[NSMutableArray alloc] initWithCapacity:0];

    // 展示的时候不足的个数再展示的时候自动补满48个.
    for (int i = 0; i < 288; i++)
    {
        NSInteger total = [self getDataWithIndex:i withType:SportsModelSleep];
        [detailSleeps addObject:@(total)];
    }
    
    self.currentDaySleeps = detailSleeps;
    
    // 昨天半天的加上今天半天的.
    NSMutableArray *sleepArray = [[NSMutableArray alloc] initWithCapacity:0];
    [sleepArray addObjectsFromArray:self.lastDetailSleeps];
    [sleepArray addObjectsFromArray:[detailSleeps subarrayWithRange:NSMakeRange(0, 144)]];
    
    self.detailSleeps = sleepArray;
    self.nextDetailSleeps = [detailSleeps subarrayWithRange:NSMakeRange(144, 144)];

    // 加上睡眠开始和结束的时间。// detailSleeps已经是实际的睡眠了.
    [self addSleepStartTimeAndEndTime];
    
    /*
    if (timeOrder > 282)
    {
        timeOrder = 282;
    }
    */
    
    for (int i = 0; i < 288; i += 6)
    {
        NSInteger total = [self halfHourData:i withType:SportsModelSteps];
        [detailSteps addObject:@(total)];
        
        total = [self halfHourData:i withType:SportsModelDistance];
        [detailDistans addObject:@(total)];
        
        total = [self halfHourData:i withType:SportsModelCalories];
        [detailCalories addObject:@(total)];
    }
    
    self.detailSteps = detailSteps;
    self.detailDistans = detailDistans;
    self.detailCalories = detailCalories;
}

// 取出每半个小时的数据
- (NSInteger)halfHourData:(int)index withType:(SportsModelType)type
{
    NSInteger number = 0;
    for (int i = index; i < index + 6; i++)
    {
        number += [self getDataWithIndex:i withType:type];
    }
    
    return number;
}

// 取出当前5分钟的具体数据。
- (NSInteger)getDataWithIndex:(int)index withType:(SportsModelType)type
{
    if (type != SportsModelSleep)
    {
        if (self.sportsArray && self.sportsArray.count > 0)
        {
            for (int i = 0; i < self.sportsArray.count; i++)
            {
                SportsModel *model = self.sportsArray[i];
                if (index <= model.currentOrder)
                {
                    switch (type)
                    {
                        case SportsModelSteps:
                        {
                            return model.steps;
                        }
                            break;
                        case SportsModelCalories:
                        {
                            return model.calories;
                        }
                            break;
                        case SportsModelDistance:
                        {
                            return model.distance;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        
        return 0;
    }
    else
    {
        if (self.sleepArray && self.sleepArray.count > 0)
        {
            for (int i = 0; i < self.sleepArray.count; i++)
            {
                SleepModel *model = self.sleepArray[i];
                if (index <= model.currentOrder)
                {
                    return model.sleepState;
                }
            }
        }
        
        return 4;
    }
}
        /*
        if (index < 144)
        {
            if (self.lastSleepArray && self.lastSleepArray.count)
            {
                for (int i = 0; i < self.lastSleepArray.count; i++)
                {
                    SleepModel *model = self.lastSleepArray[i];
                    if (index + 144 <= model.currentOrder)
                    {
                        return model.sleepState;
                    }
                }

                return 3;
            }
            else
            {
                return 3;
            }
        }
        else
        {
            if (self.sleepArray && self.sleepArray.count > 0)
            {
                for (int i = 0; i < self.sleepArray.count; i++)
                {
                    SleepModel *model = self.sleepArray[i];
                    if (index - 144 <= model.currentOrder)
                    {
                        return model.sleepState;
                    }
                }

                return 3;
            }
            else
            {
                return 3;
            }
        }
         */

// 从用户信息为模型添加各种目标.
- (void)addTargetForModelFromUserInfo
{
    _targetStep = [UserInfoHelp sharedInstance].userModel.targetSteps;
    _targetCalories = [UserInfoHelp sharedInstance].userModel.targetCalories;
    _targetDistance = [UserInfoHelp sharedInstance].userModel.targetDistance;
    _targetSleep = [UserInfoHelp sharedInstance].userModel.targetSleep;
}

// 表名
+ (NSString *)getTableName
{
    return @"PedometerTable";
}

// 复合主键
+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"userName", @"dateString", @"wareUUID"];
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

+ (void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    [self removePropertyWithColumnName:@"sportsArray"];
    [self removePropertyWithColumnName:@"sleepArray"];
    [self removePropertyWithColumnName:@"lastSleepArray"];

    //[self removePropertyWithColumnName:@"detailDistans"];
    //[self removePropertyWithColumnName:@"detailCalories"];
}

@end

