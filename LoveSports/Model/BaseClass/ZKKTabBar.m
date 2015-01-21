//
//  ZKKTabBar.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define ZKKTabBar_ItemButton 3300

#import "ZKKTabBar.h"

@interface ZKKTabBar ()

@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation ZKKTabBar

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        self.itemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < items.count; i++)
        {
            UIButton *button = items[i];
         
            button.tag = ZKKTabBar_ItemButton + i;
            [button addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.itemsArray addObject:button];
            [self addSubview:button];
            
            if (i == 0)
            {
                _lastButton = button;
                button.selected = YES;
            }
        }
    }
    
    return self;
}

- (void)tabBarButtonClick:(UIButton *)sender
{
    UIButton *button = sender;
    NSInteger index = button.tag - ZKKTabBar_ItemButton;
    
    if ([_delegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)])
    {
        if (![_delegate tabBar:self shouldSelectIndex:index])
        {
            return;
        }
    }
    
    [self selectTabAtIndex:index];
}

- (void)selectTabAtIndex:(NSInteger)index
{
    _lastButton.selected = NO;
    UIButton *btn = [self.itemsArray objectAtIndex:index];
    btn.selected = YES;
    _lastButton = btn;
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:index];
    }
}

#pragma mark ---Public Fun ---
- (void)setupItem:(UIButton *)item index:(NSInteger)index
{
    CGSize buttonSize = item.size;
    CGFloat offsetX = (self.width - _itemsArray .count * buttonSize.width) / 7;
    CGFloat offsetY = (self.height - buttonSize.height) / 2;
    CGRect rect = CGRectMake(offsetX + index * (buttonSize.width + offsetX), offsetY, buttonSize.width, buttonSize.height);
    item.frame = rect;
}

- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index
{
    UIButton *item = _itemsArray[index];
    
    [UIView animateWithDuration:0.1f animations:^{
        animatedView.frame = CGRectMake(item.frame.origin.x, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
    }];
}

- (void)setBackgroundImage:(UIImage *)img
{
    [_backgroundView setImage:img];
}

@end
