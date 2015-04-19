//
//  monthModel.h
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekModel.h"

@interface MonthModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, assign) NSInteger monthNumber;          //第几月
@property (nonatomic, assign) NSInteger yearNumber;           //年，如2014
@property (nonatomic, assign) NSInteger monthTotalSteps;      // 当月的总步数
@property (nonatomic, assign) NSInteger monthTotalCalories;   // 当月的总卡路里
@property (nonatomic, assign) NSInteger monthTotalDistance ;  // 当月的总路程
@property (nonatomic, strong) NSString *showDate;

@property (nonatomic, assign) NSInteger todaySteps;     // 当天的总步数
@property (nonatomic, assign) NSInteger toadyCalories;  // 当天的总卡路里
@property (nonatomic, assign) NSInteger todayDistance;  // 当天的总路程

/**
 *  初始化一个月模型
 *
 *  @param monthNumber 这个星期是那一年的第几月
 *  @param andYearNumber 表示是哪一年
 *
 *  @return 月模型
 */
- (instancetype)initWithmonthNumber:(NSInteger ) monthNumber
                     andYearNumber: (NSInteger ) yearNumber;

/**
 *  更新汇总信息
 */
- (void)updateInfo;
- (void)updateTotalWithModel:(PedometerModel *)model;

@end
