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
        
        if (i == 1)
        {
            detailView.allowAnimation = YES;
        }
    }
    
    [self loadUnlimitScrollView];
}

- (void)loadUnlimitScrollView
{
    _scrollView = [[UnlimitScroll alloc] initWithFrame:self.bounds];
    
    _scrollView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:1.0];
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

- (void)updateDetailViewsDataWithIndex:(NSInteger)index
{
    DayDetailView *detailView = _viewsArray[index];
    NSDate *date = detailView.currentDate;

    for (int i = 0; i < 3; i++)
    {
        DayDetailView *detailView = _viewsArray[i];
        detailView.currentDate = [date dateAfterDay:i - 1];
        
        if (i == 1)
        {
            detailView.allowAnimation = YES;
        }
    }
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
    }
    
    return NO;
}

- (void)updateContentForDayDetailViews
{
    NSLog(@"11111");
    DayDetailView *detailView = _viewsArray[1];
    NSDate *date = detailView.currentDate;
    
    if ([date isSameWithDate:[NSDate date]])
    {
        NSLog(@"22222");

        detailView.currentDate = detailView.currentDate;
    }
}

@end
