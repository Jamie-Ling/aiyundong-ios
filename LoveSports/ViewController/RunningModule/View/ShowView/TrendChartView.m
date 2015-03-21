//
//  TrendChartView.m
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendChartView.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "ShowWareView.h"
#import "CalendarHomeView.h"
#import "PedometerModel.h"
#import "CalendarHelper.h"

@interface TrendChartView ()

@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UISegmentedControl *segement;
@property (nonatomic, assign) NSInteger segIndex;

@property (nonatomic, strong) UIButton *calendarButton;
@property (nonatomic, strong) CalendarHomeView *calenderView;
@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger percent;

@end

@implementation TrendChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        // self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        
        _showType = TrendChartViewShowDaySteps;
        
        _dayDate = [NSDate date];
        _weekDate = [NSDate date];
        _monthIndex = [NSDate date].month;
        
        [self loadCalendarButton];
        [self loadSegmentedControl];
        [self loadLandscapeButton];
        [self loadTrendScrollView];
        [self loadChartStyleButtons];
    }
    
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _dayDate = currentDate;
    _weekDate = currentDate;
    _monthIndex = [YearModel monthOfYearWithDate:currentDate];
    
    [self reloadTrendChartView];
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(15, 70, 45, 35)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
    _calendarButton = calendarButton;
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(TrendChartView);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        weakSelf.currentDate = [model date];
    };
    
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
    }];
}

- (void)loadSegmentedControl
{
    _segement = [[UISegmentedControl alloc] initWithItems:@[@"日", @"周", @"月"]];
    _segement.frame = CGRectMake((self.width - 200) / 2, 30, 200, 40);
    
    _segement.backgroundColor = [UIColor clearColor];
    _segement.tintColor = [UIColor clearColor];
    //[_segement setBackgroundImage:[UIImage image:@"日@2x.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segement setImage:[UIImage image:@"日选中@2x.png"] forSegmentAtIndex:0];
    [_segement setImage:[UIImage image:@"周@2x.png"] forSegmentAtIndex:1];
    [_segement setImage:[UIImage image:@"月@2x.png"] forSegmentAtIndex:2];
    [_segement addTarget:self action:@selector(clickSegementControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segement];
    _segIndex = 0;
}

// 日月周趋势切换
- (void)clickSegementControl:(UISegmentedControl *)seg
{
    NSArray *images = @[@"日@2x.png", @"周@2x.png", @"月@2x.png"];
    NSArray *selectImages = @[@"日选中@2x.png", @"周选中@2x.png", @"月选中@2x.png"];
    
    [_segement setImage:[UIImage image:images[_segIndex]]
      forSegmentAtIndex:_segIndex];
    [_segement setImage:[UIImage image:selectImages[_segement.selectedSegmentIndex]]
      forSegmentAtIndex:_segement.selectedSegmentIndex];
    _segIndex = _segement.selectedSegmentIndex;
    
    [self reloadTrendChartView];
}

- (void)loadLandscapeButton
{
    UIButton *landscapeButton = [UIButton simpleWithRect:CGRectMake(self.width - 60, 70, 45, 35)
                                               withImage:@"竖屏@2x.png"
                                         withSelectImage:@"竖屏@2x.png"];
    
    [landscapeButton addTarget:self action:@selector(landscapeViewData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:landscapeButton];
}

- (void)landscapeViewData
{
    if ([_delegate respondsToSelector:@selector(trendChartViewLandscape:)])
    {
        [_delegate trendChartViewLandscape:self];
    }
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 50, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_dateLabel];
}

- (void)loadTrendScrollView
{
    _scrollView = [[TrendScrollView alloc] initWithFrame:CGRectMake(0, self.height * 0.22, self.width, self.height * 0.36)];
    _scrollView.showType = _showType;
    [self addSubview:_scrollView];
    
    DEF_WEAKSELF_(TrendChartView);
    _scrollView.yearBlock = ^ (UIView *view, id object) {
        weakSelf.yearLabel.text = [NSString stringWithFormat:@"%@年", object];
    };
}

// 步数，卡路里，距离切换.
- (void)loadChartStyleButtons
{
    CGFloat offsetX = ((self.width - 60) - 90 * 3) / 2;
    NSArray *images = @[@"足迹@2x.png", @"能量@2x.png", @"路程@2x.png"];
    NSArray *selectImages = @[@"足迹-选中@2x.png", @"能量选中@2x.png", @"路程选中@2x.png"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIButton *button = [UIButton simpleWithRect:CGRectMake(30 + (90 + offsetX) * i , 340, 90, 89)
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
    
    _yearLabel = [self addSubLabelWithRect:CGRectMake(4, 350, 44, 20)
                             withAlignment:NSTextAlignmentCenter
                              withFontSize:13
                                  withText:[NSString stringWithFormat:@"%ld年", [NSDate date].year]
                             withTextColor:[UIColor blackColor]
                                   withTag:3000];
}

- (void)clcikChartStyleButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    [self reloadTrendChartView];
}

// 点击6个按钮后图表进行切换。
- (void)reloadTrendChartView
{
    _showType = [TrendShowType showWithIndex:_segIndex withButton:_lastButton];
 
    [_scrollView reloadTrendChartViewWith:_showType];
}

- (void)loadShareButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(self.width - 45, self.height - 99, 90/2.0, 70/2.0)
                                              withImage:@"分享@2x.png"
                                        withSelectImage:@"分享@2x.png"];
    
    [self addSubview:calendarButton];
}

@end
