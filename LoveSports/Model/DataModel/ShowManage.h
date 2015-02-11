//
//  ShowManage.h
//  LoveSports
//
//  Created by jamie on 15/2/9.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

typedef enum {
    ShowTypeDefault = 0,   //常用显示方式，如每年的1月1号当作使用的第一天,每年过完，周和月都是当年的第一个
    ShowTypeFromUserUseDay = 1, //用户使用点为起点的显示方式，如用户10月2号使用，10月2号所在的周为第一周，以后不再以年为单位，从1-100进行周显示
} ShowType;

#import <Foundation/Foundation.h>
#import "YearModel.h"

@interface ShowModel : NSObject

@property (nonatomic, assign) NSInteger _showSort;      //展现的序号，根据ShowType变化
@property (nonatomic, strong) NSDate *_thisWeekOrMonthFirstDate;  //这一周/月的第一天的日期
@property (nonatomic, strong) WeekModel *_weekModel;
@property (nonatomic, strong) MonthModel *_monthModel;

@end

@interface ShowManage : NSObject

/**
 *   当使用ShowTypeFromUserUseDay类型展示前，必须设置用户使用起点日期（用户第一天使用的日期）
 */
+ (void) setUserUseFirstDate: (NSDate *)userUseFirstDate;

/**
 *  得到周或者月的横坐标（序号）
 *
 *  @param isShowWeekSort 是否显示周序号，YES:返回周序号， No: 返回月序号
 *  @param showType       显示模式
 *  @param yearDate     年，如2014-01-06，表示为2014年，如果为ShowTypeFromUserUseDay，不用设置或者设置为Nil
 *
 *  @return 返回包含这一年周序号或者月序号的字符串,如果为ShowTypeFromUserUseDay，返回100个周或者月
 */
+ (NSArray *) showThisYearAllWeekSortOrMonthSort: (BOOL) isShowWeekSort
                                    withShowType: (ShowType) showType
                                    withYearDate: (NSDate *) yearDate;


/**
 *  返回一个周模型或者一个月模型，根据传入的序号
 *
 *  @param sort           周/月序号
 *  @param isShowWeekSort 是否是周？
 *  @param returnNilOrModel  返回空还是返加一个空模型
 *  @param showType       显示类型
 *  @param yearDate       年，如2014-01-06，表示为2014年，如果为ShowTypeFromUserUseDay，不用设置或者设置为Nil
 *
 *  @return 返回一个展现的模型。包含
 */
+ (ShowModel *) getAWeekOrMonthFromASort: (NSInteger) sort
                    withReturnNilOrModel: (BOOL) returnNil
                          withIsWeekSort:(BOOL) isShowWeekSort
                            withShowType: (ShowType) showType
                            withYearDate: (NSDate *) yearDate;

/**
 *  根据指定的日期返回它是哪一个月/周
 *
 *  @param isShowWeekSort 是否是判断周
 *  @param showType       显示类型
 *  @param theDate        指定的日期
 *
 *  @return 返回这个序号
 */
+ (NSInteger ) getTheWeekOrMonthSortWithIsWeekSort:(BOOL) isShowWeekSort
                                      WithShowType: (ShowType) showType
                                       withTheDate: (NSDate *) theDate;
@end
