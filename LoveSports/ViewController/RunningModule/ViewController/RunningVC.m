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

@interface RunningVC ()

@property (nonatomic, strong) DayDetailView *detailView;
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
}

- (void)loadDayDetailView
{
    _detailView = [[DayDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    [self.view addSubview:_detailView];
}

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    NSLog(@"..左扫..");
    NSMutableArray *chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i = 0; i < 7; i++)
    {
        chartData[i] = [NSNumber numberWithFloat: (arc4random() % 10 + 1) * 0.1];
    }
    
   // if (_lineChart)
    {
      //  [_lineChart setChartData:chartData];
    }
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i = 0;i < 7;i ++)
    {
        chartData[i] = [NSNumber numberWithFloat: (arc4random() % 10 + 1) * 0.1];
    }
    
   // if (_lineChart)
    {
       // [_lineChart setChartData:chartData];
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
   [_detailView updateContentForView:[PedometerModel getModelWithDate:_currentDate]];
}

@end
