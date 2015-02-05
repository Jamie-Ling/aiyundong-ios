//
//  PedometerModel.h
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateDay;
@property (nonatomic, strong) NSString *dateHour;
@property (nonatomic, assign) NSInteger lastOrder; // 上一个时间序号
@property (nonatomic, assign) NSInteger currentOrder; // 当前时间序号
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger calories; // 卡路里

@end

@interface SleepModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateDay;
@property (nonatomic, strong) NSString *dateHour;
@property (nonatomic, assign) NSInteger lastOrder; // 上一个时间序号
@property (nonatomic, assign) NSInteger currentOrder; // 当前时间序号
@property (nonatomic, assign) NSInteger sleepState; // 睡眠状态

@end

@interface PedometerModel : NSObject

@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, assign) NSInteger totalBytes;
@property (nonatomic, assign) NSInteger totalSteps; // 当天的总步数
@property (nonatomic, assign) NSInteger totalCalories; // 当天的总卡路里

@property (nonatomic, strong) NSArray *sportsArray;
@property (nonatomic, strong) NSArray *sleepArray;

// 目前硬件协议有问题。协商改进。
- (void)saveDataToModel:(NSData *)data;
- (void)setTotalSteps;
- (void)setTotalCalories;

@end


