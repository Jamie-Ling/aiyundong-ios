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

#import "UIScrollView+Simple.h"
#import "DayDetailView.h"
#import "TrendChartView.h"
#import "MJRefresh.h"

@interface RunningVC () <TrendChartViewDelegate, DayDetailViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *srcollView;
@property (nonatomic, strong) DayDetailView *detailView;
@property (nonatomic, strong) TrendChartView *trendView;

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL isUpSwipe;

@end

@implementation RunningVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(RunningVC);
    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf updateConnectForView];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
    [self loadScrollView];
    NSLog(@"..%@", NSStringFromCGPoint(_srcollView.contentOffset));
}

- (void)loadScrollView
{
    _srcollView = [UIScrollView simpleInit:CGRectMake(0, 0, self.view.width, self.view.height) withShow:NO withBounce:YES];
    
    [self.view addSubview:_srcollView];
    _srcollView.delegate = self;
    _srcollView.contentSize = _srcollView.frame.size;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_srcollView addGestureRecognizer:swipe];
    
    [self loadDayDetailView];
    [self loadTrendChartView];
    [self setupRefresh];
    
    // 默认显示当天的.
    [_detailView updateContentForView:[PedometerHelper getModelFromDBWithToday]];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [_srcollView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_srcollView headerBeginRefreshing];

    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _srcollView.headerPullToRefreshText = @"下拉同步运动数据.";
    _srcollView.headerReleaseToRefreshText = @"松开马上同步.";
    _srcollView.headerRefreshingText = @"正在同步中.";
}

- (void)headerRereshing
{
    [_srcollView headerEndRefreshing];
    
    DEF_WEAKSELF_(RunningVC);
    [[BLTSimpleSend sharedInstance] synHistoryDataWithBackBlock:^(NSDate *date){
        [weakSelf updateConnectForView];
    }];
}

- (void)loadDayDetailView
{
    _detailView = [[DayDetailView alloc] initWithFrame:_srcollView.bounds];
    
    _detailView.delegate = self;
    [_srcollView addSubview:_detailView];
}

- (void)loadTrendChartView
{
    _trendView = [[TrendChartView alloc] initWithFrame:_srcollView.bounds];
    
    _trendView.delegate = self;
    [_srcollView addSubview:_trendView];
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
    
    /*
    DEF_WEAKSELF_(RunningVC);
    [[BLTSimpleSend sharedInstance] synHistoryDataWithBackBlock:^(NSDate *date){
        [weakSelf updateConnectForView];
    }];
     */
}

- (void)updateConnectForView
{
    NSLog(@"。。。事实刷新主界面");
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

#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _offsetY += scrollView.contentOffset.y;

    if (scrollView.contentOffset.y > 0.0)
    {
        _isUpSwipe = YES;

        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (scrollView.contentOffset.y < 0.0)
    {
        _isUpSwipe = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isUpSwipe && _offsetY > 60.0)
    {
        [self upSwipe];
    }
    
    _offsetY = 0;
}

@end
