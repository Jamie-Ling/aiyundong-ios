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
#import "DashLineView.h"
#import "GraphicButton.h"
#import "ShareView.h"

@interface DayDetailView () <PieChartViewDelegate, PieChartViewDataSource>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) DashLineView *dashView;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) CalendarHomeView *calenderView;

@property (nonatomic, strong) GraphicButton *lastButton;
@property (nonatomic, strong) UIButton *backButton;

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
        self.backgroundColor = UIColorRGB(247, 247, 247);
        // self.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
        NSLog(@".height..%f", self.height);
        _offsetY = (self.height < 485) ? 20.0 : 0.0;
        _percent = 25;
        _chartData = [[NSMutableArray alloc] initWithCapacity:0];
        _currentDate = [NSDate date];

        [self loadPieChartView];
        [self loadCalendarButton];
        [self loadBackButton];
        [self loadDateLabel];
        [self loadChartStyleButtons];
        [self loadFSLineView];
    }
    
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    if (_backButton)
    {
        [_backButton rotationAccordingWithDate:currentDate];
    }
    
    // 将内存之前的图标清除...
    _allowAnimation = NO;
    _percent = 0;
    [_chartView reloadData];
    
    [self updateContentForChartViewWithDirection:0];
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
    [_chartView daySetting];
    [_chartView reloadData];
}

- (void)startTimer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateChartView) userInfo:nil repeats:YES];
    }
}

- (void)updateChartView
{
    _percent += 5;
    [_chartView reloadData];

    if (_percent >= (int)(_totalPercent * 100))
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

- (void)loadChartStyleButtons
{
    CGFloat offsetX = ((self.width - 60) - 100 * 3) / 2;
    NSArray *images = @[@"脚印-小@2x.png", @"能量@2x.png", @"路程@2x.png"];
    NSArray *selectImages = @[@"脚印-小选中@2x.png", @"能量选中@2x.png", @"路程选中@2x.png"];
    
    for (int i = 0; i < images.count; i++)
    {
        GraphicButton *button = [[GraphicButton alloc] initWithFrame:CGRectMake(30 + (100 + offsetX) * i , _chartView.totalHeight + 10, 100, 40)];
        
        button.imageArray =  @[images[i], selectImages[i]];
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

- (void)updateContentForGraphicButtons:(PedometerModel *)model
{
    NSArray *array = @[@(model.totalSteps), @(model.totalCalories), @(model.totalDistance)];
    for (int i = 0; i < 3; i++)
    {
        GraphicButton *button = (GraphicButton *)[self viewWithTag:2000 + i];
        
        if (i != 2)
        {
            button.subTitle = [NSString stringWithFormat:@"%@", array[i]];
        }
        else
        {
            NSInteger distance = [array[i] integerValue];
            button.subTitle = [NSString stringWithFormat:@"%0.2fkm", distance / 100.0];
        }
    }
}

- (void)clcikChartStyleButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = (GraphicButton *)button;
    
    [self updateContentFromClickChangeEvent];
}

- (void)loadFSLineView
{
    CGFloat offsetY = _chartView.totalHeight + 50;
    _dashView = [[DashLineView alloc] initWithFrame:CGRectMake(10, offsetY + 15.0, self.width - 20, self.height - offsetY - 120)];
    [_dashView setHoriAndVert:9 vert:10];
    [self addSubview:_dashView];
    
    _fsLineView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, self.width, self.height - offsetY - 120)];
    _fsLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:_fsLineView];
    
    [self loadLineChart];
}

-(void)loadLineChart
{
    // Generating some dummy data
    NSMutableArray *bottomTitles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 49; i++)
    {
        NSString *string = [NSString stringWithFormat:@"%d", i / 2];
        [bottomTitles addObject:string];
    }
    
    _lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(10.0, 20, _fsLineView.width - 20, _fsLineView.height)];
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = (int)bottomTitles.count; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.increase = 6;
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return bottomTitles[item];
    };
    
    _lineChart.hiddenBlock = ^(NSInteger index) {
        BOOL hidden = ((index % 6) != 0);
        return hidden;
    };

    [_fsLineView addSubview:_lineChart];
    
    [self updateContentForChartViewWithDirection:0];
}

- (void)loadShareButton
{
    SphereMenu *sphereMenu = [[ShareView sharedInstance] simpleWithPoint:CGPointMake(self.width - 22.5, self.height - 66)];
    [self addSubview:sphereMenu];
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

- (void)updateContentForView:(PedometerModel *)model
{
    _model = model;
    
    [self updateContentForGraphicButtons:model];
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
                                    weakSelf.totalPercent = arc4random() % 100 / 100.0; //percent;
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
