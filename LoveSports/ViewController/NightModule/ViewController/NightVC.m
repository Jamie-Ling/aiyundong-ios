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

@interface NightVC () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) BarGraphView *barView;;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic) CalendarHomeView *calenderView;

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
    
    [self loadPieChartView];
    [self loadCalendarButton];
    [self loadDateLabel];
    [self loadBarGraphView];
    [self loadShareButton];
}

- (void)loadPieChartView
{
    CGRect rect = CGRectMake((self.view.width - 200) / 2, 85 - _offsetY * 1.2, 200, 200);
    _chartView = [[PieChartView alloc] initWithFrame:rect];
    _chartView.delegate = self;
    _chartView.datasource = self;
    [self.view addSubview:_chartView];
    _chartView.signView.image = [UIImage image:@"睡觉@2x.png"];
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

- (void)loadBarGraphView
{
    _barView = [[BarGraphView alloc] initWithFrame:CGRectMake((self.view.width - 280) / 2, 300 - _offsetY * 1.5, 280, 160 - _offsetY)];
    
    [self.view addSubview:_barView];
    [self updateContentForBarGraphView];
}

- (void)updateContentForBarGraphView
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++)
    {
        DataModel *model = [[DataModel alloc] init];
        
        model.width = arc4random() % 30 + 5;
        model.height = arc4random() % 180 + 20;
        model.color = [UIColor colorWithRed:(arc4random() % 200 + 20) / 255.0
                                      green:(arc4random() % 200 + 20) / 255.0
                                       blue:(arc4random() % 200 + 20) / 255.0
                                      alpha:1.0];
        
        [array addObject:model];
    }
    
    _barView.array = array;
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

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    NSLog(@"..左扫..");
    
    _percent = arc4random() % 70 + 20;
    [_chartView reloadData];
    [self updateContentForBarGraphView];
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    
    _percent = arc4random() % 70 + 20;
    [_chartView reloadData];
    [self updateContentForBarGraphView];
}

@end
