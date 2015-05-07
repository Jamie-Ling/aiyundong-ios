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
#import "TrendStepView.h"

@interface TrendChartView ()

@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UISegmentedControl *segement;
@property (nonatomic, assign) NSInteger segIndex;

@property (nonatomic, strong) TrendStepView *stepView;

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
        self.backgroundColor = UIColorRGB(247, 247, 247);
        // self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        
        _showType = TrendChartViewShowDaySteps;
        
        _dayDate = [NSDate date];
        _weekDate = [NSDate date];
        _monthIndex = [NSDate date].month;
        
        [self loadCalendarButton];
        [self loadTrendStepView];
        [self loadLandscapeButton];
        [self loadTrendScrollView];
        [self loadTrendTypeView];
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
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(20, 18, 45, 35)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    // [self addSubview:calendarButton];
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

- (void)loadTrendStepView
{
    DEF_WEAKSELF_(TrendChartView);
    _stepView = [[TrendStepView alloc] initWithFrame:CGRectMake((self.width - 190) / 2, 30, 190, 50)
                                           withBlock:^(UIView *aView, id object) {
                                               weakSelf.segIndex = [(NSNumber *)object integerValue];
                                               [weakSelf reloadTrendChartView];
                                           }];
    [self addSubview:_stepView];
    _segIndex = 0;
}

- (void)loadLandscapeButton
{
    UIButton *landscapeButton = [UIButton simpleWithRect:CGRectMake(self.width - 70, 18, 50, 44)
                                               withImage:@"旋转屏幕@2x.png"
                                         withSelectImage:@"旋转屏幕@2x.png"];
    
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
                                     withText:@""
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 50, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@""
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
        weakSelf.yearLabel.text = [NSString stringWithFormat:@"%@%@", object, LS_Text(@"Year")];
    };
}

// 步数，卡路里，距离切换.
- (void)loadTrendTypeView
{
    CGRect rect = FitScreenRect(CGRectMake(0, 320, self.width, 64),
                                CGRectMake(0, 370, self.width, 64),
                                CGRectMake(0, 450, self.width, 64),
                                CGRectMake(0, 500, self.width, 64),
                                CGRectMake(0, 370, self.width, 64));
    DEF_WEAKSELF_(TrendChartView);
    _typeView = [[TrendTypeView alloc] initWithFrame:rect
                                          withOffset:45
                                           withBlock:^(UIView *aView, id object) {
                                               weakSelf.lastButton = (UIButton *)object;
                                               [weakSelf reloadTrendChartView];
                                           }];
    [self addSubview:_typeView];
    _lastButton = _typeView.lastButton;
    
    rect = FitScreenRect(CGRectMake(4, 300, 64, 20),
                         CGRectMake(4, 350, 64, 20),
                         CGRectMake(4, 400, 64, 20),
                         CGRectMake(4, 450, 64, 20),
                         CGRectMake(4, 350, 64, 20));
    _yearLabel = [self addSubLabelWithRect:rect
                             withAlignment:NSTextAlignmentCenter
                              withFontSize:13
                                  withText:[NSString stringWithFormat:@"%ld%@", (long)[NSDate date].year, LS_Text(@"Year")]
                             withTextColor:[UIColor blackColor]
                                   withTag:3000];
}

// 点击6个按钮后图表进行切换。
- (void)reloadTrendChartView
{
    _showType = [TrendShowType showWithIndex:_segIndex withButton:_lastButton];
 
    [_scrollView reloadTrendChartViewWith:_showType];
}

@end
