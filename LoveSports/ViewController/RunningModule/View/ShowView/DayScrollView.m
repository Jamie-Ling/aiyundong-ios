//
//  DayScrollView.m
//  LoveSports
//
//  Created by zorro on 15/3/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DayScrollView.h"

@implementation DayScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self loadDayDetailView];
    }
    
    return self;
}

- (void)loadDayDetailView
{
    NSDate *date = [NSDate date];
    for (int i = 0; i < 3; ++i)
    {
        DayDetailView *detailView = [[DayDetailView alloc] initWithFrame:self.bounds];
       
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
    
    DEF_WEAKSELF_(DayScrollView);
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
    DayDetailView *detailView = _viewsArray[1];
    detailView.allowAnimation = YES;
    
    if (_buttonRotationBlock)
    {
        _buttonRotationBlock(detailView, nil);
    }
}

- (void)updateDetailViewsDataWithIndex:(NSInteger)index
{
    DayDetailView *detailView = _viewsArray[index];
    NSDate *date = detailView.currentDate;

    [self updateContentWithDate:date];
}

- (BOOL)setBoundaryOfScrollView:(int)index
{
    DayDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.currentDate;
    
    if (index == -1)
    {
        if ([date isSameWithDate:[NSDate date]])
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

- (void)updateContentForDayDetailViews:(BOOL)isAnimaiton
{
    DayDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.currentDate;
    
    if ([date isSameWithDate:[NSDate date]])
    {
        detailView.currentDate = detailView.currentDate;
        detailView.allowAnimation = isAnimaiton;
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
        DayDetailView *detailView = _viewsArray[i];
        detailView.currentDate = [date dateAfterDay:i - 1];
        if (i == 1)
        {
            [self startChartAnimation];
        }
    }
}

@end
