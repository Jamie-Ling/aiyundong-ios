//
//  PieChartView.h
//  PieChartViewDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#define LS_PieChartCount 720

#import <UIKit/UIKit.h>
#import "PedometerModel.h"

typedef enum {
    PieChartViewShowSteps = 0,
    PieChartViewShowCalories = 1,
    PieChartViewShowDistance = 2,
    PieChartViewShowSleep = 3
} PieChartViewShowState;

@protocol PieChartViewDelegate;
@protocol PieChartViewDataSource;

@interface PieChartView : UIView 
typedef void(^PieChartViewReload)(CGFloat percent);

@property (nonatomic, assign) id <PieChartViewDataSource> datasource;
@property (nonatomic, assign) id <PieChartViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *signView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *targetLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) PieChartViewReload reloadBlock;

@property (nonatomic, strong) UIImageView *clockImage;

@property (nonatomic, strong) NSArray *sleepsArray;
@property (nonatomic, assign) NSInteger pieCount;

@property (nonatomic, assign) CGFloat lineWidth;

-(id)initWithFrame:(CGRect)frame withPieCount:(NSInteger)pieCount withStartAngle:(CGFloat)startAngle;

- (void)reloadData;
- (void)nightSetting;
- (void)daySetting;
- (void)updateContentForViewWithModel:(PedometerModel *)model
                            withState:(PieChartViewShowState)state withReloadBlock:(PieChartViewReload)block;

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
