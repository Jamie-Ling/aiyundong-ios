//
//  TrendChartView.h
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TrendChartViewDelegate;

@interface TrendChartView : UIView

@property (nonatomic, assign) id <TrendChartViewDelegate> delegate;

@end

@protocol TrendChartViewDelegate <NSObject>

- (void)trendChartViewLandscape:(TrendChartView *)trendView;

@end
