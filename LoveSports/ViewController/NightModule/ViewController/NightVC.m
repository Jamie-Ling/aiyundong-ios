//
//  NightVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NightVC.h"
#import "NightScrollView.h"
#import "ShareView.h"
#import "CalendarHelper.h"

@interface NightVC ()

@property (nonatomic, strong) NightScrollView *scrollView;

@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation NightVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(NightVC);
    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf updateConnectForView];
    };
    
    [BLTManager sharedInstance].connectBlock = ^ {
        [weakSelf.scrollView refreshSleepViewHiddenForScrollView];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_scrollView startChartAnimation];
    [BLTManager sharedInstance].connectBlock = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    // self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
    
    [self loadNightScrollView];
    [self loadCalendarButton];
    [self loadDateLabel];
    [self loadBackButton];
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
    DEF_WEAKSELF_(NightVC);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        NSLog(@"..%@", [model date]);
        [weakSelf.scrollView updateContentWithDate:[model date]];
    };
    
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
    }];
}

- (void)clickBackButton:(UIButton *)button
{
    [_scrollView updateContentToToday];
}

- (void)loadDateLabel
{
    _weekLabel = [UILabel customLabelWithRect:CGRectMake(0, 0, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:15
                                     withText:@""
                                withTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel customLabelWithRect:CGRectMake(0, 20, self.width, 30)
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:15
                                     withText:@""
                                withTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self addSubview:_dateLabel];
}

- (void)loadNightScrollView
{
    _scrollView = [[NightScrollView alloc] initWithFrame:self.view.bounds];
    
    [self addSubview:_scrollView];
    
    DEF_WEAKSELF_(NightVC);
    _scrollView.buttonRotationBlock = ^(UIView *view, id object) {
        [weakSelf updateContentForLabelsAndButton:(NightDetailView *)view];
    };
}

- (void)updateContentForLabelsAndButton:(NightDetailView *)detailView
{
    _dateLabel.text = [detailView.model showDateTextForSleep];
    _weekLabel.text = [detailView.model showWeekTextForSleep];
    
    NSDate *date = detailView.currentDate;
    [_backButton rotationAccordingWithDate:date];
    _backButton.hidden = [date isSameWithDate:[NSDate date]];
}

- (void)loadShareButton
{
    SphereMenu *sphereMenu = [[ShareView sharedInstance] simpleWithPoint:CGPointMake(self.width - 22.5, self.height - 86)];
    [self addSubview:sphereMenu];
}

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    // [self updateContentForBarShowViewWithDate:[_currentDate dateAfterDay:1]]; 21 33 ＊ 5
}

- (void)rightSwipe
{
    // [self updateContentForBarShowViewWithDate:[_currentDate dateAfterDay:-1]];
}

- (void)updateConnectForView
{
 
}

@end
