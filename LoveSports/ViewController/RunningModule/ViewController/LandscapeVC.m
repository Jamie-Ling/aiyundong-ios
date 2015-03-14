//
//  LandscapeVC.m
//  LoveSports
//
//  Created by zorro on 15-2-3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "LandscapeVC.h"
#import "FSLineChart.h"
#import "PedometerModel.h"

@interface LandscapeVC ()

@property (nonatomic, strong) FSLineChart *lineChart;

@property (nonatomic, strong) NSDate *weekDate;
@property (nonatomic, assign) NSInteger monthIndex;

@end

@implementation LandscapeVC

- (instancetype)initWithDate:(NSDate *)date
                withWeekDate:(NSDate *)weekDate
              withMonthIndex:(NSInteger)index
                withShowtype:(TrendChartShowType)showtype
{
    self = [super init];
    if (self) {
        _dayDate = date;
        _weekDate = weekDate;
        _monthIndex = index;
        _showType = showtype;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(LandscapeVC);
    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf updateContentForChartViewWithDirection:0];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;

    [self loadVerticalButton];
    [self loadLineChart];
}

- (void)loadVerticalButton
{
    UIButton *verticalButton = [UIButton simpleWithRect:CGRectMake(self.view.height - 90, 0, 90, 70)
                                               withImage:@"竖屏@2x.png"
                                         withSelectImage:@"竖屏@2x.png"];
    
    [verticalButton addTarget:self action:@selector(verticalViewData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verticalButton];
}

- (void)verticalViewData
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)loadLineChart
{
    // Creating the line chart
    CGRect rect = CGRectMake((self.view.height - self.view.height * 0.9) / 2, 50, self.view.height * 0.9, self.view.width - 120);
    _lineChart = [[FSLineChart alloc] initWithFrame:rect];
    _lineChart.verticalGridStep = 6;
    _lineChart.horizontalGridStep = LS_TrendChartShowCount; // 151,187,205,0.2
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@""];
    };
    [self.view addSubview:_lineChart];
    
    [self updateContentForChartViewWithDirection:0];
}

// 日刷新
- (void)refreshTrendChartViewWithDayDate:(NSDate *)date
{
    _dayDate = date;
    NSArray *array = [TrendShowType getShowDataArrayWithDayDate:_dayDate withShowType:_showType];
    
    [self refreshTrendChartViewWithChartData:array[0] withTitle:array[1]];
}

// 周刷新
- (void)refreshTrendChartViewWithWeekDate:(NSDate *)date
{
    _weekDate = date;
    NSArray *array = [TrendShowType getShowDataArrayWithWeekDate:_weekDate withShowType:_showType];
    
    [self refreshTrendChartViewWithChartData:array[0] withTitle:array[1]];
}

// 月刷新
- (void)refreshTrendChartViewWithMonthIndex:(NSInteger)index
{
    _monthIndex = index;
    NSArray *array = [TrendShowType getShowDataArrayWithMonthIndex:_monthIndex withShowType:_showType];
    
    [self refreshTrendChartViewWithChartData:array[0] withTitle:array[1]];
}

// 传入数据刷新
- (void)refreshTrendChartViewWithChartData:(NSArray *)ChartData withTitle:(NSArray *)titlesArray
{
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return titlesArray[item];
    };
    [_lineChart setChartData:ChartData];
}

// 左右滑动进行数据变换。
- (void)updateContentForChartViewWithDirection:(NSInteger)direction
{
    if (_showType < 3)
    {
        [self refreshTrendChartViewWithDayDate:[_dayDate dateAfterDay:((int)direction * 8)]];
    }
    else if (_showType < 6)
    {
        [self refreshTrendChartViewWithWeekDate:[_weekDate dateAfterDay:((int)direction * 49)]];
    }
    else
    {
        [self refreshTrendChartViewWithMonthIndex:_monthIndex + ((int)direction * 8)];
    }
}

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    NSLog(@"..左扫..");
    [self updateContentForChartViewWithDirection:1];
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    [self updateContentForChartViewWithDirection:-1];
}

// 下面的是6.0以后的
#pragma mark 旋屏
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
#pragma mark -todo
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
