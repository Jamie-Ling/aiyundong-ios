//
//  PedometerOld.m
//  LoveSports
//
//  Created by zorro on 15/3/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "PedometerOld.h"
#import "BLTSendOld.h"
#import "PedometerHelper.h"

@implementation PedometerOld

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _modelArray = [[NSMutableArray alloc] init];
        
        if (![LS_PedometerOld_Date getObjectValue])
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
            [LS_PedometerOld_Date setObjectValue:date];
        }
    }
    
    return self;
}

DEF_SINGLETON(PedometerOld)

+ (void)saveDataToModelFromOld:(NSArray *)array withEnd:(PedometerModelSyncEnd)endBlock
{
    [[PedometerOld sharedInstance].modelArray removeAllObjects];
    
    NSInteger length = [array[1] integerValue];
    NSData *originalData = array[0];
    UInt8 val[1024 * 64] = {0};
    [originalData getBytes:&val length:originalData.length];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    // 将每个数据包的第一个byte清除.
    for (int i = 0; i < originalData.length; i++)
    {
        if (!(i % 20 == 0))
        {
            [data appendBytes:&val[i] length:1];
        }
    }
    
    [data getBytes:&val length:data.length];
    
    int currentDay = 0;
    NSDate *currentDate = [NSDate date];
    NSInteger timeIndex = (currentDate.hour * 60 + currentDate.minute) / 5; //当前5分钟内。数据时前5分钟开始的。
    
    // 去除2个校验码。i是数据包的第一个数据时不计数.
    /*
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       dateString, [LS_LastWareUUID getObjectValue]];
     */

    PedometerModel *currentModel = [[PedometerOld sharedInstance] getCurrentModelWithDate:currentDate
                                                                                 withUUID:[LS_LastWareUUID getObjectValue]];
    
    // 第一个包
    currentModel.totalSteps    = val[0] | (val[1]  << 8) | (val[2]  << 16) | (val[3]  << 24);
    currentModel.totalCalories = val[4] | (val[5]  << 8) | (val[6]  << 16) | (val[7]  << 24);
    currentModel.totalDistance = val[8] | (val[9]  << 8) | (val[10] << 16) | (val[11] << 24);
    
    NSLog(@"..%d..%d..%d", currentModel.totalSteps, currentModel.totalCalories, currentModel.totalDistance);
    // [PedometerModel updateToDB:currentModel where:where];

    NSLog(@"...%@", [NSDate date]);
    BOOL today = YES;
    for (int i = 12; i < length - 2; i += 6)
    {
        if ([currentDate isSameWithDate:[LS_PedometerOld_Date getObjectValue]] &&
            timeIndex == [LS_PedometerOld_TimeIndex getIntValue])
        {
            break;
        }
        
        NSInteger state = (UInt8)(val[i + 1] >> 4);
        if (state == 8)
        {
            NSInteger sleepX = val[i]   | ((val[i+1] & 0x0F) << 8);
            NSInteger sleepY = val[i+2] | ((val[i+3] & 0x0F) << 8);
            NSInteger sleepZ = val[i+4] | ((val[i+5] & 0x0F) << 8);
            NSInteger sleep = sleepX + sleepY + sleepZ;
            NSInteger sleepState = 0;
            if (sleep < 800)
            {
                sleepState = 0;
            }
            else if (sleep > 801 && sleep < 1600)
            {
                sleepState = 1;
            }
            else if (sleep > 1601 && sleep < 3500)
            {
                sleepState = 2;
            }
            else
            {
                sleepState = 3;
            }
            
            [self updateDataForSleep:currentModel withNumber:sleepState withTimeIndex:timeIndex];
        }
        else
        {
            NSInteger step =        val[i]   | (val[i+1] << 8);
            NSInteger cal =         val[i+2] | (val[i+3] << 8);
            NSInteger distance =    val[i+4] | (val[i+5] << 8);
            
            [self updateDataForArray:currentModel
                                with:@[@(step), @(cal), @(distance)]
                       withTimeIndex:timeIndex
                           withToday:today];
        }
        
        /*
        // 将当前模型保存到周表和月表.
        // [currentModel savePedometerModelToWeekModelAndMonthModel];
        NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                           currentModel.dateString, [LS_LastWareUUID getObjectValue]];
        
        // PedometerModel *model = [PedometerModel searchSingleWithWhere:where orderBy:nil];

        if (model)
        {
            [PedometerModel updateToDB:currentModel where:where];
        }
        else
        {
            [currentModel saveToDB];
        }
         */

        if (timeIndex == 0)
        {
            // 到了下一天。创建新的模型.
            timeIndex = 288;
            currentDay--;
            today = NO;
            currentDate = [[NSDate date] dateAfterDay:currentDay];
            NSLog(@"...currentDate..%@", currentDate);
            currentModel = [[PedometerOld sharedInstance] getCurrentModelWithDate:currentDate
                                                                         withUUID:[LS_LastWareUUID getObjectValue]];
        }
        
        timeIndex--;
   
    }
    
    // 存储最后同步的日期和时间避免重复同步.
    [LS_PedometerOld_Date setObjectValue:[NSDate date]];
    [LS_PedometerOld_TimeIndex setIntValue:(currentDate.hour * 60 + currentDate.minute) / 5];
    
    // 将数据存储
    [[PedometerOld sharedInstance] saveModelDataOfPedometerOldToDB];
    
    NSLog(@"...%@", [NSDate date]);

    [currentModel showMessage];
    
    if (endBlock)
    {
        endBlock([NSDate date], YES);
    }
}

