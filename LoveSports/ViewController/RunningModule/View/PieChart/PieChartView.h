//
//  PieChartView.h
//  PieChartViewDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PieChartViewDelegate;
@protocol PieChartViewDataSource;

@interface PieChartView : UIView 

@property (nonatomic, assign) id <PieChartViewDataSource> datasource;
@property (nonatomic, assign) id <PieChartViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *signView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *targetLabel;
@property (nonatomic, strong) UILabel *durationLabel;

-(void)reloadData;

@end

@protocol PieChartViewDelegate <NSObject>

- (CGFloat)centerCircleRadius;

@end

@protocol PieChartViewDataSource <NSObject>

@required
- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView;
- (double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index;
- (UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index;

@optional
- (NSString*)pieChartView:(PieChartView *)pieChartView titleForSliceAtIndex:(NSUInteger)index;

@end
