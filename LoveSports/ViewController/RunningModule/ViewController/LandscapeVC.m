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
#import "ShareView.h"

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
    [BLTSendOld sharedInstance].backBlock = ^(NSDate *date) {
        [weakSelf.trendView reloadTrendChartView];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
    [BLTSendOld sharedInstance].backBlock = nil;
    [DataShare sharedInstance].showCount = 8;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    // self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;

    [self loadLSTrendView];
    // [self loadShareButton];
}

- (void)loadLSTrendView
{
    _trendView = [[LSTrendView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.width)];
    
    [self addSubview:_trendView];
    
    DEF_WEAKSELF_(LandscapeVC);
    _trendView.backBlock = ^(UIView *view, id object) {
        [weakSelf verticalViewData];
    };
}

- (void)verticalViewData
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)loadShareButton
{
    SphereMenu *sphereMenu = [[ShareView sharedInstance] simpleWithPoint:CGPointMake(self.height - 22.5, self.width - 20)];
    [self addSubview:sphereMenu];
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
