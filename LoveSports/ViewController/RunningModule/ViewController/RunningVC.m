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

@interface RunningVC () <TrendChartViewDelegate, DayDetailViewDelegate>

@property (nonatomic, strong) DayDetailView *detailView;
@property (nonatomic, strong) TrendChartView *trendView;

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
    
    [self loadDayDetailView];
    [self loadTrendChartView];
    
    // 默认显示当天的.
    [_detailView updateContentForView:[PedometerModel getModelFromDBWithToday]];
}

- (void)loadDayDetailView
{
    _detailView = [[DayDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    _detailView.delegate = self;
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
    LandscapeVC *vc = [[LandscapeVC alloc] initWithDate:_trendView.dayDate
                                           withWeekDate:_trendView.weekDate
                                         withMonthIndex:_trendView.monthIndex
                                           withShowtype:_trendView.showType];
    
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    NSLog(@"..左扫..");
    [self swipeUpdateContentForChartViewWithDirection:1];
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    [self swipeUpdateContentForChartViewWithDirection:-1];
}

- (void)swipeUpdateContentForChartViewWithDirection:(NSInteger)direction;
{
    if (_detailView.hidden)
    {
        [_trendView updateContentForChartViewWithDirection:direction];
    }
    else
    {
        [_detailView updateContentForChartViewWithDirection:direction];
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
    if (_detailView.hidden)
    {
        if ([_trendView.dayDate isSameWithDate:[NSDate date]])
        {
            [_trendView updateContentForChartViewWithDirection:0];
        }
    }
    else
    {
        if ([_detailView.currentDate isSameWithDate:[NSDate date]])
        {
            [_detailView updateContentForChartViewWithDirection:0];
        }
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

- (void)dayDetailViewSwipeUp
{
    [self upSwipe];
}

@end
