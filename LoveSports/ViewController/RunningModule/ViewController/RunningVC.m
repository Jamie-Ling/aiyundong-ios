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
#import "MJRefresh.h"

#import "DayScrollView.h"
#import "ShareView.h"

@interface RunningVC () <TrendChartViewDelegate, DayDetailViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *srcollView;
@property (nonatomic, strong) DayDetailView *detailView;
@property (nonatomic, strong) TrendChartView *trendView;

@property (nonatomic, strong) DayScrollView *dayScroll;

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL isUpSwipe;

@end

@implementation RunningVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(RunningVC);

    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf updateConnectForView];
    };
    
    [BLTSendOld sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf updateConnectForView];
    };
    
    [self updateConnectForView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_dayScroll startChartAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
    [BLTSendOld sharedInstance].backBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
    
    [self loadScrollView];
    [self loadShareButton];
}

- (void)loadScrollView
{
    _srcollView = [UIScrollView simpleInit:CGRectMake(0, 0, self.view.width, self.view.height) withShow:NO withBounce:YES];
    
    _srcollView.delegate = self;
    _srcollView.pagingEnabled = YES;
    _srcollView.contentSize = CGSizeMake(_srcollView.width, _srcollView.height * 2);

    self.tableView.tableHeaderView = _srcollView;
    
    [self loadDayDetailView];
    [self loadTrendChartView];
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    DEF_WEAKSELF_(RunningVC);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        [self setTitleForConnect];
    }
    else
    {
        [self setTitleForNoConnect];
    }
    
    // [self.tableView.legendHeader beginRefreshing];
}

- (void)setTitleForConnect
{
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
}

- (void)setTitleForNoConnect
{
    [self.tableView.header setTitle:@"Pull down to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"请按下设备按键进行同步." forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
}

- (void)headerRereshing
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        if (![BLTRealTime sharedInstance].isRealTime ||
            ![BLTManager sharedInstance].model.isNewDevice)
        {
            DEF_WEAKSELF_(RunningVC);
            [[BLTSimpleSend sharedInstance] synHistoryDataWithBackBlock:^(NSDate *date){
                [weakSelf updateConnectForView];

                [weakSelf.tableView.header performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
            }];
        }
        else
        {
            // SHOWMBProgressHUD(@"实时同步期间关闭下拉同步数据.", nil, nil, NO, 2.0);
            [self.tableView.header performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
        }
    }
    else
    {
        // SHOWMBProgressHUD(@"设备没有链接.", @"无法同步数据.", nil, NO, 2.0);
        //[_srcollView headerEndRefreshing];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.header endRefreshing];
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tableView.header.state == MJRefreshHeaderStateRefreshing)
        {
            [self.tableView.header endRefreshing];
        }
    });}

- (void)loadDayDetailView
{
    _dayScroll = [[DayScrollView alloc] initWithFrame:_srcollView.bounds];
    
    [_srcollView addSubview:_dayScroll];
}

- (void)loadTrendChartView
{
    _trendView = [[TrendChartView alloc] initWithFrame:CGRectMake(0, _srcollView.height, _srcollView.width, _srcollView.height)];
    
    _trendView.delegate = self;
    [_srcollView addSubview:_trendView];
}

- (void)loadShareButton
{
    SphereMenu *sphereMenu = [[ShareView sharedInstance] simpleWithPoint:CGPointMake(self.width - 22.5, self.height - 86)];
    [self addSubview:sphereMenu];
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

// 下拉刷新主界面.
- (void)updateConnectForView
{
    [_dayScroll updateContentForDayDetailViews];
}

#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY > 0)
        {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.height * 2;
}

@end
