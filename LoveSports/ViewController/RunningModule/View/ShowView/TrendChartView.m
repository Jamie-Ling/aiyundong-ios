//
//  TrendChartView.m
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendChartView.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "ShowWareView.h"
#import "CalendarHomeView.h"
#import "PedometerModel.h"
#import "CalendarHelper.h"

@interface TrendChartView ()

@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UISegmentedControl *segement;
@property (nonatomic, assign) NSInteger segIndex;

@property (nonatomic, strong) CalendarHomeView *calenderView;
@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger percent;

@end

@implementation TrendChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        // self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        
        _showType = TrendChartViewShowDaySteps;
        
        _dayDate = [NSDate date];
        _weekDate = [NSDate date];
        _monthIndex = [NSDate date].month;
        
        [self loadCalendarButton];
        [self loadSegmentedControl];
        [self loadLandscapeButton];
        [self loadLineChart];
        [self loadChartStyleButtons];
    }
    
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _dayDate = currentDate;
    _weekDate = currentDate;
    _monthIndex = [YearModel monthOfYearWithDate:currentDate];
    
    [self updateContentForChartViewWithDirection:0];
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(15, 70, 45, 35)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(TrendChartView);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        weakSelf.currentDate = [model date];
    };
    
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
    }];
}

- (void)loadSegmentedControl
{
    _segement = [[UISegmentedControl alloc] initWithItems:@[@"日", @"周", @"月"]];
    _segement.frame = CGRectMake((self.width - 200) / 2, 30, 200, 40);
    
    _segement.backgroundColor = [UIColor clearColor];
    _segement.tintColor = [UIColor clearColor];
    //[_segement setBackgroundImage:[UIImage image:@"日@2x.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segement setImage:[UIImage image:@"日选中@2x.png"] forSegmentAtIndex:0];
    [_segement setImage:[UIImage image:@"周@2x.png"] forSegmentAtIndex:1];
    [_segement setImage:[UIImage image:@"月@2x.png"] forSegmentAtIndex:2];
    [_segement addTarget:self action:@selector(clickSegementControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segement];
    _segIndex = 0;
}

// 日月周趋势切换
- (void)clickSegementControl:(UISegmentedControl *)seg
{
    NSArray *images = @[@"日@2x.png", @"周@2x.png", @"月@2x.png"];
    NSArray *selectImages = @[@"日选中@2x.png", @"周选中@2x.png", @"月选中@2x.png"];
    
    [_segement setImage:[UIImage image:images[_segIndex]]
      forSegmentAtIndex:_segIndex];
    [_segement setImage:[UIImage image:selectImages[_segement.selectedSegmentIndex]]
      forSegmentAtIndex:_segement.selectedSegmentIndex];
    _segIndex = _segement.selectedSegmentIndex;
    
    [self reloadTrendChartView];
}

- (void)loadLandscapeButton
{
    UIButton *landscapeButton = [UIButton simpleWithRect:CGRectMake(self.width - 60, 70, 45, 35)
                                               withImage:@"竖屏@2x.png"
                                         withSelectImage:@"竖屏@2x.png"];
    
    [landscapeButton addTarget:self action:@selector(landscapeViewData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:landscapeButton];
}

- (void)landscapeViewData
{
    if ([_delegate respondsToSelector:@selector(trendChartViewLandscape:)])
    {
        [_delegate trendChartViewLandscape:self];
    }
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 50, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_dateLabel];
}

-(void)loadLineChart
{
    // Generating some dummy data
 
    CGRect rect = CGRectMake((self.width - self.width * 0.9) / 2, 120, self.width * 0.9, 200);
    _lineChart = [[FSLineChart alloc] initWithFrame:rect];
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = LS_TrendChartShowCount; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@""];
    };
    [self addSubview:_lineChart];
    
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
- (void)updateContentForChartViewWithDirection:(NSInteger)direction
{
    if (_showType < 3)
    {
        if (direction == 1 && [_dayDate isSameWithDate:[NSDate date]])
        {
            return;
        }
        
        [self refreshTrendChartViewWithDayDate:[_dayDate dateAfterDay:((int)direction * 8)]];
    }
    else if (_showType < 6)
    {
        if (direction == 1 && [_weekDate isSameWithDate:[NSDate date]])
        {
            return;
        }
        
        [self refreshTrendChartViewWithWeekDate:[_weekDate dateAfterDay:((int)direction * 49)]];
    }
    else
    {
        if (direction == 1 && _monthIndex == [NSDate date].month)
        {
            return;
        }
        
        [self refreshTrendChartViewWithMonthIndex:_monthIndex + ((int)direction * 8)];
    }
}

// 步数，卡路里，距离切换.
- (void)loadChartStyleButtons
{
    CGFloat offsetX = ((self.width - 60) - 90 * 3) / 2;
    NSArray *images = @[@"足迹@2x.png", @"能量@2x.png", @"路程@2x.png"];
    NSArray *selectImages = @[@"足迹-选中@2x.png", @"能量选中@2x.png", @"路程选中@2x.png"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIButton *button = [UIButton simpleWithRect:CGRectMake(30 + (90 + offsetX) * i , 340, 90, 89)
                                          withImage:images[i]
                                    withSelectImage:selectImages[i]];
        
        button.tag = 2000 + i;
        [button addTarget:self action:@selector(clcikChartStyleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0)
        {
            button.selected = YES;
            _lastButton = button;
        }
    }
}

- (void)clcikChartStyleButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    [self reloadTrendChartView];
}

// 点击6个按钮后图表进行切换。
- (void)reloadTrendChartView
{
    _showType = [TrendShowType showWithIndex:_segIndex withButton:_lastButton];
    
    if (_showType < 3)
    {
        [self refreshTrendChartViewWithDayDate:_dayDate];
    }
    else if (_showType < 6)
    {
        [self refreshTrendChartViewWithWeekDate:_weekDate];
    }
    else
    {
        [self refreshTrendChartViewWithMonthIndex:_monthIndex];
    }
}

- (void)loadShareButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(self.width - 45, self.height - 99, 90/2.0, 70/2.0)
                                              withImage:@"分享@2x.png"
                                        withSelectImage:@"分享@2x.png"];
    
    [self addSubview:calendarButton];
}

@end
