//
//  ZKKTabBarController.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ZKKTabBarController.h"

@interface ZKKTabBarController ()

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *tempItems;
@property (nonatomic, retain) UIView *contentView;

@end

@implementation ZKKTabBarController

- (id)initWithViewControllers:(NSArray *)vcs items:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        self.viewControllers = vcs;
        self.tempItems = items;
        
       
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tabBarFrame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    _contentFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    [self loadContentViews];
    self.selectedIndex = 0;
}

- (void)loadContentViews
{
    self.navigationController.navigationBar.hidden = YES;
    _contentView = [[UIView alloc] initWithFrame:_contentFrame];
    [self.view addSubview:_contentView];
    
    _tabBar = [[ZKKTabBar alloc] initWithFrame:_tabBarFrame items:_tempItems];
    
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    
    _tabBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    _contentView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    self.tempItems = nil;
    
    for (int i = 0; i < _tabBar.itemsArray.count; i++)
    {
        [self setupItem:_tabBar.itemsArray[i] index:i];
    }
}

- (void)setupItem:(UIButton *)item index:(NSInteger)index
{
    [_tabBar setupItem:item index:index];
}

- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)displayViewAtIndex:(NSUInteger)index
{
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    // If target index is equal to current index.
    if (_selectedIndex == index && [[_contentView subviews] count] != 0)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]])
        {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        
        return;
    }
    
    _selectedIndex = index;
    
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    targetViewController.view.frame = _contentView.bounds;
    [self addChildViewController:targetViewController];
    [_contentView addSubview:targetViewController.view];
    
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
    }
}

- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index
{
    static BOOL isFirst = NO;
    if (!isFirst)
    {
        animatedView.backgroundColor = [UIColor orangeColor];
        animatedView.alpha = 0.5;
        isFirst = YES;
    }
    
    [_tabBar resetAnimatedView:animatedView index:index];
}

#pragma mark --- ZKKTabBarDelegate ---
- (BOOL)tabBar:(ZKKTabBar *)tabBar shouldSelectIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        return [_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]];
    }
    
    return YES;
}

- (void)tabBar:(ZKKTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    [self displayViewAtIndex:index];
    
    [self resetAnimatedView:_tabBar.animatedView index:index];
}

@end

@implementation UIViewController (ZKKTabBarVC)

- (ZKKTabBarController *)tabBarController
{
    UIViewController *vc = self.parentViewController;
    while (vc)
    {
        if ([vc isKindOfClass:[ZKKTabBarController class]])
        {
            return (ZKKTabBarController *)vc;
        }
        else if (vc.parentViewController && vc.parentViewController != vc)
        {
            vc = vc.parentViewController;
        }
        else
        {
            vc = nil;
        }
    }
    
    return nil;
}

@end