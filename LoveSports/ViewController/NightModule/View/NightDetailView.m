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

@interface NightDetailView () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) BarGraphView *barView;;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BarShowView *showView;
@property (nonatomic, strong) PedometerModel *model;

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
        _offsetY = (frame.size.height < 485.0) ? 25.0 : 0.0;
        _percent = 0;
        
        _currentDate = [NSDate date];
        
        [self loadPieChartView];
        [self loadCalendarButton];
        [self loadDateLabel];
        [self loadScrollView];
    }
    
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
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
    CGRect rect = CGRectMake((self.width - 200) / 2, 85 - _offsetY * 1.2, 200, 200);
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateChartView) userInfo:nil repeats:YES];
    }
}

#define NightVC_TotalPercent 100
- (void)updateChartView
{
    _percent += 5;
    [_chartView reloadData];
    
    if (_percent >= NightVC_TotalPercent)
    {
        [self stopTimer];
    }
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
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(0, 15 - _offsetY, 90, 70)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(NightDetailView);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        weakSelf.currentDate = [model date];
    };
    
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
    }];
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 25 - _offsetY, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor blackColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 50 - _offsetY, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor blackColor]];
    [self addSubview:_dateLabel];
}

- (void)loadScrollView
{
    NSInteger width = self.width;
    _showView = [[BarShowView alloc] initWithFrame:CGRectMake(20, _chartView.totalHeight + 20, width - 40, 160 - _offsetY)];
    [self addSubview:_showView];
    
    [self updateContentForBarShowViewWithDate:_currentDate];
}

- (void)updateContentForBarShowViewWithDate:(NSDate *)date
{
    _currentDate = date;
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:_currentDate];
    
    [self updateContentForLabel:model];
    _chartDataArray = model.detailSleeps;
    
    [_chartView updateContentForViewWithModel:model withState:PieChartViewShowSleep withReloadBlock:nil];
    [self startTimer];
    
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
    
    _dateLabel.text = [model.dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSDate *date = [NSDate dateWithString:model.dateString];
    NSString *weekString = [NSObject numberTransferWeek:date.weekday];
    _weekLabel.text = weekString;
}

- (void)updateContentForChartView:(PedometerModel *)model
{
    
}

#pragma mark --- PieChartViewDelegate ---
-(CGFloat)centerCircleRadius
{
    return 81;
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
            if (_chartDataArray && _chartDataArray.count > 0)
            {
                if (_chartDataArray.count > index)
                {
                    return [UIColor colorWithIndex:(int)[_chartDataArray[index] integerValue]];
                }
                else
                {
                    return [UIColor lightGrayColor];
                }
            }
            else
            {
                return [UIColor lightGrayColor];
            }
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
