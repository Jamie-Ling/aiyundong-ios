//
//  YearModel.h
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekModel.h"
#import "monthModel.h"


@interface YearModel : NSObject

@property (nonatomic, strong) NSString *_yearID;  //年份，作为ID。 如2014
@property (nonatomic, strong) NSMutableDictionary *_thisYearAllWeeks;  //这一年内所有有数据的周模型
@property (nonatomic, strong) NSMutableDictionary *_thisYearAllMonths;//这一年内所有有数据的月模型

#pragma mark ---------------- 周 - 月  相关 -----------------
/**
 *  初始化或更新 周&月模型 通过传入PedModel
 *
 *  @param onePedoMeterModel 传入的PedMode
 *
 */
+ (void) initOrUpdateTheWeekAndMonthModelFromAPedometerModel: (PedometerModel *) onePedoMeterModel;


#pragma mark ---------------- 周相关 -----------------
/**
 *  返回一个指定日期是今年的第几周
 *
 *  @param oneDate 指定的日期
 *
 *  @return 今年的第几周数
 */
+ (NSInteger) weekOfYearFromADate: (NSDate *) oneDate;

/**
 *  得到一个周模型。通过指定的PedModel,******注意：更新或者创建此周模型时才用此方法，取用后面的方法
 *
 *  @param onePedoMeterModel 传入的PedMode
 *
 *  @return 返回更新后的周模型
 */
+ (WeekModel *) initOrUpdateTheWeekModelFromAPedometerModel: (PedometerModel *) onePedoMeterModel;

/**
 *  返回指定日期一年内所有的周模型
 *
 *  @param oneDate 指定日期
 *
 *  @return 这一年内所有周模型的字典
 */
+ (NSDictionary *) getThisYearAllWeekModelWithDate:(NSDate *) oneDate;

/**
 *  返回指定日期的周模型
 *
 *  @param oneDate 指定的日期
 *
 *  @return 取出来的周模型
 */
+ (WeekModel *) getTheWeekModelWithDate:(NSDate *) oneDate;

#pragma mark ---------------- 月相关 -----------------
/**
 *  得到一个月模型。通过指定的PedModel，******注意：更新或者创建此月模型时才用此方法，取用后面的方法
 *
 *  @param onePedoMeterModel 传入的PedMode
 *
 *  @return 返回更新后的月模型
 */
+ (MonthModel *) initOrUpdateThemonthModelFromAPedometerModel: (PedometerModel *) onePedoMeterModel;

/**
 *  返回一个指定日期是今年的第几月
 *
 *  @param oneDate 指定的日期
 *
 *  @return 今年的第几月数
 */
+ (NSInteger) monthOfYearFromADate: (NSDate *) oneDate;

/**
 *   返回指定日期一年内所有的月模型
 *
 *  @param oneDate 指定日期
 *
 *  @return 这一年内所有月模型的字典
 */
+ (NSDictionary *) getThisYearAllMonthModelWithDate:(NSDate *) oneDate;

/**
 *  返回指定日期的月模型
 *
 *  @param oneDate 指定的日期
 *
 *  @return 取出来的月模型
 */
+ (MonthModel *) getTheMonthModelWithDate:(NSDate *) oneDate;

@end



