//
//  PedometerModel.h
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StateModelSportSteps = 0,
    StateModelSportCalories = 1,
    StateModelSportDistance = 2,
    StateModelSportSleep
} StateModelSportType;

typedef enum {
    StateModelSport = 0,
    StateModelSleep
} StateModelType;

@interface StateModel : NSObject

@property (nonatomic, strong) NSString *wareUUID;           // 设备uuid
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *dateDay;
@property (nonatomic, assign) NSInteger lastOrder;      // 上一个时间序号
@property (nonatomic, assign) NSInteger currentOrder;   // 当前时间序号
@property (nonatomic, assign) StateModelType modelType;

@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger calories;       // 卡路里
@property (nonatomic, assign) CGFloat distance;         // 距离

@property (nonatomic, assign) NSInteger sleepState;     // 睡眠状态

@end

@interface SportsModel : StateModel


@end

@interface SleepModel : StateModel


@end

@interface PedometerModel : NSObject

typedef void(^PedometerModelSyncEnd)(NSDate *date, BOOL success);

@property (nonatomic, strong) NSString *wareUUID;           // 设备uuid
@property (nonatomic, strong) NSString *userName;           // 用户名
@property (nonatomic, strong) NSString *dateString;         // 日期
@property (nonatomic, assign) NSInteger totalBytes;         // 数据包 。
@property (nonatomic, assign) NSInteger settingBytes;

@property (nonatomic, assign) NSInteger totalSteps;         // 当天的总步数
@property (nonatomic, assign) NSInteger totalCalories;      // 当天的总卡路里
@property (nonatomic, assign) NSInteger totalDistance ;     // 当天的总路程
@property (nonatomic, assign) NSInteger totalSportTime ;    // 当天的总运动时间

@property (nonatomic, assign) NSInteger totalSleepTime ;    // 当天的总睡眠时间
@property (nonatomic, assign) NSInteger totalStillTime ;    // 当天的总静止时间
@property (nonatomic, assign) NSInteger walkTime ;          // 当天散步时间
@property (nonatomic, assign) NSInteger slowWalkTime ;      // 当天慢步时间
@property (nonatomic, assign) NSInteger midWalkTime ;       // 当天中等散步时间
@property (nonatomic, assign) NSInteger fastWalkTime ;      // 当天快速散步时间
@property (nonatomic, assign) NSInteger slowRunTime ;       // 当天慢速跑步时间
@property (nonatomic, assign) NSInteger midRunTime ;        // 当天中等跑步时间
@property (nonatomic, assign) NSInteger fastRunTime ;       // 当天快速跑步时间

@property (nonatomic, assign) NSInteger targetStep;         // 目标步数
@property (nonatomic, assign) CGFloat targetCalories;       // 目标卡路里
@property (nonatomic, assign) CGFloat targetDistance;       // 目标距离
@property (nonatomic, assign) NSInteger targetSleep;        // 目标睡眠

@property (nonatomic, assign) NSInteger sleepTodayStartTime;// 今天开始的睡眠时间
@property (nonatomic, assign) NSInteger sleepTodayEndTime;  // 今天结束的睡眠时间  // 都是时序.
@property (nonatomic, assign) NSInteger sleepNextStartTime; // 明天开始睡眠的时间

@property (nonatomic, assign) NSInteger stepSize;           // 步距
@property (nonatomic, assign) CGFloat weight;               // 体重

@property (nonatomic, strong) NSArray *sportsArray;
@property (nonatomic, strong) NSArray *sleepArray;

@property (nonatomic, strong) NSArray *stateArray;

@property (nonatomic, strong) NSArray *lastSleepArray;      // 昨天的睡眠
@property (nonatomic, assign) BOOL isSaveAllDay;            // 是否保存了全天的数据

// @property (nonatomic, strong) NSArray *stepSizes;

@property (nonatomic, strong) NSArray *currentDaySleeps;     // 这是当天拉出来的数据.

@property (nonatomic, strong) NSArray *nextDetailSleeps;    // 今天拉下来的的详细睡眠。用数组替换掉模型.模型开销太大. 也是今天拉下来的睡眠数据.
@property (nonatomic, strong) NSArray *lastDetailSleeps;     // 昨天拉下来的的详细睡眠。用数组替换掉模型.模型开销太大. 也是今天拉下来的睡眠数据.

@property (nonatomic, strong) NSArray *detailSleeps;         // 这个是昨天半天加今天半天的.

@property (nonatomic, strong) NSArray *detailSteps;
@property (nonatomic, strong) NSArray *detailCalories;
@property (nonatomic, strong) NSArray *detailDistans;

// 目前硬件协议有问题。协商改进。
+ (void)saveDataToModel:(NSArray *)array withTimeOrder:(NSInteger)timeOrder withEnd:(PedometerModelSyncEnd)endBlock;
+ (PedometerModel *)simpleInitWithDate:(NSDate *)date;

// 将数据分成阶段展示.
- (void)modelToDetailShowWithTimeOrder:(int)lastOrder;

// 将模型保存到周表和月表
- (void)savePedometerModelToWeekModelAndMonthModel;

- (void)showMessage;

// 为当前的模型附加上昨天的睡眠模型, 数据
- (void)setLastSleepDataForCurrentModel;

// 为明天附上今天晚上的数据.
- (void)setNextSleepDataForNextModel;

// 从用户信息为模型添加各种目标.
- (void)addTargetForModelFromUserInfo;

// 加上睡眠开始和结束的时间。// detailSleeps已经是实际的睡眠了.
- (void)addSleepStartTimeAndEndTime;

// 睡眠时的星期显示
- (NSString *)showWeekTextForSleep;
// 睡眠时的日期显示
- (NSString *)showDateTextForSleep;

@end


