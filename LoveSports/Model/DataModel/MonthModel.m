//
//  monthModel.m
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "MonthModel.h"

@implementation MonthModel

@synthesize _allSubPedModelArray, _monthNumber, _monthTotalCalories, _monthTotalDistance, _monthTotalSteps, _yearNumber;

/**
 *  初始化一个月模型
 *
 *  @param monthNumber 这个星期是那一年的第几月
 *  @param andYearNumber 表示是哪一年
 *
 *  @return 月模型
 */
- (instancetype)initWithmonthNumber:(NSInteger ) monthNumber
                     andYearNumber: (NSInteger ) yearNumber
{
    self = [super init];
    if (self) {
        _allSubPedModelArray = [[NSMutableDictionary alloc] init];
        _monthNumber = monthNumber;
        _yearNumber = yearNumber;
    }
    return self;
}

/**
 *  更新汇总信息
 */
- (void) updateInfo
{
    _monthTotalCalories = 0;
    _monthTotalDistance = 0;
    _monthTotalSteps = 0;
    
    if (self._allSubPedModelArray.count == 0)
    {
        return;
    }
    for (SubOfPedometerModel *tempSubPedModel in self._allSubPedModelArray)
    {
        _monthTotalCalories += tempSubPedModel._thisDayTotalCalories;
        _monthTotalDistance += tempSubPedModel._thisDayTotalDistance;
        _monthTotalSteps += tempSubPedModel._thisDayTotalSteps;
    }
}

@end
