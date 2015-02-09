//
//  ShowManage.m
//  LoveSports
//
//  Created by jamie on 15/2/9.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShowManage.h"

@implementation ShowModel

@synthesize _monthModel, _showSort, _weekModel, _thisWeekOrMonthFirstDate;

@end

@implementation ShowManage

/**
 *   当使用ShowTypeFromUserUseDay类型展示前，必须设置用户使用起点日期（用户第一天使用的日期）
 */
+ (void) setUserUseFirstDate: (NSDate *)userUseFirstDate
{
    [[ObjectCTools shared] setobject:userUseFirstDate forKey:kUserUseFirstDateKey];
}

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
                                    withYearDate: (NSDate *) yearDate
{
    if (showType == ShowTypeDefault)
    {
        NSInteger wentNumber = 12;  //12个月
        if (isShowWeekSort)
        {
            wentNumber = [ShowManage getThisYearAllWeeksNumber:yearDate];
        }
        return [ShowManage getNSArrayWithInter:wentNumber];
    }
    
    return [ShowManage getNSArrayWithInter:100];
    
}


/**
 *  得到这一年的所有周数
 *
 *  @param yearDate 表示年的日期
 *
 *  @return 这一年的所有周数
 */
+ (NSInteger) getThisYearAllWeeksNumber: (NSDate *) yearDate
{
    NSDate *firstDate = [ShowManage thisYearFirstDayWithShowType:ShowTypeDefault WithYearDate:yearDate];
    NSDate *lastDate = [ShowManage thisYearLastDayWithYearDate:yearDate];
    
    return [lastDate weeksFrom:firstDate];
}

+ (NSArray *) getNSArrayWithInter :(NSInteger) number
{
    NSMutableArray *wentArray = [[NSMutableArray alloc] initWithCapacity:32];
    for (int i = 1; i <= number; i++)
    {
        [wentArray addObject:[NSString stringWithFormat:@"%ld", (long) number]];
    }
    return wentArray;
}


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
                            withYearDate: (NSDate *) yearDate
{
    if (showType == ShowTypeDefault)
    {
        if (isShowWeekSort)
        {
            NSInteger thisYearAllWeeks = [ShowManage getThisYearAllWeeksNumber:yearDate];
            if (sort > thisYearAllWeeks)
            {
                
                [UIView showAlertView:[NSString stringWithFormat:@"正常模式下%@年周数最多不能超过 %ld个周", yearDate, thisYearAllWeeks] andMessage:nil];
                return nil;
            }
            NSDictionary *allWeekModelDictionary = [YearModel getThisYearAllWeekModelWithDate:yearDate];
            if (!allWeekModelDictionary || allWeekModelDictionary.count == 0)
            {
                if (returnNil)
                {
                    return nil;
                }
                else
                {
                    ShowModel *onlySortShowModel = [[ShowModel alloc] init];
                    onlySortShowModel._showSort = sort;
                    onlySortShowModel._thisWeekOrMonthFirstDate = [[ShowManage thisYearFirstDayWithShowType:showType WithYearDate:yearDate] dateByAddingWeeks:sort];
                    return onlySortShowModel;
                }
            }
            else
            {
                ShowModel *weekShowModel = [[ShowModel alloc] init];
                weekShowModel._showSort = sort;
                weekShowModel._thisWeekOrMonthFirstDate = [[ShowManage thisYearFirstDayWithShowType:showType WithYearDate:yearDate] dateByAddingWeeks:sort];
                weekShowModel._weekModel = [allWeekModelDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)sort]];
                return weekShowModel;
            }
            
        }
        else
        {
            if (sort > 12)
            {
                [UIView showAlertView:@"正常模式下月份最多不能超过 12个月" andMessage:nil];
                return nil;
            }
            NSDictionary *allMonthModelDictionary = [YearModel getThisYearAllMonthModelWithDate:yearDate];
            if (!allMonthModelDictionary || allMonthModelDictionary.count == 0)
            {
                if (returnNil)
                {
                    return nil;
                }
                else
                {
                    ShowModel *onlySortShowModel = [[ShowModel alloc] init];
                    onlySortShowModel._showSort = sort;
                    onlySortShowModel._thisWeekOrMonthFirstDate = [[ShowManage thisYearFirstDayWithShowType:showType WithYearDate:yearDate] dateByAddingMonths:sort];
                    return onlySortShowModel;
                }
            }
            else
            {
                ShowModel *monthShowModel = [[ShowModel alloc] init];
                monthShowModel._showSort = sort;
                monthShowModel._thisWeekOrMonthFirstDate = [[ShowManage thisYearFirstDayWithShowType:showType WithYearDate:yearDate] dateByAddingMonths:sort];
                monthShowModel._monthModel = [allMonthModelDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)sort]];
                return monthShowModel;
            }
            
        }
    }
    else if (showType == ShowTypeFromUserUseDay)
    {
        if (sort > 100)
        {
            
            [UIView showAlertView:@"用户模式下，最多一100个周" andMessage:nil];
            return nil;
        }
        
        if (isShowWeekSort)
        {
            NSDate *tempYearDate = [[ShowManage thisYearFirstDayWithShowType:showType WithYearDate:yearDate] dateByAddingWeeks:sort];
            
            NSDictionary *allWeekModelDictionary = [YearModel getThisYearAllWeekModelWithDate:tempYearDate];
            if (!allWeekModelDictionary || allWeekModelDictionary.count == 0)
            {
                if (returnNil)
                {
                    return nil;
                }
                else
                {
                    ShowModel *onlySortShowModel = [[ShowModel alloc] init];
                    onlySortShowModel._showSort = sort;
                    onlySortShowModel._thisWeekOrMonthFirstDate = tempYearDate;
                    return onlySortShowModel;
                }
            }
            else
            {
                ShowModel *weekShowModel = [[ShowModel alloc] init];
                weekShowModel._showSort = sort;
                weekShowModel._thisWeekOrMonthFirstDate = tempYearDate;
                weekShowModel._weekModel = [YearModel getTheWeekModelWithDate:tempYearDate];
                return weekShowModel;
            }
            
        }
        else
        {
            NSDate *tempYearDate = [[ShowManage thisYearFirstDayWithShowType:showType WithYearDate:yearDate] dateByAddingMonths:sort];
            
            NSDictionary *allMonthModelDictionary = [YearModel getThisYearAllMonthModelWithDate:tempYearDate];
            if (!allMonthModelDictionary || allMonthModelDictionary.count == 0)
            {
                if (returnNil)
                {
                    return nil;
                }
                else
                {
                    ShowModel *onlySortShowModel = [[ShowModel alloc] init];
                    onlySortShowModel._showSort = sort;
                    onlySortShowModel._thisWeekOrMonthFirstDate = tempYearDate;
                    return onlySortShowModel;
                }
            }
            else
            {
                ShowModel *monthShowModel = [[ShowModel alloc] init];
                monthShowModel._showSort = sort;
                monthShowModel._thisWeekOrMonthFirstDate = tempYearDate;
                monthShowModel._monthModel = [allMonthModelDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)sort]];
                return monthShowModel;
            }
            
        }
    }
    return nil;
}


