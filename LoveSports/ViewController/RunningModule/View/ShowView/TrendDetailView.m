//
//  TrendDetailView.m
//  LoveSports
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendDetailView.h"

@interface TrendDetailView ()

@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation TrendDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        // self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        
        _showType = TrendChartViewShowDaySteps;
        
        _dayDate = [NSDate date];
        _weekDate = [NSDate date];
        _monthIndex = [NSDate date].month;
        
        [self loadBaseView];
    }
    
    return self;
}

- (void)setDayDate:(NSDate *)currentDate
{
    _dayDate = currentDate;
    // _weekDate = currentDate;
    // _monthIndex = [YearModel monthOfYearWithDate:currentDate];
    [self updateContentForChartViewWithDirection:0];
}

- (void)setWeekDate:(NSDate *)weekDate
{
    _weekDate = weekDate;
    [self updateContentForChartViewWithDirection:0];
}

- (void)setMonthIndex:(NSInteger)monthIndex
{
    _monthIndex = monthIndex;
    [self updateContentForChartViewWithDirection:0];
}

- (void)loadBaseView
{
    _baseView = [[UIView alloc] initWithFrame:self.bounds];
    _baseView.backgroundColor = [UIColor clearColor];
    [self addSubview:_baseView];
    
    [self loadLineChart];
}

-(void)loadLineChart
{
    // Generating some dummy data
    
    _lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(self.width * 0.05, 0, self.width * 0.9, self.height)];
    _lineChart.showType = FSLineChartShowDateStepsType;
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = (int)[DataShare sharedInstance].showCount; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@""];
    };
    _lineChart.hiddenBlock = ^(NSInteger index) {
        return NO;
    };
    [_baseView addSubview:_lineChart];

    [self refreshTrendChartViewWithDayDate:_dayDate];
}

// 日刷新
- (void)refreshTrendChartViewWithDayDate:(NSDate *)date
{
    _dayDate = date;
    NSArray *array = [TrendShowType getShowDataArrayWithDayDate:_dayDate withShowType:_showType];
    
    [self refreshTrendChartViewWithChartData:array[0] withTitle:array[1]];
}

// 周刷新
- (void)refreshTrendChartViewWithWeekDate:(NSDate *)date
{
    _weekDate = date;
    NSArray *array = [TrendShowType getShowDataArrayWithWeekDate:_weekDate withShowType:_showType];
    
    [self refreshTrendChartViewWithChartData:array[0] withTitle:array[1]];
}

// 月刷新
- (void)refreshTrendChartViewWithMonthIndex:(NSInteger)index
{
    _monthIndex = index;
    NSArray *array = [TrendShowType getShowDataArrayWithMonthIndex:_monthIndex withShowType:_showType];
    
    [self refreshTrendChartViewWithChartData:array[0] withTitle:array[1]];
}

// 传入数据刷新
- (void)refreshTrendChartViewWithChartData:(NSArray *)ChartData withTitle:(NSArray *)titlesArray
{
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return titlesArray[item];
    };
    [_lineChart setChartData:ChartData];
}

// 左右滑动进行数据变换。
- (NSInteger)updateContentForChartViewWithDirection:(NSInteger)direction
{
    NSInteger currentYear = LS_Baseyear;
    if (_showType < 3)
    {
        [self refreshTrendChartViewWithDayDate:[_dayDate dateAfterDay:((int)direction * (int)[DataShare sharedInstance].showCount)]];
        currentYear = _dayDate.year;
    }
    else if (_showType < 6)
    {
        [self refreshTrendChartViewWithWeekDate:[_weekDate dateAfterDay:((int)direction * 7 * (int)[DataShare sharedInstance].showCount)]];
        currentYear = _weekDate.year;
    }
    else
    {
        [self refreshTrendChartViewWithMonthIndex:_monthIndex + ((int)direction * [DataShare sharedInstance].showCount)];
        currentYear = [YearModel getYearWithMonthIndex:_monthIndex];
    }
    
    return currentYear;
}

// 点击6个按钮后图表进行切换。
- (NSInteger)reloadTrendChartViewWith:(TrendChartShowType)type
{
    //_showType = [TrendShowType showWithIndex:_segIndex withButton:_lastButton];
    _showType = type;
    _lineChart.showType = _showType + 1;

    NSInteger currentYear = LS_Baseyear;
    if (type < 3)
    {
        [self refreshTrendChartViewWithDayDate:_dayDate];
        currentYear = _dayDate.year;
    }
    else if (type < 6)
    {
        [self refreshTrendChartViewWithWeekDate:_weekDate];
        currentYear = _weekDate.year;
    }
    else
    {
        [self refreshTrendChartViewWithMonthIndex:_monthIndex];
        currentYear = [YearModel getYearWithMonthIndex:_monthIndex];
    }
    
    return currentYear;
}

- (BOOL)checkCurrentDateOfDetailViewIsToday
{
    if (_showType < 3)
    {
        NSDate *date = self.dayDate;
        if ([date isSameWithDate:[NSDate date]])
        {
            return YES;
        }
    }
    else if (_showType < 6)
    {
        NSDate *weekDate = self.weekDate;
        if ([weekDate isSameWithDate:[NSDate date]])
        {
            return YES;
        }
    }
    else
    {
        NSInteger currentIndex = [YearModel monthOfYearWithDate:[NSDate date]];
        NSInteger monthIndex = self.monthIndex;
        if (currentIndex == monthIndex)
        {
            return YES;
        }
    }
    
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
