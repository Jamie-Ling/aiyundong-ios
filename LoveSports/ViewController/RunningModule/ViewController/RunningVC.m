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

#import "CalendarHelper.h"

@interface RunningVC () <TrendChartViewDelegate, DayDetailViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *srcollView;
@property (nonatomic, strong) DayDetailView *detailView;
@property (nonatomic, strong) TrendChartView *trendView;

@property (nonatomic, strong) DayScrollView *dayScroll;

@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIButton *backButton;

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
    // [self loadShareButton];
    [self loadCalendarButton];
    [self loadDateLabel];
    [self loadBackButton];
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(20, 18, 50, 44)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [_srcollView addSubview:calendarButton];
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(RunningVC);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        // weakSelf.currentDate = [model date];
        [weakSelf.dayScroll updateContentWithDate:[model date]];
    };
    
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
    }];
}

- (void)loadBackButton
{
    _backButton = [UIButton simpleWithRect:CGRectMake(self.width - 70, 18, 50, 44)
                                 withImage:@"返回@2x.png"
                           withSelectImage:@"返回@2x.png"];
    [_backButton addTouchUpTarget:self action:@selector(clickBackButton:)];
    [_srcollView addSubview:_backButton];
}

- (void)clickBackButton:(UIButton *)button
{
    [_dayScroll updateContentToToday];
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 0, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor blackColor]];
    [_srcollView addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor blackColor]];
    [_srcollView addSubview:_dateLabel];
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
    [self.tableView.header setTitle:@"下拉进行刷新." forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"下拉进行刷新." forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"更新数据..." forState:MJRefreshHeaderStateRefreshing];
}

- (void)setTitleForNoConnect
{
    [self.tableView.header setTitle:@"请按下设备按键进行同步." forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"请按下设备按键进行同步." forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"请按下设备按键进行同步." forState:MJRefreshHeaderStateRefreshing];
}

- (void)headerRereshing
{
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        if (![UserInfoHelp sharedInstance].braceModel.isRealTime ||
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
            SHOWMBProgressHUD(@"实时同步期间关闭下拉同步数据.", nil, nil, NO, 2.0);
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
    DEF_WEAKSELF_(RunningVC);
    _dayScroll.buttonRotationBlock = ^(UIView *view, id object) {
        [weakSelf updateContentForLabelsAndButton:(DayDetailView *)view];
    };
}

- (void)updateContentForLabelsAndButton:(DayDetailView *)detailView
{
    _dateLabel.text = [detailView.model.dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSDate *date = detailView.currentDate;
    NSString *weekString = [NSObject numberTransferWeek:date.weekday];
    _weekLabel.text = weekString;
    
    [_backButton rotationAccordingWithDate:date];
    _backButton.hidden = [date isSameWithDate:[NSDate date]];
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
