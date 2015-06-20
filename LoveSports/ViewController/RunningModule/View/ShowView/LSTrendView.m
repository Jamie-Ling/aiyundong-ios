//
//  LSTrendView.m
//  LoveSports
//
//  Created by zorro on 15/3/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "LSTrendView.h"
#import "CalendarHelper.h"

@implementation LSTrendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self updateRectForSubViews];
    }
    
    return self;
}

- (void)updateRectForSubViews
{
    self.scrollView.frame = CGRectMake(0, 100, self.width, 160);

    CGFloat offsetY = FitScreenNumber(240, 240, 260, 280, 260);
    self.yearLabel.frame = CGRectMake(20, offsetY, 100, 20);
    
    offsetY = FitScreenNumber(240, 240, 260, 280, 260);
    self.weekNumberLabel.frame = CGRectMake(100, offsetY, 100, 20);

    offsetY = FitScreenNumber(260, 260, 280, 300, 300);
    self.typeView.frame = CGRectMake(0, offsetY, self.width, 64);
    self.typeView.offset = FitScreenNumber(140, 170, 180, 200, 300);
    
    DEF_WEAKSELF_(LSTrendView);
    self.scrollView.yearBlock = ^ (UIView *view, id object) {
        weakSelf.yearLabel.text = [NSString stringWithFormat:@"%@%@", object, LS_Text(@"Year")];
        weakSelf.weekNumberLabel.text = [NSString stringWithFormat:@"%ld-%d%@",
                                         (long)[weakSelf.scrollView getCurrentWeekForMiddleThrendView], [weakSelf.scrollView getCurrentWeekForMiddleThrendView] + 1, LS_Text(@"Week")];
    };
    
    self.weekNumberLabel.text = [NSString stringWithFormat:@"%ld-%d%@",
                                 (long)[NSDate date].weekOfYear, [self.scrollView getCurrentWeekForMiddleThrendView] + 1, LS_Text(@"Week")];
}

- (void)loadLandscapeButton
{
    UIButton *landscapeButton = [UIButton simpleWithRect:CGRectMake(self.width - 70, 18, 50, 44)
                                               withImage:@"旋转屏幕@2x.png"
                                         withSelectImage:@"旋转屏幕@2x.png"];
    
    [landscapeButton addTarget:self action:@selector(landscapeViewData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:landscapeButton];
}

- (void)clickCalendarButton
{
    DEF_WEAKSELF_(LSTrendView);
    [CalendarHelper sharedInstance].calendarblock = ^(CalendarDayModel *model) {
        weakSelf.currentDate = [model date];
    };
    
    CGPoint point = [CalendarHelper sharedInstance].calenderView.center;
    [[CalendarHelper sharedInstance].calenderView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calenderView.center = weakSelf.center;
    } dismissBlock:^(UIView *_view) {
        [CalendarHelper sharedInstance].calendarblock = nil;
        [CalendarHelper sharedInstance].calenderView.center = point;
    }];
}

- (void)landscapeViewData
{
    if (_backBlock)
    {
        _backBlock(self, nil);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
