//
//  TrendShowType.m
//  LoveSports
//
//  Created by zorro on 15/2/13.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendShowType.h"

@implementation TrendShowType

+ (TrendChartShowType)showWithIndex:(NSInteger)index withButton:(UIButton *)button
{
    TrendChartShowType type = TrendChartViewShowDaySteps;
    NSInteger tag = button.tag;
    if (index == 0)
    {
        if (tag == 2000)
        {
            type = TrendChartViewShowDaySteps;
        }
        else if (tag == 2001)
        {
            type = TrendChartViewShowDayCalories;
        }
        else if (tag == 2002)
        {
            type = TrendChartViewShowDayDistance;
        }
    }
    else if (index == 1)
    {
        if (tag == 2000)
        {
            type = TrendChartViewShowWeekSteps;
        }
        else if (tag == 2001)
        {
            type = TrendChartViewShowWeekCalories;
        }
        else if (tag == 2002)
        {
            type = TrendChartViewShowWeekDistance;
        }
    }
    else if (index == 2)
    {
        if (tag == 2000)
        {
            type = TrendChartViewShowMonthSteps;
        }
        else if (tag == 2001)
        {
            type = TrendChartViewShowMonthCalories;
        }
        else if (tag == 2002)
        {
            type = TrendChartViewShowMonthDistance;
        }
    }
    
    return type;
}

+ (NSArray *)getShowDataArrayWithDayDate:(NSDate *)date withShowType:(TrendChartShowType)showType
{
    NSArray *array = [PedometerHelper getEveryDayTrendDataWithDate:date];
    NSMutableArray *chartDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < array.count; i++)
    {
        PedometerModel *model = array[i];
        if (showType == TrendChartViewShowDaySteps)
        {
            chartDataArray[i] = @(model.totalSteps);
        }
        else if (showType == TrendChartViewShowDayCalories)
        {
            chartDataArray[i] = @(model.totalCalories);
        }
        else
        {
            chartDataArray[i] = @(model.totalDistance);
        }
        
        daysArray[i] = [model.dateString substringFromIndex:5];
    }
    
    return @[chartDataArray, daysArray];
}

+ (NSArray *)getShowDataArrayWithWeekDate:(NSDate *)date withShowType:(TrendChartShowType)showType
{
    NSArray *array = [YearModel getWeekModelArrayWithDate:date withReturnModel:YES];
    NSMutableArray *chartDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < array.count; i++)
    {
        WeekModel *model = array[i];
        if (showType == TrendChartViewShowWeekSteps)
        {
            chartDataArray[i] = @(model._weekTotalSteps);
        }
        else if (showType == TrendChartViewShowWeekCalories)
        {
            chartDataArray[i] = @(model._weekTotalCalories);
        }
        else
        {
            chartDataArray[i] = @(model._weekTotalDistance);
        }
        
        daysArray[i] = model.showDate;
    }
    
    return @[chartDataArray, daysArray];
}

+ (NSArray *)getShowDataArrayWithMonthIndex:(NSInteger)index withShowType:(TrendChartShowType)showType
{
    NSArray *array = [YearModel getMonthModelArrayWithIndex:index withReturnModel:YES];
    NSMutableArray *chartDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < array.count; i++)
    {
        MonthModel *model = array[i];
        if (showType == TrendChartViewShowMonthSteps)
        {
            chartDataArray[i] = @(model._monthTotalSteps);
        }
        else if (showType == TrendChartViewShowMonthCalories)
        {
            chartDataArray[i] = @(model._monthTotalCalories);
        }
        else
        {
            chartDataArray[i] = @(model._monthTotalDistance);
        }
        
        daysArray[i] = model.showDate;
    }
    
    return @[chartDataArray, daysArray];
}

@end
