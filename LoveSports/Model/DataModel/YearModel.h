//
//  YearModel.h
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

typedef enum {
    ShowTypeDefault = 0,        //常用显示方式，如每年的1月1号当作使用的第一天,每年过完，周和月都是当年的第一个
    ShowTypeFromUserUseDay = 1, //用户使用点为起点的显示方式，如用户10月2号使用，10月2号所在的周为第一周，以后不再以年为单位，从1-100进行周显示
} ShowType;

#import <Foundation/Foundation.h>
#import "WeekModel.h"
#import "monthModel.h"


@interface YearModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareUUID;
@property (nonatomic, strong) NSString *_yearID;                        //年份，作为ID。 如2014
@property (nonatomic, strong) NSMutableDictionary *_thisYearAllWeeks;   //这一年内所有有数据的周模型
@property (nonatomic, strong) NSMutableDictionary *_thisYearAllMonths;  //这一年内所有有数据的月模型

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

// 根据日期去取周的模型，因为每周7天是固定的
+ (WeekModel *) getTheWeekModelWithDate:(NSDate *)date
                        withReturnModel:(BOOL)model;

// 返回需要展示的周数组
+ (NSArray *)getWeekModelArrayWithDate:(NSDate *)date
                       withReturnModel:(BOOL)noEmpty;


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

// 返回日期在展示时的序号,程序记忆的，无需展示给用户。以2015年为基准.
+ (NSInteger)monthOfYearWithDate: (NSDate *)date;

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

// 通过序号取月的模型，因为月数时固定的.
+ (MonthModel *)getTheWeekModelWithIndex:(NSInteger)index
                         withReturnModel:(BOOL)noEmpty;

// 返回需要展示的月数组。
+ (NSArray *)getMonthModelArrayWithIndex:(NSInteger)index
                         withReturnModel:(BOOL)noEmpty;


// 根据月序号返回年份。
+ (NSInteger)getYearWithMonthIndex:(NSInteger)index;


@end



