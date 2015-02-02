//
//  RunningVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 测试。。。
#import "RunningVC.h"
#import "PieChartView.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "ShowWareView.h"
#import "CalendarHomeView.h"

@interface RunningVC () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic) CalendarHomeView *calenderView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger percent;

@end

@implementation RunningVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(testChart) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)testChart
{
    _percent ++;
    if (_percent > 100)
    {
        _percent = 0;
    }
    
    if (_chartView)
    {
        [_chartView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
    
    _percent = 25;
    
    [self loadCalendarButton];
    [self loadDateLabel];
    [self loadShareButton];
    [self loadLineChart];
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(0, 15, 90, 70)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calendarButton];
}

- (void)clickCalendarButton
{
    if (!_calenderView)
    {
        _calenderView = [[CalendarHomeView alloc] initWithFrame:CGRectMake(2, self.view.height * 0.15, self.view.width - 4.0, self.view.height * 0.8)];
    }
    
    [_calenderView setLoveSportsToDay:365 ToDateforString:nil];
    DEF_WEAKSELF_(RunningVC);
    _calenderView.calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);
        if (model.holiday)
        {
        }
        else
        {
        }
    };
    
    [_calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
    }];
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.view.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor whiteColor]];
    [self.view addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 50, self.view.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor whiteColor]];
    [self.view addSubview:_dateLabel];
}

-(void)loadLineChart
{
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i = 0;i < 7;i ++)
    {
        chartData[i] = [NSNumber numberWithFloat: (float)i / 30.0f + (float)(rand() % 100) / 500.0f];
    }
    
    NSArray* months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July"];
    
    // Creating the line chart
    CGRect rect = CGRectMake((self.view.width - self.view.width * 0.9) / 2, self.view.height * 0.60, self.view.width * 0.9, self.view.height * 0.25);
    _lineChart = [[FSLineChart alloc] initWithFrame:rect];
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = 3; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return months[item];
    };
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.02f €", value];
    };
    [_lineChart setChartData:chartData];
    
    [self.view addSubview:_lineChart];
}

- (void)loadShareButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(self.view.width - 45, self.view.height - 99, 90/2.0, 70/2.0)
                                              withImage:@"分享@2x.png"
                                        withSelectImage:@"分享@2x.png"];
    
    [self.view addSubview:calendarButton];
}

#pragma mark --- PieChartViewDelegate ---
-(CGFloat)centerCircleRadius
{
    return 90;
}

#pragma mark --- PieChartViewDataSource ---
- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 180;
}

- (UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    if (index % 2)
    {
        if (index <= 180 * (_percent * 0.01))
        {
            return [UIColor yellowColor];
        }
        else
        {
            return [UIColor lightGrayColor];
        }
    }
    else
    {
        return [UIColor clearColor];
    }
}

- (double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    return 100 / 10;
}

@end
