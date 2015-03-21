//
//  TrendDetailView.h
//  LoveSports
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLineChart.h"
#import "TrendShowType.h"

@interface TrendDetailView : UIView

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) NSDate *dayDate;
@property (nonatomic, strong) NSDate *weekDate;
@property (nonatomic, assign) NSInteger monthIndex;

@property (nonatomic, assign) TrendChartShowType showType;
@property (nonatomic, strong) UIViewSimpleBlock yearBlock;

- (NSInteger)updateContentForChartViewWithDirection:(NSInteger)direction;
- (NSInteger)reloadTrendChartViewWith:(TrendChartShowType)type;
// 检查当前视图的日期是否是今天。
- (BOOL)checkCurrentDateOfDetailViewIsToday;

@end
