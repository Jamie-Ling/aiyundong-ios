//
//  PedometerModel.h
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepsModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateDay;
@property (nonatomic, assign) NSInteger timeOrder;
@property (nonatomic, assign) NSInteger stepSize;

+ (StepsModel *)simpleInit;

@end

typedef enum {
    SportsModelSteps = 0,
    SportsModelCalories = 1,
    SportsModelDistance,
    SportsModelSleep
} SportsModelType;

@interface SportsModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateDay;
@property (nonatomic, strong) NSString *dateHour;
@property (nonatomic, assign) NSInteger lastOrder;      // 上一个时间序号
@property (nonatomic, assign) NSInteger currentOrder;   // 当前时间序号
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger calories;       // 卡路里
@property (nonatomic, assign) CGFloat distance;         // 距离

@end

@interface SleepModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateDay;
@property (nonatomic, strong) NSString *dateHour;
@property (nonatomic, assign) NSInteger lastOrder;      // 上一个时间序号
@property (nonatomic, assign) NSInteger currentOrder;   // 当前时间序号
@property (nonatomic, assign) NSInteger sleepState;     // 睡眠状态

@end

@interface PedometerModel : NSObject
typedef void(^PedometerModelSyncEnd)(NSDate *date, BOOL success);

@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, assign) NSInteger totalBytes;
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
@property (nonatomic, assign) CGFloat targetCalories;     // 目标卡路里
@property (nonatomic, assign) CGFloat targetDistance;     // 目标距离
@property (nonatomic, assign) NSInteger targetSleep;        // 目标睡眠

@property (nonatomic, assign) NSInteger stepSize;           // 步距
@property (nonatomic, assign) CGFloat weight;               // 体重

@property (nonatomic, strong) NSArray *sportsArray;
@property (nonatomic, strong) NSArray *sleepArray;

@property (nonatomic, strong) NSArray *lastSleepArray;      // 昨天的睡眠
@property (nonatomic, assign) BOOL isSaveAllDay;            // 是否保存了全天的数据

// @property (nonatomic, strong) NSArray *stepSizes;

@property (nonatomic, strong) NSArray *detailSteps;
@property (nonatomic, strong) NSArray *detailSleeps;
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


@end


