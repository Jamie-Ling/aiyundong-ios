//
//  TrendShowType.h
//  LoveSports
//
//  Created by zorro on 15/2/13.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

typedef enum {
    TrendChartViewShowDaySteps = 0,
    TrendChartViewShowDayCalories = 1,
    TrendChartViewShowDayDistance = 2,
    TrendChartViewShowWeekSteps = 3,
    TrendChartViewShowWeekCalories = 4,
    TrendChartViewShowWeekDistance = 5,
    TrendChartViewShowMonthSteps = 6,
    TrendChartViewShowMonthCalories = 7,
    TrendChartViewShowMonthDistance = 8
} TrendChartShowType;

#import <UIKit/UIKit.h>
#import "PedometerModel.h"
#import "YearModel.h"

@interface TrendShowType : UIView

+ (TrendChartShowType)showWithIndex:(NSInteger)index withButton:(UIButton *)button;
+ (NSArray *)getShowDataArrayWithDayDate:(NSDate *)date withShowType:(TrendChartShowType)showType;
+ (NSArray *)getShowDataArrayWithWeekDate:(NSDate *)date withShowType:(TrendChartShowType)showType;
+ (NSArray *)getShowDataArrayWithMonthIndex:(NSInteger)index withShowType:(TrendChartShowType)showType;

@end
