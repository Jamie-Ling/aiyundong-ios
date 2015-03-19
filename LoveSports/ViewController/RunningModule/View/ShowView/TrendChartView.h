//
//  TrendChartView.h
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendShowType.h"
#import "TrendScrollView.h"

@protocol TrendChartViewDelegate;

@interface TrendChartView : UIView

@property (nonatomic, assign) id <TrendChartViewDelegate> delegate;
@property (nonatomic, strong) NSDate *dayDate;
@property (nonatomic, strong) NSDate *weekDate;
@property (nonatomic, assign) NSInteger monthIndex;

@property (nonatomic, assign) TrendChartShowType showType;
@property (nonatomic, strong) TrendScrollView *scrollView;

@property (nonatomic, strong) UILabel *yearLabel;

- (void)updateContentForChartViewWithDirection:(NSInteger)direction;

@end

@protocol TrendChartViewDelegate <NSObject>

- (void)trendChartViewLandscape:(TrendChartView *)trendView;

@end
