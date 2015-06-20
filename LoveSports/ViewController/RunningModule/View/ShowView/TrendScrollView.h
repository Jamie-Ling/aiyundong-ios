//
//  TrendScrollView.h
//  LoveSports
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnlimitScroll.h"
#import "TrendDetailView.h"

@interface TrendScrollView : UIView

@property (nonatomic, strong) UnlimitScroll *scrollView;
@property (nonatomic, strong) NSMutableArray *viewsArray;

@property (nonatomic, strong) UIViewSimpleBlock yearBlock;
@property (nonatomic, assign) TrendChartShowType showType;

// 点击按钮后图标进行刷新
- (void)reloadTrendChartViewWith:(TrendChartShowType)type;
- (void)updateContentWithDate:(NSDate *)date;
// 取得中间趋势图是周几.
- (NSInteger)getCurrentWeekForMiddleThrendView;
// 取得中间趋势图是哪一年.
- (NSInteger)getCurrentYearForMiddleThrendView;

@end
