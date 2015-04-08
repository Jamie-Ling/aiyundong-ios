//
//  NightDetailView.m
//  LoveSports
//
//  Created by zorro on 15/3/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NightDetailView.h"
#import "PieChartView.h"
#import "CalendarHomeView.h"
#import "BarGraphView.h"
#import "BarShowView.h"
#import "UIColor+RGB.h"
#import "CalendarHelper.h"
#import "SleepTimeView.h"

@interface NightDetailView () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) BarGraphView *barView;
@property (nonatomic, strong) SleepTimeView *sleepView;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BarShowView *showView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) CalendarHomeView *calenderView;
@property (nonatomic, strong) NSArray *chartDataArray;

@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, assign) CGFloat totalPercent;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation NightDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorRGB(247, 247, 247);
        _offsetY = (frame.size.height < 485.0) ? 20.0 : 0.0;
        _percent = 0;
        
        _currentDate = [NSDate date];
        
        [self loadPieChartView];
        [self loadSleepTimeView];
        [self loadBarShowView];
    }
    
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    if (_backButton)
    {
       // [_backButton rotationAccordingWithDate:currentDate];
    }
    
    // 将内存之前的图标清除...
    _allowAnimation = NO;
    _percent = 0;
    [_chartView reloadData];
    
    [self updateContentForBarShowViewWithDate:_currentDate];
}

- (void)setAllowAnimation:(BOOL)allowAnimation
{
    _allowAnimation = allowAnimation;
    
    if (_allowAnimation)
    {
        [self startTimer];
    }
}

- (void)loadPieChartView
{
    CGRect rect = CGRectMake((self.width - 200 + _offsetY) / 2, 60 - _offsetY * 0.5, 200 - _offsetY, 200 - _offsetY);
    _chartView = [[PieChartView alloc] initWithFrame:rect];
    _chartView.delegate = self;
    _chartView.datasource = self;
    [self addSubview:_chartView];
    [_chartView nightSetting];
    [_chartView reloadData];
}

- (void)startTimer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateChartView) userInfo:nil repeats:YES];
    }
}

#define NightVC_TotalPercent 100
- (void)updateChartView
{
    if (_percent >= (int)(_totalPercent * 100))
    {
        [self stopTimer];
        return;
    }
    
    _percent += 5;
    [_chartView reloadData];
}

- (void)stopTimer
{
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)loadCalendarButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(20, 18, 50, 44)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
}

- (void)loadBackButton
{
    _backButton = [UIButton simpleWithRect:CGRectMake(self.width - 70, 18, 50, 44)
                                 withImage:@"返回@2x.png"
                           withSelectImage:@"返回@2x.png"];
    [_backButton addTouchUpTarget:self action:@selector(clickBackButton:)];
    [self addSubview:_backButton];
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(NightDetailView);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        // weakSelf.currentDate = [model date];
        if (weakSelf.switchDateBlock)
        {
            weakSelf.switchDateBlock(weakSelf, [model date]);
        }
    };
    
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
    }];
}

- (void)clickBackButton:(UIButton *)button
{
    if (_backBlock)
    {
        _backBlock(self, nil);
    }
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 0, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor blackColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor blackColor]];
    [self addSubview:_dateLabel];
}

- (void)loadSleepTimeView
{
    _sleepView = [[SleepTimeView alloc] initWithFrame:CGRectMake(0, _chartView.totalHeight + 5, self.width, 32)];
    
    [self addSubview:_sleepView];
}

- (void)loadBarShowView
{
    NSInteger width = self.width;
    CGRect rect = FitScreenRect(CGRectMake(20, _sleepView.totalHeight + 40, width - 40, 110 - _offsetY),
                                CGRectMake(20, _sleepView.totalHeight + 40, width - 40, 140 - _offsetY),
                                CGRectMake(20, _sleepView.totalHeight + 60, width - 40, 210 - _offsetY),
                                CGRectMake(20, _sleepView.totalHeight + 70, width - 40, 260 - _offsetY),
                                CGRectMake(20, _sleepView.totalHeight + 20, width - 40, 160 - _offsetY));
    _showView = [[BarShowView alloc] initWithFrame:rect];
    [self addSubview:_showView];
    
    [self updateContentForBarShowViewWithDate:_currentDate];
}

#pragma mark --- PieChartViewDelegate ---
-(CGFloat)centerCircleRadius
{
    return 81 - _offsetY * 0.5;
}

#pragma mark --- PieChartViewDataSource ---
- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 288;
}

- (UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    if (index % 2)
    {
        if (index <= 288 * (_percent * 0.01))
        {
            return UIColorRGB(82, 182, 21);
        }
        else
        {
            return UIColorRGB(205, 205, 205);
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


// 下面为内容更新的各种方法.
- (void)updateContentForBarShowViewWithDate:(NSDate *)date
{
    _currentDate = date;
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:_currentDate];
    
    _model = model;
    [self updateContentForLabel:model];
    _chartDataArray = model.detailSleeps;
    
    DEF_WEAKSELF_(NightDetailView);
    [_chartView updateContentForViewWithModel:model withState:PieChartViewShowSleep withReloadBlock:^(CGFloat percent) {
        weakSelf.totalPercent = percent;
    }];
    
    /*
     NSMutableArray *array = [[NSMutableArray alloc] init];
     if (model.detailSleeps && model.detailSleeps.count > 0)
     {
     for (int i = 0; i < model.detailSleeps.count; i++)
     {
     NSInteger number = [model.detailSleeps[i] intValue]     + [model.detailSleeps[i + 1] intValue] +
     [model.detailSleeps[i + 2] intValue] + [model.detailSleeps[i + 3] intValue] +
     [model.detailSleeps[i + 4] intValue] + [model.detailSleeps[i + 5] intValue];
     [array addObject:@(18 - number)];
     }
     
     for (NSInteger i = array.count; i < 288; i++)
     {
     [array addObject:@(0)];
     }
     }
     else
     {
     for (int i = 0; i < 288; i++)
     {
     [array addObject:@(0)];
     }
     }
     */
    
    [_showView updateContentForView:model.detailSleeps withStart:model.sleepTodayStartTime withEnd:model.sleepTodayEndTime];
}

- (void)updateContentForLabel:(PedometerModel *)model
{
    _model = model;
    
    /*
    _dateLabel.text = [model.dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSDate *date = [NSDate dateWithString:model.dateString];
    NSString *weekString = [NSObject numberTransferWeek:date.weekday];
    _weekLabel.text = weekString;
     */
}

- (void)updateContentForChartView:(PedometerModel *)model
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
