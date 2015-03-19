//
//  UnlimitScroll.m
//  LoveSports
//
//  Created by zorro on 15/3/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UnlimitScroll.h"

@interface UnlimitScroll () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) NSMutableArray *contentViews;

@end

@implementation UnlimitScroll

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0)
    {
        [self configContentViews];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 1;
        
        [self addSwipeForScrollView];
    }
    
    return self;
}

- (void)addSwipeForScrollView
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
  //  [self.scrollView addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
  //  [self.scrollView addGestureRecognizer:swipe];
}

- (void)leftSwipe
{
    NSLog(@"..左扫..");
    
    self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    [self configContentViews];
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
    
    self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    [self configContentViews];
}

- (void)setViewsArray:(NSArray *)viewsArray
{
    _viewsArray = viewsArray;
    
    [self configContentViews];
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews)
    {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        
        [self.scrollView addSubview:contentView];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    if (_updateBlock)
    {
        _updateBlock(self, _currentPageIndex);
    }
    
    _currentPageIndex = 1;
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil)
    {
        self.contentViews = [@[] mutableCopy];
    }
    
    [self.contentViews removeAllObjects];
    [self.contentViews addObject:_viewsArray[previousPageIndex]];
    [self.contentViews addObject:_viewsArray[_currentPageIndex]];
    [self.contentViews addObject:_viewsArray[rearPageIndex]];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1)
    {
        return self.totalPageCount - 1;
    }
    else if (currentPageIndex == self.totalPageCount)
    {
        return 0;
    }
    else
    {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
      //  [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame)))
    {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    else if(contentOffsetX <= 0)
    {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
    else if (contentOffsetX < CGRectGetWidth(scrollView.frame) * 0.75)
    {
        // 向左滑动到第一张后就不再滑动 向左滚动为1，向右为－1
        if (_allowBlock)
        {
            BOOL allow = _allowBlock(self, 1);
            if (allow)
            {
                [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame) * 0.75, 0) animated:NO];
            }
        }
    }
    else if (contentOffsetX >= CGRectGetWidth(scrollView.frame) * 1.25)
    {
        // 这里可以判断向右滑动多少张后就不再滑动
        if (_allowBlock)
        {
            BOOL allow = _allowBlock(self, -1);
            if (allow)
            {
                [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame) * 1.25, 0) animated:NO];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_allowBlock)
    {
        BOOL allow = _isRight ? _allowBlock(self, -1) : _allowBlock(self, 1);
        if (allow)
        {
            [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    if (_allowBlock)
    {
        BOOL allow = _isRight ? _allowBlock(self, -1) : _allowBlock(self, 1);
        if (allow)
        {
            [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
        }
    }
}

#pragma mark -
#pragma mark - 响应事件

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock)
    {
        self.TapActionBlock(self.currentPageIndex);
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