// 将所有的值放入数组中.
+ (void)updateDataForArray:(PedometerModel *)model
                      with:(NSArray *)numberArray
             withTimeIndex:(NSInteger)order withToday:(BOOL)today
{
    NSInteger stepNumber = [numberArray[0] integerValue];
    NSMutableArray *stepsArray = [NSMutableArray arrayWithArray:model.detailSteps];
    [self fixMutableArray:stepsArray withCount:48];
    NSInteger steps = [stepsArray[order / 6] integerValue];
    steps += stepNumber;
    stepsArray[order / 6] = @(steps);
    model.detailSteps = stepsArray;
    
    NSInteger calNumber = [numberArray[1] integerValue];
    NSMutableArray *calArray = [NSMutableArray arrayWithArray:model.detailCalories];
    [self fixMutableArray:calArray withCount:48];
    NSInteger calories = [calArray[order / 6] integerValue];
    calories += calNumber;
    calArray[order / 6] = @(calories);
    model.detailCalories = calArray;
    
    NSInteger distanceNumber = [numberArray[2] integerValue];
    NSMutableArray *distansArray = [NSMutableArray arrayWithArray:model.detailDistans];
    [self fixMutableArray:distansArray withCount:48];
    NSInteger distans = [distansArray[order / 6] integerValue];
    distans += distanceNumber;
    distansArray[order / 6] = @(distans);
    model.detailDistans = distansArray;
    
    if (!today)
    {
        model.totalSteps += stepNumber;
        model.totalCalories += calNumber;
        model.totalDistance += distanceNumber;
    }
}

+ (void)updateDataForSleep:(PedometerModel *)model withNumber:(NSInteger)number withTimeIndex:(NSInteger)order
{
    NSMutableArray *sleepArray = [NSMutableArray arrayWithArray:model.detailSleeps];
    [self fixMutableArray:sleepArray withCount:288];
    sleepArray[order] = @(number);
    model.detailSleeps = sleepArray;
}

+ (void)fixMutableArray:(NSMutableArray *)array withCount:(int)count
{
    for (NSInteger i = array.count; i < count; i++)
    {
        [array addObject:@(0)];
    }
}

// 实例方法，先从内存取。 不在就在数据库取，数据库没有就返回空。 不然就进行第一次保存.
- (PedometerModel *)getCurrentModelWithDate:(NSDate *)date withUUID:(NSString *)idString
{
    NSString *dateString = [[date dateToString] componentsSeparatedByString:@" "][0];
    NSString *where = [NSString stringWithFormat:@"dateString = '%@' and wareUUID = '%@'",
                       dateString, idString];
    PedometerModel *model;
    
    for (int i = 0; i < _modelArray.count; i++)
    {
        PedometerModel *tmpModel = _modelArray[i];
        
        if ([tmpModel.wareUUID isEqualToString:idString] &&
            [tmpModel.dateString isEqualToString:dateString])
        {
            model = tmpModel;

            break;
        }
    }
    
    if (!model)
    {
        model = [PedometerModel searchSingleWithWhere:where orderBy:nil];
        
        if (!model)
        {
            model = [PedometerHelper pedometerSaveEmptyModelToDBWithDate:date];
        }
     
        if (![_modelArray containsObject:model])
        {
            [[PedometerOld sharedInstance].modelArray addObject:model];
        }
    }
    
    return model;
}

// 将数据一次性的存入表里面.
- (void)saveModelDataOfPedometerOldToDB
{
    for (NSInteger i = _modelArray.count - 1; i >= 0; i--)
    {
        PedometerModel *tmpModel = _modelArray[i];
        
        // 最后设置睡眠的数据。昨天半天加上今天半天的.
        [tmpModel setLastSleepDataForCurrentModel];
        tmpModel.nextDetailSleeps = [tmpModel.detailSleeps subarrayWithRange:NSMakeRange(144, 144)];
        
        // 昨天半天的加上今天半天的.
        NSMutableArray *sleepArray = [[NSMutableArray alloc] initWithCapacity:0];
        [sleepArray addObjectsFromArray:tmpModel.lastDetailSleeps];
        [sleepArray addObjectsFromArray:[tmpModel.detailSleeps subarrayWithRange:NSMakeRange(0, 144)]];
        tmpModel.detailSleeps = sleepArray;
        
        // 加上开始睡眠和结束睡眠的时间.
        [tmpModel addSleepStartTimeAndEndTime];
 
        [PedometerModel updateToDB:tmpModel where:nil];
        [tmpModel savePedometerModelToWeekModelAndMonthModel];
        
        // 如果有数据就保存到record
        if (tmpModel.totalSteps > 0)
        {
            [StepDataRecord addDateToStepDataRecord:tmpModel.dateString];
        }
    }
    
    // 保存完毕后将内存清除...
    [_modelArray removeAllObjects];
}

@end
