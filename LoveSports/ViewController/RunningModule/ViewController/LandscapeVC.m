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
        
        [DataShare sharedInstance].showCount = 14;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(LandscapeVC);
    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf.trendView reloadTrendChartView];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
    [DataShare sharedInstance].showCount = 8;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    // self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;

    [self loadVerticalButton];
    [self loadLSTrendView];
}

- (void)loadLSTrendView
{
    _trendView = [[LSTrendView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.width)];
    
    [self addSubview:_trendView];
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
