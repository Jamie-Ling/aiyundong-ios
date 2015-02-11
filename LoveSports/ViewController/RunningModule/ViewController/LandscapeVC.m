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
@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation LandscapeVC

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _currentDate = date;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;

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
    _lineChart.horizontalGridStep = 8; // 151,187,205,0.2
    _lineChart.levelNumber = 800;
    _lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    _lineChart.fillColor = [_lineChart.color colorWithAlphaComponent:0.3];
    _lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@""];
    };
    [self.view addSubview:_lineChart];
    
    [self refreshTrendChartViewWithDate:_currentDate];
}

- (void)refreshTrendChartViewWithDate:(NSDate *)date
{
    _currentDate = date;
    NSArray *array = [PedometerModel getEveryDayTrendDataWithDate:_currentDate];
    NSMutableArray *chartDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < array.count; i++)
    {
        PedometerModel *model = array[i];
        chartDataArray[i] = @(model.totalSteps);
        daysArray[i] = [model.dateString substringFromIndex:5];
    }
    
    _lineChart.labelForIndex = ^(NSUInteger item) {
        return daysArray[item];
    };
    [_lineChart setChartData:chartDataArray];
}

- (void)updateContentForChartViewWithDirection:(NSInteger)direction
{
    [self refreshTrendChartViewWithDate:[_currentDate dateAfterDay:((int)direction * 8)]];
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
