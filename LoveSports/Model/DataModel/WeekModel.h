//
//  WeekModel.h
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PedometerModel.h"
#import "DateTools.h"

@interface SubOfPedometerModel : NSObject  //pedometermodel子模型

@property (nonatomic, assign) NSInteger _thisDayTotalSteps;         // 当天的总步数
@property (nonatomic, assign) NSInteger _thisDayTotalCalories;      // 当天的总卡路里
@property (nonatomic, assign) NSInteger _thisDayTotalDistance ;     // 当天的总路程

/**
 *  更新此子模型的信息通过传入的pedometerModel模型
 *
 *  @param onePedometerModel 传入的pedometerModel模型
 */
- (void) updateInfoFromAPedometerModel: (PedometerModel *) onePedometerModel;

@end

@interface WeekModel : NSObject

@property (nonatomic, assign) NSInteger _weekNumber;         // 第几周
@property (nonatomic, assign) NSInteger _yearNumber;         // 年，如2014
@property (nonatomic, assign) NSInteger _weekTotalSteps;     // 当天的总步数
@property (nonatomic, assign) NSInteger _weekTotalCalories;  // 当天的总卡路里
@property (nonatomic, assign) NSInteger _weekTotalDistance ; // 当天的总路程
@property (nonatomic, strong) NSMutableDictionary *_allSubPedModelArray;
@property (nonatomic, strong) NSString *showDate;

/**
 *  初始化一个星期模型
 *
 *  @param weekNumber 这个星期是那一年的第几周
 *  @param andYearNumber 表示是哪一年
 *
 *  @return 星期模型
 */
- (instancetype)initWithWeekNumber:(NSInteger ) weekNumber
                     andYearNumber: (NSInteger ) yearNumber;


/**
 *  更新汇总信息
 */
- (void) updateInfo;

@end

