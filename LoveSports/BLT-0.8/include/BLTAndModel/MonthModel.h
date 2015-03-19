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

@property (nonatomic, assign) NSInteger _monthNumber;          //第几月
@property (nonatomic, assign) NSInteger _yearNumber;           //年，如2014
@property (nonatomic, assign) NSInteger _monthTotalSteps;      // 当月的总步数
@property (nonatomic, assign) NSInteger _monthTotalCalories;   // 当月的总卡路里
@property (nonatomic, assign) NSInteger _monthTotalDistance ;  // 当月的总路程
@property (nonatomic, strong) NSMutableDictionary *_allSubPedModelArray;
@property (nonatomic, strong) NSString *showDate;

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
- (void) updateInfo;

@end
