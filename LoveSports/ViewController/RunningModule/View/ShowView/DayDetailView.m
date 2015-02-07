//
//  DayDetailView.m
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DayDetailView.h"
#import "PieChartView.h"
#import "CalendarHomeView.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "ShowWareView.h"
#import "NSObject+Property.h"

@interface DayDetailView () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic) CalendarHomeView *calenderView;
@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, assign) NSInteger percent;

@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation DayDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        NSLog(@".height..%f", self.height);
        _offsetY = (self.height < 485) ? 20.0 : 0.0;
        _percent = 25;
        
        [self loadPieChartView];
        [self loadCalendarButton];
        [self loadDateLabel];
        [self loadChartStyleButtons];
        [self loadLineChart];
        // [self loadShareButton];
    }
    
    return self;
}

- (void)loadPieChartView
{
    CGRect rect = CGRectMake((self.width - 200) / 2, 60 - _offsetY * 0.5, 200 - _offsetY, 200 - _offsetY);
    _chartView = [[PieChartView alloc] initWithFrame:rect];
    _chartView.delegate = self;
    _chartView.datasource = self;
    [self addSubview:_chartView];
    [_chartView daySetting];
    [_chartView reloadData];
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(0, 0, 90, 70)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
}

- (void)clickCalendarButton
{
    if (!_calenderView)
    {
        _calenderView = [[CalendarHomeView alloc] initWithFrame:CGRectMake(2, self.height * 0.15, self.width - 4.0, self.height * 0.8)];
    }
    
    [_calenderView setLoveSportsToDay:365 ToDateforString:nil];
    DEF_WEAKSELF_(DayDetailView);
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
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 0, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_dateLabel];
}

- (void)loadChartStyleButtons
{
    CGFloat offsetX = ((self.width - 60) - 90 * 3) / 2;
    NSArray *images = @[@"足迹@2x.png", @"能量@2x.png", @"路程@2x.png"];
    NSArray *selectImages = @[@"足迹-选中@2x.png", @"能量选中@2x.png", @"路程选中@2x.png"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIButton *button = [UIButton simpleWithRect:CGRectMake(30 + (90 + offsetX) * i , _chartView.totalHeight - 15, 90, 89)
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
    
    if (button.tag == 2000)
    {
        
    }
    else if (button.tag == 2001)
    {
    }
    else if (button.tag == 2002)
    {
        
    }
}

-(void)loadLineChart
{
    // Generating some dummy data
    NSMutableArray *chartData = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0; i < 7; i++)
    {
        chartData[i] = [NSNumber numberWithFloat: (arc4random() % 10 + 1) * 0.1];
    }
    
    NSArray *days = @[@"10/10", @"10/11", @"10/12", @"10/13", @"10/14", @"10/15", @"10/16"];
    
    CGFloat offsetY = _chartView.totalHeight + 70;
    CGRect rect = CGRectMake((self.width - self.width * 0.9) / 2, offsetY, self.width * 0.9, self.height - offsetY - 85);
    _lineChart = [[FSLineChart alloc] initWithFrame:rect];
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = (int)days.count; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return days[item];
    };
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@""];
    };
    [_lineChart setChartData:chartData];
    
    [self addSubview:_lineChart];
}

- (void)loadShareButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(self.width - 45, self.height - 99, 90/2.0, 70/2.0)
                                              withImage:@"分享@2x.png"
                                        withSelectImage:@"分享@2x.png"];
    
    [self addSubview:calendarButton];
}

#pragma mark --- PieChartViewDelegate ---
-(CGFloat)centerCircleRadius
{
    return 81 - _offsetY * 0.5;
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

- (void)updateContentForView:(PedometerModel *)model
{
    _model = model;
    
    [_chartView updateContentForViewWithModel:model];
    _dateLabel.text = [model.dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSDate *date =  [NSDate stringToDate:[NSString stringWithFormat:@"%@ 06:00:00", model.dateString]];
    NSString *weekString = [NSObject numberTransferWeek:date.weekday];
    _weekLabel.text = weekString;
}

@end
