//
//  TrendScrollView.m
//  LoveSports
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendScrollView.h"

@implementation TrendScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _viewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self loadTrendDetailView];
    }
    
    return self;
}

- (void)loadTrendDetailView
{
    NSDate *date = [NSDate date];
    for (int i = 0; i < 3; ++i)
    {
        TrendDetailView *detailView = [[TrendDetailView alloc] initWithFrame:self.bounds];
        
        detailView.currentDate = [date dateAfterDay:(i - 1) * 7];
        [_viewsArray addObject:detailView];
    }
    
    [self loadUnlimitScrollView];
}

- (void)loadUnlimitScrollView
{
    _scrollView = [[UnlimitScroll alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height + 40)];
    _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    _scrollView.isRight = YES;
    _scrollView.viewsArray = _viewsArray;
    
    DEF_WEAKSELF_(TrendScrollView);
    _scrollView.updateBlock = ^(UnlimitScroll *view, NSInteger index) {
        [weakSelf updateDetailViewsDataWithIndex:index];
    };
    _scrollView.allowBlock = ^(UnlimitScroll *view, int index) {
        return [weakSelf setBoundaryOfScrollView:index];
    };
    
    [self addSubview:_scrollView];
}

- (void)updateDetailViewsDataWithIndex:(NSInteger)index
{
    TrendDetailView *detailView = _viewsArray[index];
    NSDate *date = detailView.dayDate;
    
    for (int i = 0; i < 3; i++)
    {
        TrendDetailView *detailView = _viewsArray[i];
        detailView.currentDate = [date dateAfterDay:(i - 1) * 7];
        
        if (i == 1)
        {
            if (_yearBlock)
            {
                _yearBlock(self, detailView.dayDate);
            }
        }
    }
}

- (BOOL)setBoundaryOfScrollView:(int)index
{
    TrendDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.dayDate;
    
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

- (void)updateContentForDayDetailViews
{
    TrendDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.dayDate;
    
    if ([date isSameWithDate:[NSDate date]])
    {
        detailView.currentDate = detailView.dayDate;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
 {
    // Drawing code
}
*/

@end
