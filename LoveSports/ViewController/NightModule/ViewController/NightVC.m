//
//  NightVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NightVC.h"
#import "PieChartView.h"
#import "CalendarHomeView.h"
#import "BarGraphView.h"
#import "BarShowView.h"
#import "UIColor+RGB.h"

@interface NightVC () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) BarGraphView *barView;;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BarShowView *showView;
@property (nonatomic, strong) PedometerModel *model;

@property (nonatomic) CalendarHomeView *calenderView;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSArray *chartDataArray;

@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation NightVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
    
    NSLog(@"..%f..%f",self.view.totalHeight, self.view.height);
    _offsetY = (self.view.height < 485.0) ? 25.0 : 0.0;
    _percent = 25;
    
    _currentDate = [NSDate date];
    
    [self loadPieChartView];
    [self loadCalendarButton];
    [self loadDateLabel];
    [self loadScrollView];
    [self loadShareButton];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    [self updateContentForBarShowViewWithDate:_currentDate];
}

- (void)loadPieChartView
{
    CGRect rect = CGRectMake((self.view.width - 200) / 2, 85 - _offsetY * 1.2, 200, 200);
    _chartView = [[PieChartView alloc] initWithFrame:rect];
    _chartView.delegate = self;
    _chartView.datasource = self;
    [self.view addSubview:_chartView];
    [_chartView nightSetting];
    [_chartView reloadData];
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(0, 15 - _offsetY, 90, 70)
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
    DEF_WEAKSELF_(NightVC);
    _calenderView.calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        weakSelf.currentDate = [model date];
    };
    
    [_calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [_calenderView removeFromSuperview];
        _calenderView = nil;
    }];
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 25 - _offsetY, self.view.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor whiteColor]];
    [self.view addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 50 - _offsetY, self.view.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor whiteColor]];
    [self.view addSubview:_dateLabel];
}

- (void)loadScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300 - _offsetY * 1.5, self.view.width, 160 - _offsetY)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    NSInteger width = ((int)(_scrollView.width * (5 + 1 / 16.0) / 49)) * 49;
    _showView = [[BarShowView alloc] initWithFrame:CGRectMake(0, 0, width, _scrollView.height)];
    [_scrollView addSubview:_showView];
    _scrollView.contentSize = _showView.frame.size;
    
    [self updateContentForBarShowViewWithDate:_currentDate];
}

- (void)updateContentForBarShowViewWithDate:(NSDate *)date
{
    _currentDate = date;
    PedometerModel *model = [PedometerModel getModelFromDBWithDate:_currentDate];
    
    [self updateContentForLabel:model];
    _chartDataArray = model.detailSleeps;
    [_chartView reloadData];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (model.detailSleeps && model.detailSleeps.count > 0)
    {
        for (int i = 0; i < model.detailSleeps.count - 5; i += 6)
        {
            NSInteger number = [model.detailSleeps[i] intValue]     + [model.detailSleeps[i + 1] intValue] +
                               [model.detailSleeps[i + 2] intValue] + [model.detailSleeps[i + 3] intValue] +
                               [model.detailSleeps[i + 4] intValue] + [model.detailSleeps[i + 5] intValue];
            [array addObject:@(18 - number)];
        }
        
        for (NSInteger i = array.count - 1; i < 49; i++)
        {
            [array addObject:@(0)];
        }
    }
    else
    {
        for (int i = 0; i < 49; i++)
        {
            [array addObject:@(0)];
        }
    }
    
    [_showView updateContentForView:array];
}

- (void)updateContentForLabel:(PedometerModel *)model
{
    _model = model;
    
    _dateLabel.text = [model.dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSDate *date = [NSDate dateWithString:model.dateString];
    NSString *weekString = [NSObject numberTransferWeek:date.weekday];
    _weekLabel.text = weekString;
}

- (void)updateContentForChartView:(PedometerModel *)model
{
    
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
    return 81;
}

#pragma mark --- PieChartViewDataSource ---
- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 288 * 2;
}

- (UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    if (index % 2)
    {
        if (_chartDataArray && _chartDataArray.count > 0)
        {
            if (_chartDataArray.count > index)
            {
                return [UIColor colorWithIndex:[_chartDataArray[index] integerValue]];
            }
            else
            {
                return [UIColor lightGrayColor];
            }
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

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    NSLog(@"..左扫..");

    [self updateContentForBarShowViewWithDate:[_currentDate dateAfterDay:1]];
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    
    [self updateContentForBarShowViewWithDate:[_currentDate dateAfterDay:-1]];
}

- (void)downSwipe
{
    NSLog(@"..下扫..");
    
    DEF_WEAKSELF_(NightVC);
    [[BLTSendData sharedInstance] synHistoryDataWithBackBlock:^{
        [weakSelf updateConnectForView];
    }];
}

- (void)updateConnectForView
{
    if ([_currentDate isSameWithDate:[NSDate date]])
    {
        [self updateContentForBarShowViewWithDate:_currentDate];
    }
}

@end
