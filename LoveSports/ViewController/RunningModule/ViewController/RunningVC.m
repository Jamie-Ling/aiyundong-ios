//
//  RunningVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "RunningVC.h"

@interface RunningVC ()

@property (nonatomic, strong) UIImage *navImage;
@end

@implementation RunningVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadItems];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_navImage)
    {
        [self loadItems];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadItems
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"1" forState:UIControlStateNormal];
    [button setTitle:@"2" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    item1.tintColor = [UIColor clearColor];
    
    self.navigationItem.leftBarButtonItems = @[item1];
    UIView *navView = self.navigationController.navigationBar;
    UIImage *image = [[UIImage imageNamed:@"pop_up_box_frame_high224.png"]scaleToSize:CGSizeMake(navView.width, navView.totalHeight)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)clickButton:(UIButton *)button
{
    button.selected = !button.selected;
}

@end
