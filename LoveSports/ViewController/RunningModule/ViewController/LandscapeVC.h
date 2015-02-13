//
//  LandscapeVC.h
//  LoveSports
//
//  Created by zorro on 15-2-3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ZKKViewController.h"
#import "TrendShowType.h"

@interface LandscapeVC : ZKKViewController

@property (nonatomic, strong) NSDate *dayDate;
@property (nonatomic, assign) TrendChartShowType showType;

- (instancetype)initWithDate:(NSDate *)date
                withWeekDate:(NSDate *)weekDate
              withMonthIndex:(NSInteger)index
                withShowtype:(TrendChartShowType)showtype;
@end
