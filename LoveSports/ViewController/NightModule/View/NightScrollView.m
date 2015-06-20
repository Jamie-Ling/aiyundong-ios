//
//  NightScrollView.m
//  LoveSports
//
//  Created by zorro on 15/3/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NightScrollView.h"

@implementation NightScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadNightDetailView];
    }
    
    return self;
}

- (void)loadNightDetailView
{
    NSDate *date = [NSDate date];
    for (int i = 0; i < 3; ++i)
    {
        NightDetailView *detailView = [[NightDetailView alloc] initWithFrame:self.bounds];
        
        detailView.currentDate = [date dateAfterDay:i - 1];
        [_viewsArray addObject:detailView];
    }
    
    [self loadUnlimitScrollView];
}

- (void)loadUnlimitScrollView
{
    _scrollView = [[UnlimitScroll alloc] initWithFrame:self.bounds];
    
    _scrollView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:1.0];
    _scrollView.isRight = YES;
    _scrollView.viewsArray = _viewsArray;
    
    DEF_WEAKSELF_(NightScrollView);
    _scrollView.updateBlock = ^(UnlimitScroll *view, NSInteger index) {
        [weakSelf updateDetailViewsDataWithIndex:index];
    };
    _scrollView.allowBlock = ^(UnlimitScroll *view, int index) {
        return [weakSelf setBoundaryOfScrollView:index];
    };
    
    [self addSubview:_scrollView];
}

- (void)startChartAnimation
{
    NightDetailView *detailView = _viewsArray[1];
    detailView.allowAnimation = YES;
    
    if (_buttonRotationBlock)
    {
        _buttonRotationBlock(detailView, nil);
    }
}

- (void)updateDetailViewsDataWithIndex:(NSInteger)index
{
    NightDetailView *detailView = _viewsArray[index];
    NSDate *date = detailView.currentDate;
    
    [self updateContentWithDate:date];
}

- (BOOL)setBoundaryOfScrollView:(int)index
{
    NightDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.currentDate;
    
    if (index == -1)
    {
        if ([date isSameWithDate:[[NSDate date] dateAfterDay:1]])
        {
            return YES;
        }
        else
        {
            // DayDetailView *detailView = _viewsArray[2];
            // detailView.allowAnimation = YES;
        }
    }
    else
    {
        // DayDetailView *detailView = _viewsArray[0];
        // detailView.allowAnimation = YES;
    }
    
    return NO;
}

- (void)updateContentForNightDetailViews
{
    NightDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.currentDate;
    
    // if ([date isSameWithDate:[NSDate date]])
    {
        detailView.currentDate = detailView.currentDate;
        detailView.allowAnimation = YES;
    }
}

- (void)updateContentToToday
{
    [UIView transitionWithView:self
                      duration:0.35
                       options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                        NSDate *date = [NSDate date];
                        [self updateContentWithDate:date];
                    } completion:nil];
}

- (void)updateContentWithDate:(NSDate *)date
{
    for (int i = 0; i < 3; ++i)
    {
        NightDetailView *detailView = _viewsArray[i];
        detailView.currentDate = [date dateAfterDay:i - 1];
        if (i == 1)
        {
            [self startChartAnimation];
        }
    }
}

- (void)refreshSleepViewHiddenForScrollView
{
    for (int i = 0; i < 3; ++i)
    {
        NightDetailView *detailView = _viewsArray[i];
        
        [detailView refreshSleepViewHidden];
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
