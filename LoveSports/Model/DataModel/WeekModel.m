//
//  WeekModel.m
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "WeekModel.h"

@implementation SubOfPedometerModel

@synthesize _thisDayTotalCalories, _thisDayTotalDistance, _thisDayTotalSteps;

/**
 *  更新此子模型的信息通过传入的pedometerModel模型
 *
 *  @param onePedometerModel 传入的pedometerModel模型
 */
- (void) updateInfoFromAPedometerModel: (PedometerModel *) onePedometerModel
{
    _thisDayTotalSteps = onePedometerModel.totalSteps;
    _thisDayTotalDistance = onePedometerModel.totalDistance;
    _thisDayTotalCalories = onePedometerModel.totalCalories;
}

@end

@implementation WeekModel

@synthesize _weekNumber, _weekTotalCalories, _weekTotalSteps, _weekTotalDistance, _yearNumber, _allSubPedModelArray;

/**
 *  初始化一个星期模型
 *
 *  @param weekNumber 这个星期是那一年的第几周
 *  @param andYearNumber 表示是哪一年
 *
 *  @return 星期模型
 */
- (instancetype)initWithWeekNumber:(NSInteger ) weekNumber
                     andYearNumber: (NSInteger ) yearNumber
{
    self = [super init];
    if (self) {
        _allSubPedModelArray = [[NSMutableDictionary alloc] init];
        _weekNumber = weekNumber;
        _yearNumber = yearNumber;
    }
    return self;
}


/**
 *  更新汇总信息
 */
- (void) updateInfo
{
    _weekTotalCalories = 0;
    _weekTotalDistance = 0;
    _weekTotalSteps = 0;
    
    if (self._allSubPedModelArray.count == 0)
    {
        return;
    }
    for (SubOfPedometerModel *tempSubPedModel in self._allSubPedModelArray)
    {
        _weekTotalCalories += tempSubPedModel._thisDayTotalCalories;
        _weekTotalDistance += tempSubPedModel._thisDayTotalDistance;
        _weekTotalSteps += tempSubPedModel._thisDayTotalSteps;
    }
}

@end
