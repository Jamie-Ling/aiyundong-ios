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
@property (nonatomic, strong) UIView *signView;
@end

@implementation ZKKTabBar

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor whiteColor];
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
            else if (i == 2 || i == 3 || i == 4)
            {
                button.userInteractionEnabled = NO;
            }
        }
        
        [self loadLineViewAndSignView];
    }
    
    return self;
}

- (void)loadLineViewAndSignView
{
    [_backgroundView addSubViewWithRect:CGRectMake(0, _backgroundView.height - 1, _backgroundView.width, 1)
                              withColor:UIColorRGB(223, 223, 223)
                              withImage:nil];
    
    _signView = [_backgroundView addSubViewWithRect:CGRectMake((_lastButton.width - 45) / 2,
                                                               _backgroundView.height - 3,
                                                               45, 3)
                                          withColor:UIColorRGB(238, 10, 0)
                                          withImage:nil];
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
    if (index != _itemsArray.count - 1)
    {
        _lastButton.selected = NO;
        UIButton *btn = [self.itemsArray objectAtIndex:index];
        btn.selected = YES;
        _lastButton = btn;
        
        _signView.center = CGPointMake(_lastButton.center.x, _signView.center.y);
    }
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:index];
    }
}

#pragma mark ---Public Fun ---
- (void)setupItem:(UIButton *)item index:(NSInteger)index
{
    CGSize buttonSize = item.size;
    CGFloat offsetX = (self.width - _itemsArray.count * buttonSize.width) / (_itemsArray.count + 1);
    CGFloat offsetY = (self.height - buttonSize.height) / 2 + 5;
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
