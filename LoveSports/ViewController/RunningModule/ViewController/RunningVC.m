//
//  RunningVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 测试。。。
#import "RunningVC.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "ShowWareView.h"
#import "CalendarHomeView.h"
#import "LandscapeVC.h"

#import "DayDetailView.h"
#import "TrendChartView.h"

@interface RunningVC () <TrendChartViewDelegate>

@property (nonatomic, strong) DayDetailView *detailView;
@property (nonatomic, strong) TrendChartView *trendView;

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation RunningVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _currentDate = [NSDate date];
    [self loadDayDetailView];
    [self loadTrendChartView];
    
    // 默认显示当天的.
    [_detailView updateContentForView:[PedometerModel getModelWithToday]];
}

- (void)loadDayDetailView
{
    _detailView = [[DayDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    [self.view addSubview:_detailView];
}

- (void)loadTrendChartView
{
    _trendView = [[TrendChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    _trendView.delegate = self;
    [self.view addSubview:_trendView];
    _trendView.hidden = YES;
}

#pragma mark --- TrendChartViewDelegate ---
- (void)trendChartViewLandscape:(TrendChartView *)trendView
{
    LandscapeVC *vc = [[LandscapeVC alloc] init];
    
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    NSLog(@"..左扫..");
    _currentDate = [_currentDate dateAfterDay:1];
    PedometerModel *model = [PedometerModel getModelWithDate:_currentDate];
    if (model)
    {
        [_detailView updateContentForView:model];
    }
    else
    {
        SHOWMBProgressHUD(@"没有明天的数据.", nil, nil, NO, 2.0);
    }
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    _currentDate = [_currentDate dateAfterDay:-1];
    PedometerModel *model = [PedometerModel getModelWithDate:_currentDate];
    if (model)
    {
        [_detailView updateContentForView:model];
    }
    else
    {
        SHOWMBProgressHUD(@"没有更早的数据.", nil, nil, NO, 2.0);
    }
}

- (void)downSwipe
{
    NSLog(@"..下扫..");
    
    DEF_WEAKSELF_(RunningVC);
    [[BLTSendData sharedInstance] synHistoryDataWithBackBlock:^{
        [weakSelf updateConnectForView];
    }];
}

- (void)updateConnectForView
{
    if ([_currentDate isSameWithDate:[NSDate date]])
    {
        [_detailView updateContentForView:[PedometerModel getModelWithDate:_currentDate]];
    }
}

- (void)upSwipe
{
    if (_detailView.hidden)
    {
        _detailView.hidden = NO;
        _trendView.hidden = YES;
    }
    else
    {
        _detailView.hidden = YES;
        _trendView.hidden = NO;
    }
}

@end