//
/**
 *  获取这一年的第一天，根据显示模式及年份
 *
 *  @param showType       显示类型
 *  @param yearDate       年，如2014-01-06，表示为2014年，如果为ShowTypeFromUserUseDay，不用设置或者设置为Nil
 *
 *  @return 返回这一年的第一天
 */
+ (NSDate *) thisYearFirstDayWithShowType: (ShowType) showType
                             WithYearDate: (NSDate *) yearDate

{
    if (showType == ShowTypeDefault)
    {
        NSInteger yearNumber = yearDate.year;
        NSString *dateString = [NSString stringWithFormat:@"%ld-01-01", (long)yearNumber];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *oneDate = [dateFormatter dateFromString:dateString];
        return oneDate;
    }
    
    else  if (showType == ShowTypeFromUserUseDay)
    {
        NSDate *userUseDay = [[ObjectCTools shared] objectForKey:kUserUseFirstDateKey];
        if (!userUseDay)
        {
            [UIView showAlertView:@"在用户模式下必须设置用户第一天使用的时间" andMessage:@"请能过setUserUseFirstDate:方法设置起点日期"];
            return nil;
        }
        return userUseDay;
    }
    return nil;
}

/*
 *  @return 正常情况下返回这一年的最后一天
 */
+ (NSDate *) thisYearLastDayWithYearDate: (NSDate *) yearDate

{
    NSInteger yearNumber = yearDate.year;
    NSString *dateString = [NSString stringWithFormat:@"%ld-01-01", (long)yearNumber];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-12-31"];
    
    NSDate *oneDate = [dateFormatter dateFromString:dateString];
    return oneDate;
}

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
                                       withTheDate: (NSDate *) theDate
{
    if (showType == ShowTypeDefault)
    {
        if (isShowWeekSort)
        {
            return theDate.weekOfYear;
        }
        else
        {
            return theDate.weekOfMonth;
        }
    }
    else
    {
        NSDate *userUserDay = [ShowManage thisYearFirstDayWithShowType:ShowTypeFromUserUseDay WithYearDate:nil];
        if (isShowWeekSort)
        {
            return [theDate weeksFrom:userUserDay];
        }
        else
        {
            return [theDate monthsFrom:userUserDay];
        }
    }
}

@end
