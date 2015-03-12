//
//  DayDetailView.m
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DayDetailView.h"
#import "PieChartView.h"
#import "CalendarHomeView.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "ShowWareView.h"
#import "NSObject+Property.h"
#import "CalendarHelper.h"

@interface DayDetailView () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic) CalendarHomeView *calenderView;
@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, strong) NSMutableArray *chartData;

@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, assign) CGFloat totalPercent;

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DayDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        NSLog(@".height..%f", self.height);
        _offsetY = (self.height < 485) ? 20.0 : 0.0;
        _percent = 25;
        _chartData = [[NSMutableArray alloc] initWithCapacity:0];
        _currentDate = [NSDate date];

        [self loadPieChartView];
        [self loadCalendarButton];
        [self loadDateLabel];
        [self loadChartStyleButtons];
        [self loadScrollView];
        // [self loadShareButton];
    }
    
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    [self updateContentForChartViewWithDirection:0];
}

- (void)loadPieChartView
{
    CGRect rect = CGRectMake((self.width - 200 + _offsetY) / 2, 60 - _offsetY * 0.5, 200 - _offsetY, 200 - _offsetY);
    _chartView = [[PieChartView alloc] initWithFrame:rect];
    _chartView.delegate = self;
    _chartView.datasource = self;
    [self addSubview:_chartView];
    [_chartView daySetting];
    [_chartView reloadData];
}

- (void)startTimer
{
    _percent = 0;
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateChartView) userInfo:nil repeats:YES];
    }
    //[self performSelector:@selector(updateChartView) withObject:nil afterDelay:0.02];
}

- (void)updateChartView
{
    _percent += 4;
    [_chartView reloadData];
    
    if (_percent >= (int)(_totalPercent * 100))
    {
        [self stopTimer];
    }
    else
    {
       // [self performSelector:@selector(updateChartView) withObject:nil afterDelay:0.02];
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
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(0, 0, 90, 70)
                                              withImage:@"日历.png"
                                        withSelectImage:@"日历.png"];
    
    [calendarButton addTarget:self action:@selector(clickCalendarButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(DayDetailView)
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
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 0, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"星期一"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 25, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:20
                                     withText:@"2015/2/2"
                                withTextColor:[UIColor whiteColor]];
    [self addSubview:_dateLabel];
}

- (void)loadChartStyleButtons
{
    CGFloat offsetX = ((self.width - 60) - 90 * 3) / 2;
    NSArray *images = @[@"足迹@2x.png", @"能量@2x.png", @"路程@2x.png"];
    NSArray *selectImages = @[@"足迹-选中@2x.png", @"能量选中@2x.png", @"路程选中@2x.png"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIButton *button = [UIButton simpleWithRect:CGRectMake(30 + (90 + offsetX) * i , _chartView.totalHeight - 15, 90, 89)
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
}

- (void)clcikChartStyleButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    [self updateContentFromClickChangeEvent];
}

- (void)loadScrollView
{
    CGFloat offsetY = _chartView.totalHeight + 50;
    _scrollView = [UIScrollView simpleInit:CGRectMake(0, offsetY, self.width, self.height - offsetY - 120)
                                  withShow:NO
                                withBounce:YES];
    [self addSubview:_scrollView];
    [self loadLineChart];
    _scrollView.contentSize = CGSizeMake(_scrollView.width * 6, _scrollView.height);
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_scrollView addGestureRecognizer:swipe];
}

- (void)upSwipe
{
    NSLog(@"上");
    if ([_delegate respondsToSelector:@selector(dayDetailViewSwipeUp)])
    {
        [_delegate dayDetailViewSwipeUp];
    }
}

-(void)loadLineChart
{
    // Generating some dummy data
    NSMutableArray *bottomTitles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 49; i++)
    {
        NSString *string = [NSString stringWithFormat:@"%02d:%@\n", i / 2, (((i % 2) == 0) ? @"00" : @"30")];
        [bottomTitles addObject:string];
    }
    
    _lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(15.0, 20, _scrollView.width * 6 - 30.0, _scrollView.height - 40)];
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = (int)bottomTitles.count - 1; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return bottomTitles[item];
    };
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@""];
    };
    [_scrollView addSubview:_lineChart];
    
    [self updateContentForChartViewWithDirection:0];
}

- (void)loadShareButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(self.width - 45, self.height - 99, 90/2.0, 70/2.0)
                                              withImage:@"分享@2x.png"
                                        withSelectImage:@"分享@2x.png"];
    
    [self addSubview:calendarButton];
}

#pragma mark --- PieChartViewDelegate ---
-(CGFloat)centerCircleRadius
{
    return 81 - _offsetY * 0.5;
}

#pragma mark --- PieChartViewDataSource ---
- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 288 * 2;
}

- (UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    if (index % 2)
    {
        if (index <= 288 * 2 * (_percent * 0.01))
        {
            return [UIColor greenColor];
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

- (void)updateContentForView:(PedometerModel *)model
{
    _model = model;
    
    [self updateContentFromClickChangeEvent];
    _dateLabel.text = [model.dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSDate *date = [NSDate dateWithString:model.dateString];
    NSString *weekString = [NSObject numberTransferWeek:date.weekday];
    _weekLabel.text = weekString;
}

- (void)updateContentFromClickChangeEvent
{
    DEF_WEAKSELF_(DayDetailView);
    [_chartView updateContentForViewWithModel:_model
                                    withState:(PieChartViewShowState)(_lastButton.tag - 2000)
                              withReloadBlock:^(CGFloat percent) {
                                //  if (percent > -0.1)
                                  {
                                      weakSelf.totalPercent = arc4random() % 100 / 100.0; //percent;
                                      [weakSelf startTimer];
                                  }
                              }];
    
    [_chartData removeAllObjects];
    [_chartData addObject:@(0)];
    
    if (_lastButton.tag == 2000)
    {
        [_chartData addObjectsFromArray:_model.detailSteps];
    }
    else if (_lastButton.tag == 2001)
    {
        [_chartData addObjectsFromArray:_model.detailCalories];
        
    }
    else if (_lastButton.tag == 2001)
    {
        [_chartData addObjectsFromArray:_model.detailDistans];
    }
    
    for (NSUInteger i = _chartData.count; i < 49; i++)
    {
        [_chartData addObject:@(0)];
    }
    
    [_lineChart setChartData:_chartData];
}

- (void)updateContentForChartViewWithDirection:(NSInteger)direction
{
    if (direction == 1 && [_currentDate isSameWithDate:[NSDate date]])
    {
        return;
    }
    
    [self stopTimer];
    _currentDate = [_currentDate dateAfterDay:direction * 1];
    
    PedometerModel *model = [PedometerHelper getModelFromDBWithDate:_currentDate];

    [self updateContentForView:model];
}

@end
