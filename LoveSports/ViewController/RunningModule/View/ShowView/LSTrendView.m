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

    offsetY = FitScreenNumber(260, 260, 280, 300, 300);
    self.typeView.frame = CGRectMake(0, offsetY, self.width, 64);
    self.typeView.offset = FitScreenNumber(140, 170, 180, 200, 300);
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
